USE [CGPay]
GO
/****** Object:  StoredProcedure [dbo].[sproc_user_detail]    Script Date: 8/29/2020 6:01:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
  
ALTER     PROCEDURE [dbo].[sproc_user_detail] @flag VARCHAR(25)  
 ,@user_id INT = NULL  
 ,@user_name VARCHAR(200) = NULL  
 ,@password VARCHAR(500) = NULL  
 ,@new_password VARCHAR(500) = NULL  
 ,@full_name VARCHAR(400) = NULL  
 ,@role_id VARCHAR(10) = NULL  
 ,@agent_id VARCHAR(20) = NULL  
 ,@email VARCHAR(300) = NULL  
 ,@mobile VARCHAR(20) = NULL  
 ,@session VARCHAR(200) = NULL  
 ,@forced_password_changed CHAR(1) = NULL  
 ,@created_by VARCHAR(200) = NULL  
 ,@created_ip VARCHAR(20) = NULL  
 ,@created_platform VARCHAR(800) = NULL  
 ,@updated_by VARCHAR(200) = NULL  
 ,@allow_multiple_login CHAR(1) = NULL  
 ,@is_deleted CHAR(1) = NULL  
 ,@is_currently_logged_in CHAR(1) = NULL  
 ,@device_id VARCHAR(400) = NULL  
 ,@status CHAR(3) = NULL  
 ,@usr_type_id INT = NULL  
 ,@usr_type VARCHAR(50) = NULL  
 ,@agent_type VARCHAR(20) = NULL  
 ,@is_login_enabled CHAR(3) = NULL  
 ,@is_primary CHAR(3) = NULL  
 ,@browser_info VARCHAR(1000) = NULL  
 ,@search VARCHAR(50) = NULL  
 ,@page_size VARCHAR(5) = 10  
 ,@parent_id VARCHAR(20) = NULL  
 ,@grand_parent_id VARCHAR(20) = NULL  
 ,@user VARCHAR(200) = NULL  
 ,@country VARCHAR(100) = NULL  
 ,@action_user VARCHAR(100) = NULL  
 ,@mpin VARCHAR(10) = NULL  
 ,@updated_ip VARCHAR(10) = NULL  
 ,@province VARCHAR(50) = NULL  
 ,@district VARCHAR(50) = NULL  
 ,@local_body VARCHAR(50) = NULL  
 ,@ward_no VARCHAR(50) = NULL  
 ,@address VARCHAR(50) = NULL  
 ,@latitude VARCHAR(50) = NULL  
 ,@longitude VARCHAR(50) = NULL  
 ,@phone_no VARCHAR(50) = NULL  
 ,@pan_no VARCHAR(50) = NULL  
 ,@logo_img VARCHAR(500) = NULL  
 ,@access_code VARCHAR(100) = NULL  
 ,@qr_image VARCHAR(max) = NULL  
 ,@mode VARCHAR(3) = NULL  
 ,@old_mpin VARCHAR(10) = NULL  
 ,@email_mobile VARCHAR(500) = NULL  
 ,@confirm_password VARCHAR(15) = NULL  
 ,@verification_code VARCHAR(10) = NULL  
AS  
--i -- insert admin details,                                 
--u --  update admin details,                                 
--d -- delete admin details,                                 
--v --view admin details                                
DECLARE @sql VARCHAR(max)  
 ,@id INT  
 ,@last_login_date_utc DATETIME = getutcdate()  
 ,@last_login_date_local DATETIME = getdate()  
DECLARE @last_password_changed_date_utc DATETIME = getutcdate()  
 ,@last_password_changed_date_local DATETIME = getdate()  
DECLARE @created_UTC_date DATETIME = getutcdate()  
 ,@created_local_date DATETIME = getdate()  
DECLARE @created_nepali_date VARCHAR(10) = dbo.func_get_nepali_date(DEFAULT)  
 ,@updated_UTC_date DATETIME = getutcdate()  
 ,@updated_local_date DATETIME = getutcdate()  
DECLARE @updated_nepali_date VARCHAR(10) = dbo.func_get_nepali_date(DEFAULT)  
 ,@desc VARCHAR(max)  
DECLARE @gen_verification_code VARCHAR(10)  
 ,@user_verification_code_pr VARCHAR(100)  
 ,@user_verification_status VARCHAR(100)  
 ,@send_datetime DATETIME  
  
IF @flag = 'i'  
BEGIN  
 -- check if user already exists                                
 IF EXISTS (  
   SELECT TOP 1 'x'  
   FROM tbl_user_detail  
   WHERE user_name = @user_name  
   )  
 BEGIN  
  EXEC sproc_error_handler @error_code = '1'  
   ,@msg = 'username already exists'  
   ,@error_script = 'username already exists'  
   ,@error_source = 'sproc_user_detail @flag = ''i'''  
   ,@id = NULL;  
  
  RETURN;  
 END;  
  
 IF EXISTS (  
   SELECT TOP 1 'x'  
   FROM tbl_user_detail  
   WHERE user_mobile_no = @mobile  
   )  
 BEGIN  
  EXEC sproc_error_handler @error_code = '1'  
   ,@msg = 'mobile/phone number already exists'  
   ,@error_script = 'mobile/phone number already exists'  
   ,@error_source = 'sproc_user_detail @flag = ''i'''  
   ,@id = NULL;  
  
  RETURN;  
 END;  
  
 IF EXISTS (  
   SELECT TOP 1 'x'  
   FROM tbl_user_detail  
   WHERE user_email = @email  
   )  
 BEGIN  
  EXEC sproc_error_handler @error_code = '1'  
   ,@msg = 'email id already exists'  
   ,@error_source = 'sproc_user_detail @flag = ''i'''  
   ,@id = NULL;  
  
  RETURN;  
 END;  
  
 IF @usr_type_id = 1  
 BEGIN  
  SET @usr_type = 'admin'  
  SET @role_id = '1'  
 END  
 ELSE IF @usr_type_id = 6  
 BEGIN  
  SET @usr_type = 'walletuser'  
  SET @role_id = '6'  
 END  
 ELSE  
 BEGIN  
  SET @usr_type = @usr_type  
 END  
  
 BEGIN TRY  
  BEGIN TRANSACTION insertUser  
  
  INSERT INTO dbo.tbl_user_detail (  
   [user_name]  
   ,[password]  
   ,full_name  
   ,agent_id  
   ,user_email  
   ,user_mobile_no  
   ,[session]  
   ,forced_password_changed  
   ,created_by  
   ,created_UTC_date  
   ,created_local_date  
   ,created_nepali_date  
   ,created_ip  
   ,created_platform  
   ,allow_multiple_login  
   ,device_id  
   ,[status]  
   ,usr_type_id  
   ,usr_type  
   ,is_login_enabled  
   ,is_primary  
   ,browser_info  
   ,role_id  
   )  
  VALUES (  
   @user_name  
   ,pwdencrypt(@password)  
   ,@full_name  
   ,@agent_id  
   ,@email  
   ,@mobile  
   ,@session  
   ,@forced_password_changed  
   ,@created_by  
   ,@created_UTC_date  
   ,@created_local_date  
   ,@created_nepali_date  
   ,@created_ip  
   ,@created_platform  
   ,isnull(@allow_multiple_login, 'n')  
   ,@device_id  
   ,@status  
   ,@usr_type_id  
   ,@usr_type  
   ,@is_login_enabled  
   ,@is_primary  
   ,@browser_info  
   ,@role_id  
   );  
  
  EXEC sproc_error_handler @error_code = '0'  
   ,@msg = 'user created succesfully.'  
   ,@id = NULL;  
  
  COMMIT TRANSACTION insertUser  
 END TRY  
  
 BEGIN CATCH  
  IF @@trancount > 0  
   ROLLBACK TRANSACTION insertUser  
  
  SET @desc = 'sql error found:(' + error_message() + ')'  
  
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
   ,'sproc_user_detail(Insert in User Detail:flag ''i'')'  
   ,'sql'  
   ,'sql'  
   ,'sproc_user_detail(Insert in User Detail)'  
   ,getdate()  
   ,getutcdate()  
   ,[dbo].func_get_nepali_date(DEFAULT)  
  
  SELECT '1' code  
   ,'errorid: ' + cast(scope_identity() AS VARCHAR) message  
   ,NULL id  
 END CATCH  
  
 RETURN;  
END;  
  
-- wallet user registration                                
IF @flag = 'wmp' -- wallet mpin settings              
BEGIN  
 DECLARE @isoldmatchmpin VARCHAR(5) = NULL  
  ,@isoldmatchnewmpin VARCHAR(5) = NULL  
  ,@ispassmatch VARCHAR(5) = NULL;  
  
 IF NOT EXISTS (  
   SELECT 'x'  
   FROM tbl_user_detail  
   WHERE user_id = @user_id  
   )  
 BEGIN  
  SELECT '1' code  
   ,'user not found' message  
   ,@user_id id;  
  
  RETURN;  
 END;  
 ELSE  
 BEGIN  
  SELECT @isoldmatchmpin = pwdcompare(@old_mpin, m_pin)  
   ,@isoldmatchnewmpin = pwdcompare(@mpin, m_pin)  
   ,@ispassmatch = pwdcompare(@password, password)  
  FROM tbl_user_detail  
  WHERE user_id = @user_id;  
  
  IF @mode = 's'  
  BEGIN  
   UPDATE tbl_user_detail  
   SET m_pin = pwdencrypt(@mpin)  
    ,updated_by = isnull(@action_user, updated_by)  
    ,updated_UTC_date = isnull(getutcdate(), updated_UTC_date)  
    ,updated_local_date = isnull(getdate(), updated_local_date)  
    ,updated_nepali_date = isnull([dbo].func_get_nepali_date(DEFAULT), updated_nepali_date)  
   WHERE user_id = @user_id;  
  
   SELECT '0' code  
    ,'mpin number set successfully.' message  
    ,@user_id id;  
  
   RETURN;  
  END;  
  ELSE IF @mode = 'u'  
  BEGIN  
   IF @isoldmatchmpin = '0'  
   BEGIN  
    SELECT '1' code  
     ,'current mpin number did not match.' message  
     ,@user_id id;  
  
    RETURN;  
   END;  
   ELSE  
   BEGIN  
    IF @isoldmatchnewmpin = '1'  
    BEGIN  
     SELECT '1' code  
      ,'new mpin number must not match with old mpin number. please try again.' message  
      ,NULL id;  
  
     RETURN;  
    END;  
    ELSE  
    BEGIN  
     UPDATE tbl_user_detail  
     SET m_pin = pwdencrypt(@mpin)  
      ,updated_by = isnull(@action_user, updated_by)  
      ,updated_UTC_date = isnull(getutcdate(), updated_UTC_date)  
      ,updated_local_date = isnull(getdate(), updated_local_date)  
      ,updated_nepali_date = isnull([dbo].func_get_nepali_date(DEFAULT), updated_nepali_date)  
     WHERE user_id = @user_id;  
  
     SELECT '0' code  
      ,'mpin number updated successfully.' message  
      ,@user_id id;  
  
     RETURN;  
    END;  
   END;  
  END;  
  ELSE IF @mode = 'r'  
  BEGIN  
   IF @ispassmatch = '0'  
   BEGIN  
    SELECT '1' code  
     ,'user password did not match' message  
     ,@user_id id;  
  
    RETURN;  
   END;  
   ELSE  
   BEGIN  
    UPDATE tbl_user_detail  
    SET m_pin = pwdencrypt(@mpin)  
     ,updated_by = isnull(@action_user, updated_by)  
     ,updated_UTC_date = isnull(getutcdate(), updated_UTC_date)  
     ,updated_local_date = isnull(getdate(), updated_local_date)  
     ,updated_nepali_date = isnull([dbo].func_get_nepali_date(DEFAULT), updated_nepali_date)  
    WHERE user_id = @user_id;  
  
    SELECT '0' code  
     ,'mpin number reset successfully.' message  
     ,@user_id id;  
  
    RETURN;  
   END;  
  END;  
 END;  
END;  
  
-- end wallet user registration              
IF @flag = 'u'  
BEGIN  
 IF @user_id IS NULL  
 BEGIN  
  EXEC sproc_error_handler @error_code = '1'  
   ,@msg = 'user id cannot be null'  
   ,@id = NULL;  
  
  RETURN;  
 END;  
  
 IF @password IS NOT NULL  
 BEGIN  
  IF (len(@password) < 8)  
  BEGIN  
   SELECT '1' code  
    ,'Password must be 8 or more than 8 characters' message  
    ,NULL id  
  
   RETURN  
  END  
  ELSE IF (@password <> @confirm_password)  
  BEGIN  
   SELECT '1' code  
    ,'Password and Confirm password didn''t match' message  
    ,NULL id  
  
   RETURN  
  END  
 END  
  
 BEGIN TRY  
  BEGIN TRANSACTION updateUserDetail  
  
  UPDATE dbo.tbl_user_detail  
  SET full_name = isnull(@full_name, full_name)  
   ,user_name = isnull(@user_name, user_name)  
   ,password = Isnull(PWDENcrypt(@password), password)  
   ,agent_id = isnull(@agent_id, agent_id)  
   ,user_email = isnull(@email, user_email)  
   ,user_mobile_no = isnull(@mobile, user_mobile_no)  
   ,updated_by = isnull(@updated_by, updated_by)  
   ,updated_UTC_date = isnull(@updated_UTC_date, updated_UTC_date)  
   ,updated_local_date = isnull(@updated_local_date, updated_local_date)  
   ,updated_nepali_date = isnull(@updated_nepali_date, updated_nepali_date)  
   ,allow_multiple_login = @allow_multiple_login
   ,device_id = isnull(@device_id, device_id)  
   ,[status] = isnull(@status, [status])  
   ,usr_type_id = isnull(@usr_type_id, usr_type_id)  
   ,usr_type = isnull(@usr_type, usr_type)  
   ,is_primary = isnull(@is_primary, is_primary)  
   ,browser_info = isnull(@browser_info, browser_info)  
  --,agenttype = isnull(@agenttype, agenttype)                      
  WHERE user_id = @user_id;  
  
  IF @role_id IS NOT NULL  
  BEGIN 
  if @user_name is null set @user_name=@user_id
   --exec spa_role @flag ='assignuserrole',@id=@roleid, @username=@admin_username,@user=@user                                
   DELETE tbl_user_role  
   WHERE user_id = @user_name;  
  
   INSERT INTO tbl_user_role (  
    [user_id]  
    ,role_id  
    ,created_by  
    ,created_UTC_date  
    ,created_local_date  
    ,created_nepali_date
	,created_ip
    )  
   SELECT @user_name  
    ,@role_id  
    ,@updated_by  
    ,@created_UTC_date  
    ,@created_local_date  
    ,@created_nepali_date
	,@created_ip;  
  END;  
  
  EXEC sproc_error_handler @error_code = '0'  
   ,@msg = 'user succesfully updated'  
   ,@id = NULL;  
  
  COMMIT TRANSACTION updateUserDetail  
 END TRY  
  
 BEGIN CATCH  
  IF @@trancount > 0  
   ROLLBACK TRANSACTION updateUserDetail  
  
  SET @desc = 'sql error found:(' + error_message() + ')'  
  
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
   ,'sproc_user_detail(update User Detail and Role:flag ''u'')'  
   ,'sql'  
   ,'sql'  
   ,'sproc_user_detail(update User Detail and Role)'  
   ,getdate()  
   ,getutcdate()  
   ,[dbo].func_get_nepali_date(DEFAULT)  
  
  SELECT '1' code  
   ,'errorid: ' + cast(scope_identity() AS VARCHAR) message  
   ,NULL id  
 END CATCH  
  
 RETURN;  
END;  
  
IF @flag = 'v'  
BEGIN  
 -- IF @user_name IS NULL        
 --  AND @agent_id IS NULL        
 -- BEGIN        
 --  SELECT TOP 100 a.*         --   ,b.role_id        
 --   ,ad.parent_id        
 --   --,ad.grand_parent_id            
 --   ,gd.gateway_id        
 --  FROM tbl_user_detail a        
 --  LEFT JOIN tbl_user_role b ON b.[user_id] = a.[user_name]        
 --  LEFT JOIN tbl_agent_detail ad ON ad.agent_id = a.agent_id        
 --  LEFT JOIN tbl_gateway_detail gd ON gd.gateway_id = a.agent_id        
 --  WHERE ad.agent_type = 'Distributor';        
 --  RETURN;        
 -- END;        
 -- ELSE IF @user_name IS NOT NULL        
 -- BEGIN        
 --  SELECT TOP 100 a.*        
 --   ,b.role_id        
 --   ,ad.parent_id        
 --   --,ad.grand_parent_id            
 --   ,gd.gateway_id        
 --  FROM tbl_user_detail a        
 --  LEFT JOIN tbl_user_role b ON b.[user_id] = a.[user_name]        
 --  LEFT JOIN tbl_agent_detail ad ON ad.agent_id = a.agent_id        
 --  LEFT JOIN tbl_gateway_detail gd ON gd.gateway_id = a.agent_id        
 --  WHERE user_name = @user_name        
 -- END        
 -- ELSE        
 -- BEGIN        
 --  SELECT TOP 100 a.*        
 --   ,b.role_id        
 --   ,ad.parent_id        
 --   -- ,ad.grand_parent_id            
 --   ,gd.gateway_id        
 --  FROM tbl_user_detail a        
 --  LEFT JOIN tbl_user_role b ON b.[user_id] = a.[user_name]        
 --  LEFT JOIN tbl_agent_detail ad ON ad.agent_id = a.agent_id        
 --  LEFT JOIN tbl_gateway_detail gd ON gd.gateway_id = a.agent_id        
 --  WHERE a.agent_id = @agent_id;        
 --  RETURN;        
 -- --END;        
 --END;        
 IF @agent_id IS NULL  
  AND @user_id IS NULL --Get all agent users    
 BEGIN  
  SELECT u.[user_id]  
   ,u.[user_name]  
   ,u.full_name  
   ,u.agent_id  
   ,u.user_mobile_no  
   ,u.user_email  
   ,u.[status]  
   ,u.usr_type_id  
   ,u.usr_type  
   ,b.role_id  
   ,a.parent_id  
   ,ad.agent_id AS grand_parent_id  
   ,gd.gateway_id  
  FROM tbl_user_detail u  
  JOIN tbl_agent_detail a ON a.agent_id = u.agent_id  
  LEFT JOIN tbl_agent_detail ad ON ad.agent_id = a.parent_id  
  LEFT JOIN tbl_user_role b ON b.[user_id] = u.[user_id]  
  LEFT JOIN tbl_gateway_detail gd ON gd.gateway_id = a.agent_id  
   --where u.agent_id = @agent_id and u.user_id =@user_id      
 END  
 ELSE IF @user_id IS NOT NULL  
  AND @agent_id IS NOT NULL --get agent user by agent_id and user_id    
 BEGIN  
  SELECT u.[user_id]  
   ,u.[user_name]  
   ,u.full_name  
   ,u.agent_id  
   ,u.user_mobile_no  
   ,u.user_email  
   ,u.[status]  
   ,u.usr_type_id  
   ,u.usr_type  
   ,u.is_primary  
   ,b.role_id  
   ,a.parent_id  
   ,ad.agent_id AS grand_parent_id  
   ,gd.gateway_id  
  FROM tbl_user_detail u  
  JOIN tbl_agent_detail a ON a.agent_id = u.agent_id  
  LEFT JOIN tbl_agent_detail ad ON ad.agent_id = a.parent_id  
  LEFT JOIN tbl_user_role b ON b.[user_id] = u.[user_id]  
  LEFT JOIN tbl_gateway_detail gd ON gd.gateway_id = a.agent_id  
  WHERE u.agent_id = @agent_id  
   AND u.user_id = @user_id  
 END  
 ELSE IF @agent_id IS NOT NULL --get agent user by agent_id    
 BEGIN  
  SELECT u.[user_id]  
   ,u.[user_name]  
   ,u.full_name  
   ,u.agent_id  
   ,u.user_mobile_no  
   ,u.user_email  
   ,u.[status]  
   ,u.usr_type_id  
   ,u.usr_type  
   ,b.role_id  
   ,a.parent_id  
   ,ad.agent_id AS grand_parent_id  
   ,u.is_primary  
   ,u.STATUS  
   ,gd.gateway_id  
  FROM tbl_user_detail u  
  JOIN tbl_agent_detail a ON a.agent_id = u.agent_id  
  LEFT JOIN tbl_agent_detail ad ON ad.agent_id = a.parent_id  
  LEFT JOIN tbl_user_role b ON b.[user_id] = u.[user_id]  
  LEFT JOIN tbl_gateway_detail gd ON gd.gateway_id = a.agent_id  
  WHERE u.agent_id = @agent_id  
 END  
 ELSE IF @user_id IS NOT NULL -- get admin user by user_id    
 BEGIN  
  SELECT u.[user_id]  
   ,u.[user_name]  
   ,u.full_name  
   ,u.agent_id  
   ,u.user_mobile_no  
   ,u.user_email  
   ,u.[status]  
   ,u.usr_type_id  
   ,u.usr_type  
   ,u.allow_multiple_login
   ,b.role_id  
   ,NULL parent_id  
   ,NULL AS grand_parent_id  
   ,NULL gateway_id  
   ,u.is_primary  
   ,u.created_by  
   ,u.created_local_date  
   ,STATUS  
  FROM tbl_user_detail u  
  --left join tbl_agent_detail a on a.agent_id = u.agent_id      
  --left join tbl_agent_detail ad on ad.agent_id = a.parent_id      
  LEFT JOIN tbl_user_role b ON b.[user_id] = u.[user_id]  
  --LEFT JOIN tbl_gateway_detail gd ON gd.gateway_id = a.agent_id       
  WHERE u.user_id = @user_id  
   AND agent_id IS NULL  
 END  
 ELSE -- get all admin users    
 BEGIN  
  SELECT u.[user_id]  
   ,u.[user_name]  
   ,u.full_name  
   ,u.agent_id  
   ,u.user_mobile_no  
   ,u.user_email  
   ,u.[status]  
   ,u.usr_type_id  
   ,u.usr_type  
   ,b.role_id  
   ,NULL parent_id  
   ,NULL AS grand_parent_id  
   ,NULL gateway_id  
   ,u.is_primary  
   ,u.created_by  
   ,u.created_local_date  
   ,STATUS  
  FROM tbl_user_detail u  
  --left join tbl_agent_detail a on a.agent_id = u.agent_id      
  --left join tbl_agent_detail ad on ad.agent_id = a.parent_id      
  LEFT JOIN tbl_user_role b ON b.[user_id] = u.[user_id]  
  --LEFT JOIN tbl_gateway_detail gd ON gd.gateway_id = a.agent_id       
  WHERE agent_id IS NULL  
 END  
END  
  
IF @flag = 'list'  
BEGIN  
 SET @sql =   
  '                                
 select  u.*,ad.parent_id,          
   a.parent_id              
    ,gd.gateway_id              
    ,gd.gateway_name gatewayname                    
 ,adist.agent_id distributorid                
 ,adist.full_name distributorname                
 ,asdist.agent_id subdistributorid                
 ,asdist.full_name subdistributorname                
 ,amdist.full_name merchantname                
 ,amdist.agent_id merchantid                
 from tbl_user_detail u (nolock)                             
 left join tbl_agent_detail ad on ad.agent_id = u.agent_id           
 LEFT JOIN tbl_agent_detail a on a.agent_id =ad.parent_id          
  left join tbl_agent_detail adist on adist.agent_id = case                 
  when ad.agent_type in (                
    ''distributor''               
    ,''gateway''                
    )                
   then ad.agent_id                
  when ad.agent_type in (''subdistributor'')                
   then ad.parent_id                
  when ad.agent_type in (                
    ''wallet''                
    ,''merchant''                
    )                
   then a.parent_id                
  end                
left join tbl_agent_detail asdist on case                 
  when ad.agent_type in (                
    ''distributor''                
    ,''gateway''                
    )                
   then null                
  when ad.agent_type in (''subdistributor'')                
   then ad.agent_id                
  when ad.agent_type in (                
    ''wallet''                
    ,''merchant''                
    )                
   then a.parent_id                
  end = asdist.agent_id                
left join tbl_gateway_detail gd on gd.gateway_id=u.agent_id and u.usr_type=''gateway''              
left join tbl_agent_detail amdist on case                 
  when ad.agent_type in (                
    ''distributor''                
    ,''gateway''               
    )                
   then null                
  when ad.agent_type in (''subdistributor'')                
   then null                
  when ad.agent_type in (                
    ''wallet''                
    ,''merchant''                
    )                
   then ad.agent_id                
  end = amdist.agent_id               
 where isnull(u.status,''n'') <> ''D'' /*and isnull(u.is_enabled,''y'') <> ''n''*/ '  
  ;  
  
 IF @search IS NOT NULL  
  SET @sql += ' and (u.user_name like ''' + @search + '%''' + ' or u.full_name like ''' + @search + '%''' + ' or u.mobile like ''' + @search + '%''' + ' or u.email like ''' + @search + '%'' )';  
  
 IF @agent_type IS NOT NULL  
  SET @sql += ' and isnull(u.usr_type,'''')=''' + @agent_type + '''';  
 ELSE  
  SET @sql += ' and isnull(ad.agent_type,'''') not in(''distributor'',''subdistributor'',''merchant'',''wallet'')';  
  
 IF @agent_type IN ('distributor')  
  SET @sql += ' and ad.agent_id=''' + @agent_id + '''';  
 ELSE IF @agent_type IN ('gateway')  
  SET @sql += ' and gd.gateway_id=''' + @agent_id + '''';  
 ELSE IF @agent_type IN ('subdistributor')  
  SET @sql += ' and ad.agent_id=''' + @agent_id + '''';  
 ELSE IF @agent_type IN (  
   'merchant'  
   ,'wallet'  
   )  
  SET @sql += ' and ad.agent_id=''' + @agent_id + '''';  
  
 IF nullif(@user_id, 0) IS NOT NULL  
 BEGIN  
  SET @sql += ' and u.user_id=''' + cast(@user_id AS VARCHAR) + '''';  
 END  
  
 IF @parent_id IS NOT NULL  
 BEGIN  
  SET @sql += ' and ad.parent_id=''' + @parent_id + '''';  
 END;  
 ELSE  
  SET @sql += ' and ad.parent_id is null';  
  
 IF @grand_parent_id IS NOT NULL  
  SET @sql += ' and a.parent_id=''' + @grand_parent_id + '''';  
 ELSE  
  SET @sql += ' and a.parent_id is null';  
  
 IF @created_by != 'admin'  
 BEGIN  
  SET @sql += ' and u.created_by=''' + @created_by + ''' ';  
 END;  
  
 PRINT (@sql);  
  
 EXEC (@sql);  
  
 RETURN;  
END;  
  
IF @flag = 'searchuser'  
BEGIN  
 SET @sql = '                          
  select top ' + @page_size + ' u.user_id,           
 u.user_email,           
 u.user_mobile_no,           
 u.user_name ,          
 u.agent_id,     
 u.status,    
 u.created_local_date,     
 u.created_by,    
 k.identification_photo_logo ,          
 u.full_name,    
 isnull(ad.available_balance,0) as available_balance    
 from tbl_user_detail u (nolock)            
 left join tbl_agent_detail ad on ad.agent_id = u.agent_id          
 left join tbl_kyc_documents k on k.agent_id  = ad.agent_id          
                        
 where isnull(status,''n'') <> ''D'' ';  
  
 IF @search IS NOT NULL  
  SET @sql += ' and (u.user_name like ''' + @search + '%''' + 'or u.user_id like ''' + @search + '%''' + ' or u.full_name like ''' + @search + '%''' + ' or u.user_mobile_no like ''' + @search + '%''' + ' or u.user_email like ''' + @search + '%'' )';  
  
 PRINT @sql;  
  
 EXEC (@sql);  
  
 RETURN;  
