USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_login_log]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROC [dbo].[sproc_login_log] @flag VARCHAR(10)
	,@user VARCHAR(30) = NULL
	,@function_id VARCHAR(250) = NULL
	,@page_name VARCHAR(30) = NULL
	,@log_type VARCHAR(20) = NULL
	,@action_ip_address VARCHAR(20) = NULL
	,@browser VARCHAR(100) = NULL
	,@msg VARCHAR(200) = NULL
	,@session_id NVARCHAR(300) = NULL
	,@user_type NVARCHAR(25) = NULL
AS
SET NOCOUNT ON;

DECLARE @invalid_count INT
	,@log_id INT;
DECLARE @detail VARCHAR(200)

IF @flag = 'I'
BEGIN
	SELECT @function_id = menu_url
	FROM tbl_menus WITH (NOLOCK)
	WHERE function_id = @function_id

	SELECT @detail = CASE @log_type
			WHEN 'UnAuthorization'
				THEN 'Invalid Page Authorization'
			WHEN 'Success'
				THEN 'Login successful'
			WHEN 'Fail'
				THEN 'Invalid Login Requested'
			END

	INSERT INTO tbl_login_log (
		page_name
		,log_type
		,Remarks
		,from_ip_address
		,browser_info
		,created_by
		,is_active
		,created_UTC_date
		,created_local_date
		,created_nepali_date
		)
	SELECT @function_id
		,@log_type
		,@detail
		,@action_ip_address
		,@browser
		,@user
		,'Y'
		,GETUTCDATE()
		,GETDATE()
		,NULL

	SELECT @invalid_count = COUNT('X')
	FROM tbl_login_log(NOLOCK)
	WHERE created_by = @user
		AND is_active = 'Y'
		AND log_type = 'Fail'
		AND from_ip_address = @action_ip_address
		AND created_UTC_date >= CONVERT(DATE, GETUTCDATE())

	IF @log_type = 'UnAuthorization'
	BEGIN
		IF (
				SELECT COUNT(ISNULL(unauthorization, 0))
				FROM tbl_invalid_attempt_limit(NOLOCK)
				WHERE ISNULL(is_active, 'N') = 'Y'
				) <= ISNULL(@invalid_count, 0)
		BEGIN
			INSERT INTO tbl_login_log (
				page_name
				,log_type
				,Remarks
				,from_ip_address
				,browser_info
				,created_by
				,is_active
				)
			SELECT 'Blocked'
				,@log_type
				,'ACCOUNT IS BLOCKED DUE TO TOO MANY ATTEMPT INVALID ATTEMPTS'
				,@action_ip_address
				,@Browser
				,@user
				,'Y'

			SET @log_id = @@IDENTITY

			UPDATE tbl_user_detail
			SET is_currently_logged_in = 'N'
			WHERE user_name = @user

			EXEC sproc_error_handler @error_code = '0'
				,@msg = @log_type
				,@id = @user

			RETURN
		END
	END
END
ELSE IF @log_type = 'Fail'
BEGIN
	IF (
			SELECT ISNULL(login_fails, 0)
			FROM tbl_invalid_attempt_limit(NOLOCK)
			WHERE ISNULL(is_active, 'N') = 'Y'
			) <= ISNULL(@invalid_count, 0)
	BEGIN
		INSERT INTO tbl_login_log (
			page_name
			,log_type
			,Remarks
			,from_ip_address
			,browser_info
			,created_by
			,is_active
			)
		SELECT 'Blocked'
			,@log_type
			,'ACCOUNT IS BLOCKED DUE TO TOO MANY ATTEMPT OF INVALID LOGIN'
			,@action_ip_address
			,@browser
			,@user
			,'Y'

		SET @log_id = @@IDENTITY

		UPDATE tbl_user_detail
		SET is_currently_logged_in = 'N'
		WHERE user_name = @user

		EXEC sproc_error_handler @error_code = '0'
			,@msg = 'ACCOUNT IS BLOCKED DUE TO TOO MANY INVALID LOGIN ATTEMPTS'
			,@id = @user

		RETURN
	END
END
ELSE
BEGIN
	UPDATE tbl_user_detail
	SET device_id = @action_ip_address
		,Session = @session_id
		,is_currently_logged_in = 'Y'
		,last_login_local_date = getdate()
		,browser_info = @browser
	WHERE user_name = @user
END

IF @flag = 'S'
BEGIN
	SELECT @page_name
		,@log_type
		,@action_ip_address
		,@browser
		,@msg
	FROM tbl_login_log
	WHERE 1 = 1;
END

IF @flag = 'UnLock'
BEGIN
	SELECT TOP 1 @log_type = log_type
	FROM tbl_login_log(NOLOCK)
	WHERE created_by = @user
	ORDER BY login_log_id DESC

	UPDATE tbl_user_detail
	SET is_login_enabled = 'Y'
	WHERE user_name = @user

	IF @log_type = 'UnAuthorization'
		UPDATE tbl_login_log
		SET is_active = 'N'
		WHERE created_by = @user
			AND log_type = @log_type

	EXEC sproc_error_handler @error_code = '0'
		,@msg = 'Success.'
		,@id = @user

	RETURN
END
ELSE IF @flag = 'MLock' ---- LOCK MANUALLY BY USER                
BEGIN
	INSERT INTO tbl_login_log (
		page_name
		,log_type
		,Remarks
		,from_ip_address
		,browser_info
		,created_by
		,is_active
		)
	SELECT @log_type
		,'Blocked'
		,@Msg
		,@action_ip_address
		,@Browser
		,@user
		,'Y'

	UPDATE tbl_user_detail
	SET is_login_enabled = 'N'
	WHERE user_name = @user

	EXEC sproc_error_handler @error_code = '0'
		,@msg = 'USER LOCKED SUCCESSFULLY'
		,@id = @user

	RETURN
END


GO
