USE [CGPay]
GO

/****** Object:  StoredProcedure [dbo].[sproc_payment_gateway_transaction]    Script Date: 8/23/2020 2:17:05 AM ******/
DROP PROCEDURE [dbo].[sproc_payment_gateway_transaction]
GO

/****** Object:  StoredProcedure [dbo].[sproc_payment_gateway_transaction]    Script Date: 8/23/2020 2:17:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================        
-- Author:  <Author,,Name>        
-- Create date: <Create Date,,>        
-- Description: <Description,,>        
-- =============================================        
CREATE   PROCEDURE [dbo].[sproc_payment_gateway_transaction]
	-- Add the parameters for the stored procedure here        
	@flag CHAR(3)
	,@pmt_txn_id INT = NULL
	,@service_charge DECIMAL(18, 2) = NULL
	,@amount DECIMAL(18, 2) = NULL
	,@card_no VARCHAR(20) = NULL
	,@remarks VARCHAR(max) = NULL
	,@user_id INT = NULL
	,@user_name VARCHAR(200) = NULL
	,@gateway_status VARCHAR(50) = NULL
	,@pmt_gateway_id INT = NULL
	,@action_user VARCHAR(100) = NULL
	,@action_browser NVARCHAR(max) = NULL
	,@error_code VARCHAR(10) = NULL
	,@action_ip VARCHAR(50) = NULL
	,@pmt_gateway_txn_id VARCHAR(50) = NULL
	,@merchat_txn_id VARCHAR(50) = NULL
	,@gateway_process_id VARCHAR(100) = NULL
	,@pmt_gateway_name VARCHAR(200) = NULL
	,@txn_type VARCHAR(200) = NULL
	,@merchat_txnid VARCHAR(200) = NULL
AS
DECLARE @card_expiry_date DATE
	,@process_id VARCHAR(200)
	,@type VARCHAR(30)
	,@card_issuer VARCHAR(50)
	,@name_on_card VARCHAR(50)
	,@email VARCHAR(50)
	,@mobile VARCHAR(50)
	,@agent_id VARCHAR(50)
	,@gateway_timestamp VARCHAR(200)
	,@status VARCHAR(10)
	,@total_amount DECIMAL(18, 2)
	,@agent_name VARCHAR(100)
	,@agent_parent_id VARCHAR(100)
	,@responsemessage VARCHAR(50)
	,@responseCode INT
	,@agent_status varchar(20)
	,@agent_balance decimal(18,2)
     ,@agent_type varchar(30)
	 ,@is_auto_commission char(3)
	 ,@agent_lock_status char(3)
	 ,@commission_id int
	 ,@agent_credit_limit decimal(18,2)
	 ,@parent_id int
	 ,@kyc_status varchar(30)
	 ,@transaction_limit_max decimal(18,2)
	 ,@daily_max_limit decimal(18,2)
	 ,@monthly_max_limit decimal(18,2)
	 ,@daily_txn_amount decimal(18,2)
	 ,@monthly_txn_amount decimal(18,2)

--[pmt_gateway_txn_id] [varchar](20) NULL,        
--[gateway_timestamp] [varchar](20) NULL,        
--[gateway_status] [varchar](50) NULL,        
--[process_id] [varchar](max) NULL,        
--[gateway_process_id] [varchar](max) NULL,        
--[type] [varchar](50) NULL,        
--[error_code] [varchar](10) NULL,        
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from        
	-- interfering with SELECT statements.        
	IF nullif(@user_name, '') IS NOT NULL
		SELECT @user_id = user_id
		FROM tbl_user_detail with (nolock)
		WHERE (
				user_name = @user_name
				OR user_email = @user_name
				OR user_mobile_no = @user_name
				)

				IF nullif(@user_name, '') IS  NULL
		SELECT @user_id = user_id
		FROM tbl_user_detail with (nolock)
		WHERE (
				user_name = @action_user
				OR user_email = @action_user
				OR user_mobile_no = @action_user
				)

	SET NOCOUNT ON;

	IF @flag = 'i'
	BEGIN
		IF EXISTS (
				SELECT 'x'
				FROM tbl_payment_gateway_transaction with (nolock)
				WHERE pmt_gateway_txn_id = @pmt_gateway_txn_id
					AND STATUS = 'pending'
				)
		BEGIN
			SELECT '1' Code
				,'Transaction already exists, status pending' Message
				,NULL Id

			RETURN
		END

		IF EXISTS (
				SELECT 'x'
				FROM tbl_payment_gateway_transaction with (nolock)
				WHERE pmt_gateway_txn_id = @pmt_gateway_txn_id
					AND STATUS = 'received'
				)
		BEGIN
			SELECT '1' Code
				,'Transaction already exists' Message
				,NULL Id

			RETURN
		END

		SELECT @agent_id = agent_id
			,@user_name = user_name
			,@mobile = user_mobile_no
			,@email = user_email
		FROM tbl_user_detail with (nolock)
		WHERE user_id = @user_id


		SELECT @agent_status = agent_status
					,@agent_balance = ISNULL(available_balance, 0)
					,@agent_type = agent_type
					,@is_auto_commission = ISNULL(is_auto_commission, 1)
					,@agent_lock_status = lock_status
					,@commission_id = agent_commission_id
					,@agent_credit_limit = ISNULL(agent_credit_limit, 0)
					,@parent_id = parent_id
					,@kyc_status = CASE kyc_status
						WHEN 'Approved'
							THEN 'verified'
						ELSE 'not verified'
						END
				FROM tbl_agent_detail
				WHERE agent_id = @agent_id;

				SELECT @transaction_limit_max = transaction_limit_max
					,@daily_max_limit = transaction_daily_limit_max
					,@monthly_max_limit = transaction_monthly_limit_max
				FROM tbl_NRB_transaction_limit
				WHERE KYC_Status = @kyc_status
					AND txn_type = 'Load';--Load Balance

				SELECT @daily_txn_amount = ISNULL(SUM(CASE 
								WHEN (
										DAY(created_UTC_date) = DAY(GETUTCDATE())
										AND MONTH(created_UTC_date) = MONTH(GETUTCDATE())
										AND YEAR(created_UTC_date) = YEAR(GETUTCDATE())
										)
									THEN amount
								END), 0)
					,@monthly_txn_amount = ISNULL(SUM(CASE 
								WHEN (
										MONTH(created_UTC_date) = MONTH(GETUTCDATE())
										AND YEAR(created_UTC_date) = YEAR(GETUTCDATE())
										)
									THEN amount
								END), 0)
				FROM tbl_transaction
				WHERE STATUS = 'success'
					AND agent_id = @agent_id;

				IF @amount > @transaction_limit_max
				BEGIN
					SELECT '1' code
						,'Transaction Limit Exceeded' message
						,NULL id;

					RETURN;
				END;

				IF (@amount + @monthly_txn_amount) > @monthly_max_limit
				BEGIN
					SELECT '1' code
						,'Monthly Transaction Limit Exceeded' message
						,NULL id;

					RETURN;
				END;

				IF (@amount + @daily_txn_amount) > @daily_max_limit
				BEGIN
					SELECT '1' code
						,'Daily Transaction Limit Exceeded' message
						,NULL id;

					RETURN;
				END;


		SET @total_amount = @amount
		SET @process_id = replace(NEWID(), '-', '_')

		INSERT INTO tbl_payment_gateway_transaction (
			[amount]
			,[service_charge]
			,[total_amount]
			,[status]
			,[remarks]
			,[email]
			,[mobile]
			,[agent_id]
			,[user_id]
			,[user_name]
			,[process_id]
			,[created_UTC_date]
			,[created_local_date]
			,[created_nepali_date]
			,[created_by]
			,[createdplatform]
			,[created_ip]
			)
		VALUES (
			@amount
			,@service_charge
			,@total_amount
			,'pending'
			,@remarks
			,@email
			,@mobile
			,@agent_id
			,@user_id
			,@user_name
			,@process_id
			,GETUTCDATE()
			,GETDATE()
			,dbo.func_get_nepali_date(GETDATE())
			,@action_user
			,@action_browser
			,@action_ip
			)

		SELECT '0' Code
			,'Success' Message
			,SCOPE_IDENTITY() Id
			,@remarks Remarks

		RETURN
	END

	IF @flag = 'u'
	BEGIN
		IF EXISTS (
				SELECT 'x'
				FROM tbl_payment_gateway_transaction with (nolock)
				WHERE pmt_gateway_txn_id = @pmt_gateway_txn_id
					AND STATUS = 'pending'
				)
		BEGIN
			SELECT '1' Code
				,'Transaction already exists, status pending' Message
				,NULL Id

			RETURN
		END

		IF EXISTS (
				SELECT 'x'
				FROM tbl_payment_gateway_transaction with (nolock)
				WHERE pmt_gateway_txn_id = @pmt_gateway_txn_id
					AND pmt_txn_id = @pmt_txn_id
					AND STATUS = 'Recieved'
					AND gateway_status = 'Success'
				)
		BEGIN
			SELECT '1' Code
				,'Transaction already exists' Message
				,NULL Id

			RETURN
		END

		UPDATE tbl_payment_gateway_transaction
		SET pmt_gateway_id = @pmt_gateway_id
			,pmt_gateway_name = @pmt_gateway_name
			,pmt_gateway_txn_id = @pmt_gateway_txn_id
			,gateway_timestamp = @gateway_timestamp
			,gateway_status = @gateway_status
			,STATUS = 'Recieved'
			,gateway_process_id = @gateway_process_id
			,updated_by = @action_user
			,updated_UTC_date = GETUTCDATE()
			,updated_local_date = GETDATE()
			,updated_nepali_date = dbo.func_get_nepali_date(GETDATE())
			,updated_ip = @action_ip
			,service_charge=@service_charge
			,total_amount=@amount
			,type = @txn_type
		WHERE pmt_txn_id = @pmt_txn_id
			AND gateway_status IS NULL

		IF @agent_id IS NULL or @amount is null
		BEGIN
			SELECT @agent_id = u.agent_id
				,@amount = pmt.amount
				,@agent_parent_id = parent_id
				,@agent_name = agent_name
			FROM tbl_user_detail u with (nolock)
			JOIN tbl_agent_detail ad with (nolock) ON ad.agent_id = u.agent_id
			JOIN tbl_payment_gateway_transaction pmt with (nolock) ON pmt.created_by = u.user_name
			WHERE pmt.pmt_txn_id = @pmt_txn_id
		END

		if @agent_id is null
		select @agent_id =agent_id from tbl_payment_gateway_transaction with (nolock) where pmt_txn_id=@pmt_txn_id

		IF @gateway_status <> 'Success'
		BEGIN
			UPDATE tbl_payment_gateway_transaction
			SET STATUS = 'Failed'
			WHERE pmt_txn_id = @pmt_txn_id

			SELECT 1 code
				,'Couldn''t get response from gateway' Message
				,NULL id

			RETURN
		END

		DECLARE @oldGatewayStatus VARCHAR(20)

		SELECT @oldGatewayStatus = gateway_status
		FROM tbl_payment_gateway_transaction with (nolock)
		WHERE pmt_gateway_txn_id = @pmt_gateway_txn_id

		IF @gateway_status = 'Success'
		BEGIN
			--SELECT 0 code      
			-- ,'success' message      
			-- ,*      
			--FROM tbl_payment_gateway_transaction p      
			--JOIN tbl_agent_detail ad ON ad.agent_id = p.agent_id      
			--JOIN tbl_user_detail u ON u.user_id = p.user_id      
			--WHERE pmt_txn_id = @pmt_txn_id      
			--select @agent_id,@amount

			UPDATE tbl_agent_detail
			SET available_balance = isnull(available_balance, 0) + isnull(@amount, 0)
			WHERE agent_id = @agent_id

			INSERT INTO [dbo].[tbl_agent_balance] (
				[agent_id]
				,[agent_parent_id]
				,[agent_name]
				,[amount]
				,[currency_code]
				,[agent_remarks]
				,[user_id]
				,[txn_type]
				,[txn_mode]
				,[txn_id]
				,[pmt_gateway_id]
				,[pmt_gateway_txn_id]
				,bank_name
				,[created_UTC_date]
				,[created_local_date]
				,[created_nepali_date]
				,[created_by]
				,[created_ip]
				,[created_platform]
				)
			VALUES (
				@agent_id
				,@agent_parent_id
				,@agent_name
				,@amount
				,'NPR'
				,'Fund Load of NPR ' + cast(@amount AS VARCHAR) --+ ' from ' +@pmt_gateway_name      
				,@user_id
				,'Dig'
				,'CR'
				,@pmt_txn_id
				,@pmt_gateway_id
				,@pmt_gateway_txn_id
				,@pmt_gateway_name
				,GETUTCDATE()
				,GETDATE()
				,dbo.func_get_nepali_date(DEFAULT)
				,@action_user
				,@action_ip
				,'Web'
				)
				SELECT '0' Code
			,'Success' Message
			,@pmt_txn_id Id;

			RETURN
		END

		SELECT '0' Code
			,'Success' Message
			,@pmt_txn_id Id;

		--@pmt_gateway_txn_id  pmtGatewayTxnid,        
		--  @pmt_txn_id TxnId,        
		--  status TxnStatus,        
		--  amount Amount,        
		--  gateway_status GatewayStatus,        
		--  agent_id ,        
		--  user_name username        
		--  from tbl_payment_gateway_transaction        
		--  where pmt_txn_id = @pmt_txn_id;        
		RETURN
	END

	IF @flag = 'c'
	BEGIN
		IF @pmt_gateway_txn_id IS NULL
		BEGIN
			SELECT '1' Code
				,'Gateway Txn Id is required' Message
				,NULL Id

			RETURN
		END

		IF @merchat_txn_id IS NULL
		BEGIN
			SELECT '1' Code
				,'Merchant Txn Id is required' Message
				,NULL Id

			RETURN
		END

		IF EXISTS (
				SELECT 'x'
				FROM tbl_payment_gateway_transaction with (nolock)
				WHERE pmt_gateway_txn_id = @pmt_gateway_txn_id
					AND pmt_txn_id = @merchat_txn_id
				)
		BEGIN
			SELECT '0' Code
				,'Already Received' Message
				,NULL id

			RETURN
		END
		ELSE IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_payment_gateway_transaction with (nolock)
				WHERE pmt_txn_id = @merchat_txn_id
				)
		BEGIN
			SELECT '1' code
				,'Transaction Not Found' message
				,NULL id

			RETURN
		END
		ELSE
			SELECT '0' code
				,'transaction found' message
				,NULL id

		RETURN
	END

	IF @flag = 's'
	BEGIN
		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_payment_gateway_transaction with (nolock)
				WHERE pmt_gateway_txn_id = @pmt_gateway_txn_id
					AND pmt_txn_id = @merchat_txn_id
				)
		BEGIN
			SELECT '0' Code
				,'Transaction not found' Message
				,NULL id

			RETURN
		END
		ELSE
		BEGIN
			SELECT @status = STATUS
			FROM tbl_payment_gateway_transaction with (nolock)
			WHERE pmt_gateway_txn_id = @pmt_gateway_txn_id
				AND pmt_txn_id = @merchat_txn_id
		END

		IF @status = 'Recieved'
		BEGIN
			SET @responsecode = 0
			SET @responsemessage = 'Transaction Successful'
		END

		IF @status = 'Failed'
		BEGIN
			SET @responsecode = 1
			SET @responsemessage = 'Transaction Failed'
		END

		IF @status = 'pending'
		BEGIN
			SET @responsecode = 1
			SET @responsemessage = 'Transaction Pending'
		END

		SELECT @responseCode Code
			,@responsemessage Message
			,pmt_gateway_txn_id
			,pmt_txn_id
			,STATUS TxnStatus
			,amount Amount
			,gateway_status
			,agent_id
			,user_name
			,pmt_gateway_name AS BankName
			,type AS [Type]
		FROM tbl_payment_gateway_transaction with (nolock)
		WHERE pmt_txn_id = @merchat_txn_id
			AND pmt_gateway_txn_id = @pmt_gateway_txn_id;
	END

	IF @flag = 'up'
	BEGIN
		IF @gateway_process_id IS NULL
		BEGIN
			SELECT '1' Code
				,'Gateway Process Id' Message
				,NULL Id

			RETURN
		END

		IF @merchat_txn_id IS NULL
		BEGIN
			SELECT '1' Code
				,'Merchant Txn Id is required' Message
				,NULL Id

			RETURN
		END

		UPDATE tbl_payment_gateway_transaction
		SET gateway_process_id = @gateway_process_id
		WHERE pmt_txn_id = @merchat_txn_id

		SELECT '0' Code
			,'Gateway Process Id Updated'
			,@merchat_txn_id Id
	END

	IF @flag = 'r'
	BEGIN
		SELECT created_local_date
			,remarks
			,pmt_txn_id
			,amount Amount
			,gateway_status
			,pmt_gateway_name AS BankName
			,type AS InstrumentName
			,(
				SELECT available_balance
				FROM tbl_agent_detail ad with (nolock)
				INNER JOIN tbl_user_detail tu with (nolock) ON tu.agent_id = ad.agent_id
				WHERE tu.user_id = @user_id
				) AvailableBalance
		FROM tbl_payment_gateway_transaction with (nolock)
		WHERE pmt_txn_id = @merchat_txnid
	END
		IF @flag = 'c1' --test load fund
	BEGIN
		

		IF @merchat_txn_id IS NULL
		BEGIN
			SELECT '1' Code
				,'Merchant Txn Id is required' Message
				,NULL Id

			RETURN
		END

		IF EXISTS (
				SELECT 'x'
				FROM tbl_payment_gateway_transaction with (nolock)
				WHERE pmt_txn_id = @merchat_txn_id
				)
		BEGIN
			SELECT '0' Code
				,'Already Received' Message
				,NULL id

			RETURN
		END
		ELSE IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_payment_gateway_transaction with (nolock)
				WHERE pmt_txn_id = @merchat_txn_id
				)
		BEGIN
			SELECT '1' code
				,'Transaction Not Found' message
				,NULL id

			RETURN
		END
		ELSE
			SELECT '0' code
				,'transaction found' message
				,NULL id

		RETURN
	END
END







GO


