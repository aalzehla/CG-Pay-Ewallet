USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[apiproc_agent_cardMgmt]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE   PROCEDURE [dbo].[apiproc_agent_cardMgmt]
	-- Add the parameters for the stored procedure here  
	@flag CHAR(3) = NULL
	,@user_name VARCHAR(50) = NULL
	,@card_no VARCHAR(20) = NULL
	,@card_type VARCHAR(50) = NULL
	,@card_txn_type VARCHAR(50) = NULL
	,@is_active CHAR(3) = NULL
	,@action_user VARCHAR(50) = NULL
	,@user_mobile_no VARCHAR(10) = NULL
	,@user_email VARCHAR(20) = NULL
	,@created_ip VARCHAR(30) = NULL
	,@user_id INT = NULL
	,@requested_amount DECIMAL(18, 2) = NULL
	,@card_id INT = NULL
	,@transfer_to_mobile VARCHAR(10) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from  
	-- interfering with SELECT statements.  
	SET NOCOUNT ON;

	DECLARE @sql VARCHAR(max)
		,@new_card_no VARCHAR(100)
		,@id INT
		,@available_balance DECIMAL(18, 2)
		,@available_card_balance DECIMAL(18, 2)
		,@transfer_to_user_id INT
		,@agent_id INT
		,@username VARCHAR(50)
		,@agent_name VARCHAR(100)
		,@card_issued_date DATETIME
		,@card_expiry_date DATETIME
		,@transfer_to_agent_id INT
		,@transfer_to_user_name VARCHAR(122)
			--for notification json  
	DECLARE @notiId INT;
	DECLARE @dataPayload VARCHAR(max);

	SET @new_card_no = '1000' + cast(convert(NUMERIC(12, 0), rand() * 899999999999) + 100000000000 AS VARCHAR)
	SET @card_issued_date = format(GETDATE(), 'yyyy-MM-dd')
	SET @card_expiry_date = format(DATEADD(year, 4, GETDATE()), 'yyyy-MM-dd')

	IF @user_name IS NULL
	BEGIN
		SELECT '105' code
			,'Username is required!' message
			,NULL id

		RETURN
	END

	IF isnull(@requested_amount, 0) < 0
	BEGIN
		SET @requested_amount = isnull(@requested_amount, 0) * - 1
	END

	IF NOT EXISTS (
			SELECT 'x'
			FROM tbl_user_detail u
			JOIN tbl_agent_detail a ON a.agent_id = u.agent_id
			WHERE u.user_mobile_no = @user_name
				OR u.user_email = @user_name
			)
	BEGIN
		SELECT '104' Code
			,'User Not Found' message
			,NULL id

		RETURN
	END
	ELSE
	BEGIN
		SELECT @available_balance = available_Balance
			,@agent_id = u.agent_id
			,@user_id = u.user_id
			,@available_card_balance = cm.amount
			,@username = u.user_name
			,@agent_name = a.agent_name
		FROM tbl_user_detail u
		JOIN tbl_agent_detail a ON a.agent_id = u.agent_id
		LEFT JOIN tbl_agent_card_management cm ON cm.agent_id = u.agent_id
			AND cm.card_no = @card_no
		WHERE u.user_mobile_no = @user_name
			OR u.user_email = @user_name

		IF isnull(@available_balance, 0) < isnull(@requested_amount, 0)
		BEGIN
			SELECT '162' code
				,'User Balance is less than the Card requested Amount' message
				,NULL id

			RETURN
		END
	END

	/* add new card*/
	IF @flag = 'i'
	BEGIN
		IF EXISTS (
				SELECT 'x'
				FROM tbl_agent_card_management
				WHERE card_no = @new_card_no
				)
		BEGIN
			SELECT '1' code
				,'Card No already Exists' message
				,NULL id

			RETURN
		END

		SELECT @agent_id = agent_id
		FROM tbl_user_detail
		WHERE user_id = @user_id

		INSERT INTO tbl_agent_card_management (
			agent_id
			,user_id
			,user_name
			,card_no
			,card_type
			,card_issued_date
			,card_expiry_date
			,card_txn_type
			,is_active
			,created_by
			,created_local_date
			,created_utc_date
			,created_nepali_date
			,Amount
			)
		VALUES (
			@agent_id
			,@user_id
			,@username
			,@new_card_no
			,@card_type
			,@card_issued_date
			,@card_expiry_date
			,@card_txn_type
			,'y'
			,@user_id
			,GETDATE()
			,GETUTCDATE()
			,dbo.func_get_nepali_date(DEFAULT)
			,@requested_amount
			)

		UPDATE tbl_agent_detail
		SET available_balance = isnull(available_balance, 0) - @requested_amount
		WHERE agent_id = @agent_id

		SELECT @available_balance = isnull(available_balance, 0)
		FROM tbl_agent_detail
		WHERE agent_id = @agent_id

		INSERT INTO tbl_agent_balance (
			agent_id
			,agent_name
			,amount
			,currency_code
			,agent_remarks
			,user_id
			,created_utc_date
			,created_local_date
			,created_nepali_date
			,created_by
			,created_ip
			,txn_mode
			,txn_type
			)
		VALUES (
			@agent_id
			,@agent_name
			,@requested_amount
			,'npr'
			,'New Card Issued'
			,@user_id
			,GETUTCDATE()
			,GETDATE()
			,[dbo].func_get_nepali_date(DEFAULT)
			,@user_id
			,@created_ip
			,'DR'
			,'ct'
			);

		-- insert into notification     
		INSERT INTO tbl_agent_notification (
			notification_subject
			,notification_body
			,notification_type
			,notification_status
			,notification_to
			,agent_id
			,user_Id
			,created_UTC_date
			,created_local_Date
			,created_nepali_date
			,created_by
			,read_status
			,Remaining_Balance
			)
		VALUES (
			'Card Transaction'
			,'New Card has been added with card no ' + @new_card_no
			,'Card_Transaction'
			,'n'
			,@user_id
			,@agent_id
			,@user_id
			,GETUTCDATE()
			,GETDATE()
			,dbo.func_get_nepali_date(DEFAULT)
			,@user_name
			,'n'
			,@available_balance
			)
			SET @notiId = @@IDENTITY
		SET @dataPayload = dbo.func_notification_payload(@notiId, null, @requested_amount);

		UPDATE tbl_agent_notification
		SET data_payload = @dataPayload
		WHERE notification_id = @notiId

		SELECT '0' Code
			,'Card Issued Successfully' message
			,@new_card_no CardNo
			,@card_issued_date card_issued_date
			,@card_expiry_date card_expiry_date
			,@requested_amount Card_Balance
			,@user_id id
			,isnull(available_balance, 0) AS available_balance
		FROM tbl_agent_detail
		WHERE agent_id = @agent_id

		RETURN
	END

	/*--add balance in card */
	IF @flag = 'ad'
	BEGIN
		IF @card_no IS NULL
		BEGIN
			SELECT '176' code
				,'Invalid card or Card not Found' message
				,NULL id

			RETURN
		END

		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_agent_card_management
				WHERE user_id = @user_id
					AND card_no = @card_no
				)
		BEGIN
			SELECT '180' code
				,'User with the card no. do not exists' message
				,NULL id

			RETURN
		END

		IF @available_balance IS NULL
			SET @available_balance = 0

		IF @requested_amount IS NULL
			SET @requested_amount = 0

		IF @requested_amount = 0
		BEGIN
			SELECT '161' code
				,'Amount should be more than 0' message
				,NULL id

			RETURN
		END

		IF @available_balance < @requested_amount
		BEGIN
			SELECT '162' code
				,'Your available balance is less than the requested Balance' Message
				,NULL id

			RETURN
		END

		UPDATE tbl_agent_card_management
		SET updated_by = @user_id
			,updated_utc_date = GETUTCDATE()
			,updated_local_date = GETDATE()
			,updated_nepali_date = dbo.func_get_nepali_date(GETDATE())
			,Amount = (@available_card_balance + @requested_amount)
		WHERE card_no = @card_no

		UPDATE tbl_agent_detail
		SET available_balance = isnull(available_balance, 0) - @requested_amount
		WHERE agent_id = @agent_id

		--get remaining balance  
		SELECT @available_balance = isnull(available_balance, 0)
		FROM tbl_agent_detail
		WHERE agent_id = @agent_id

		INSERT INTO tbl_agent_balance (
			agent_id
			,agent_name
			,amount
			,currency_code
			,txn_mode
			,agent_remarks
			,user_id
			,created_utc_date
			,created_local_date
			,created_nepali_date
			,created_by
			,created_ip
			,txn_type
			)
		VALUES (
			@agent_id
			,@agent_name
			,@requested_amount
			,'npr'
			,'DR'
			,'New Card Issued'
			,@user_id
			,GETUTCDATE()
			,GETDATE()
			,[dbo].func_get_nepali_date(DEFAULT)
			,@user_id
			,@created_ip
			,'ct'
			);

		-- insert into notification table  
		INSERT INTO tbl_agent_notification (
			notification_subject
			,notification_body
			,notification_type
			,notification_status
			,notification_to
			,agent_id
			,user_Id
			,created_UTC_date
			,created_local_Date
			,created_nepali_date
			,created_by
			,read_status
			,Remaining_Balance
			)
		VALUES (
			'Card Transaction'
			,'Balance added to card No: ' + @card_no
			,'Card_Transaction'
			,'n'
			,@user_id
			,@agent_id
			,@user_id
			,GETUTCDATE()
			,GETDATE()
			,dbo.func_get_nepali_date(DEFAULT)
			,@user_name
			,'n'
			,@available_balance
			)

			SET @notiId = @@IDENTITY
		SET @dataPayload = dbo.func_notification_payload(@notiId, null, @requested_amount);

		UPDATE tbl_agent_notification
		SET data_payload = @dataPayload
		WHERE notification_id = @notiId

		SELECT '0' code
			,'Balance Added to card successfully' message
			,NULL id
			,isnull(available_balance, 0) AS available_balance
		FROM tbl_agent_detail
		WHERE agent_id = @agent_id
	END

	IF @flag = 'rb' -- retrieve blance from card    
	BEGIN
		IF @card_no IS NULL
		BEGIN
			SELECT '176' code
				,'Invalid card or Card not Found' message
				,NULL id

			RETURN
		END

		IF @available_balance IS NULL
			SET @available_balance = 0

		IF @requested_amount IS NULL
			SET @requested_amount = 0

		IF @requested_amount = 0
		BEGIN
			SELECT '161' code
				,'Requested Amount is invalid' message
				,NULL id

			RETURN
		END

		IF @available_card_balance < @requested_amount
		BEGIN
			SELECT '162' code
				,'The requested Balance is more than your card balance' Message
				,NULL id

			RETURN
		END

		UPDATE tbl_agent_card_management
		SET updated_by = @action_user
			,updated_utc_date = GETUTCDATE()
			,updated_local_date = GETDATE()
			,updated_nepali_date = dbo.func_get_nepali_date(GETDATE())
			,Amount = (@available_card_balance - @requested_amount)
		WHERE card_no = @card_no

		UPDATE tbl_agent_detail
		SET available_balance = isnull(available_balance, 0) + @requested_amount
		WHERE agent_id = @agent_id

		--get remaining balance  
		SELECT @available_balance = isnull(available_balance, 0)
		FROM tbl_agent_detail
		WHERE agent_id = @agent_id

		INSERT INTO tbl_agent_balance (
			agent_id
			,agent_name
			,amount
			,currency_code
			,txn_mode
			,agent_remarks
			,user_id
			,created_utc_date
			,created_local_date
			,created_nepali_date
			,created_by
			,created_ip
			,txn_type
			)
		VALUES (
			@agent_id
			,@agent_name
			,@requested_amount
			,'npr'
			,'CR'
			,'New Card Issued'
			,@user_id
			,GETUTCDATE()
			,GETDATE()
			,[dbo].func_get_nepali_date(DEFAULT)
			,@user_id
			,@created_ip
			,'ct'
			);

		-- insert into notification table  
		INSERT INTO tbl_agent_notification (
			notification_subject
			,notification_body
			,notification_type
			,notification_status
			,notification_to
			,agent_id
			,user_Id
			,created_UTC_date
			,created_local_Date
			,created_nepali_date
			,created_by
			,read_status
			,Remaining_Balance
			)
		VALUES (
			'Card Transaction'
			,'Balance withdrawn from card No: ' + @card_no
			,'Card_Transaction'
			,'n'
			,@user_id
			,@agent_id
			,@user_id
			,GETUTCDATE()
			,GETDATE()
			,dbo.func_get_nepali_date(DEFAULT)
			,@user_name
			,'n'
			,@available_balance
			)
			SET @notiId = @@IDENTITY
		SET @dataPayload = dbo.func_notification_payload(@notiId, null, @requested_amount);

		UPDATE tbl_agent_notification
		SET data_payload = @dataPayload
		WHERE notification_id = @notiId
		SELECT '0' code
			,'Balance transfer to wallet successfully' message
			,NULL id
			,isnull(available_balance, 0) AS available_balance
		FROM tbl_agent_detail
		WHERE agent_id = @agent_id
	END

	IF @flag = 's' --select all cards or by username            
	BEGIN
		IF @card_no IS NOT NULL
		BEGIN
			SELECT a.agent_id
				,a.agent_name
				,u.user_id
				,u.user_email
				,u.user_mobile_no
				,ac.card_id
				,ac.card_no
				,ac.card_type
				,CASE 
					WHEN ac.card_type = 1
						THEN 'Virtual Card'
					WHEN ac.card_type = 4
						THEN 'Prepaid Card'
					WHEN ac.card_Type = 2
						THEN 'Gift Card'
					WHEN ac.card_type = 3
						THEN 'Discount Card'
					ELSE 'Virtual Card'
					END card_type_label
				,format(ac.card_issued_date, 'yyyy-MM-dd') AS card_issued_date
				,format(ac.card_expiry_date, 'yyyy-MM-dd') AS card_expiry_date
				,ac.is_active
				,u.full_name
				,isnull(ac.amount, 0) AS available_balance
				,ac.is_transfer
				,ac.transfer_to
			--a.available_balance       
			FROM tbl_user_detail u
			JOIN tbl_agent_detail a ON a.agent_id = u.agent_id
			JOIN tbl_agent_card_management ac ON ac.agent_id = a.agent_id
			WHERE ac.card_no = @card_no
				AND u.user_id = @user_id
		END
		ELSE
		BEGIN
			SELECT a.agent_id
				,a.agent_name
				,u.user_id
				,u.user_email
				,u.user_mobile_no
				,ac.card_id
				,ac.card_no
				,ac.card_type
				,CASE 
					WHEN ac.card_type = 1
						THEN 'Virtual Card'
					WHEN ac.card_type = 4
						THEN 'Prepaid Card'
					WHEN ac.card_Type = 2
						THEN 'Gift Card'
					WHEN ac.card_type = 3
						THEN 'Discount Card'
					ELSE 'Virtual Card'
					END card_type_label
				,format(ac.card_issued_date, 'yyyy-MM-dd') AS card_issued_date
				,format(ac.card_expiry_date, 'yyyy-MM-dd') AS card_expiry_date
				,ac.is_active
				,u.full_name
				,isnull(ac.amount, 0) AS available_balance
				,ac.is_transfer
				,ac.transfer_to
			--a.available_balance       
			FROM tbl_user_detail u
			JOIN tbl_agent_detail a ON a.agent_id = u.agent_id
			JOIN tbl_agent_card_management ac ON ac.agent_id = a.agent_id
			WHERE u.user_id = @user_id
			
			UNION
			
			SELECT a.agent_id
				,a.agent_name
				,u.user_id
				,u.user_email
				,u.user_mobile_no
				,ac.card_id
				,ac.card_no
				,ac.card_type
				,CASE 
					WHEN ac.card_type = 1
						THEN 'Virtual Card'
					WHEN ac.card_type = 4
						THEN 'Prepaid Card'
					WHEN ac.card_Type = 2
						THEN 'Gift Card'
					WHEN ac.card_type = 3
						THEN 'Discount Card'
					ELSE 'Virtual Card'
					END card_type_label
				,format(ac.card_issued_date, 'yyyy-MM-dd')
				,format(ac.card_expiry_date, 'yyyy-MM-dd')
				,ac.is_active
				,u.full_name
				,isnull(ac.amount, 0) AS available_balance
				,ac.is_transfer
				,ac.transfer_to
			--a.available_balance       
			FROM tbl_user_detail u
			JOIN tbl_agent_detail a ON a.agent_id = u.agent_id
			JOIN tbl_agent_card_management ac ON ac.agent_id = a.agent_id
			WHERE ac.transfer_to = @user_id
		END
	END

	IF @flag = 'tr' --transfer card authority    
	BEGIN
		IF @card_no IS NULL
		BEGIN
			SELECT '1' code
				,'Invalid card or Card not Found' message
				,NULL id

			RETURN
		END

		IF @transfer_to_mobile IS NULL
		BEGIN
			SELECT '1' code
				,'Invalid User Info' message
				,NULL id

			RETURN
		END

		IF @transfer_to_mobile IS NOT NULL
			IF NOT EXISTS (
					SELECT 'x'
					FROM tbl_user_detail u
					JOIN tbl_agent_detail a ON a.agent_id = u.agent_id
					WHERE u.user_mobile_no = @transfer_to_mobile
					)
			BEGIN
				SELECT '1' Code
					,'User Not Found' message
					,NULL id

				RETURN
			END
			ELSE
			BEGIN
				SELECT @transfer_to_user_id = user_id
					,@transfer_to_agent_id = u.agent_id
					,@transfer_to_user_name = user_name
				FROM tbl_user_Detail u
				JOIN tbl_agent_detail a ON a.agent_id = u.agent_id
				WHERE u.user_mobile_no = @transfer_to_mobile
			END

		UPDATE tbl_agent_card_management
		SET updated_by = @user_name
			,updated_utc_date = GETUTCDATE()
			,updated_local_date = GETDATE()
			,updated_nepali_date = dbo.func_get_nepali_date(GETDATE())
			,is_transfer = 'Y'
			,transfer_to = @transfer_to_user_id
		WHERE card_no = @card_no

		-- insert into notification table  
		INSERT INTO tbl_agent_notification (
			notification_subject
			,notification_body
			,notification_type
			,notification_status
			,notification_to
			,agent_id
			,user_Id
			,created_UTC_date
			,created_local_Date
			,created_nepali_date
			,created_by
			,read_status
			)
		VALUES (
			'Card Transaction'
			,'card No: ' + @card_no + ' succesfully transfered by : ' + @user_name
			,'Card_Transaction'
			,'n'
			,@transfer_to_user_id
			,@transfer_to_agent_id
			,@user_id
			,GETUTCDATE()
			,GETDATE()
			,dbo.func_get_nepali_date(DEFAULT)
			,@user_name
			,'n'
			)
			SET @notiId = @@IDENTITY
		SET @dataPayload = dbo.func_notification_payload(@notiId, null, @requested_amount);

		UPDATE tbl_agent_notification
		SET data_payload = @dataPayload
		WHERE notification_id = @notiId
		SELECT '0' code
			,'Card transfer successfully to ' + @transfer_to_mobile message
			,NULL id
	END
END



GO
