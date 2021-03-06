USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[api_proc_merchant_payment_new]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE                        
	

 PROCEDURE [dbo].[api_proc_merchant_payment_new]
	-- Add the parameters for the stored procedure here
	@flag CHAR(3)
	,@card_no VARCHAR(16) = NULL
	,@merchant_user_name VARCHAR(512) = NULL
	,@payable_amount DECIMAL(18,2) = NULL
	,@payment_description VARCHAR(512) = NULL
	,@payment_OTP_code VARCHAR(6) = NULL
	,@txn_id INT = NULL
	,@action_user VARCHAR(512) = NULL
	,@merchant_payment_remarks VARCHAR(max) = NULL
	,@file_name nvarchar(max) =  null
	,@file_path nvarchar(max) =  null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT on;

	DECLARE @desc nVARCHAR(max)
		,@merchant_user_id INT
		,@merchant_available_balance DECIMAL(18, 2)
		,@merchant_agent_id INT
		,@merchant_name VARCHAR(100)
		,@merchant_remarks VARCHAR(512)
		,@customer_user_id INT
		,@customer_available_balance DECIMAL(18, 2)
		,@customer_agent_id INT
		,@customer_name VARCHAR(100)
		,@customer_mobile_number VARCHAR(15)
		,@customer_remarks VARCHAR(512)
		,@action_ip VARCHAR(20)
		,@gen_verification_code VARCHAR(6)
		,@OTP_code_time int
		,@OTP_sent_status VARCHAR(20)
		,@OTP_code VARCHAR(6)

			--for notification json
		declare @notiId int; declare @dataPayload varchar(max);
		

	SET @gen_verification_code = dbo.[func_generate_verify_code](6)

	/*payment image upload*/
	IF (@flag = 'fu')
BEGIN
	INSERT INTO tbl_file_upload_log (
		file_name
		,file_path
		,upload_local_date
		,upload_UTC_date
		,upload_nepali_date
		,upload_by
		,upload_from_ip
		)
	VALUES (
		@file_name
		,@file_path
		,GETDATE()
		,GETUTCDATE()
		,dbo.func_get_nepali_Date(DEFAULT)
		,@action_user
		,@action_ip
		)

		select '0' code, 'file uploaded successfully' message, null id
		return;
