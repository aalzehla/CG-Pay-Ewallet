USE [WePayNepal]
GO

/****** Object:  StoredProcedure [dbo].[sproc_agent_Detail_v2]    Script Date: 25/05/2020 10:14:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER Procedure [dbo].[sproc_agent_Detail_v2]
	@flag char(8) = null,
	@action_user varchar(50) =  null,
	@user_id int  =  null,
	@agent_id int  = null,
	@parent_id int =  null,
	@agent_type varchar(20) = null,
	@agent_operation_type char(1) =  null,
	@agent_commission_type bit = null,
	@agent_name varchar(512) =  null,
	@agent_phone_number varchar(15) =  null,
	@agent_mobile_no varchar(10) = nul,
	@agent_email varchar(512) =  null,
	@agent_web_url varchar(512) = null,
	@agent_registration_no varchar(512) = null,
	@agent_Pan_no varchar(512) = null,
	@agent_contract_date datetime =  null,
	@agent_province varchar(512) =  null,
	@agent_district varchar(512) = null,
	@agent_local_body varchar(512) = null,
	@agent_ward_number int = null,
	@agent_street varchar(512) = null,
	@agent_country varchar(512) = null,
	@agent_credit_limit decimal(18,2) = null,
	@agent_available_balance decimal(18,2) = null,
	@agent_logo varchar(max) = null,
	@agent_reg_certificate varchar(max) = null,
	@agent_pan_Certificate varchar(max) = null,
	@agent_commission_cat_id int  =  null,
	@agent_nationality varchar(512) =  null,
	@action_ip varchar(20) =  null,
	@action_platform varchar(30) = null,
	-----user details-------
	@user_name varchar(50) =  null,
	@password varchar(512) = null,
	@confirm_password varchar(512) = null,
	@first_name varchar(512) = null,
	@middle_name varchar(512) = null,
	@last_name varchar(512) = null,
	@user_mobile_number varchar(10) = null,
	@user_email varchar(512) = null,
	----contact person for business agent
	@contact_person_name varchar(512) = null,
	@contact_person_mobile_number varchar(10) = null,
	@contact_person_ID_type varchar(512) = null,
	@contact_person_ID_no varchar(512) = null,
	@contact_person_Id_issue_date varchar(512) = null,
	@contact_person_id_issue_date_nepali varchar(512) =  null,
	@contact_person_id_expiry_date varchar(512) = null,
	@contact_person_id_expiry_date_nepali varchar(512) = null,
	@contact_person_id_issue_district varchar(512) = null,
	@contact_person_address varchar(512) = null,
	@role_id int = null,
	@usr_type_id int  =  null,
	@action_browser varchar(512) = null,
	@is_primary char(3) = null,
	@agent_status varchar(51) =  null,
	@end_date datetime = null,
	@from_date datetime =  null,
	@user_status varchar(20) = null

	as
	set nocount on;

	DECLARE @action_agent_type VARCHAR(20), @action_parent_id INT, @action_agent_id INT, @action_grand_parent_id INT,@contract_nepali_date VARCHAR(10),@id INT ,@usr_type VARCHAR(20)  
	DECLARE @sql NVARCHAR(MAX),@currentdate DATETIME,@last_online DATETIME  ,@agent_code varchar(512) ,@agent_country_code char(3)

	Begin try
		begin
		IF (@action_user IS NULL) AND @flag != 'drole' AND @flag != 'gdrole' and @flag!='arole'
				BEGIN  
				   EXEC sproc_error_handler @error_code = '1'  
					,@Msg = 'UserName is required'  
					,@id = NULL;  
  
					 RETURN;  
				END; 
		

		SELECT @action_agent_type = A.agent_type  
			   ,@action_parent_id = A.parent_id  
			   ,@action_agent_id = U.agent_id  
			   ,@action_grand_parent_id = ad.parent_id  
		FROM [dbo].tbl_user_detail AS U  
		LEFT JOIN tbl_agent_detail AS A ON U.agent_id = A.agent_id  
		LEFT JOIN tbl_agent_detail AS ad ON ad.agent_id = A.parent_id  
		WHERE A.agent_id = @agent_id;

		--if agentid or agenttype is null then the agent is admin
		  IF (@action_agent_id IS NULL)  
		  BEGIN  
			SET @action_agent_type = 'admin';  
		  END;

		  IF (@action_agent_type != 'admin')  
			  BEGIN  
			   IF (  
				 @parent_Id IS NOT NULL  
				 AND @parent_Id != @action_parent_id  
				 )  
			   BEGIN  
				EXEC sproc_error_handler @error_code = '1'  
				 ,@Msg = 'PARENT ID DID NOT MATCH'  
				 ,@id = @action_user;  
			   END; 

		
		--sub distributor not allowed to create distributor
		   IF (  
			 @action_agent_type in ('subdistributor','agent','subagent')  
			 AND @agent_type = 'distributor'  
			 )  
		   BEGIN  
			EXEC sproc_error_handler @error_Code = '1'  
			 ,@Msg = 'YOUR ARE NOT ALLOWED TO CREATE DISTRIBUTOR'  
			 ,@id = @agent_id;  
		   END; 
		End		
	


	IF @agent_contract_date IS NOT NULL  
		SET @contract_nepali_date = dbo.func_get_nepali_date(@agent_contract_date);

		--insert agent/user detail
	if @flag = 'i'
	begin
		   SELECT @agent_id = MAX(agent_id) FROM tbl_agent_detail;  
  
		   SELECT @agent_code = RIGHT('0000000000' + CAST((ISNULL(@agent_id, 0) + 1) AS VARCHAR(10)), 10);  
  
		   SET @agent_country = ISNULL(@agent_country, 'Nepal');  
		   SET @agent_country_code = ISNULL(@agent_country_code, 'NPL');  
	
			   IF EXISTS (SELECT 'x' FROM tbl_agent_detail WHERE agent_email_address = @agent_email)  
			   BEGIN  
				SELECT '1' Code  
				 ,'Email Address already exists' Message  
				 ,NULL id;  
  
				RETURN;  
			   END;
	
			IF EXISTS ( SELECT 'x' FROM tbl_agent_detail WHERE agent_mobile_no = @agent_mobile_no )  
		   BEGIN  
			SELECT '1' Code  
			 ,'Mobile Number already exists' Message  
			 ,NULL id;  
  
			RETURN;  
		   END;  
	
		   IF @agent_commission_cat_id IS NULL  
		   BEGIN  
			SELECT @agent_commission_cat_id = category_id  
			FROM tbl_commission_category  
			WHERE category_name = 'Default';  
		   END;  
	
			
			INSERT INTO [dbo].[tbl_agent_detail]
           ([parent_id]
           ,[agent_code]
           ,[agent_type]
           ,[agent_operation_type]
           ,[agent_name]
           ,[available_balance]
           ,[agent_phone_no]
           ,[agent_mobile_no]
           ,[agent_email_address]
           ,[agent_nationality]
           ,[agent_country]
           ,[agent_country_code]
           ,[agent_province]
           ,[agent_district]
           ,[agent_localbody]
           ,[agent_wardno]
           ,[agent_address]
           ,[agent_web_url]
           ,[agent_registration_no]
           ,[agent_pan_no]
           ,[agent_credit_limit]
           ,[agent_contract_local_date]
           ,[agent_contract_nepali_date]
           ,[agent_logo_img]
           ,[agent_pan_cert_image]
           ,[agent_registeration_cert_image]
           ,[contact_person_name]
           ,[contact_person_mobile_no]
           ,[contact_person_id_type]
           ,[contact_person_id_no]
           ,[contact_id_issue_local_date]
           ,[contact_id_issued_bs_date]
           ,[contact_id_issued_district]
           ,[contact_person_address]
           ,[agent_commission_id]
           ,[agent_status]
           ,[is_auto_commission]
           ,[fund_load_reward]
           ,[txn_reward_point]
           ,[lock_status]
           ,[created_UTC_date]
           ,[created_local_date]
           ,[created_nepali_date]
           ,[created_by]
           ,[created_ip]
           ,[created_platform])
     VALUES
           (
				@parent_id,
				@agent_code,
				@agent_type,
				@agent_operation_type,
				@agent_name,
				@agent_available_balance,
				@agent_phone_number,
				@agent_mobile_no,
				@agent_email,
				isnull(@agent_nationality, 'Nepali'),
				@agent_country,
				@agent_country_code,
				@agent_province,
				@agent_district,
				@agent_local_body,
				@agent_ward_number,
				@agent_street,
				@agent_web_url,
				@agent_registration_no,
				@agent_Pan_no,
				@agent_credit_limit,
				@agent_contract_date,
				dbo.func_get_nepali_date(@agent_contract_date),
				@agent_logo,
				@agent_pan_Certificate,
				@agent_reg_certificate,
				@contact_person_name,
				@contact_person_mobile_number,
				@contact_person_ID_type,
				@contact_person_ID_no,
				@contact_person_Id_issue_date,
				@contact_person_id_expiry_date_nepali,
				@contact_person_id_issue_district,
				@contact_person_address,
				@agent_commission_cat_id,
				'y',
				@agent_commission_type,
				0,
				0,
				'n',
				GETUTCDATE(),
				GETDATE(),
				dbo.func_get_nepali_date(default),
				@action_user,
				@action_ip,
				@action_platform		   
		   )

		Set @id = SCOPE_IDENTITY()

		select * from tbl_user_detail
		INSERT INTO [dbo].[tbl_user_detail]
           ([agent_id]
           ,[role_id]
           ,[usr_type_id]
           ,[usr_type]
           ,[user_name]
           ,[kyc_status]
           ,[first_name]
           ,[middle_name]
           ,[last_name]
           ,[full_name]
           ,[password]
           ,[user_email]
           ,[user_mobile_no]
           ,[user_status]
           ,[created_UTC_date]
           ,[created_local_date]
           ,[created_nepali_date]
           ,[created_by]
           ,[created_ip]
           ,[created_platform]
           ,[allow_multiple_login]    
           ,[is_login_enabled]
           ,[is_primary]
           ,[browser_info])
     VALUES
           (
				@id,
				@role_id,
				@usr_type_id,
				@usr_type,
				@user_name,
				'Pending',
				@first_name,
				@middle_name,
				@last_name,
				isnull(@first_name,'')+' ' +isnull(@middle_name,'') +' '+isnull(@last_name,''),
				PWDENCRYPT(@password)
,
				@user_email,
				@user_mobile_number,
				'y',
				GETUTCDATE(),
				GETDATE(),
				dbo.func_get_nepali_date(default),
				@action_user,
				@action_ip,
				@action_platform,
				'y',
				'y',
				'y',
				@action_browser
		   )
		   SELECT '0' STATUS ,'Agent created successfully' Message,NULL id;  
		   return
		END;  


		--update agent/user detail
	if @flag = 'u'
	begin
		 IF (@agent_id IS NULL)  
		   BEGIN  
			EXEC sproc_error_handler @error_code = '1'  
			 ,@Msg = 'AGENT ID CANNOT BE NULL'  
			 ,@id = NULL;  
  
			RETURN;  
		   END;  
  
   IF (  
     (  
      SELECT COUNT(*)  
      FROM tbl_agent_detail  
      WHERE agent_id = @agent_id  
      ) = 0  
     )  
   BEGIN  
    EXEC sproc_error_handler @error_code = '1'  
     ,@msg = 'Agent not found'  
     ,@id = @agent_id;  
  
    RETURN;  
   END;

	   IF @user_id IS NOT NULL  
   BEGIN  
    IF NOT EXISTS (  
      SELECT 'x'  
      FROM tbl_user_detail  
      WHERE user_id = @user_id  
      )  
    BEGIN  
     SELECT '1' code  
      ,'User not Found' message  
      ,NULL id  
  
     RETURN  
    END  
   END

   UPDATE [dbo].[tbl_agent_detail]
   SET 
      [agent_operation_type]			= isnull(@agent_operation_type,agent_operation_type)
      ,[agent_name]						= isnull(@agent_name,agent_name)
      ,[agent_phone_no]					= isnull(@agent_phone_number,agent_phone_no) 
      ,[agent_mobile_no]				= isnull(@agent_mobile_no,agent_mobile_no) 
      ,[agent_email_address]			= isnull(@agent_email,agent_email_address) 
      ,[agent_nationality]				= isnull(@agent_nationality,agent_nationality)
      ,[agent_country]					= isnull(@agent_country,agent_country)
      ,[agent_country_code]				= isnull(@agent_country_code,agent_country_code) 
      ,[agent_province]					= isnull(@agent_province,agent_province) 
      ,[agent_district]					= isnull(@agent_district,agent_district) 
      ,[agent_localbody]				= isnull(@agent_local_body,agent_localbody) 
      ,[agent_wardno]					= isnull(@agent_ward_number,agent_wardno)
      ,[agent_address]					= isnull(@agent_street,agent_address) 
      ,[agent_web_url]					= isnull(@agent_web_url,agent_web_url) 
      ,[agent_registration_no]			= isnull(@agent_registration_no,agent_registration_no) 
      ,[agent_pan_no]					= isnull(@agent_Pan_no,agent_pan_no)
      ,[agent_credit_limit]				= isnull(@agent_credit_limit,agent_credit_limit) 
      ,[agent_contract_local_date]		= isnull(@agent_contract_date,agent_contract_local_date) 
      ,[agent_contract_nepali_date]		= isnull(dbo.func_get_nepali_date(@agent_contract_date),agent_contract_nepali_date)
      ,[agent_logo_img]					= isnull(@agent_logo,agent_logo_img) 
      ,[agent_pan_cert_image]			= isnull(@agent_pan_Certificate,agent_pan_cert_image) 
      ,[agent_registeration_cert_image] = isnull(@agent_reg_certificate,agent_registeration_cert_image) 
      ,[contact_person_name]			= isnull(@contact_person_name,contact_person_name) 
      ,[contact_person_mobile_no]		= isnull(@contact_person_mobile_number,contact_person_mobile_no) 
      ,[contact_person_id_type]			= isnull(@contact_person_ID_type,contact_person_id_type)
      ,[contact_person_id_no]			= isnull(@contact_person_ID_no,contact_person_id_no) 
      ,[contact_id_issue_local_date]	= isnull(@contact_person_Id_issue_date,contact_id_issue_local_date) 
      ,[contact_id_issued_bs_date]		= isnull(@contact_person_id_issue_date_nepali,contact_id_issued_bs_date) 
      ,[contact_id_issued_district]		= isnull(@contact_person_id_issue_district,contact_id_issued_district) 
      ,[contact_person_address]			= isnull(@contact_person_address,contact_person_address) 
      ,[agent_commission_id]			= isnull(@agent_commission_cat_id,agent_commission_id)
      ,[is_auto_commission]				= isnull(@agent_commission_type,is_auto_commission)
      ,[updated_by]						= isnull(@action_user,updated_by)
      ,[updated_UTC_date]				= isnull(GETUTCDATE(),updated_UTC_date)
      ,[updated_local_date]				= isnull(GETDATE(),updated_local_date)
      ,[updated_nepali_date]			= isnull(dbo.func_get_nepali_date(default),updated_nepali_date) 
      ,[updated_ip]						= isnull(@action_ip,updated_ip) 
 WHERE agent_id = @agent_id

 UPDATE [dbo].[tbl_user_detail]
   SET [role_id]			= isnull(@role_id,role_id)
      ,[usr_type_id]		= isnull(@usr_type_id,usr_type_id)
      ,[usr_type]			= isnull(@usr_type,usr_type)
      ,[user_name]			= isnull(@user_name,user_name)
      ,[first_name]			= isnull(@first_name,first_name)
      ,[middle_name]		= isnull(@middle_name,middle_name)
      ,[last_name]			= isnull(@last_name,last_name)
      ,[full_name]			= isnull((isnull(@first_name,'') + '' + isnull(@middle_name,'') + '' +  isnull(@last_name,'')),full_name)
      ,[password]			= isnull(PWDENCRYPT(@password),password)
      ,[user_email]			= isnull(@user_email,user_email)
      ,[user_mobile_no]		= isnull(@user_mobile_number,user_mobile_no)
      ,[updated_by]			= isnull(@action_user,updated_by)
      ,[updated_UTC_date]	= isnull(GETUTCDATE(),updated_UTC_date)
      ,[updated_local_date] = isnull(GETDATE(),updated_local_date)
      ,[updated_nepali_date] =isnull(dbo.func_get_nepali_date(default),updated_nepali_date)
      ,[updated_ip]			= isnull(@action_ip,updated_ip)
      ,[is_primary]			= isnull(@is_primary,is_primary)
      ,[browser_info]		= isnull(@action_browser,browser_info)
 WHERE user_id = @user_id



 end

		--view Distributor user
	if @flag = 'vdu'
	begin
		if not exists (select 'x' from tbl_agent_detail where agent_id = @agent_id and agent_status = 'y')
		begin
			EXEC sproc_error_handler @error_Code = '1'  
			 ,@Msg = 'Agent Not Found'  
			 ,@id = null
		end

		else if (select count(*)from tbl_user_detail where agent_id = @agent_id) = 0
		begin
			EXEC sproc_error_handler @error_Code = '1'  
			 ,@Msg = 'NO users found for this agent'  
			 ,@id = @agent_id
		end

		else 
		begin
			select user_id, user_name, user_email, user_mobile_no , is_primary, user_status from tbl_user_detail where agent_id = @agent_id 
		end


	end


	--select all dist
	IF (@Flag = 's')  
  BEGIN  
   SET @currentdate = dbo.func_get_nepali_date(DEFAULT);  
   SET @sql = 'SELECT agent_id,parent_id,agent_code,agent_type,agent_operation_type,agent_name,available_balance,agent_phone_no,agent_mobile_no,agent_email_address,agent_nationality,
agent_country,agent_province,agent_district,agent_localbody,agent_wardno,agent_address,
agent_web_url,agent_registration_no,agent_pan_no,agent_credit_limit,format(agent_contract_local_date,''yyyy-MM-dd'')agent_contract_local_date,agent_contract_nepali_date,agent_logo_img,
agent_registeration_cert_image,
agent_pan_cert_image,contact_person_name,agent_country_code,contact_person_mobile_no,contact_person_id_type,contact_person_id_no,format(contact_id_issue_local_date,''yyyy-MM-dd'')contact_id_issue_local_date,
contact_id_issued_bs_date,contact_id_issued_district,agent_commission_id,agent_status,is_auto_commission,agent_qr_image,fund_load_reward,txn_reward_point,
referal_id,agent_referal_id,lock_status,locked_reason,locked_UTC_date,locked_by,created_UTC_date,created_local_date,created_nepali_date,created_by,created_ip,
created_platform,updated_by,updated_UTC_date,updated_local_date,updated_nepali_date,updated_ip,agent_address,contact_person_address 
FROM tbl_agent_detail WHERE 1=1  '  
  
   --IF (@action_user != 'superadmin')  
   -- AND NOT EXISTS (  
   --  SELECT 'x'  
   --  FROM tbl_agent_detail ad  
   --  JOIN tbl_user_detail ud ON ad.agent_id = ud.agent_id  
   --  WHERE ud.user_name = @action_user  
   --   AND ISNULL(ud.is_primary, 'n') = 'y'  
   --  )  
   --BEGIN  
   -- SET @sql = @sql + ' AND Created_By = ''' + @action_user + '''';  
   --END;  
   --ELSE 
   IF @action_user IS NOT NULL  
    AND (  
     @parent_Id IS NULL  
     AND @agent_id IS NULL  
     )  
    AND EXISTS (  
     SELECT 'x'  
     FROM tbl_user_detail  
     WHERE usr_type IS NULL  
      OR usr_type = 'admin'  
      AND user_name = @action_user  
     )  
   BEGIN  
    SET @sql = @sql + ' AND parent_id is null';  
   END;  
  
   IF (@agent_type IS NOT NULL)  
   BEGIN  
    SET @sql = @sql + ' AND agent_type = ''' + @agent_type + '''';  
   END;  
  
   IF @agent_id IS NOT NULL  
   BEGIN  
    SET @sql = @sql + ' AND Agent_Id = ''' + CAST(@agent_id AS VARCHAR) + '''';  
   END;  
  

   IF @parent_Id IS NOT NULL  
   BEGIN  
    SET @sql = @sql + ' AND parent_id = ''' + CAST(@parent_Id AS VARCHAR) + '''';  
   END;  
  


   IF @agent_status IS NOT NULL  
   BEGIN  
    SET @sql = @sql + ' AND agent_status = ''' + @agent_status + '''';  
   END;  


   IF @agent_mobile_no IS NOT NULL or @agent_email is not null or @agent_name is not null                              
   BEGIN  
    SET @sql = @sql + ' AND agent_mobile_no LIKE  ''%' + @agent_mobile_no + '%'''--' or agent_email_address LIKE ''%' + @agent_email + '%'' or agent_name LIKE ''%' + @agent_name + '%''';  
   END;  
  


   IF @end_date IS NULL  
    SET @end_date = @currentdate;  
  
   IF @from_date IS NOT NULL  
    AND @end_date IS NOT NULL  
    SET @sql = @sql + ' AND created_local_date BETWEEN ''' + format(@from_date, 'yyyy-MM-dd') + ' 00:00:01'' and ''' + format(@end_date, 'yyyy-MM-dd') + ' 23:59:59.999''';  
     PRINT (@sql);   
   EXEC (@sql); 
 
  END;

	--select distributor detail
	if @flag = 'ds'
	begin
		if not exists(select 'x' from tbl_agent_detail where agent_id = @agent_id)
		begin
			select '1' code, 'Agent not found ' message, null id
			return
			
		end
		else
		begin
			select * from tbl_agent_detail ad 
			join tbl_user_detail u on u.agent_id = ad.agent_id
			where ad.agent_id = @agent_id
		end
	end	
	
	--selct distributor user
	IF @flag = 'v'      
	BEGIN         
  if @agent_id is null and @user_id  is null  --Get all agent users  
   begin    
    Select    
    u.[user_id],    
    u.[user_name],    
    u.full_name,    
    u.agent_id,    
    u.user_mobile_no,    
    u.user_email,    
    u.user_status,    
    u.usr_type_id,    
    u.usr_type,    
    b.role_id,    
    a.parent_id,     
    ad.agent_id as grand_parent_id,    
    gd.gateway_id    
    from tbl_user_detail u     
    join tbl_agent_detail a on a.agent_id = u.agent_id    
    left join tbl_agent_detail ad on ad.agent_id = a.parent_id    
    LEFT JOIN tbl_user_role b ON b.[user_id] = u.[user_id]    
    LEFT JOIN tbl_gateway_detail gd ON gd.gateway_id = a.agent_id     
    --where u.agent_id = @agent_id and u.user_id =@user_id    
   end    
  else if @user_id is not null and @agent_id is not null   --get agent user by agent_id and user_id  
  begin    
   Select     
   u.[user_id],    
    u.[user_name],    
    u.full_name,    
    u.agent_id,    
    u.user_mobile_no,    
    u.user_email,    
    u.user_status,    
    u.usr_type_id,        
    u.usr_type,    
    u.is_primary,    
    b.role_id,    
    a.parent_id,     
    ad.agent_id as grand_parent_id,    
    gd.gateway_id    
    from tbl_user_detail u     
    join tbl_agent_detail a on a.agent_id = u.agent_id    
    left join tbl_agent_detail ad on ad.agent_id = a.parent_id    
    LEFT JOIN tbl_user_role b ON b.[user_id] = u.[user_id]    
    LEFT JOIN tbl_gateway_detail gd ON gd.gateway_id = a.agent_id     
    where u.agent_id = @agent_id     
    and u.user_id =@user_id    
  end    
  else if @agent_id is not null  --get agent user by agent_id  
  begin    
   Select     
   u.[user_id],    
    u.[user_name],    
    u.full_name,    
    u.agent_id,    
    u.user_mobile_no,    
    u.user_email,    
    u.user_status,    
    u.usr_type_id,    
    u.usr_type,    
    b.role_id,    
    a.parent_id,     
    ad.agent_id as grand_parent_id,    
    u.is_primary,       
    gd.gateway_id     
    from tbl_user_detail u     
    join tbl_agent_detail a on a.agent_id = u.agent_id    
    left join tbl_agent_detail ad on ad.agent_id = a.parent_id    
    LEFT JOIN tbl_user_role b ON b.[user_id] = u.[user_id]    
    LEFT JOIN tbl_gateway_detail gd ON gd.gateway_id = a.agent_id     
    where u.agent_id = @agent_id     
  end    
  else  if @user_id is not null -- get admin user by user_id  
   begin    
   Select     
   u.[user_id],    
    u.[user_name],    
    u.full_name,    
    u.agent_id,    
    u.user_mobile_no,    
    u.user_email,    
    u.user_status,    
    u.usr_type_id,    
    u.usr_type,    
    b.role_id,    
    null parent_id,     
    null as grand_parent_id,    
    null gateway_id,    
    u.is_primary,    
    u.created_by,    
    u.created_local_date   
    from tbl_user_detail u     
    --left join tbl_agent_detail a on a.agent_id = u.agent_id    
    --left join tbl_agent_detail ad on ad.agent_id = a.parent_id    
    LEFT JOIN tbl_user_role b ON b.[user_id] = u.[user_id]    
    --LEFT JOIN tbl_gateway_detail gd ON gd.gateway_id = a.agent_id     
    where  u.user_id =@user_id  and agent_id is null  
  end    
  else -- get all admin users  
  begin    
   Select     
   u.[user_id],    
    u.[user_name],    
    u.full_name,    
    u.agent_id,    
    u.user_mobile_no,    
    u.user_email,    
    u.user_status,    
    u.usr_type_id,    
    u.usr_type,    
    b.role_id,    
    null parent_id,     
    null as grand_parent_id,    
    null gateway_id,    
    u.is_primary,    
    u.created_by,    
    u.created_local_date    
    from tbl_user_detail u     
    --left join tbl_agent_detail a on a.agent_id = u.agent_id    
    --left join tbl_agent_detail ad on ad.agent_id = a.parent_id    
    LEFT JOIN tbl_user_role b ON b.[user_id] = u.[user_id]    
    --LEFT JOIN tbl_gateway_detail gd ON gd.gateway_id = a.agent_id     
    where  agent_id is null  
  end  
  

End    

		-- assign distributor role
	IF @flag = 'dRole'       
	  BEGIN  
		UPDATE tbl_user_detail  
		SET role_id = @role_id  
		,is_primary = @is_primary  
		WHERE user_id = @user_id  
		AND agent_id = @agent_id  

		select '0' code, 'Role updated succesfully' message, null id
		return
	END 

		--Block/unblock dist user
	if @flag = 'uu' -- disable user with agent id    
			begin    
			 if not exists(select 'x' from tbl_user_detail u    
			 join tbl_agent_detail a on a.agent_id = u.agent_id    
			 where user_id = @user_id    
			 and u.agent_id = @agent_id    
			 )    
			 begin    
			  select '1' code, 'User not found' message, null id    
			  return    
			 end    
			 else    
			 begin    
			  update tbl_user_detail    
			  set user_status = Isnull(@user_status,user_status)    
			  where user_id = @user_id and agent_id = @agent_id    
    
			  EXEC sproc_error_handler @error_code = '0'     
			  ,@msg = 'user status updated'      
			  ,@id = NULL;    
			 end    
	end  

	 --insert distributer user
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
   WHERE user_mobile_no = @user_mobile_number      
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
   WHERE user_email = @user_email      
   )      
 BEGIN      
  EXEC sproc_error_handler @error_code = '1'      
   ,@msg = 'email id already exists'      
   ,@error_source = 'sproc_user_detail @flag = ''i'''      
   ,@id = NULL;      
      
  RETURN;      
 END;      
      
 If @usr_type_id = 1  
 begin  
  set @usr_type = 'admin'  
  set  @role_id = '1'  
 end  
 else if @usr_type_id = 6  
 begin  
  set @usr_type = 'walletuser'  
  set @role_id ='6'  
 end  
 else  
 begin  
  set @usr_type = @usr_type  
 end  
  
 INSERT INTO dbo.tbl_user_detail (      
  [user_name]      
  ,[password] 
  ,first_name
  ,middle_name
  ,last_name
  ,full_name      
  ,agent_id      
  ,user_email      
  ,user_mobile_no      
     
  ,created_by      
  ,created_UTC_date      
  ,created_local_date      
  ,created_nepali_date      
  ,created_ip      
  ,created_platform      
  ,allow_multiple_login      
  ,user_status      
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
  ,@first_name
  ,@middle_name
  ,@last_name
  ,isnull(@first_name,'') +  ' ' + isnull(@middle_name,'') + '' + isnull(@last_name,'')      
  ,@agent_id      
  ,@user_email      
  ,@user_mobile_number      
  ,@action_user      
  ,GETUTCDATE()      
  ,GETDATE()      
  ,dbo.func_get_nepali_date(default)       
  ,@action_ip      
  ,@action_platform      
  ,'n'     
  ,@user_status      
  ,@usr_type_id      
  ,@usr_type      
  ,'y'      
  ,@is_primary      
  ,@action_browser   
  ,@role_id  
  );      
      
 EXEC sproc_error_handler @error_code = '0'      
  ,@msg = 'user created succesfully.'      
  ,@id = NULL;      
      
 RETURN;      
END;

	--update distributor user
	IF @flag = 'u'      
		BEGIN      
		 IF @user_id IS NULL      
		 BEGIN      
		  EXEC sproc_error_handler @error_code = '1'      
		   ,@msg = 'user id cannot be null'      
		   ,@id = NULL;      
      
		  RETURN;      
		 END;      
		  if @password is not null    
		 begin    
		  if (len(@password)<8)    
		  begin    
		   select '1'code, 'Password must be 8 or more than 8 characters' message, null id    
		   return    
		  end    
		  else if (@password <> @confirm_password)    
		  begin    
		   select '1' code, 'Password and Confirm password didn''t match' message, null id    
		   return    
		  end    
		 end    
    
		 UPDATE dbo.tbl_user_detail      
		 SET 
			first_name = isnull(@first_name, first_name)
		 ,middle_name = isnull(@middle_name, middle_name)
		 ,last_name = isnull(@last_name, last_name)
		 ,full_name = isnull(isnull(@first_name, '')+ ' ' + isnull(@middle_name, '')+ ' ' + isnull(@last_name,''), full_name)      
		  ,user_name = isnull(@user_name, user_name)     
		  ,password = Isnull(PWDENcrypt(@password), password)    
		  ,agent_id = isnull(@agent_id, agent_id)      
		  ,user_email = isnull(@user_email, user_email)      
		  ,user_mobile_no = isnull(@user_mobile_number, user_mobile_no)      
		  ,updated_by = isnull(@action_user, updated_by)      
		  ,updated_UTC_date = isnull(GETUTCDATE(), updated_UTC_date)      
		  ,updated_local_date = isnull(GETDATE(), updated_local_date)      
		  ,updated_nepali_date = isnull(dbo.func_get_nepali_date(default), updated_nepali_date)      
		  ,user_status = isnull(@user_status, user_status)      
		  ,usr_type_id = isnull(@usr_type_id, usr_type_id)      
		  ,usr_type = isnull(@usr_type, usr_type)      
		  ,is_primary = isnull(@is_primary, is_primary)      
		  ,browser_info = isnull(@action_browser, browser_info)      
		 WHERE user_id = @user_id;      
      
		 IF @role_id IS NOT NULL      
		 BEGIN      
		  DELETE tbl_user_role      
		  WHERE user_id = @user_name;      
      
		  INSERT INTO tbl_user_role (      
		   [user_id]      
		   ,role_id      
		   ,created_by      
		   ,created_UTC_date      
		   ,created_local_date      
		   ,created_nepali_date      
		   )      
		  SELECT @user_name      
		   ,@role_id      
		   ,@action_user      
		   ,GETUTCDATE()      
		   ,GETDATE()      
		   ,dbo.func_get_nepali_date(default);      
		 END;      
      
		 EXEC sproc_error_handler @error_code = '0'      
		  ,@msg = 'user succesfully updated'      
		  ,@id = @user_id;      
      
		 RETURN;      
		END; 

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
		 SET user_status = @user_status      
		 WHERE user_id = @user_id and agent_id is null;      
      
		 EXEC sproc_error_handler @error_code = '0'      
		  ,@msg = 'user status updated'      
		  ,@id = NULL;      
      
		 RETURN;      
		END; 


	if @flag = 'uu' -- disable user with agent id    
		begin    
	if not exists(select 'x' from tbl_user_detail u    
	join tbl_agent_detail a on a.agent_id = u.agent_id    
	where user_id = @user_id    
	and u.agent_id = @agent_id    
	)    
	begin    
	select '1' code, 'User not found' message, null id    
	return    
	end    
	else    
	begin    
	update tbl_user_detail    
	set user_status = Isnull(@user_status,user_status)    
	where user_id = @user_id and agent_id = @agent_id    
    
	EXEC sproc_error_handler @error_code = '0'     
	,@msg = 'user status updated'      
	,@id = NULL;    
	end    
	end  


	if @flag='lglst'    
		Begin    
		 set @sql='select user_id,u.full_name,user_email,user_mobile_no,u.created_local_date,u.created_by,status,user_name 
		 from tbl_user_detail u 
		 left join tbl_agent_detail a on u.agent_id=a.agent_id  where 1=1'    
		 if @usr_type <>'Admin'    
		 set @sql=@sql+' and a.agent_name='''+@user_name+''''    
		 print @sql    
		 exec(@sql)    
		 return;    
		End 
	end



	END TRY  
  
	BEGIN CATCH  
	 IF @@trancount > 0  
	  ROLLBACK TRANSACTION;  
  
	 SELECT 1 CODE,ERROR_MESSAGE() msg ,NULL id;  
	END CATCH;        
		  


GO


