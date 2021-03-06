USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[apiproc_UserBlncTrf]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE   PROCEDURE [dbo].[apiproc_UserBlncTrf] @flag CHAR(3) = NULL
	,@subscriber_no VARCHAR(50) = NULL
	,@description VARCHAR(500) = NULL
	,@bt_purpose VARCHAR(100) = NULL
	,@amount DECIMAL(18, 2) = NULL
	,@action_user VARCHAR(50) = NULL
	,@created_ip VARCHAR(50) = NULL
	,@created_platform VARCHAR(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from  
	-- interfering with SELECT statements.  
	SET NOCOUNT ON;

	DECLARE @user_mobile_number VARCHAR(15)
		,@user_email VARCHAR(50)
		,@user_full_name VARCHAR(50)
		,@reciever_id INT
		,@sender_agent_id INT
		,@reciever_agent_id INT
		,@reciever_full_name VARCHAR(50)
		,@reciever_email VARCHAR(50)
	DECLARE @agent_current_balance DECIMAL(18, 2)
		,@parent_id INT
		,@sender_name VARCHAR(50)
		,@user_id INT
		,@remarks_agent VARCHAR(max)
		,@desc VARCHAR(max)
		,@sender_user_id INT
		,@reciever_user_id INT
		,@remarks_agent_sender VARCHAR(max)
		,@available_balance_sender DECIMAL(18, 2)
		,@available_balance_reciever DECIMAL(18, 2)
	--for notification json  
	DECLARE @notiId INT;
	DECLARE @dataPayload VARCHAR(max);

	--send request  
	IF @flag = 'trq'
	BEGIN
		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_user_detail
				WHERE user_name = @action_user
					OR user_mobile_no = @action_user
					OR user_email = @action_user
				)
		BEGIN
			SELECT '104' code
				,'User not found' message
				,NULL id

			RETURN
		END
		ELSE
		BEGIN
			SELECT @user_mobile_number = user_mobile_no
				,@user_email = user_email
				,@user_full_name = u.full_name
				,@sender_agent_id = u.agent_id
				,@sender_user_id = u.user_id
			FROM tbl_user_detail u
			JOIN tbl_agent_detail a ON a.agent_id = u.agent_id
			WHERE u.user_name = @action_user
				OR u.user_mobile_no = @action_user
				OR u.user_email = @action_user
		END

		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_user_detail
				WHERE user_email = @subscriber_no
					OR user_mobile_no = @subscriber_no
				)
		BEGIN
			SELECT '104' code
				,'Requested User not Found' message
				,NULL id

			RETURN
		END
		ELSE
		BEGIN
			SELECT @reciever_id = user_id
				,@reciever_agent_id = u.agent_id
				,@reciever_full_name = u.full_name
				,@reciever_email = u.user_email
				,@reciever_user_id = u.user_id
			FROM tbl_user_detail u
			JOIN tbl_agent_detail a ON a.agent_id = u.agent_id
			WHERE user_email = @subscriber_no
				OR user_mobile_no = @subscriber_no
		END

		IF (@sender_user_id = @reciever_user_id)
		BEGIN
			SELECT '160' code
				,'Cannot Make Balance Transfer Request to Yourself' message
				,NULL id

			RETURN
		END

		INSERT INTO tbl_agent_notification (
			notification_subject
			,notification_body
			,notification_type
			,notification_status
			,notification_to
			,agent_id
			,user_id
			,created_by
			,created_local_date
			,created_UTC_date
			,created_nepali_date
			)
		VALUES (
			'Balance Transfer Request'
			,@description
			,'Balance_Request'
			,'n'
			,@reciever_id
			,@sender_agent_id
			,@sender_user_id
			--,@action_user  
			,@user_id
			,GETDATE()
			,GETUTCDATE()
			,dbo.func_get_nepali_date(DEFAULT)
			)

		SET @notiId = @@IDENTITY
		SET @dataPayload = dbo.func_notification_payload(@notiId, @subscriber_no, @amount);

		UPDATE tbl_agent_notification
		SET data_payload = @dataPayload
		WHERE notification_id = @notiId

		EXEC sproc_email_request @flag = 'bt'
			,@agent_id = @reciever_agent_id
			,@user_name = @user_mobile_number
			,@full_name = @reciever_full_name
			,@email_id = @reciever_email
			,@amount = @amount
			,@subscriber_no = @subscriber_no

		SELECT '0' code
			,'Successfully sent Balance Transfer request to User: ' + @reciever_full_name message
			,@sender_user_id id

		RETURN
	END

	-- trf request  
	IF @flag = 'trf'
	BEGIN
		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_user_detail u
				JOIN tbl_agent_detail a ON a.agent_id = u.agent_id
				WHERE u.user_name = @action_user
					OR u.user_mobile_no = @action_user
					OR u.user_email = @action_user
				)
		BEGIN
			SELECT '104' code
				,'User not found' message
				,NULL id

			RETURN
		END
		ELSE
		BEGIN
			SELECT @user_id = user_id
				,@user_mobile_number = user_mobile_no
				,@user_email = user_email
				,@user_full_name = u.full_name
				,@sender_agent_id = u.agent_id
			FROM tbl_user_detail u
			WHERE user_name = @action_user
				OR u.user_mobile_no = @action_user
				OR u.user_email = @action_user
		END

		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_user_detail u
				JOIN tbl_agent_detail a ON a.agent_id = u.agent_id
				WHERE user_mobile_no = @subscriber_no
					OR user_email = @subscriber_no
				)
		BEGIN
			SELECT '104' code
				,'User Not found' message
				,NULL id

			RETURN
		END
		ELSE
		BEGIN
			SELECT @reciever_id = user_id
				,@reciever_agent_id = u.agent_id
				,@reciever_full_name = u.full_name
				,@reciever_email = u.user_email
				,@reciever_user_id = u.user_id
			FROM tbl_user_detail u
			WHERE user_mobile_no = @subscriber_no
				OR user_email = @subscriber_no
		END

		IF @amount <= 0
		BEGIN
			SELECT '161' code
				,'Amount should be more than 0' message
				,NULL id

			RETURN
		END

		SELECT @agent_current_balance = Isnull(a.available_balance, 0)
			,@parent_id = a.parent_id
			,@sender_name = u.full_name
			,@sender_agent_id = u.agent_id
			,@sender_user_id = u.user_id
		FROM tbl_user_detail u
		JOIN tbl_agent_detail a ON a.agent_id = u.agent_id
		WHERE user_id = @user_id

		SET @remarks_agent = 'Balance transfered by ' + @sender_name + '(id: ' + @sender_name + ') of ' + cast(@amount AS VARCHAR) + ' NPR'
		SET @remarks_agent_sender = 'Balance transfered t0 ' + @reciever_full_name + 'of ' + cast(@amount AS VARCHAR) + ' NPR'

		IF (@sender_user_id = @reciever_user_id)
		BEGIN
			SELECT '160' code
				,'Cannot Make Balance Transfer to Yourself' message
				,NULL id

			RETURN
		END

		IF @agent_current_balance < @amount
		BEGIN
			SELECT '162' code
				,'Sender''s balance is less the amount to be transfered' message
				,NULL id

			RETURN
		END

		BEGIN TRY
			BEGIN TRANSACTION usertouserbalancetrf

			UPDATE tbl_agent_detail
			SET available_balance = available_balance + @amount
			WHERE agent_id = @reciever_agent_id

			UPDATE tbl_agent_detail
			SET available_balance = available_balance - @amount
			WHERE agent_id = @sender_agent_id

			/*get available balance*/
			SELECT @available_balance_reciever = isnull(available_balance, 0)
			FROM tbl_agent_detail
			WHERE agent_id = @reciever_agent_id

			SELECT @available_balance_sender = isnull(available_balance, 0)
			FROM tbl_agent_detail
			WHERE agent_id = @sender_agent_id

			-- insert into agent balance table for user transfered to              
			INSERT INTO tbl_agent_balance (
				agent_id
				,agent_name
				,amount
				,currency_code
				,agent_parent_id
				,txn_type
				,created_by
				,created_UTC_date
				,created_local_date
				,created_nepali_date
				,created_ip
				,created_platform
				,user_id
				,agent_remarks
				,txn_mode
				)
			VALUES (
				@sender_agent_id
				,@sender_name
				,@amount
				,'NPR'
				,@parent_id
				,'p2p'
				--,@sender_name  
				,@user_id
				,getutcdate()
				,getdate()
				,[dbo].func_get_nepali_date(DEFAULT)
				,@created_ip
				,@created_platform
				,@user_id
				,@remarks_agent_sender
				,'DR'
				)

			INSERT INTO tbl_agent_balance (
				agent_id
				,agent_name
				,amount
				,currency_code
				,agent_parent_id
				,txn_type
				,created_by
				,created_UTC_date
				,created_local_date
				,created_nepali_date
				,created_ip
				,created_platform
				,user_id
				,agent_remarks
				,txn_mode
				)
			VALUES (
				@reciever_agent_id
				,@reciever_full_name
				,@amount
				,'NPR'
				,@parent_id
				,'p2p'
				--,@reciever_full_name  
				,@user_id
				,getutcdate()
				,getdate()
				,[dbo].func_get_nepali_date(DEFAULT)
				,@created_ip
				,@created_platform
				,@user_id
				,@remarks_agent
				,'CR'
				)

			--insert notification for reciever  
			INSERT INTO tbl_agent_notification (
				notification_subject
				,notification_body
				,notification_type
				,notification_status
				,notification_to
				,agent_id
				,user_id
				,created_by
				,created_local_date
				,created_UTC_date
				,created_nepali_date
				,Remaining_Balance
				)
			VALUES (
				'Balance Transfer'
				,@bt_purpose
				,'Balance_Transfer'
				,'n'
				--,@reciever_agent_id  
				,@reciever_id
				--,@reciever_agent_id  
				,@sender_agent_id
				,@sender_user_id
				,@user_id
				,GETDATE()
				,GETUTCDATE()
				,dbo.func_get_nepali_date(DEFAULT)
				,@available_balance_reciever
				)

			SET @notiId = @@IDENTITY
			SET @dataPayload = dbo.func_notification_payload(@notiId, @subscriber_no, @amount);

			UPDATE tbl_agent_notification
			SET data_payload = @dataPayload
			WHERE notification_id = @notiId

			INSERT INTO tbl_agent_notification (
				notification_subject
				,notification_body
				,notification_type
				,notification_status
				,notification_to
				,agent_id
				,user_id
				,created_by
				,created_local_date
				,created_UTC_date
				,created_nepali_date
				,Remaining_Balance
				)
			VALUES (
				'Balance Transfer'
				,@bt_purpose
				,'Balance_Transfer'
				,'n'
				--,@sender_agent_id  
				,@sender_user_id
				,@sender_agent_id
				,@user_id
				--,@action_user  
				,@user_id
				,GETDATE()
				,GETUTCDATE()
				,dbo.func_get_nepali_date(DEFAULT)
				,@available_balance_sender
				)

			SET @notiId = @@IDENTITY
			SET @dataPayload = dbo.func_notification_payload(@notiId, @subscriber_no, @amount);

			UPDATE tbl_agent_notification
			SET data_payload = @dataPayload
			WHERE notification_id = @notiId

			COMMIT TRANSACTION usertouserbalancetrf

			SELECT '0' code
				,@remarks_agent message
				,@sender_user_id sender_id
				,@reciever_user_id reciever_id
				,isnull(available_balance, 0) AS available_balance
			FROM tbl_agent_Detail
			WHERE agent_id = @sender_agent_id
		END TRY

		BEGIN CATCH
			IF @@trancount > 0
				ROLLBACK TRANSACTION usertouserbalancetrf

			SET @desc = 'sql error found:(' + error_message() + ')' + ' at ' + error_line()

			INSERT INTO tbl_error_log_sql (
				sql_error_desc
				,sql_error_script
				,sql_query_string
				,sql_error_category
				,sql_error_source
				,sql_error_local_date
				,sql_error_UTC_date
				,sql_error_nepali_date
				)
			SELECT @desc
				,'sproc_balance_transfer(user to user balance trf:flag ''trf'')'
				,'sql'
				,'sql'
				,'sproc_balance_transfer((user to user balance trf)'
				,getdate()
				,getutcdate()
				,[dbo].func_get_nepali_date(DEFAULT)

			SELECT '1' code
				,'errorid: ' + cast(scope_identity() AS VARCHAR) message
				,NULL id
		END CATCH
	END
END


GO
