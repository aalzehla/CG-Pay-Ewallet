USE [CGPay]
GO

/****** Object:  StoredProcedure [dbo].[sproc_merchant_detail]    Script Date: 8/26/2020 11:37:50 AM ******/
DROP PROCEDURE [dbo].[sproc_merchant_detail]
GO

/****** Object:  StoredProcedure [dbo].[sproc_merchant_detail]    Script Date: 8/26/2020 11:37:50 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
    
CREATE   PROCEDURE [dbo].[sproc_merchant_detail] @flag CHAR(8) = NULL    
 ,@action_user VARCHAR(50) = NULL    
 ,@user_id INT = NULL    
 ,@agent_id INT = NULL    
 ,@parent_id INT = NULL    
 ,@merchant_type VARCHAR(20) = NULL    
 ,@merchant_operation_type VARCHAR(15) = NULL    
 ,@merchant_commission_type BIT = NULL    
 ,@merchant_name VARCHAR(512) = NULL    
 ,@merchant_phone_number VARCHAR(15) = NULL    
 ,@merchant_mobile_no VARCHAR(10) = NULL    
 ,@merchant_email VARCHAR(512) = NULL    
 ,@merchant_web_url VARCHAR(512) = NULL    
 ,@merchant_registration_no VARCHAR(512) = NULL    
 ,@merchant_Pan_no VARCHAR(512) = NULL    
 ,@merchant_contract_date DATETIME = NULL    
 ,@merchant_province VARCHAR(512) = NULL    
 ,@merchant_district VARCHAR(512) = NULL    
 ,@merchant_local_body VARCHAR(512) = NULL    
 ,@merchant_ward_number INT = NULL    
 ,@merchant_street VARCHAR(512) = NULL    
 ,@merchant_country VARCHAR(512) = NULL    
 ,@merchant_credit_limit DECIMAL(18, 2) = NULL    
 ,@merchant_available_balance DECIMAL(18, 2) = NULL    
 ,@merchant_logo VARCHAR(max) = NULL    
 ,@merchant_reg_certificate VARCHAR(max) = NULL    
 ,@merchant_pan_Certificate VARCHAR(max) = NULL    
 ,@merchant_commission_cat_id INT = NULL    
 ,@merchant_nationality VARCHAR(512) = NULL    
 ,@action_ip VARCHAR(20) = NULL    
 ,@action_platform VARCHAR(30) = NULL    
 ,    
 -----user details-------      
 @user_name VARCHAR(50) = NULL    
 ,@password VARCHAR(512) = NULL    
 ,@confirm_password VARCHAR(512) = NULL    
 ,@first_name VARCHAR(512) = NULL    
 ,@middle_name VARCHAR(512) = NULL    
 ,@last_name VARCHAR(512) = NULL    
 ,@user_mobile_number VARCHAR(10) = NULL    
 ,@user_email VARCHAR(512) = NULL    
 ,@full_name varchar(512)=Null    
 ----contact person for business agent      
 ,@contact_person_name VARCHAR(512) = NULL    
 ,@contact_person_mobile_number VARCHAR(10) = NULL    
 ,@contact_person_ID_type VARCHAR(512) = NULL    
 ,@contact_person_ID_no VARCHAR(512) = NULL    
 ,@contact_person_Id_issue_date VARCHAR(512) = NULL    
 ,@contact_person_id_issue_date_nepali VARCHAR(512) = NULL    
 ,@contact_person_id_expiry_date VARCHAR(512) = NULL    
 ,@contact_person_id_expiry_date_nepali VARCHAR(512) = NULL    
 ,@contact_person_id_issue_district VARCHAR(512) = NULL    
 ,@contact_person_address VARCHAR(512) = NULL    
 ,@role_id INT = NULL    
 ,@usr_type_id INT = NULL    
 ,@action_browser VARCHAR(512) = NULL    
 ,@is_primary CHAR(3) = NULL    
 ,@agent_status VARCHAR(51) = NULL    
 ,@end_date DATETIME = NULL    
 ,@from_date DATETIME = NULL    
 ,@user_status VARCHAR(20) = NULL    
 ,@usr_type VARCHAR(20) = NULL    
 ,@qr_image_path VARCHAR(max) = NULL    
 ,@merchantqr TEXT = NULL    
AS    
DECLARE @sql NVARCHAR(max)    
 ,@currentdate DATETIME    
 ,@last_online DATETIME    
 ,@merchant_code VARCHAR(512)    
 ,@merchant_country_code CHAR(3)    
 ,@randmon_pasword VARCHAR(100)  
 ,@fullname VARCHAR(255)  
 ,@usermobileNumber VARCHAR(10)  
 ,@useremail VARCHAR(255)  
 ,@id INT    
 ,@desc VARCHAR(max)    
    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
    
 IF @flag = 's' -- merchant user list                    
 BEGIN    
  SET @currentdate = dbo.func_get_nepali_date(DEFAULT);    
  SET @sql =     
   '    
SELECT    
   a.[agent_id]    
      ,[parent_id]    
      ,[agent_code]    
      ,[agent_type]    
      ,[agent_operation_type]    
      ,[agent_name]    
      ,[kyc_status]    
      ,[first_name]    
      ,[middle_name]    
      ,[last_name]    
      ,[available_balance]    
      ,[date_of_birth_eng]    
      ,[date_of_birth_nep]    
      ,[gender]    
      ,[agent_phone_no]    
      ,[agent_mobile_no]    
      ,[agent_email_address]    
      ,[occupation]    
      ,[marital_status]    
      ,[spouse_name]    
      ,[father_name]    
      ,[mother_name]    
      ,[grand_father_name]    
      ,[agent_nationality]    
      ,[agent_country]    
      ,[permanent_province]    
      ,[permanent_district]    
  ,[permanent_localbody]    
      ,[permanent_wardno]    
      ,[permanent_address]    
      ,[temporary_province]    
      ,[temporary_district]    
      ,[temporary_localbody]    
      ,[temporary_wardno]    
      ,[temporary_address]    
      ,[latitude]    
      ,[longitude]    
      ,[web_url]    
      ,[agent_registration_no]    
      ,[agent_pan_no]    
      ,[agent_credit_limit]    
      ,[agent_support_staff]    
      ,format(agent_contract_local_date,''yyyy-MM-dd'')agent_contract_local_date    
      ,[agent_contract_nepali_date]    
      ,[agent_logo_img]    
      ,[agent_document_img_front]    
      ,[agent_document_img_back]    
      ,[contact_person_name]    
      ,[agent_country_code]    
      ,[contact_person_mobile_no]    
      ,[contact_person_id_type]    
      ,[contact_person_id_no]    
      ,format(contact_id_issue_local_date,''yyyy-MM-dd'')contact_id_issue_local_date    
      ,[contact_id_issued_bs_date]    
      ,[contact_id_issued_district]    
      ,[agent_commission_id]    
      ,[agent_status]    
      ,[is_auto_commission]    
      ,[agent_qr_image]    
      ,[fund_load_reward]    
      ,[txn_reward_point]    
      ,[admin_remarks]    
      ,a.[full_name]    
      ,[is_sameAs_per_add]    
      ,[individual_image]    
      ,[referal_id]    
      ,[agent_referal_id]    
      ,[lock_status]    
      ,[locked_reason]    
      ,[locked_UTC_date]    
      ,[locked_by]       
      ,[agent_address]    
      ,[contact_Person_address]    
       
    FROM tbl_agent_detail as a with (nolock)   
 WHERE 1=1  '    
    
  IF (@merchant_type IS NOT NULL)    
  BEGIN    
   SET @sql = @sql + ' AND a.agent_type = ''' + @merchant_type + '''';    
  END;    
    
  IF (@agent_id IS NOT NULL)    
  BEGIN    
   SET @sql = @sql + ' AND a.agent_id = ''' + @agent_id + '''';    
  END;    
    
  IF @parent_id IS NOT NULL    
  BEGIN    
   SET @sql = @sql + ' AND a.parent_id = ''' + CAST(@parent_id AS VARCHAR) + '''';    
  END;    
    
  PRINT @sql;    
    
  EXEC (@sql);    
 END;    
    
 IF @flag = 'i' -- insert new merchant      
 BEGIN    
  IF EXISTS (    
    SELECT 'x'    
    FROM tbl_agent_detail with (nolock)   
    WHERE agent_email_address = @merchant_email    
    )    
  BEGIN    
   SELECT '1' Code    
    ,'Email Address already exists' Message    
    ,NULL id;    
    
   RETURN;    
  END;    
    
  IF EXISTS (    
    SELECT 'x'    
    FROM tbl_user_detail  with (nolock)  
    WHERE user_name = @user_name    
    )    
  BEGIN    
   SELECT '1' Code    
    ,'User Name already exists' Message    
    ,NULL id;    
    
   RETURN;    
  END;    
    
  IF EXISTS (    
    SELECT 'x'    
    FROM tbl_agent_detail with (nolock)   
    WHERE agent_mobile_no = @merchant_mobile_no    
    )    
  BEGIN    
   SELECT '1' Code    
    ,'Merchant Mobile Number already exists' Message    
    ,NULL id;    
    
   RETURN;    
  END;    
    
  IF EXISTS (    
    SELECT 'x'    
    FROM tbl_user_detail with (nolock)   
    WHERE user_mobile_no = @merchant_mobile_no    
    )    
  BEGIN    
   SELECT '1' Code    
    ,'User Mobile Number already exists' Message    
    ,NULL id;    
    
   RETURN;    
  END;    
    
  SELECT @agent_id = MAX(agent_id)    
  FROM tbl_agent_detail with (nolock);    
    
  SELECT @merchant_code = RIGHT('0000000000' + CAST((ISNULL(@agent_id, 0) + 1) AS VARCHAR(10)), 10);    
    
  SET @merchant_country = ISNULL(@merchant_country, 'Nepal');    
  SET @merchant_country_code = ISNULL(@merchant_country_code, 'NPL');    
    
  IF @merchant_commission_cat_id IS NULL    
  BEGIN    
   SELECT @merchant_commission_cat_id = category_id    
   FROM tbl_commission_category with (nolock)   
   WHERE category_name = 'Default';    
  END;    
    
  --Print ('x')    
  --return    
  INSERT INTO [dbo].[tbl_agent_detail] (    
   [parent_id]    
   ,[agent_code]    
   ,[agent_type]    
   ,[agent_operation_type]    
   ,[agent_name]    
   ,first_name    
   ,middle_name    
   ,last_name    
   ,full_name    
   ,[available_balance]    
   ,[agent_phone_no]    
   ,[agent_mobile_no]    
   ,[agent_email_address]    
   ,[agent_nationality]    
   ,[agent_country]    
   ,[agent_country_code]    
   ,permanent_province    
   ,permanent_district    
   ,[permanent_localbody]    
   ,[permanent_wardno]    
   ,[permanent_address]    
   ,[web_url]    
   ,[agent_registration_no]    
   ,[agent_pan_no]    
   ,[agent_credit_limit]    
   ,[agent_contract_local_date]    
   ,[agent_contract_nepali_date]    
   ,[agent_logo_img]    
   ,[agent_document_img_front]    
   ,[agent_document_img_back]    
   ,[contact_person_name]    
   ,[contact_person_mobile_no]    
   ,[contact_person_id_type]    
   ,[contact_person_id_no]    
   ,[contact_id_issue_local_date]    
   ,[contact_id_issued_bs_date]    
   ,[contact_id_issued_district]    
   ,contact_person_address    
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
   ,[created_platform]    
   ,kyc_status    
   )    
  VALUES (    
   @parent_id    
   ,@merchant_code    
   ,@merchant_type    
   ,@merchant_operation_type    
   ,@merchant_name    
   ,@first_name    
   ,@middle_name    
   ,@last_name    
   ,ISNULL(@first_name, '') + ' ' + ISNULL(@middle_name, '') + ' ' + ISNULL(@last_name, '')    
   ,@merchant_available_balance    
   ,@merchant_phone_number    
   ,@merchant_mobile_no    
   ,@merchant_email    
   ,ISNULL(@merchant_nationality, 'Nepali')    
   ,@merchant_country    
   ,@merchant_country_code    
   ,@merchant_province    
   ,@merchant_district    
   ,@merchant_local_body    
   ,@merchant_ward_number    
   ,@merchant_street    
   ,@merchant_web_url    
   ,@merchant_registration_no    
   ,@merchant_Pan_no    
   ,@merchant_credit_limit    
   ,@merchant_contract_date    
   ,dbo.func_get_nepali_date(@merchant_contract_date)    
   ,@merchant_logo    
   ,@merchant_pan_Certificate    
   ,@merchant_reg_certificate    
   ,@contact_person_name    
   ,@contact_person_mobile_number    
   ,@contact_person_ID_type    
   ,@contact_person_ID_no    
   ,@contact_person_Id_issue_date    
   ,@contact_person_id_expiry_date_nepali    
   ,@contact_person_id_issue_district    
   ,@contact_person_address    
   ,@merchant_commission_cat_id    
   ,'y'    
   ,@merchant_commission_type    
   ,0    
   ,0    
   ,'n'    
   ,GETUTCDATE()    
   ,GETDATE()    
   ,dbo.func_get_nepali_date(DEFAULT)    
   ,@action_user    
   ,@action_ip    
   ,@action_platform    
   ,'Approved'    
   )    
    
  SET @id = SCOPE_IDENTITY()    
    
  INSERT INTO [dbo].[tbl_user_detail] (    
   [agent_id]    
   ,[role_id]    
   ,[usr_type_id]    
   ,[usr_type]    
   ,[user_name]    
   ,[full_name]    
   ,[password]    
   ,[user_email]    
   ,[user_mobile_no]    
   ,[status]    
   ,[created_UTC_date]    
   ,[created_local_date]    
   ,[created_nepali_date]    
   ,[created_by]    
   ,[created_ip]    
   ,[created_platform]    
   ,[allow_multiple_login]    
   ,[is_login_enabled]    
   ,[is_primary]    
   ,[browser_info]    
   )    
  VALUES (    
   @id    
   ,@role_id    
   ,@usr_type_id    
   ,@usr_type    
   ,@user_name    
   ,ISNULL(@first_name, '') + ' ' + ISNULL(@middle_name, '') + ' ' + ISNULL(@last_name, '')    
   ,PWDENCRYPT(@password)    
   ,@user_email    
   ,@user_mobile_number    
   ,'y'    
   ,GETUTCDATE()    
   ,GETDATE()    
   ,dbo.func_get_nepali_date(DEFAULT)    
   ,@action_user    
   ,@action_ip    
   ,@action_platform    
   ,'y'    
   ,'y'    
   ,'y'    
   ,@action_browser    
   )    
    
  SELECT '0' STATUS    
   ,'Merchant created successfully' Message    
   ,SCOPE_IDENTITY() extra1    
   ,@id extra2    
   ,@merchant_code extra3    
    
  RETURN    
 END;    
    
 IF @flag = 'u' --update agent/user detail      
 BEGIN    
  IF (@agent_id IS NULL)    
  BEGIN    
   EXEC sproc_error_handler @error_code = '1'    
    ,@Msg = 'MERCHANT ID CANNOT BE NULL'    
    ,@id = NULL;    
    
   RETURN;    
  END;    
    
  IF (    
    (    
     SELECT COUNT(*)    
     FROM tbl_agent_detail  with (nolock)  
     WHERE agent_id = @agent_id    
     ) = 0    
    )    
  BEGIN    
   EXEC sproc_error_handler @error_code = '1'    
    ,@msg = 'Merchant not found'    
    ,@id = @agent_id;    
    
   RETURN;    
  END;    
    
  IF @user_id IS NOT NULL    
  BEGIN    
   IF NOT EXISTS (    
     SELECT 'x'    
     FROM tbl_user_detail  with (nolock)  
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
  SET [agent_operation_type] = ISNULL(@merchant_operation_type, agent_operation_type)    
   ,[agent_name] = ISNULL(@merchant_name, agent_name)    
   ,[agent_phone_no] = ISNULL(@merchant_phone_number, agent_phone_no)    
   ,[agent_mobile_no] = ISNULL(@merchant_mobile_no, agent_mobile_no)    
   ,[agent_email_address] = ISNULL(@merchant_email, agent_email_address)    
   ,[first_name] = ISNULL(@first_name, first_name)    
   ,[middle_name] = ISNULL(@middle_name, middle_name)    
   ,[last_name] = ISNULL(@last_name, last_name)    
   ,[agent_nationality] = ISNULL(@merchant_nationality, agent_nationality)    
   ,[agent_country] = ISNULL(@merchant_country, agent_country)    
   ,[agent_country_code] = ISNULL(@merchant_country_code, agent_country_code)    
   ,[permanent_province] = ISNULL(@merchant_province, [permanent_province])    
   ,[permanent_district] = ISNULL(@merchant_district, [permanent_district])    
   ,[permanent_localbody] = ISNULL(@merchant_local_body, [permanent_localbody])    
   ,[permanent_wardno] = ISNULL(@merchant_ward_number, [permanent_wardno])    
   ,[agent_address] = ISNULL(@merchant_street, agent_address)    
   ,[web_url] = ISNULL(@merchant_web_url, web_url)    
   ,[agent_registration_no] = ISNULL(@merchant_registration_no, agent_registration_no)    
   ,[agent_pan_no] = ISNULL(@merchant_Pan_no, agent_pan_no)    
   ,[agent_credit_limit] = ISNULL(@merchant_credit_limit, agent_credit_limit)    
   ,[agent_contract_local_date] = ISNULL(@merchant_contract_date, agent_contract_local_date)    
   ,[agent_contract_nepali_date] = ISNULL(dbo.func_get_nepali_date(@merchant_contract_date), agent_contract_nepali_date)    
   ,[agent_logo_img] = ISNULL(@merchant_logo, agent_logo_img)    
   ,[agent_document_img_front] = ISNULL(@merchant_pan_Certificate, [agent_document_img_front])    
   ,[agent_document_img_back] = ISNULL(@merchant_reg_certificate, [agent_document_img_back])    
   ,[contact_person_name] = ISNULL(@contact_person_name, contact_person_name)    
   ,[contact_person_mobile_no] = ISNULL(@contact_person_mobile_number, contact_person_mobile_no)    
   ,[contact_person_id_type] = ISNULL(@contact_person_ID_type, contact_person_id_type)    
   ,[contact_person_id_no] = ISNULL(@contact_person_ID_no, contact_person_id_no)    
   ,[contact_id_issue_local_date] = ISNULL(@contact_person_Id_issue_date, contact_id_issue_local_date)    
   ,[contact_id_issued_bs_date] = ISNULL(@contact_person_id_issue_date_nepali, contact_id_issued_bs_date)    
   ,[contact_id_issued_district] = ISNULL(@contact_person_id_issue_district, contact_id_issued_district)    
   ,contact_person_address = ISNULL(@contact_person_address, contact_person_address)    
   ,[agent_commission_id] = ISNULL(@merchant_commission_cat_id, agent_commission_id)    
   ,[is_auto_commission] = ISNULL(@merchant_commission_type, is_auto_commission)    
   ,[updated_by] = ISNULL(@action_user, updated_by)    
   ,[updated_UTC_date] = ISNULL(GETUTCDATE(), updated_UTC_date)    
   ,[updated_local_date] = ISNULL(GETDATE(), updated_local_date)    
   ,[updated_nepali_date] = ISNULL(dbo.func_get_nepali_date(DEFAULT), updated_nepali_date)    
   ,[updated_ip] = ISNULL(@action_ip, updated_ip)    
  WHERE agent_id = @agent_id    
    
  SELECT '0' code    
   ,'Agent updated succesfully' message    
   ,NULL id    
    
  RETURN    
 END    
    
 IF @flag = 'md' --select merchant detail      
 BEGIN    
  IF NOT EXISTS (    
    SELECT 'x'    
    FROM tbl_agent_detail with (nolock)   
    WHERE agent_id = @agent_id    
    )    
  BEGIN    
   SELECT '1' code    
    ,'Merchant not found ' message    
    ,NULL id    
    
   RETURN    
  END    
  ELSE    
  BEGIN    
   SELECT *    
   FROM tbl_agent_detail ad with (nolock)    
   JOIN tbl_user_detail u with (nolock) ON u.agent_id = ad.agent_id    
   WHERE ad.agent_id = @agent_id    
  END    
 END    
    
 IF @flag = 'edm' --Enable/Disable Merchant Status    
 BEGIN    
      
  IF NOT EXISTS (    
    SELECT 'x'    
    FROM tbl_agent_detail  with (nolock)  
    WHERE agent_id = @agent_id    
    )    
  BEGIN    
   SELECT '1' code    
    ,'Merchant not found' message    
    ,NULL id    
    
   RETURN    
  END    
    
  UPDATE tbl_agent_detail    
  SET agent_status = @user_status    
  WHERE agent_id = @agent_id    
    
  UPDATE tbl_user_detail    
  SET STATUS = @user_status    
  WHERE agent_id = @agent_id    
    
  SELECT '0' code    
   ,'Merchant Status updated succesfully' message    
   ,NULL id    
    
  RETURN    
 END    
    
 IF @flag = 'qr' --for updating qr to db                
 BEGIN    
  IF NOT EXISTS (    
    SELECT 'x'    
    FROM tbl_user_detail with (nolock)   
    WHERE user_id = @user_id    
    )    
  BEGIN    
   SELECT '1' Code    
    ,'User Not Found' Message    
    ,NULL id;    
    
   RETURN;    
  END;    
    
  IF NOT EXISTS (    
    SELECT 'x'    
    FROM tbl_agent_detail with (nolock)    
    WHERE agent_id = @agent_id    
    )    
  BEGIN    
   SELECT '1' Code    
    ,'Agent Not Found' Message    
    ,NULL id;    
    
   RETURN;    
  END;    
  ELSE    
  BEGIN    
   UPDATE tbl_agent_detail    
   SET agent_qr_image = CONCAT (    
     cast('data:image/png;base64,' AS TEXT)    
     ,@merchantqr    
     )    
    ,agent_qr_image_path = @qr_image_path    
   WHERE agent_id = @agent_id;    
    
   UPDATE tbl_user_detail    
   SET user_qrimage = CONCAT (    
     cast('data:image/png;base64,' AS TEXT)    
     ,@merchantqr    
     )    
   WHERE agent_id = @agent_id    
    AND user_id = @user_id    
    
   SELECT '0' Code    
    ,'QR added successfully' Message    
    ,NULL id;    
    
   RETURN;    
  END    
 END    
    
 IF @flag = 'su' -- search user    
 BEGIN    
  IF @agent_id IS NOT NULL    
   AND @user_id IS NULL    
  BEGIN    
   SELECT user_id    
    ,user_name    
    ,full_name    
    ,agent_id    
    ,user_email    
    ,user_mobile_no    
    ,STATUS    
    ,usr_type_id    
    ,usr_type    
    ,is_primary    
    ,role_id    
        
   FROM tbl_user_detail with (nolock)    
       
   WHERE agent_id = @agent_id     
  END    
  ELSE IF @user_id IS NOT NULL    
  BEGIN    
   SELECT user_id    
    ,user_name    
    ,u.full_name    
    ,u.agent_id    
    ,user_email    
    ,user_mobile_no    
    ,STATUS    
    ,usr_type_id    
    ,usr_type    
    ,is_primary    
    ,role_id    
    ,a.agent_qr_image    
   FROM tbl_user_detail u with (nolock) join tbl_agent_detail a with (nolock)     
   on u.agent_id = a.agent_id    
   WHERE user_id = @user_id     
  END    
    
  RETURN    
 END    
    
 IF @flag = 'iu' --insert User    
 BEGIN    
  IF EXISTS (    
    SELECT TOP 1 'x'    
    FROM tbl_user_detail with (nolock)   
    WHERE user_name = @user_name    
    )    
  BEGIN    
   EXEC sproc_error_handler @error_code = '1'    
    ,@msg = 'username already exists'    
    ,@error_script = 'username already exists'    
    ,@error_source = 'sproc_merchant_detail @flag = ''iu'''    
    ,@id = NULL;    
    
   RETURN;    
  END;    
    
  IF EXISTS (    
    SELECT TOP 1 'x'    
    FROM tbl_user_detail with (nolock)   
    WHERE user_mobile_no = @user_mobile_number    
    )    
  BEGIN    
   EXEC sproc_error_handler @error_code = '1'    
    ,@msg = 'mobile/phone number already exists'    
    ,@error_script = 'mobile/phone number already exists'    
    ,@error_source = 'sproc_merchant_detail @flag = ''iu'''    
    ,@id = NULL;    
    
   RETURN;    
  END;    
    
  IF EXISTS (    
    SELECT TOP 1 'x'    
    FROM tbl_user_detail with (nolock)   
    WHERE user_email = @user_email    
    )    
  BEGIN    
   EXEC sproc_error_handler @error_code = '1'    
    ,@msg = 'email id already exists'    
    ,@error_source = 'sproc_merchant_detail @flag = ''iu'''    
    ,@id = NULL;    
RETURN;    
  END;    
    
        
    
   BEGIN TRY    
    BEGIN TRANSACTION insertUser    
    
    INSERT INTO dbo.tbl_user_detail (    
     [user_name]    
     ,[password]    
     ,full_name    
     ,agent_id    
     ,user_email    
     ,user_mobile_no    
     ,forced_password_changed    
     ,created_by    
     ,created_UTC_date    
     ,created_local_date    
     ,created_nepali_date    
     ,created_ip    
     ,allow_multiple_login    
     ,[status]    
     ,usr_type_id    
     ,usr_type         
     ,is_primary    
     ,browser_info    
     ,role_id    
     )    
    VALUES (    
     @user_name    
     ,pwdencrypt(@password)    
     ,@full_name    
     ,@agent_id    
     ,@user_email    
     ,@user_mobile_number    
     ,'y'    
     ,@action_user    
     ,GETUTCDATE()    
     ,GETDATE()    
     ,dbo.func_get_nepali_date(getdate())    
     ,@action_ip         
     ,'n'    
     ,@user_status    
     ,@usr_type_id    
     ,@usr_type    
     ,@is_primary    
     ,@action_browser    
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
     ,'sproc_merchant_detail(Insert in User Detail:flag ''iu'')'    
     ,'sql'    
     ,'sql'    
     ,'sproc_merchant_detail(Insert in User Detail)'    
     ,getdate()    
     ,getutcdate()    
     ,[dbo].func_get_nepali_date(DEFAULT)    
    
    SELECT '1' code    
     ,'errorid: ' + cast(scope_identity() AS VARCHAR) message    
     ,NULL id    
   END CATCH    
    
   RETURN;    
      
 END    
    
 IF @flag = 'uu'    
 BEGIN    
  IF @user_id IS NULL    
  BEGIN    
   SELECT '1' code    
    ,'User not Found' message    
    ,NULL id    
    
   RETURN    
  END    
    
  IF @user_id IS NOT NULL    
  BEGIN    
   IF NOT EXISTS (    
     SELECT 'x'    
     FROM tbl_user_detail with (nolock)   
     WHERE user_id = @user_id    
     )    
   BEGIN    
    SELECT '1' code    
     ,'User not Found' message    
     ,NULL id    
    
    RETURN    
   END    
  END    
    
  UPDATE [dbo].[tbl_user_detail]    
  SET [role_id] = ISNULL(@role_id, role_id)    
   ,[usr_type_id] = ISNULL(@usr_type_id, usr_type_id)    
   ,[usr_type] = ISNULL(@usr_type, usr_type)    
   --,[user_name] = ISNULL(@user_name, user_name)    
   ,[full_name] = ISNULL(@full_name, full_name)    
   ,[password] = ISNULL(PWDENCRYPT(@password), password)    
   --,[user_email] = ISNULL(@user_email, user_email)    
   --,[user_mobile_no] = ISNULL(@user_mobile_number, user_mobile_no)    
   ,[updated_by] = ISNULL(@action_user, updated_by)    
   ,[updated_UTC_date] = ISNULL(GETUTCDATE(), updated_UTC_date)    
   ,[updated_local_date] = ISNULL(GETDATE(), updated_local_date)    
   ,[updated_nepali_date] = ISNULL(dbo.func_get_nepali_date(DEFAULT), updated_nepali_date)    
   ,[updated_ip] = ISNULL(@action_ip, updated_ip)    
   ,[is_primary] = ISNULL(@is_primary, is_primary)    
   ,[browser_info] = ISNULL(@action_browser, browser_info)    
  WHERE user_id = @user_id    
    
  EXEC sproc_error_handler @error_code = '0'    
     ,@msg = 'User Updated succesfully.'    
     ,@id = NULL;    
 END    
    
 If @flag='edu'--enable disable user    
 begin    
      
  IF NOT EXISTS (    
    SELECT 'x'    
    FROM tbl_user_detail with (nolock)    
    WHERE user_id = @user_id    
    )    
  BEGIN    
   SELECT '1' code    
    ,'User Not Found' message    
    ,NULL id    
    
   RETURN    
  END    
    
    
  UPDATE tbl_user_detail    
  SET STATUS = @user_status    
  WHERE user_id = @user_id    
    
  SELECT '0' code    
   ,'Merchant Status updated succesfully' message    
   ,NULL id    
    
  RETURN    
     
 end    
  
 --Reset password by admin Merchant management    
 IF @flag = 'rpass'    
 BEGIN    
  IF NOT EXISTS (    
    SELECT 'x'    
    FROM tbl_user_detail    
    WHERE user_id=@user_id  and agent_id=@agent_id  
    )    
  BEGIN    
   SELECT '1' code    
    ,'User Not Found!' message    
    ,NULL id    
    
   RETURN    
  END    
    
  ELSE    
  BEGIN    
   select @fullname = full_name, @useremail =user_email, @usermobileNumber = user_mobile_no, @agent_id =agent_id  from tbl_user_detail where user_id=@user_id    
   set @randmon_pasword = SUBSTRING(CONVERT(varchar(40), NEWID()),0,9)    
   UPDATE tbl_user_detail set password=PWDENCRYPT(@randmon_pasword) where user_id=@user_id;    
    
  EXEC sproc_email_request @flag = 'dr'  
    ,@full_name = @fullname  
    ,@email_id = @useremail  
    ,@password = @randmon_pasword  
  
  
    INSERT INTO tbl_sms_transaction (  
    country  
    ,agent_id  
    ,sms_destination_no  
    ,sms_message_type  
    ,message  
    ,STATUS  
    ,created_by  
    ,created_date  
    )  
    VALUES   
    (  
     'Nepal'  
     ,@agent_id  
     ,@usermobileNumber  
     ,1  
     ,'Please Login with the following password:  ' + @randmon_pasword  
     ,'Pending'  
     ,@action_user  
     ,GETDATE()  
    )  
  
   SELECT '0' code                      
   ,'User Password Reset Successfully' message    
  END    
 END  
  
  IF @flag = 'mlist'
  BEGIN
	SET @sql ='SELECT agent_id value, full_name text FROM tbl_agent_detail with (nolock) where agent_type =''Merchant''' 
    
	  IF (@agent_id IS NOT NULL)    
	  BEGIN    
	   SET @sql = @sql + ' AND agent_id = ''' + @agent_id + '''';    
	  END;    
    
	  IF @parent_id IS NOT NULL    
	  BEGIN    
	   SET @sql = @sql + ' AND parent_id = ''' + CAST(@parent_id AS VARCHAR) + '''';    
	  END;    
    
	  PRINT @sql;    
    
	  EXEC (@sql);    
  END
END    
GO


