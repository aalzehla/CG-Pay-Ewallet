USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_user_login]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sproc_user_login] @flag VARCHAR(10)
	,@user_name VARCHAR(512)
	,@password VARCHAR(512)
	,@ip NVARCHAR(30)
	,@browser_info NVARCHAR(512)
	,@session_id NVARCHAR(100)
	,@force_login VARCHAR(1) = NULL
	,@pagename varchar(100)=null
	,@url varchar(512)=null
	
AS
SET NOCOUNT ON;
SET @force_login = isnull(@force_login, 'n');

DECLARE @errortable TABLE (
	code INT
	,msg VARCHAR(100)
	,id VARCHAR(20)
	);
DECLARE @sys_date DATE;
---check if multiple login allow or not --                                      
DECLARE @allow_multiple_login CHAR(1)
	,@is_currently_loggedin CHAR(1)
	,@login_device_id NVARCHAR(50)
	,@login_session_id NVARCHAR(300)
	,@last_online_date NVARCHAR(50)
	,@user_type NVARCHAR(25)
	,@last_browser_info VARCHAR(1000)
	,@active_status VARCHAR(100)

BEGIN
	SET @browser_info = isnull(@browser_info,'chrome');

	SELECT @user_type = usr_type
	FROM tbl_user_detail
	WHERE user_name = @user_name;

	IF @flag = 'login'
	BEGIN
		

		IF EXISTS (
				SELECT 'x'
				FROM tbl_user_detail WITH (NOLOCK)
				WHERE (
						user_name = @user_name
						OR user_mobile_no = @user_name
						OR user_email = @user_name
						)
					AND pwdcompare(@password, password) = 1
					AND isnull(STATUS, 'N') = 'Y'
				)
		BEGIN
			SELECT @sys_date = getdate();

			SELECT @allow_multiple_login = isnull(allow_multiple_login, 'n')
				,@login_device_id = device_id
				,@login_session_id = session
				,@is_currently_loggedin = isnull(is_currently_logged_in, 'n')
				,@last_online_date = last_login_local_date
				,@user_type = usr_type
				,@last_browser_info = 'chrome'
				,@active_status = is_login_enabled
			FROM tbl_user_detail ud
			WHERE (
					isnull(ud.user_name, '') = @user_name
					OR isnull(ud.user_email, '') = @user_name
					OR isnull(ud.user_mobile_no, '') = @user_name
					)
				AND pwdcompare(@password, password) = 1
				AND isnull(STATUS, 'N') = 'Y'

			PRINT (@allow_multiple_login);

			IF (isnull(@active_status, 'y') = 'n')
			BEGIN
				EXEC sproc_error_handler @error_code = '1'
					,@msg = 'you''r login status has been disabled, please contact head office.'
					,@id = @user_name;

				RETURN;
			END;

			--if (@allowmultiplelogin <> 'y')        
			--begin        
			--  print ('h')        
			--  print (@iscurrentlyloggedin)        
			--  --select datediff(minute, @lastonlinedate, getdate())                     
			--  if (        
			--      @iscurrentlyloggedin = 'y'        
			--      and datediff(minute, @lastonlinedate, getdate()) <= 10        
			--      and @forcelogin = 'n'        
			--      )        
			--  begin        
			--    print (@loginsessionid)        
			--    print (@sessionid)        
			--    if (@loginsessionid <> @sessionid)        
			--    begin        
			--      --select 0 errorcode,'you are already loggedin to the system from another device.' msg,@username id                                      
			--      exec spaerrorhandler @errorcode = '3'        
			--        ,@msg = 'you are already loggedin to the system from another device.'        
			--        ,@id = @username        
			--      return        
			--    end        
			--    if @browserinfo <> @lastbrowserinfo        
			--    begin        
			--      --select 0 errorcode,'you are already loggedin to the system from another device.' msg,@username id                                      
			--      exec spaerrorhandler @errorcode = '3'        
			--        ,@msg = 'you are already loggedin to the system from another device.'        
			--        ,@id = @username        
			--      return        
			--    end        
			--  end        
			--  if (        
			--      (@logindeviceid <> @ip)        
			--      and @forcelogin = 'n'        
			--      )        
			--  begin        
			--    --select 0 code,'you are already loggedin to the system from another device.' msg,@username id                                      
			--    exec spaerrorhandler @errorcode = '3'        
			--      ,@msg = 'you are already loggedin to the system from another device.'        
			--      ,@id = @username        
			--   return        
			--  end        
			--end        
			PRINT ('b');

			INSERT INTO @errortable
			EXEC sproc_login_log @flag = 'i'
				,@user = @user_name
				,@log_type = 'success'
				,@action_ip_address = @ip
				,@browser = @browser_info
				,@function_id = 'login'
				,@user_type = @user_type
				,@session_id = @session_id;

			SELECT 0 code
				,message = 'success'
				,ud.[user_id] AS UserId
				,CASE 
					WHEN ad.agent_id IS NULL
						THEN ud.usr_type
					ELSE ad.agent_type
					END AS UserType
				,ud.role_id AS RoleId
				,ud.user_name AS UserName
				,ud.full_name FullName
				,ad.agent_id AS AgentId
				,ad.parent_id AS ParentId
				,ISnull(ad.available_balance, 0) AS Balance
				,isnull(ad.kyc_status, '') KycStatus
				,CASE 
					WHEN last_login_local_date IS NULL
						THEN 'y'
					ELSE 'n'
					END AS FirstTimeLogin
				,isnull(ud.is_primary, 'n') IsPrimaryUser
			FROM tbl_user_detail ud WITH (NOLOCK)
			LEFT JOIN tbl_agent_detail ad ON ad.agent_id = ud.agent_id
			WHERE (
					isnull(ud.user_name, '') = @user_name
					OR isnull(ud.user_email, '') = @user_name
					OR isnull(ud.user_mobile_no, '') = @user_name
					)
				AND pwdcompare(@password, password) = 1
				AND isnull(STATUS, 'N') = 'Y'

			UPDATE ud
			SET last_login_local_date = GETDATE()
			FROM tbl_user_detail ud
			WHERE (
					isnull(ud.user_name, '') = @user_name
					OR isnull(ud.user_email, '') = @user_name
					OR isnull(ud.user_mobile_no, '') = @user_name
					)
				AND pwdcompare(@password, password) = 1
				AND isnull(STATUS, 'N') = 'Y'

			RETURN;
		END;
		ELSE
		BEGIN
			INSERT INTO @errortable
			EXEC sproc_login_log @flag = 'i'
				,@user = @user_name
				,@log_type = 'Failed'
				,@action_ip_address = @ip
				,@browser = @browser_info
				,@function_id = 'login'
				,@user_type = @user_type;

			EXEC sproc_error_handler @error_code = '1'
				,@msg = 'login failed'
				,@id = @user_name;
		END;
	END;
END;
	--AND ud.[user_name] = 'superadmin';  
	--select * from tbl_agent_detail  


GO