END;  
  
IF @flag = 'selectuser'  
BEGIN  
 SET @sql = '                          
  select top ' + @page_size + ' u.user_id,           
 u.user_email,           
 u.user_mobile_no,           
 u.user_name ,          
 u.agent_id,     
 u.status,    
 u.created_local_date,     
 u.created_by,    
 k.identification_photo_logo ,          
 u.full_name,
 r.role_name,    
 isnull(ad.available_balance,0) as available_balance    
 from tbl_user_detail u (nolock)            
 left join tbl_agent_detail ad on ad.agent_id = u.agent_id          
 left join tbl_kyc_documents k on k.agent_id  = ad.agent_id  
 left join tbl_roles r on r.role_id  = u.role_id         
         
                        
 where isnull(status,''n'') <> ''D'' ';  
  
 IF @search IS NOT NULL  
  SET @sql += ' and (u.user_name = ''' + @search + '''' + 'or u.user_id like ''' + @search + '%''' + ' or u.full_name = ''' + @search + '''' + ' or u.user_mobile_no = ''' + @search + '''' + ' or u.user_email = ''' + @search + ''' )';  
  
 PRINT @sql;  
  
 EXEC (@sql);  
  
 RETURN;  
END; 

IF @flag = 'searchfilteruser'  
BEGIN  
 SET @sql = '                                
 select top ' + @page_size + ' u.user_id,           
 u.user_email,           
 u.user_mobile_no,           
 u.user_name ,          
 u.agent_id,     
 u.status,    
 u.created_local_date,     
 u.created_by,    
 k.identification_photo_logo ,          
 u.full_name,
 u.is_primary,
 u.allow_multiple_login
 from tbl_user_detail u (nolock)            
 left join tbl_agent_detail ad on ad.agent_id = u.agent_id          
 left join tbl_kyc_documents k on k.agent_id  = ad.agent_id          
 where isnull(status,''n'') <> ''D''';  
  
 IF @user_name IS NOT NULL  
  SET @sql += ' and u.user_name like ''' + @user_name + '%'''  
  
 IF @search IS NOT NULL  
  SET @sql += ' and u.user_id like ''' + @search + ''''  
  
 IF @full_name IS NOT NULL  
  SET @sql += ' and u.full_name like ''' + @full_name + '%'''  
  
 IF @mobile IS NOT NULL  
  SET @sql += 'and u.user_mobile_no like ''' + @mobile + '%'''  
  
 IF @email IS NOT NULL  
  SET @sql += ' and u.user_email like ''' + @email + '%''';  
  
 PRINT @sql;  
  
 EXEC (@sql);  
  
 RETURN;  
