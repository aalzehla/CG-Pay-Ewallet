USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_email_request]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================              
-- author:   developer              
-- create date: 25 aug 2019              
-- description: email request              
-- =============================================              
CREATE  
	

 PROCEDURE [dbo].[sproc_email_request] @flag CHAR(3) NULL
	,@agent_id INT = NULL
	,@email_id VARCHAR(50) = NULL
	,@previous_balance MONEY = NULL
	,@current_balance MONEY = NULL
	,@amount MONEY = NULL
	,@subscriber_no VARCHAR(50) = NULL
	,@tcn_id INT = NULL
	,@user_name VARCHAR(50) = NULL
	,@full_name VARCHAR(400) = NULL
	,@bank_name VARCHAR(200) = NULL
	,@txn_date DATETIME = NULL
	,@password VARCHAR(50) = NULL
	,@agent_verification_code VARCHAR(20) = NULL
AS
--flag: d  : registration verification code    
--  dr : registration success    
--  bt : user to user balance transfer    
--  ad : admin to distributor balance transfer    
--  aa : admin to agent balance transfer    
--  ds : distributor to sub-distributor balance trd    
--  da : distributor to agent balance trf    
--  sa : sub-distributor to agent    
--  as : agent to sub_agent   
BEGIN
	DECLARE @email_body VARCHAR(max)
		,@subject VARCHAR(200)
		,@send_by VARCHAR(50)
		,@Ewallet_address VARCHAR(500)
		,@customer_email VARCHAR(50)
	DECLARE @email_subject VARCHAR(100)
		,@balance MONEY
		,@gateway_name VARCHAR(100)
		,@admin_username VARCHAR(100)
		,@admin_email VARCHAR(100)

	IF @full_name IS NULL
	BEGIN
		SELECT @full_name = full_name
			,@email_id = user_email
		FROM tbl_user_detail
		WHERE user_id = @agent_id
	END

	IF @send_by IS NULL
	BEGIN
		SET @send_by = 'support@nepalpayment.com'
	END

	SET @admin_email = 'samir.khadka@nepalpayment.com;sabin@nepalpayment.com'
	SET @Ewallet_address = ' Sundhara, kathmandu <br> info@nepalpayment.com'

	IF @flag = 'd'
	BEGIN
		SET @email_subject = 'Yo! Pay: Verification Code'
		SET @email_body = '<strong>Hello ' + isnull(upper(@full_name), 'user') + ',</strong><br>'
		SET @email_body = @email_body + ' Here is your verification code you need to register with Yo! Pay<br><br> ' + cast(@agent_verification_code AS VARCHAR) + ' <br>'
		SET @email_body = @email_body + ' If you are not trying to register with Yo! Pay, please ignore this email. It is possible that another user entered their registration information incorrectly<br><br>'
		SET @email_body = @email_body + ' <image src="http://202.79.47.32:8084/Content/assets/images/service%20logos/yopay-email-icon.png"></image> <br>'
		SET @email_body = @email_body + ' <strong>The Yo! Pay Support Team <a href = "https://www.yopay.com/">Yo! Pay</a></strong>'
		SET @email_body = @email_body + ' <br>' + isnull(@Ewallet_address, '')
			---insert into email request table              
			---exec sproc_email_sent @flag='i',@email_subject = @email_subject, @email_text=@email_body, @sent_by=@send_by, @sent_to = @email_id, @sent_to_cc = @admin_email,@created_by='System'            
	END -- Registration Verification Code    

	IF @flag = 'dr'
	BEGIN
		SET @email_subject = 'Yo! wallet: Registration'
		SET @email_body = 'Dear ' + isnull(upper(@full_name), 'user') + ',<br>'
		SET @email_body = @email_body + ' <strong>Thank you for Choosing Yo! Pay, you can login with your Email or Mobile Number </strong><br><br>'

		IF @password IS NOT NULL
		BEGIN
			SET @email_body = @email_body + ' <strong>Please use the following password: ' + @password + '  to log in and change it immediately </strong><br><br>'
		END

		SET @email_body = @email_body + ' <image src="http://202.79.47.32:8084/Content/assets/images/service%20logos/yopay-email-icon.png"></image> <br>'
		SET @email_body = @email_body + ' <strong>The Yo! Pay Support Team <a href = "https://www.yopay.com/">Yo! Pay</a></strong>'
		SET @email_body = @email_body + ' <br>' + isnull(@Ewallet_address, '')
			---insert into email request table             
			--exec sproc_email_sent @flag='i',@email_subject = @email_subject, @email_text=@email_body, @sent_by=@send_by, @sent_to = @email_id, @created_by='System'            
	END -- Registration Success    

	IF @flag = 'bt' -- user to user balance transfer    
	BEGIN
		SET @email_subject = 'Yo! Pay: Balance Transfer Request'
		SET @email_body = 'Dear ' + upper(@email_id) + ',<br>'
		SET @email_body = @email_body + 'Balance Transfer Request has been made by<br>'
		SET @email_body = @email_body + ' User: ' + cast(@subscriber_no AS VARCHAR) + ' </font><br>'
		SET @email_body = @email_body + ' Please login to www.YoPay.com or Yo! Pay app to transfer balance <br><br>'
		           
		SET @email_body = @email_body + ' <image src="http://202.79.47.32:8084/Content/assets/images/service%20logos/yopay-email-icon.png"></image> <br>'
		SET @email_body = @email_body + ' <strong>The Yo! Pay Support Team <a href = "https://www.yopay.com/">Yo! Pay</a></strong>'
		SET @email_body = @email_body + ' <br>' + @Ewallet_address
	END

	---insert into email request table              
	EXEC sproc_email_sent @flag = 'i'
		,@email_subject = @email_subject
		,@email_text = @email_body
		,@sent_by = @send_by
		,@sent_to = @email_id
		,@created_by = 'System'
END


GO
