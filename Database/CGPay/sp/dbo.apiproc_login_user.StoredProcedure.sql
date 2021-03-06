USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[apiproc_login_user]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================    
-- Author:  Sabin Dawadi    
-- Create date: 2020-05-06    
-- Description: Mobile App USer Validation    
-- =============================================    
CREATE   PROCEDURE [dbo].[apiproc_login_user] @flag CHAR(3)
	,@username VARCHAR(200) = NULL
	,@password VARCHAR(200) = NULL
	,@Authentication_Log VARCHAR(150) = NULL
	,@device_id VARCHAR(200) = NULL
	,@ip_address VARCHAR(20) = NULL
	,@token VARCHAR(1000) = NULL
	,@api_secret_key VARCHAR(1000) = NULL
	,@version_id varchar(1000) =  NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from    
	-- interfering with SELECT statements.    
	SET NOCOUNT ON;

	DECLARE @encryption_key VARCHAR(1000)

	CREATE TABLE #error (
		code VARCHAR(4)
		,message VARCHAR(500)
		)

	DECLARE @user_id VARCHAR(300)
		,@check_pwd INT

	SELECT @user_id = user_id
	FROM tbl_user_detail
	WHERE user_mobile_no = @username
		OR user_email = @username
		or user_name =@username
	-- login user
	IF @flag = 'l'
	BEGIN
		IF nullif(@username, '') IS NULL
		BEGIN
			INSERT INTO #error (
				code
				,message
				)
			SELECT '100'
				,'user_login_id is required'
		END

		IF nullif(@password, '') IS NULL
		BEGIN
			INSERT INTO #error (
				code
				,message
				)
			SELECT '106'
				,'password is required'
		END

		IF nullif(@device_id, '') IS NULL
		BEGIN
			INSERT INTO #error (
				code
				,message
				)
			SELECT '122'
				,'Device Id is Required!'
		END

		IF nullif(@ip_address, '') IS NULL
		BEGIN
			INSERT INTO #error (
				code
				,message
				)
			SELECT '158'
				,'IP Address is required'
		END

		IF EXISTS (
				SELECT 'x'
				FROM #error
				)
		BEGIN
			SELECT *
			FROM #error

			RETURN
		END

		-- check if user exists  
		IF @user_id IS NULL
		BEGIN
			SELECT '101' code
				,'Invalid username or password' message
				,NULL id

			RETURN
		END

		SELECT @check_pwd = PWDCOMPARE(@password, password)
		FROM tbl_user_detail
		WHERE user_id = @user_id

		--added: disable multiple device login

		--update tbl_Authentication_Log set 


		IF @check_pwd = '1'
		BEGIN
			SET @Authentication_Log = REPLACE(newid(), '-', '_')

			IF EXISTS (
					SELECT 'x'
					FROM tbl_Authentication_Log WITH (NOLOCK)
					WHERE STATUS = 'y'
						AND USer_Id = @user_id
					)
			BEGIN
				UPDATE tbl_Authentication_Log
				SET STATUS = 'n'
				WHERE STATUS = 'y'
					AND User_Id = @user_id
			END

			INSERT [tbl_Authentication_Log] (
				[User_Id]
				,[Authentication_Log]
				,[Device_Id]
				,[Authentication_Local_Date]
				,[Authentication_UTC_Date]
				,[Txn_Id]
				,[Status]
				)
			VALUES (
				@user_id
				,@Authentication_Log
				,@device_id
				,GETDATE()
				,GETUTCDATE()
				,NULL
				,'y'
				)

			SELECT @token = replace(newid(), '-', '') + replace(NEWID(), '-', '') + '/' + replace(newid(), '-', '') + replace(NEWID(), '-', '') + '-' + replace(newid(), '-', '') + replace(NEWID(), '-', '')

			SELECT @encryption_key = replace(newid(), '-', '') + '-' + replace(NEWID(), '-', '') + '=='

			UPDATE tbl_authorization_request
			SET STATUS = 'n'
			WHERE request_user = @user_id

			INSERT tbl_authorization_request (
				request_user
				,request_ip
				,device_info
				,authorization_scheme
				,authorization_token
				,encryption_key
				,expiry_ts
				,version_Id
				,STATUS
				,created_by
				,created_ts
				)
			VALUES (
				@user_id
				,@ip_address
				,@device_id
				,'Bearer'
				,@token
				,@encryption_key
				,DATEADD(DAY, 30, CURRENT_TIMESTAMP)
				,@version_id
				,'y'
				,'system'
				,GETDATE()
				)

			SELECT '0' code
				,'User Verified Successfully' message
				,'Bearer' authorization_scheme
				,@token token_id
				,@encryption_key encryption_key
				,CASE 
					WHEN ud.m_pin IS NULL
						THEN 'n'
					ELSE 'y'
					END mpin_status
			FROM tbl_user_detail ud
			JOIN tbl_Authentication_Log al ON al.User_id = ud.user_id
			WHERE al.User_id = @user_id
				AND al.STATUS = 'y'

			RETURN
		END
		ELSE
		BEGIN
			SELECT '101' code
				,'Invalid username or password' message

			RETURN
		END
	END

	--verify token and get encryption key
	IF @flag = 'vt'
	BEGIN
		IF nullif(@token, '') IS NULL
		BEGIN
			INSERT INTO #error (
				code
				,message
				)
			--SELECT '100','token is required'
			select '100' code, 'Unauthorized Access' message
		END

		IF EXISTS (
				SELECT 'x'
				FROM #error
				)
		BEGIN
			SELECT *
			FROM #error

			RETURN
		END

		IF  EXISTS (
				SELECT 'x'
				FROM tbl_authorization_request
				WHERE authorization_token = @token
					AND STATUS = 'n'
				)
		BEGIN
			SELECT '102' code
				,'Invalid or Session Expired ' message

			RETURN
		END

		SELECT '0' code
			,'User Verified Successfully' message
			,encryption_key encryption_key
		FROM tbl_authorization_request
		WHERE authorization_token = @token
			AND STATUS = 'y'

		RETURN
	END

	-- validate api(not logged in)
	IF @flag = 'ac'
	BEGIN
		IF nullif(@username, '') IS NULL
		BEGIN
			INSERT INTO #error (
				code
				,message
				)
			SELECT '100'
				,'header authentication is required'
		END

		IF nullif(@password, '') IS NULL
		BEGIN
			INSERT INTO #error (
				code
				,message
				)
			SELECT '100'
				,'header authentication is required'
		END

		IF EXISTS (
				SELECT 'x'
				FROM #error
				)
		BEGIN
			SELECT *
			FROM #error

			RETURN
		END

		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_application_config
				WHERE config_label = 'Authorisation'
					AND config_value = @username
					AND config_value1 = @password
				)
		BEGIN
			SELECT '103' code
				,'Invalid Api Credentials' message

			RETURN
		END

		SELECT 0 code
			,'success' message

		RETURN
	END

	--verify user and get encryption key(not logged in)
	IF @flag = 'vu'
	BEGIN
		IF nullif(@username, '') IS NULL
		BEGIN
			INSERT INTO #error (
				code
				,message
				)
			SELECT '100'
				,'header_authentication is required'
		END

		IF EXISTS (
				SELECT 'x'
				FROM #error
				)
		BEGIN
			SELECT *
			FROM #error

			RETURN
		END

		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_application_config
				WHERE config_label = 'Authorisation'
					AND config_value = @username
				)
		BEGIN
			SELECT '103' code
				,'Invalid Api Credentials' message

			RETURN
		END

		SELECT '0' code
			,'success' message
			,config_value2 encryption_key
		FROM tbl_application_config
		WHERE config_label = 'Authorisation'
			AND config_value = @username

		RETURN
	END

	if @flag = 'lo'
	begin
		if not exists (select'x' from tbl_authorization_request where request_user = @user_id and device_info = @device_id)
		begin
		select '104' code, 'User Not Found' message, null id
		return
		end

		

		update tbl_authorization_request set status = 'n' where request_user = @user_id and device_info = @device_id and status = 'y'
		
		SET @Authentication_Log = REPLACE(newid(), '-', '_')
		INSERT [tbl_Authentication_Log] (
				[User_Id]
				,[Authentication_Log]
				,[Device_Id]
				,[Authentication_Local_Date]
				,[Authentication_UTC_Date]
				,[Txn_Id]
				,[Status]
				)
			VALUES (
				@user_id
				,@Authentication_Log
				,@device_id
				,GETDATE()
				,GETUTCDATE()
				,NULL
				,'n'
				)

		select '0' code, 'Successfully Logged Out' message, null id

	end
END








GO