END;  
  
IF @flag = 'changepwd'  
BEGIN  
 IF NOT EXISTS (  
   SELECT *  
   FROM tbl_user_detail  
   WHERE [user_name] = @user_name  
    AND pwdcompare(@password, [password]) = 1  
   )  
 BEGIN  
  EXEC sproc_error_handler @error_code = '1'  
   ,@msg = 'Invalid Current Password'  
   ,@id = NULL;  
  
  RETURN;  
 END;  
  
 UPDATE tbl_user_detail  
 SET [password] = pwdencrypt(@new_password)  
  ,last_password_changed_local_date = @last_password_changed_date_local  
  ,last_password_changed_UTC_date = @last_password_changed_date_utc  
  ,forced_password_changed = 'n'  
  ,session='|'+@session
 WHERE [user_name] = @user_name  
  AND pwdcompare(@password, password) = 1;  
  
 EXEC sproc_error_handler @error_code = '0'  
  ,@msg = 'your password has been changed successfully.'  
  ,@id = NULL;  
  
 RETURN;  
END;  
  
IF @flag = 's'  
BEGIN  
 IF @user_id IS NOT NULL  
  OR @user_name IS NOT NULL  
  SELECT pu.[user_id]  
   ,pu.is_primary  
   ,pu.full_name fullname  
   ,pu.[user_name]  
   ,pu.user_email  
   ,pu.updated_by updatedby  
   ,pu.created_by createdby  
   ,pu.STATUS AS [Status]  
   ,pu.created_nepali_date  
   ,pu.user_mobile_no  
   ,pu.pay_load  
   ,ad.kyc_status  
   ,ad.agent_logo_img  
   ,pu.m_pin  
   ,pu.access_code  
   ,ad.agent_country  
   ,ad.agent_country_code  
   ,CASE   
    WHEN pu.usr_type = 'gateway'  
     THEN gd.gateway_id  
    ELSE NULL  
    END gateway_id  
   ,gd.gateway_name gateway_name  
   ,CASE   
    WHEN pu.usr_type = 'admin'  
     THEN NULL  
    WHEN ad.agent_id IS NOT NULL  
     AND ad.agent_type = 'distributor'  
     THEN ad.agent_id  
    WHEN ad.agent_id IS NOT NULL  
     AND ad.agent_type = 'subdistributor'  
     THEN ad.parent_id  
    WHEN ad.agent_id IS NOT NULL  
     AND ad.agent_type IN (  
      'merchant'  
      ,'wallet'  
      )  
     THEN a.parent_id  
    ELSE NULL  
    END distributor_id  
   ,distdetail.full_name distributor_name  
   ,CASE   
    WHEN pu.usr_type = 'admin'  
     THEN NULL  
    WHEN ad.agent_id IS NOT NULL  
     AND ad.agent_type = 'distributor'  
     THEN NULL  
    WHEN ad.agent_id IS NOT NULL  
     AND ad.agent_type = 'subdistributor'  
     THEN ad.agent_id  
    WHEN ad.agent_id IS NOT NULL  
     AND ad.agent_type IN (  
      'merchant'  
      ,'wallet'  
      )  
     THEN ad.parent_id  
    ELSE NULL  
    END subdistributor_id  
   ,subdistdetail.full_name subdistributor_name  
   ,CASE   
    WHEN pu.usr_type = 'admin'  
     THEN NULL  
    WHEN ad.agent_id IS NOT NULL  
     AND ad.agent_type = 'distributor'  
     THEN NULL  
    WHEN ad.agent_id IS NOT NULL  
     AND ad.agent_type = 'subdistributor'  
     THEN NULL  
    WHEN ad.agent_id IS NOT NULL  
     AND ad.agent_type IN (  
      'merchant'  
      ,'wallet'  
      )  
     THEN ad.agent_id  
    ELSE NULL  
    END merchant_id  
   ,mertdetail.full_name merchant_name  
   ,isnull(pu.usr_type, ad.agent_type) AS usertype  
  FROM tbl_user_detail pu WITH (NOLOCK)  
  LEFT OUTER JOIN tbl_agent_detail ad ON ad.agent_id = pu.agent_id  
  LEFT OUTER JOIN tbl_agent_detail a ON a.agent_id = ad.parent_id  
  LEFT OUTER JOIN tbl_gateway_detail gd ON gd.gateway_id = pu.agent_id  
   AND pu.usr_type = 'gateway'  
  LEFT OUTER JOIN tbl_agent_detail distdetail ON distdetail.agent_id = CASE   
    WHEN pu.usr_type = 'admin'  
     THEN NULL  
    WHEN ad.agent_id IS NOT NULL  
     AND ad.agent_type = 'distributor'  
     THEN ad.agent_id  
    WHEN ad.agent_id IS NOT NULL  
     AND ad.agent_type = 'subdistributor'  
     THEN ad.parent_id  
    WHEN ad.agent_id IS NOT NULL  
     AND ad.agent_type IN (  
      'merchant'  
      ,'wallet'  
      )  
     THEN a.parent_id  
    ELSE NULL  
    END  
  LEFT OUTER JOIN tbl_agent_detail subdistdetail ON subdistdetail.agent_id = CASE   
    WHEN pu.usr_type = 'admin'  
     THEN NULL  
    WHEN ad.agent_id IS NOT NULL  
     AND ad.agent_type = 'distributor'  
     THEN NULL  
    WHEN ad.agent_id IS NOT NULL  
     AND ad.agent_type = 'subdistributor'  
     THEN NULL  
    WHEN ad.agent_id IS NOT NULL  
     AND ad.agent_type IN (  
      'merchant'  
      ,'wallet'  
      )  
     THEN ad.agent_id  
    ELSE NULL  
    END  
  LEFT OUTER JOIN tbl_agent_detail mertdetail ON mertdetail.agent_id = CASE   
    WHEN pu.usr_type = 'admin'  
     THEN NULL  
    WHEN ad.agent_id IS NOT NULL  
     AND ad.agent_type = 'distributor'  
     THEN NULL  
    WHEN ad.agent_id IS NOT NULL  
     AND ad.agent_type = 'subdistributor'  
     THEN NULL  
    WHEN ad.agent_id IS NOT NULL  
     AND ad.agent_type IN (  
      'merchant'  
      ,'wallet'  
      )  
     THEN ad.agent_id  
    ELSE NULL  
    END  
  WHERE pu.[user_id] = @user_id  
   OR pu.[user_name] = @user_name;  
 ELSE IF @agent_id IS NOT NULL  
 BEGIN  
  IF @user_id IS NOT NULL  
   SELECT pu.[user_id]  
    ,pu.is_primary  
    ,pu.full_name fullname  
    ,pu.[user_name]  
    ,pu.[user_email]  
    ,pu.updated_by updatedby  
    ,pu.created_by createdby  
    ,pu.STATUS AS [Status]  
    ,pu.created_nepali_date  
    ,pu.user_mobile_no  
    ,CASE   
     WHEN pu.usr_type = 'admin'  
      THEN NULL  
     WHEN ad.agent_id IS NOT NULL  
      AND ad.agent_type = 'distributor'  
      THEN ad.agent_id  
     WHEN ad.agent_id IS NOT NULL  
      AND ad.agent_type = 'subdistributor'  
      THEN ad.parent_id  
     WHEN ad.agent_id IS NOT NULL  
      AND ad.agent_type IN (  
       'merchant'  
       ,'wallet'  
       )  
      THEN a.parent_id  
     ELSE NULL  
     END distributor_id  
    ,distdetail.full_name distributor_name  
    ,CASE   
     WHEN pu.usr_type = 'admin'  
      THEN NULL  
     WHEN ad.agent_id IS NOT NULL  
      AND ad.agent_type = 'distributor'  
      THEN NULL  
     WHEN ad.agent_id IS NOT NULL  
      AND ad.agent_type = 'subdistributor'  
      THEN ad.agent_id  
     WHEN ad.agent_id IS NOT NULL  
      AND ad.agent_type IN (  
       'merchant'  
       ,'wallet'  
       )  
      THEN ad.parent_id  
     ELSE NULL  
     END subdistributor_id  
    ,subdistdetail.full_name subdistributor_name  
    ,CASE   
     WHEN pu.usr_type = 'admin'  
      THEN NULL  
     WHEN ad.agent_id IS NOT NULL  
      AND ad.agent_type = 'distributor'  
      THEN NULL  
     WHEN ad.agent_id IS NOT NULL  
      AND ad.agent_type = 'subdistributor'  
      THEN NULL  
     WHEN ad.agent_id IS NOT NULL  
      AND ad.agent_type IN (  
       'merchant'  
       ,'wallet'  
       )  
      THEN ad.agent_id  
     ELSE NULL  
     END merchant_id  
    ,mertdetail.full_name merchant_name  
    ,isnull(pu.usr_type, ad.agent_type) AS usertype  
    ,CASE   
     WHEN pu.usr_type = 'gateway'  
      THEN gd.gateway_id  
     ELSE NULL  
     END gateway_id  
    ,gd.gateway_name gateway_name  
   FROM tbl_user_detail pu WITH (NOLOCK)  
   LEFT OUTER JOIN tbl_agent_detail ad ON ad.agent_id = pu.agent_id  
   LEFT OUTER JOIN tbl_agent_detail a ON a.agent_id = ad.parent_id  
   LEFT OUTER JOIN tbl_gateway_detail gd ON gd.gateway_id = pu.agent_id  
    AND pu.usr_type = 'gateway'  
   LEFT OUTER JOIN tbl_agent_detail distdetail ON distdetail.agent_id = CASE   
     WHEN pu.usr_type = 'admin'  
      THEN NULL  
     WHEN ad.agent_id IS NOT NULL  
      AND ad.agent_type = 'distributor'  
      THEN ad.agent_id  
     WHEN ad.agent_id IS NOT NULL  
      AND ad.agent_type = 'subdistributor'  
      THEN ad.parent_id  
     WHEN ad.agent_id IS NOT NULL  
      AND ad.agent_type IN (  
       'merchant'  
       ,'wallet'  
       )  
      THEN a.parent_id  
     ELSE NULL  
     END  
   LEFT OUTER JOIN tbl_agent_detail subdistdetail ON subdistdetail.agent_id = CASE   
     WHEN pu.usr_type = 'admin'  
      THEN NULL  
     WHEN ad.agent_id IS NOT NULL  
      AND ad.agent_type = 'distributor'  
      THEN NULL  
     WHEN ad.agent_id IS NOT NULL  
      AND ad.agent_type = 'subdistributor'  
      THEN NULL  
     WHEN ad.agent_id IS NOT NULL  
      AND ad.agent_type IN (  
       'merchant'  
       ,'wallet'  
       )  
      THEN ad.agent_id  
     ELSE NULL  
     END  
   LEFT OUTER JOIN tbl_agent_detail mertdetail ON mertdetail.agent_id = CASE   
     WHEN pu.usr_type = 'admin'  
      THEN NULL  
     WHEN ad.agent_id IS NOT NULL  
      AND ad.agent_type = 'distributor'  
      THEN NULL  
     WHEN ad.agent_id IS NOT NULL  
      AND ad.agent_type = 'subdistributor'  
      THEN NULL  
     WHEN ad.agent_id IS NOT NULL  
      AND ad.agent_type IN (  
       'merchant'  
       ,'wallet'  
       )  
      THEN ad.agent_id  
     ELSE NULL  
     END  
   WHERE ad.agent_id = @agent_id;  
 END;  
