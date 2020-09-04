USE [CGPay]
GO

/****** Object:  StoredProcedure [dbo].[api_proc_merchant_payment]    Script Date: 8/11/2020 6:47:12 PM ******/
DROP PROCEDURE [dbo].[api_proc_merchant_payment]
GO

/****** Object:  StoredProcedure [dbo].[api_proc_merchant_payment]    Script Date: 8/11/2020 6:47:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE
	
 PROCEDURE [dbo].[api_proc_merchant_payment] @flag CHAR(3)
	,@user_mobile_no VARCHAR(512) = NULL
	,@payable_amount DECIMAL(18, 2) = NULL
	,@payment_description VARCHAR(512) = NULL
	,@payment_OTP_code VARCHAR(6) = NULL
	,@txn_id INT = NULL
	,@action_user VARCHAR(512) = NULL
	,@merchant_payment_remarks VARCHAR(max) = NULL
	,@merchant_Code VARCHAR(20) = NULL
	,@merchant_fullname VARCHAR(20) = NULL
AS
BEGIN
	DECLARE @desc VARCHAR(max)
		,@merchant_user_id INT
		,@merchant_available_balance DECIMAL(18, 2)
		,@merchant_agent_id INT
		,@merchant_name VARCHAR(100)
		,@merchant_remarks VARCHAR(512)
		,@customer_user_id INT
		,@customer_available_balance DECIMAL(18, 2)
		,@customer_agent_id INT
		,@customer_name VARCHAR(100)
		,@customer_remarks VARCHAR(512)
		,@action_ip VARCHAR(20)
		,@merchant_parent_id INT
		,@service_charge DECIMAL(18, 2)
		,@commission_amt DECIMAL(18, 2)

	/*merchant payment*/
	IF @flag = 'mp'
	BEGIN
		--merchant code is required
		IF @merchant_code IS NULL
		BEGIN
			SELECT 181 code
				,'Invalid Merchant' message
				,NULL id

			RETURN
		END

		--payable amount shouldn't be 0
		IF @payable_amount IS NULL
			OR isnull(@payable_amount, 0) < 0
		BEGIN
			SELECT 182 code
				,'Invalid amount' message
				,NULL id

			RETURN
		END

		--get usermobile from app, shouldn't be null
		IF @user_mobile_no IS NULL
		BEGIN
			SELECT 1 code
				,'Customer Mobile Number is required' message
				,NULL id

			RETURN
		END

		--check if mobile number exists
		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_user_detail
				WHERE user_mobile_no = @user_mobile_no or user_email  = @user_mobile_no
				)
		BEGIN
			SELECT 1 code
				,'Customer Not Found' Message
				,NULL id

			RETURN
		END
		else
		begin
			Select @user_mobile_no = user_mobile_no from tbl_user_detail WHERE user_mobile_no = @user_mobile_no or user_email  = @user_mobile_no 
		end

		--check if merchant exists against the merchant code recieved after scanning the QR code
		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_agent_detail
				WHERE agent_code = @merchant_code
				)
		BEGIN
			SELECT 1 code
				,'Merchant Not Found' Message
				,NULL id

			RETURN
		END

		--check merchant name
		IF @merchant_fullname <> @merchant_name
		BEGIN
			SELECT 1 code
				,'Merchant Name Not Matched' Message
				,NULL id

			RETURN
		END

		--get customer detail against the mobile number
		SELECT @customer_user_id = u.user_id
			,@customer_agent_id = ad.agent_id
			,@customer_available_balance = isnull(ad.available_balance, 0)
			,@customer_name = u.full_name
		FROM tbl_user_detail u
		INNER JOIN tbl_agent_detail ad ON ad.agent_id = u.agent_id
		WHERE u.user_mobile_no = @user_mobile_no

		--get merchant detail against the merchant code recieved
		SELECT @merchant_user_id = u.user_id
			,@merchant_agent_id = ad.agent_id
			,@merchant_available_balance = isnull(ad.available_balance, 0)
			,@merchant_name = ad.agent_name
		FROM tbl_agent_Detail ad
		JOIN tbl_user_detail u ON u.agent_id = ad.agent_id
		WHERE ad.agent_code = @merchant_code

		IF @payable_amount > @customer_available_balance
		BEGIN
			SELECT 162 code
				,'Customer Balance is less than payment amount' message
				,NULL id

			RETURN
		END

		IF @action_user IS NULL
		BEGIN
			SET @action_user = @customer_user_id
		END

		BEGIN TRY
			BEGIN TRANSACTION merchantPayment

			--deduct customer balance  
			UPDATE tbl_agent_detail
			SET available_balance = isnull(available_balance, 0) - @payable_amount
			WHERE agent_id = @customer_agent_id

			SELECT @customer_available_balance = isnull(available_balance, 0)
			FROM tbl_agent_Detail
			WHERE agent_id = @customer_agent_id

			--add merchant balance  
			UPDATE tbl_agent_detail
			SET available_balance = isnull(available_balance, 0) + @payable_amount
			WHERE agent_id = @merchant_agent_id

			SELECT @merchant_available_balance = isnull(available_balance, 0)
			FROM tbl_agent_Detail
			WHERE agent_id = @merchant_agent_id

			SET @customer_remarks = 'Payment to merchant: ' + isnull(@merchant_name, '') + ' of amount: ' + cast(@payable_amount AS VARCHAR) + ' for purchase of ' + isnull(@merchant_payment_remarks, '')
			SET @merchant_remarks = 'Payment by Customer: ' + isnull(@customer_name, '') + ' of amount: ' + cast(@payable_amount AS VARCHAR) + ' for purchase of ' + isnull(@merchant_payment_remarks, '')

			--select @customer_agent_id CustomerAgentId, @customer_available_balance customerAvailableBalance, @customer_name CustomerName, @customer_remarks CustomerRemarks, @customer_user_id CustomerUSerId
			--select @merchant_agent_id merchantagentId, @merchant_available_balance MerchantAvailableBalance, @merchant_Code MerchantCode, @merchant_name merchantName, @merchant_payment_remarks merchantpmtRemarks, @merchant_remarks merchantRemarks, @merchant_user_id MerchantUserid
			-- insert into agent balance for merchant(CR) and customer(DR)  

			INSERT INTO tbl_agent_QR_transaction (
				agent_id
				,agent_parent_id
				,agent_name
				,Agent_code
				,amount
				,service_charge
				,commission_amt
				,pmt_description
				,PaymentBy
				,created_by
				,created_local_date
				,created_UTC_date
				,created_nepali_date
				,created_ip
				)
			VALUES (
				@merchant_agent_id
				,@merchant_parent_id
				,@merchant_name
				,@merchant_Code
				,@payable_amount
				,isnull(@service_charge,0)
				,isnull(@commission_amt,0)
				,@merchant_payment_remarks
				,@customer_name + '[ID:'+cast(@customer_user_id as varchar)+']'
				,@action_user
				,GETDATE()
				,GETUTCDATE()
				,dbo.func_get_nepali_date(DEFAULT)
				,@action_ip
				)

			SET @txn_id = SCOPE_IDENTITY()



			--select * from tbl_agent_balance  
			INSERT INTO tbl_agent_balance (
				agent_id
				,agent_name
				,amount
				,currency_code
				,agent_remarks
				,user_id
				,txn_type
				,txn_mode
				,txn_id
				,created_UTC_date
				,created_local_date
				,created_nepali_date
				,created_by
				,created_ip
				,created_platform
				)
			VALUES (
				@merchant_agent_id
				,@merchant_name
				,@payable_amount
				,'NPR'
				,@merchant_remarks
				,@merchant_user_id
				,'mp'
				,'CR'
				,@txn_id
				,GETUTCDATE()
				,GETDATE()
				,dbo.func_get_nepali_date(DEFAULT)
				,@action_user
				,@action_ip
				,'app'
				)

			INSERT INTO tbl_agent_balance (
				agent_id
				,agent_name
				,amount
				,currency_code
				,agent_remarks
				,user_id
				,txn_type
				,txn_mode
				,txn_id
				,created_UTC_date
				,created_local_date
				,created_nepali_date
				,created_by
				,created_ip
				,created_platform
				)
			VALUES (
				@customer_agent_id
				,@customer_name
				,@payable_amount
				,'NPR'
				,@customer_remarks
				,@merchant_user_id
				,'mp'
				,'DR'
				,@txn_id
				,GETUTCDATE()
				,GETDATE()
				,dbo.func_get_nepali_date(DEFAULT)
				,@action_user
				,@action_ip
				,'app'
				)

			--insert into notification table  
			INSERT INTO tbl_agent_notification (
				notification_subject
				,notification_body
				,notification_type
				,notification_status
				,notification_to
				,agent_id
				,user_id
				,created_UTC_date
				,created_local_date
				,created_nepali_date
				,created_by
				,read_status
				,Remaining_Balance
				)
			VALUES (
				'Merchant Payment'
				,@merchant_remarks
				,'Merchant_Payment'
				,'n'
				,@merchant_user_id
				,@merchant_agent_id
				,@merchant_user_id
				,GETUTCDATE()
				,GETDATE()
				,dbo.func_get_nepali_date(DEFAULT)
				,@action_user
				,'n'
				,@merchant_available_balance
				)

			INSERT INTO tbl_agent_notification (
				notification_subject
				,notification_body
				,notification_type
				,notification_status
				,notification_to
				,agent_id
				,user_id
				,created_UTC_date
				,created_local_date
				,created_nepali_date
				,created_by
				,read_status
				,Remaining_Balance
				)
			VALUES (
				'Merchant Payment'
				,@customer_remarks
				,'Merchant_Payment'
				,'n'
				,@customer_user_id
				,@customer_agent_id
				,@customer_user_id
				,GETUTCDATE()
				,GETDATE()
				,dbo.func_get_nepali_date(DEFAULT)
				,@action_user
				,'n'
				,@customer_available_balance
				)

			COMMIT TRANSACTION merchantPayment

			SELECT 0 code
				,'Merchant Payment Successful' message
				--,@customer_name CustomerName
				,@merchant_name MerchantName
				,@payable_amount Amount
				,@merchant_remarks [Description]
				,GETDATE() AS [date]
				,@txn_id id
				,@merchant_available_balance merchant_available_balance
				,@customer_available_balance customer_available_balance

			RETURN
		END TRY

		BEGIN CATCH
			IF @@trancount > 0
				ROLLBACK TRANSACTION merchantPayment

			SET @desc = 'sql error found:(' + error_message() + ')' + ' at ' + cast(error_line() AS VARCHAR)

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
				,'api_proc_merchant_payment(merchantPayment:flag ''mp'')'
				,'sql'
				,'sql'
				,'api_proc_merchant_payment(merchantPayment)'
				,getdate()
				,getutcdate()
				,[dbo].func_get_nepali_date(DEFAULT)

			SELECT '1' code
				,'errorid: ' + cast(scope_identity() AS VARCHAR) message
				,NULL id
		END CATCH
	END

	IF @flag = 'gm' -- get merchant detail
	BEGIN
		IF @merchant_code IS NULL
		BEGIN
			SELECT 181 code
				,'Invalid Merchant' message
				,NULL id

			RETURN
		END

		IF @merchant_code IS NOT NULL
		BEGIN
			IF EXISTS (
					SELECT 'x'
					FROM tbl_agent_detail WITH (NOLOCK)
					WHERE agent_Code = @merchant_Code
						AND isnull(agent_status, 'n') = 'n'
					)
			BEGIN
				SELECT 176 code
					,'Invalid Merchant or Merchant not Found' message
					,NULL id

				RETURN
			END
		END

		SELECT 
			ta.agent_code as merchant_code
			,ta.agent_name merchant_name

		FROM tbl_agent_detail ta WITH (NOLOCK)
		INNER JOIN tbl_user_detail td WITH (NOLOCK) ON ta.agent_id = td.agent_id
		WHERE ta.agent_code = @merchant_Code
	END
END

GO


