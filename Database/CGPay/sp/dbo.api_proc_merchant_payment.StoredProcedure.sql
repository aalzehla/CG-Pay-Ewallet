USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[api_proc_merchant_payment]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE   PROCEDURE [dbo].[api_proc_merchant_payment]
	-- Add the parameters for the stored procedure here  
	@flag CHAR(3)
	,@card_no VARCHAR(16) = NULL
	,@merchant_user_name VARCHAR(512) = NULL
	,@payable_amount DECIMAL(18, 2) = NULL
	,@payment_description VARCHAR(512) = NULL
	,@payment_OTP_code VARCHAR(6) = NULL
	,@txn_id INT = NULL
	,@action_user VARCHAR(512) = NULL
	,@merchant_payment_remarks VARCHAR(max) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from  
	-- interfering with SELECT statements.  
	SET NOCOUNT ON;

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

	/* merchant payment*/
	IF @flag = 'mp'
	BEGIN
		IF @card_no IS NULL
		BEGIN
			SELECT 177 code
				,'Card number is required' message
				,NULL id

			RETURN
		END

		IF @merchant_user_name IS NULL
		BEGIN
			SELECT 181 code
				,'Merchant user name is required' message
				,NULL id

			RETURN
		END

		IF @payable_amount IS NULL
			OR isnull(@payable_amount, 0) < 0
		BEGIN
			SELECT 182 code
				,'Invalid amount' message
				,NULL id

			RETURN
		END

		SELECT @merchant_user_id = u.user_id
			,@merchant_agent_id = ad.agent_id
			,@merchant_available_balance = isnull(ad.available_balance, 0)
		FROM tbl_user_detail u
		JOIN tbl_agent_detail ad ON ad.agent_id = u.agent_id
		WHERE u.user_name = @merchant_user_name

		SELECT @customer_user_id = u.user_id
			,@customer_agent_id = ad.agent_id
			,@customer_available_balance = isnull(ad.available_balance, 0)
		FROM tbl_agent_card_management tc
		INNER JOIN tbl_agent_detail ad ON ad.agent_id = tc.agent_id
		INNER JOIN tbl_user_detail u ON u.agent_id = ad.agent_id
		WHERE tc.card_no = @card_no

		IF @payable_amount < @customer_available_balance
		BEGIN
			SELECT 162 code
				,'Customer Balance is less than payment amount' message
				,NULL id

			RETURN
		END

		BEGIN TRY
			BEGIN TRANSACTION merchantPayment

			--deduct customer balance  
			UPDATE tbl_agent_detail
			SET available_balance = available_balance - @payable_amount
			WHERE agent_id = @customer_agent_id

			SELECT @customer_available_balance = isnull(available_balance, 0)
			FROM tbl_agent_Detail
			WHERE agent_id = @customer_agent_id

			--add merchant balance  
			UPDATE tbl_agent_detail
			SET available_balance = available_balance + @payable_amount
			WHERE agent_id = @merchant_agent_id

			SELECT @merchant_available_balance = isnull(available_balance, 0)
			FROM tbl_agent_Detail
			WHERE agent_id = @merchant_agent_id

			SET @customer_remarks = 'Payment to merchant: ' + @merchant_name + 'of amount: ' + @payable_amount + 'for purchase of ' + @merchant_payment_remarks
			SET @merchant_remarks = 'Payment by Customer: ' + @customer_name + 'of amount: ' + @payable_amount + 'for purchase of ' + @merchant_payment_remarks

			-- insert into agent balance for merchant(CR) and customer(DR)  
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
		END TRY

		BEGIN CATCH
			IF @@trancount > 0
				ROLLBACK TRANSACTION merchantPayment

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
END


GO