END;  
  
IF @flag = 'lglst'  
BEGIN  
 SET @sql = 'select user_id,u.full_name,user_email,user_mobile_no,u.created_local_date,u.created_by,status,user_name,u.role_id from tbl_user_detail u left join tbl_agent_detail a on u.agent_id=a.agent_id  where 1=1'  
  
 IF @usr_type <> 'admin'  
  SET @sql = @sql + ' and u.user_name=''' + @user_name + ''''  
 else  
  set @sql=@sql+' and u.agent_id is null'  
 PRINT @sql  
  
 EXEC (@sql)  
  
 RETURN;  
END  
  
-- admin user / no agent      
IF @flag = 'e'  
BEGIN  
 IF @user_id IS NULL  
 BEGIN  
  SELECT '1' code  
   ,'User Id cannot be null' message;  
  
  RETURN;  
 END;  
  
 --delete from [dbo].[pp_admin_detail] where userid = @user_id                                
 UPDATE [dbo].tbl_user_detail  
 SET [status] = @status  
 WHERE user_id = @user_id  
  AND agent_id IS NULL;  
  
 EXEC sproc_error_handler @error_code = '0'  
  ,@msg = 'user status updated'  
  ,@id = NULL;  
  
 RETURN;  
END;  
  
IF @flag = 'uu' -- disable user with agent id      
BEGIN  
 IF NOT EXISTS (  
   SELECT 'x'  
   FROM tbl_user_detail u  
   JOIN tbl_agent_detail a ON a.agent_id = u.agent_id  
   WHERE user_id = @user_id  
    AND u.agent_id = @agent_id  
   )  
 BEGIN  
  SELECT '1' code  
   ,'User not found' message  
   ,NULL id  
  
  RETURN  
 END  
 ELSE  
 BEGIN  
  UPDATE tbl_user_detail  
  SET STATUS = Isnull(@status, STATUS)  
  WHERE user_id = @user_id  
   AND agent_id = @agent_id  
  
  EXEC sproc_error_handler @error_code = '0'  
   ,@msg = 'user status updated'  
   ,@id = NULL;  
 END  
END  
  
--check balance for user    
IF @flag = 'cb'  
BEGIN  
 IF NOT EXISTS (  
   SELECT 'x'  
   FROM tbl_user_detail  
   WHERE user_id = @user_id  
   )  
 BEGIN  
  SELECT '1' code  
   ,'User Not Found' message  
   ,NULL id  
  
  RETURN  
 END  
 ELSE  
 BEGIN  
  SELECT isnull(a.available_balance, 0)  
  FROM tbl_user_detail u  
  JOIN tbl_agent_detail a ON a.agent_id = u.agent_id  
  WHERE User_id = @user_id  
 END  
END  
  
IF @flag = 'checkuser'  
BEGIN  
 IF EXISTS (  
   SELECT 'x'  
   FROM tbl_user_detail  
   WHERE user_name = @user_name  
    OR user_mobile_no = @user_name  
    OR user_email = @user_name  
   )  
  EXEC sproc_error_handler @error_code = '0'  
   ,@msg = 'User Exists'  
   ,@id = NULL;  
 ELSE  
  EXEC sproc_error_handler @error_code = '1'  
   ,@msg = 'User Doesnot Exists'  
   ,@id = NULL;  
END  
  
--forgot pwd  send verification code  
IF @flag = 'fpv'  
BEGIN  
 IF NOT EXISTS (  
   SELECT 'x'  
   FROM tbl_user_detail  
   WHERE user_mobile_no = @user_name  
    OR user_email = @user_name  
    OR user_name = @user_name  
   )  
 BEGIN  
  SELECT '1' code  
   ,'User Not Found!' message  
   ,NULL id  
  
  RETURN  
 END  
 ELSE  
 BEGIN  
  SET @gen_verification_code = dbo.[func_generate_verify_code](6)  
  
  SELECT @user_name = user_name  
   ,@email = user_email  
   ,@user_id = user_id  
   ,@mobile = user_mobile_no  
   ,@full_name = full_name  
  FROM tbl_user_detail  
  WHERE user_mobile_no = @user_name  
   OR user_email = @user_name  
   OR user_name = @user_name  
  
  INSERT INTO tbl_verification_sent (  
   UserId  
   ,username  
   ,Mobile_Number  
   ,Email_address  
   ,full_Name  
   ,verification_code  
   ,generate_date_time  
   )  
  VALUES (  
   @user_id  
   ,@user_name  
   ,@mobile  
   ,@email  
   ,@full_name  
   ,@gen_verification_code  
   ,GETDATE()  
   )  
  
  EXEC sproc_email_request @flag = 'd'  
   ,@full_name = @full_name  
   ,@agent_verification_code = @gen_verification_code  
   ,@email_id = @email  
  
  UPDATE tbl_verification_sent  
  SET verification_Status = 'Sent'  
   ,send_date_time = getdate()  
  WHERE (  
    Mobile_Number = @mobile  
    OR Email_address = @email  
    )  
   AND verification_code = @gen_verification_code  
  
  UPDATE ar  
  SET ar.STATUS = 'n'  
  FROM tbl_user_detail ud  
  JOIN tbl_authorization_request ar ON ar.request_user = ud.user_id  
  WHERE ud.user_mobile_no = @user_name  
   OR ud.user_email = @user_name  
  
  SELECT '0' COde  
   ,'Succesfully Sent Verification Code' message  
   ,@user_id id  
  
  RETURN  
 END  
END  
  
--forgot pwd   
IF @flag = 'fp'  
BEGIN  
 IF NOT EXISTS (  
   SELECT 'x'  
   FROM tbl_user_detail  
   WHERE user_mobile_no = @user_name  
    OR user_email = @user_name  
    OR user_name = @user_name  
   )  
 BEGIN  
  SELECT '1' code  
   ,'User Not Found!' message  
   ,NULL id  
  
  RETURN  
 END  
 ELSE  
 BEGIN  
  SELECT TOP 1 @user_verification_code_pr = verification_code  
   ,@user_verification_status = verification_Status  
   ,@email = Email_address  
   ,@full_name = full_Name  
   ,@send_datetime = send_date_time  
  FROM tbl_verification_sent  
  WHERE vid = (  
    SELECT max(vid)  
    FROM tbl_verification_sent  
    WHERE Mobile_Number = @user_name  
     OR Email_address = @user_name  
     OR username = @user_name  
    )  
  
  IF (@user_verification_code_pr = @verification_code)  
   EXEC sproc_error_handler @error_code = '0'  
    ,@msg = 'Code Verified'  
    ,@id = NULL;  
  ELSE  
   EXEC sproc_error_handler @error_code = '1'  
    ,@msg = 'Code Invalid'  
    ,@id = NULL;  
 END  
END  
  
IF @flag = 'fcp'  
BEGIN  
 IF NOT EXISTS (  
   SELECT 'x'  
   FROM tbl_verification_sent  
   WHERE vid = (select max(vid) from tbl_verification_sent where verification_code=@verification_code and ( username = @user_name or Mobile_Number=@user_name or Email_address=@email )  
      
   ))  
 BEGIN  
  EXEC sproc_error_handler @error_code = '1'  
   ,@msg = 'invalid password.'  
   ,@id = NULL;  
  
  RETURN;  
 END;  
  
 UPDATE tbl_user_detail  
 SET [password] = pwdencrypt(@new_password)  
  ,last_password_changed_local_date = @last_password_changed_date_local  
  ,last_password_changed_UTC_date = @last_password_changed_date_utc  
  ,forced_password_changed = 'n'  
  ,session=null
 WHERE user_name = @user_name or user_mobile_no=@user_name or user_email=@email;  
  
 EXEC sproc_error_handler @error_code = '0'  
  ,@msg = 'your password has been changed successfully.'  
  ,@id = NULL;  
  
 RETURN;  
END;  

IF @flag ='gsi'
BEGIN
	select '0' code,'Sucess',session,allow_multiple_login from tbl_user_detail where user_name=@user_name
	return;
END

IF @flag ='usi'
BEGIN
	update tbl_user_detail set session=@session  where user_name=@user_name
	select '0' code              
     ,'Success' message              
     ,null id       
    RETURN;  
END

IF @flag = 'validuser'  
BEGIN  
 IF NOT EXISTS (  
    SELECT *  
    FROM tbl_user_detail  
    WHERE user_mobile_no = @email or user_email=@email   
    )  
  BEGIN  
   select '1' code              
    ,'Invalid User' message              
    ,null id       
   RETURN;  
  END;  
 IF EXISTS (  
   SELECT *  
   FROM tbl_user_detail  
   WHERE @agent_id =(select agent_id from tbl_user_detail WHERE user_mobile_no = @email or user_email=@email )  
   )  
 BEGIN  
  select '1' code              
  ,'Cannot send to self' message              
  ,null id       
  RETURN;  
 END;  
 if @mode ='lb'    --load balance          
  begin    
   if @usr_type='Agent'  
   if exists(  
    SELECT 'x'  
    from  
     tbl_user_detail u (nolock)            
     left join tbl_agent_detail ad on ad.agent_id = u.agent_id  
     where u.status='y' and (u.user_email=@email or u.user_mobile_no=@email ) and ( u.usr_type='WalletUser')  
   )  
   BEGIN  
    select '0' code              
     ,'Valid User For Agent' message              
     ,null id       
    RETURN;  
   END  
  
   if @usr_type='Sub-Agent'  
   if exists(  
   SELECT 'x'  
   from  
    tbl_user_detail u (nolock)            
    left join tbl_agent_detail ad on ad.agent_id = u.agent_id  
    where u.status='y' and (u.user_email=@email or u.user_mobile_no=@email ) and ( u.usr_type='WalletUser')  
   )  
   BEGIN  
    select '0' code              
     ,'Valid User For Sub-Agent' message              
     ,null id       
    RETURN;  
   END  
   select '1' code              
     ,'Invalid User to load balance' message              
     ,null id       
    RETURN;  
  end  
 if @mode ='tb' --transfer balance  
  begin    
   if @usr_type='Agent'  
   if exists(  
   SELECT 'x'  
   from  
    tbl_user_detail u (nolock)            
    left join tbl_agent_detail ad on ad.agent_id = u.agent_id  
    where u.status='y' and (u.user_email=@email or u.user_mobile_no=@email ) and ( u.usr_type='Agent' or u.usr_type='Sub-Agent')  
   )  
   BEGIN  
    select '0' code              
     ,'Valid User For balance transfer' message              
     ,null id       
    RETURN;  
   END  
   if @usr_type='WalletUser'  
   if exists(  
   SELECT 'x'  
   from  
    tbl_user_detail u (nolock)            
    left join tbl_agent_detail ad on ad.agent_id = u.agent_id  
    where u.status='y' and (u.user_email=@email or u.user_mobile_no=@email ) and ( u.usr_type='WalletUser')  
   )  
   BEGIN  
    select '0' code              
     ,'Valid User For balance transfer' message              
     ,null id       
    RETURN;  
   END  
   select '1' code              
     ,'Invalid User to transfer balance' message              
     ,null id       
    RETURN;  
  end  
  
END

If @flag='changeuserpwd'
begin
 IF NOT EXISTS (  
   SELECT 'x'  
   FROM tbl_user_detail  
   WHERE [user_name] = @action_user  
    
   )  
 BEGIN  
  EXEC sproc_error_handler @error_code = '1'  
   ,@msg = 'Invalid Action User'  
   ,@id = NULL;  
  
  RETURN;  
 END;  
  IF NOT EXISTS (  
   SELECT 'x'  
   FROM tbl_user_detail  
   WHERE user_id = @user_id  
    
   )  
 BEGIN  
  EXEC sproc_error_handler @error_code = '1'  
   ,@msg = 'Invalid User'  
   ,@id = NULL;  
  
  RETURN;  
 END; 
  IF @password!=@confirm_password
 BEGIN  
  EXEC sproc_error_handler @error_code = '1'  
   ,@msg = 'Invalid Password/Confirm Password'  
   ,@id = NULL;  
  
  RETURN;  
 END; 
  

 UPDATE tbl_user_detail  
 SET [password] = pwdencrypt(@password)  
  ,last_password_changed_local_date = @last_password_changed_date_local  
  ,last_password_changed_UTC_date = @last_password_changed_date_utc  
  ,updated_by=@action_user
  ,updated_ip=@updated_ip


  --,forced_password_changed = 'n'  
  --,session='|'+@session
 WHERE user_id = @user_id  ;
  --AND pwdcompare(@password, password) = 1;  
  
 EXEC sproc_error_handler @error_code = '0'  
  ,@msg = 'password has been changed successfully.'  
  ,@id = NULL;  
  
 RETURN;  
end

if @flag='r'
begin
	 IF NOT EXISTS (  
   SELECT 'x'  
   FROM tbl_user_detail  
   WHERE [user_name] = @action_user  
    
   )  
 BEGIN  
  EXEC sproc_error_handler @error_code = '1'  
   ,@msg = 'Invalid Action User'  
   ,@id = NULL;  
  
  RETURN;  
 END;  
  IF NOT EXISTS (  
   SELECT 'x'  
   FROM tbl_user_detail  
   WHERE user_id = @user_id  
    
   )  
 BEGIN  
  EXEC sproc_error_handler @error_code = '1'  
   ,@msg = 'Invalid User'  
   ,@id = NULL;  
  
  RETURN;  
 END; 
 
 UPDATE tbl_user_detail  
 SET role_id = @role_id
  ,updated_by = @action_user 
  ,updated_ip = @updated_ip   
  ,updated_local_date=getdate()
  ,updated_UTC_date=getutcdate()
  ,updated_nepali_date=dbo.func_get_nepali_date(getdate())

 WHERE user_id = @user_id  ;
  --AND pwdcompare(@password, password) = 1;  
  
 EXEC sproc_error_handler @error_code = '0'  
  ,@msg = 'Role has been Assigned Succesfully'  
  ,@id = NULL;  
  
 RETURN;  

end

if @flag='d'
begin
 IF NOT EXISTS (  
   SELECT 'x'  
   FROM tbl_user_detail  
   WHERE [user_name] = @action_user  
    
   )  
 BEGIN  
  EXEC sproc_error_handler @error_code = '1'  
   ,@msg = 'Invalid Action User'  
   ,@id = NULL;  
  
  RETURN;  
 END;  
  IF NOT EXISTS (  
   SELECT 'x'  
   FROM tbl_user_detail  
   WHERE user_id = @user_id  
    
   )  
 BEGIN  
  EXEC sproc_error_handler @error_code = '1'  
   ,@msg = 'Invalid User'  
   ,@id = NULL;  
  
  RETURN;  
 END; 
 UPDATE tbl_user_detail  
 SET updated_by = @action_user 
  ,updated_ip = @updated_ip   
  ,updated_local_date=getdate()
  ,updated_UTC_date=getutcdate()
  ,updated_nepali_date=dbo.func_get_nepali_date(getdate())
   WHERE user_id = @user_id  


 delete from tbl_user_detail
 WHERE user_id = @user_id  ;

  
 EXEC sproc_error_handler @error_code = '0'  
  ,@msg = 'User has been Deleted Succesfully'  
  ,@id = NULL;  
  
 RETURN;  
end