END
	/*check card status*/
	IF @card_no IS NULL
	BEGIN
		SELECT 177 code
			,'Card number is required' message
			,NULL id

		RETURN
	END

	IF @card_no IS NOT NULL
	BEGIN
		IF EXISTS (
				SELECT 'x'
				FROM tbl_agent_card_management with (nolock)
				WHERE card_no = @card_no
					AND isnull(is_active, 'n') = 'n'
				)
		BEGIN
			SELECT 176 code
				,'Invalid card or Card not Found' message
				,NULL id

			RETURN
		END
	END

	/*get merchant detail*/
	SELECT @merchant_user_id = u.user_id
		,@merchant_agent_id = ad.agent_id
		,@merchant_available_balance = isnull(ad.available_balance, 0)
		,@merchant_name  = ad.full_name
	FROM tbl_user_detail u with (nolock)
	JOIN tbl_agent_detail ad ON ad.agent_id = u.agent_id
	WHERE u.user_mobile_no = @merchant_user_name or u.user_email = @merchant_user_name

	SELECT @customer_user_id = u.user_id
		,@customer_agent_id = ad.agent_id
		,@customer_available_balance = isnull(ad.available_balance, 0)
		,@customer_mobile_number = u.user_mobile_no
		,@customer_name = ad.full_name
	FROM tbl_agent_card_management tc with (nolock)
	INNER JOIN tbl_agent_detail ad ON ad.agent_id = tc.agent_id
	INNER JOIN tbl_user_detail u ON u.agent_id = ad.agent_id
	WHERE tc.card_no = @card_no

	/* merchant payment*/
	IF @flag = 'mp'
	BEGIN
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

		IF @payable_amount > @customer_available_balance
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
			SET available_balance = isnull(available_balance,0) - @payable_amount
			WHERE agent_id = @customer_agent_id
		

			SELECT @customer_available_balance = isnull(available_balance, 0)
			FROM tbl_agent_Detail with (nolock)
			WHERE agent_id = @customer_agent_id

							
			--add merchant balance
			UPDATE tbl_agent_detail
			SET available_balance = isnull(available_balance,0) + @payable_amount
			WHERE agent_id = @merchant_agent_id
	

			SELECT @merchant_available_balance = isnull(available_balance, 0)
			FROM tbl_agent_Detail with (nolock)
			WHERE agent_id = @merchant_agent_id
			

			--select @merchant_name, @customer_name, @payable_amount
			SET @customer_remarks = 'Payment to Merchant: ' + @merchant_name + ' of amount: ' + cast(@payable_amount as varchar) + ' NPR for purchase of ' + @merchant_payment_remarks
			SET @merchant_remarks = 'Payment by Customer: ' + @customer_name + ' of amount: ' + cast(@payable_amount as varchar) + ' NPR for purchase of ' + @merchant_payment_remarks
		
						--select @customer_remarks,@merchant_remarks

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
				cast(@merchant_agent_id as varchar)
				,@merchant_name
				,@payable_amount
				,'NPR'
				,@merchant_remarks
				,cast(@merchant_user_id as varchar)
				,'mp'
				,'CR'
				,cast(@txn_id as varchar(20))
				,GETUTCDATE()
				,GETDATE()
				,dbo.func_get_nepali_date(DEFAULT)
				,@merchant_user_id
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
				cast(@customer_agent_id as varchar)
				,@customer_name
				,@payable_amount
				,'NPR'
				,@customer_remarks
				,cast(@merchant_user_id as varchar)
				,'mp'
				,'DR'
				,CAST( @txn_id as varchar)
				,GETUTCDATE()
				,GETDATE()
				,dbo.func_get_nepali_date(DEFAULT)
				,@merchant_user_id
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
				,'N'
				,cast(@merchant_user_id as varchar)
				,@merchant_agent_id
				,@merchant_user_id
				,GETUTCDATE()
				,GETDATE()
				,dbo.func_get_nepali_date(DEFAULT)
				,@merchant_user_id
				,'n'
				,@merchant_available_balance
				)
				set @notiId = @@IDENTITY
			set @dataPayload = dbo.func_notification_payload (@notiId ,   NULL,@payable_amount);
			update tbl_agent_notification set data_payload =  @dataPayload where notification_id = @notiId

			
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
				,'N'
				,cast(@customer_user_id as varchar)
				,@customer_agent_id
				,@customer_user_id
				,GETUTCDATE()
				,GETDATE()
				,dbo.func_get_nepali_date(DEFAULT)
				,@merchant_user_id
				,'n'
				,@customer_available_balance
				)
				set @notiId = @@IDENTITY
			set @dataPayload = dbo.func_notification_payload (@notiId ,   NULL,@payable_amount);
			update tbl_agent_notification set data_payload =  @dataPayload where notification_id = @notiId


				Commit TRANSACTION merchantPayment
				select 0 code, 'Merchant Payment Succesful' message, @customer_name farmerName, @customer_name companyName, @payable_amount Amount,@merchant_remarks [Description], GETDATE() as [date]  ,null id , @merchant_available_balance merchant_available_balance
				return
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

	/*regenerate/get OTP code*/
	IF @flag = 'otp'
	BEGIN
		/*insert into sms table*/
		INSERT INTO tbl_sms_transaction (
			country
			,agent_id
			,sms_destination
			,sms_message_type
			,message
			,STATUS
			,created_by
			,created_date
			)
		VALUES (
			'Nepal'
			,@customer_agent_id
			,@customer_mobile_number
			,1
			,'Your payment OTP code is ' + @gen_verification_code
			,'Pending'
			,@merchant_user_id
			,GETDATE()
			)

		/*insert into verificatoin code table*/
		INSERT INTO tbl_verification_sent (
			Mobile_Number
			,verification_code
			,verification_Status
			,send_date_time
			)
		VALUES (
			@customer_mobile_number
			,@gen_verification_code
			,'Sent'
			,GETDATE()
			)
			select 0 code, 'OTP generated succesfully' message, null id
	END

	/*verify OTP code*/
	IF @flag = 'v'
	BEGIN
		SELECT top 1 @OTP_code_time = datediff(second, send_date_time, getdate())
			,@OTP_sent_status = verification_Status
			,@OTP_code = verification_code
		FROM tbl_verification_sent with (nolock)
		WHERE mobile_number = @customer_mobile_number
		order by send_date_time desc

		--select @OTP_code_time, @OTP_sent_status, @OTP_code, @customer_mobile_number
		--return

		/*otp expires in 2 minutes*/
		if @OTP_code_time > 120 
		begin
			update tbl_verification_sent set verification_Status = 'Expired' where Mobile_Number =  @customer_mobile_number 
			select 172 code,'OTP Code is already expired, please regenerate OTP Code' message, null id
			return
		end

		if @OTP_sent_status != ltrim('Sent')
		begin
			select 183 code, 'OTP Code already used, please regenerate OTP Code ' message, null id
			return
		end

		if @OTP_code != @payment_OTP_code
		begin
			select 184 code, 'OTP code didn''t match, please try again' message, null id
			return
		end

		if @OTP_code = @payment_OTP_code
		begin
			update tbl_verification_sent set verification_Status = 'Used' where Mobile_Number =  @customer_mobile_number  and  verification_code = @OTP_code
			select 0 code, 'OTP code verified succesfully' message, null id
			return
		end
	END

	/*Get Farmer Detail*/
	If(@flag = 'sf')
	BEGIN
	IF @card_no IS NULL
	BEGIN
		SELECT 177 code
			,'Card number is required' message
			,NULL id

		RETURN
	END

	IF @card_no IS NOT NULL
	BEGIN
		IF EXISTS (
				SELECT 'x'
				FROM tbl_agent_card_management with (nolock)
				WHERE card_no = @card_no
					AND isnull(is_active, 'n') = 'n'
				)
		BEGIN
			SELECT 176 code
				,'Invalid card or Card not Found' message
				,NULL id

			RETURN
		END
	END
		select isnull(ta.first_name, '') + ' ' + isnull(ta.middle_name, '') + ' ' + isnull(ta.last_name, '') as  agent_name        
,      ta.agent_email_address
,      ta.agent_name          company_name
from       tbl_agent_detail          ta with (nolock)
inner join tbl_user_detail           td with (nolock) on ta.agent_id = td.agent_id
inner join tbl_agent_card_management tc with (nolock) on tc.agent_id = ta.agent_id
where tc.card_no = @card_no

	END





END












GO
