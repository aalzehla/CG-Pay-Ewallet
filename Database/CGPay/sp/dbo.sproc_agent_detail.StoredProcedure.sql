USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_agent_detail]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

    
CREATE     PROCEDURE [dbo].[sproc_agent_detail] (    
 @flag CHAR(10)    
 ,--- i=INSERT,u=UPDATE,d=DELETE,l=LOCKED,ul=UNLOCKED,s=SEARCH                              
 @agent_id INT = NULL    
 ,@agent_code VARCHAR(30) = NULL    
 ,@agent_operation_type VARCHAR(20) = NULL    
 ,@agent_name VARCHAR(50) = NULL    
 ,@first_name VARCHAR(100) = NULL    
 ,@middle_name VARCHAR(100) = NULL    
 ,@last_name VARCHAR(100) = NULL    
 ,@balance DECIMAL(18, 2) = NULL    
 ,@country VARCHAR(20) = NULL    
 ,@province VARCHAR(30) = NULL    
 ,@district VARCHAR(50) = NULL    
 ,@local_body VARCHAR(50) = NULL    
 ,@ward_no INT = NULL    
 ,@address VARCHAR(60) = NULL    
 ,@latitude VARCHAR(30) = NULL    
 ,@longitude VARCHAR(30) = NULL    
 ,@phone_no VARCHAR(20) = NULL    
 ,@email_address VARCHAR(50) = NULL    
 ,@web_url VARCHAR(100) = NULL    
 ,@registration_no VARCHAR(20) = NULL    
 ,@pan_no VARCHAR(20) = NULL    
 ,@credit_limit DECIMAL(18, 2) = NULL    
 ,@support_staff VARCHAR(50) = NULL    
 ,@contract_date DATETIME = NULL    
 ,@logo_img NVARCHAR(MAX) = NULL    
 ,@contact_name VARCHAR(50) = NULL    
 ,@country_code VARCHAR(3) = NULL    
 ,@mobile_no VARCHAR(50) = NULL    
 ,@Contact_id_type VARCHAR(50) = NULL    
 ,@Contact_id_no VARCHAR(50) = NULL    
 ,@Contact_id_issue_date DATETIME = NULL    
 ,@Contact_id_issue_date_bs VARCHAR(50) = NULL    
 ,@Contact_id_issue_district VARCHAR(50) = NULL    
 ,@Contact_id_address VARCHAR(550) = NULL    
 ,@commission_cat_id INT = NULL    
 ,@Status VARCHAR(10) = NULL    
 ,@lock_status CHAR(3) = NULL    
 ,@locked_reason VARCHAR(350) = NULL    
 ,    
 --,@is_deleted CHAR(3) = NULL                     
 @created_ip VARCHAR(50) = NULL    
 ,@created_platform VARCHAR(10) = NULL    
 ,@parent_Id VARCHAR(10) = NULL    
 ,@grand_parent_id VARCHAR(10) = NULL    
 ,@referal_id VARCHAR(10) = NULL    
 ,@agent_referal_id VARCHAR(10) = NULL    
 ,@kyc_status CHAR(3) = NULL    
 ,@agent_type VARCHAR(20) = NULL    
 ,@is_auto_commission BIT = NULL    
 ,@qr_image VARCHAR(150) = NULL    
 ,@fund_load_reward INT = NULL    
 ,@txn_rewardpoint INT = NULL    
 ,@from_date DATETIME = NULL    
 ,@end_date DATETIME = NULL    
 ,@action_ip NVARCHAR(50) = NULL    
 ,@action_user NVARCHAR(200) = NULL    
 ,@platform VARCHAR(100) = NULL    
 ,@gender VARCHAR(10) = NULL    
 ,@occupation VARCHAR(100) = NULL    
 ,@nationality VARCHAR(10) = NULL    
 ,@dob_eng DATETIME = NULL    
 ,@dob_nepali VARCHAR(20) = NULL    
 ,@temp_province VARCHAR(50) = NULL    
 ,@temp_district VARCHAR(30) = NULL    
 ,@temp_local_body VARCHAR(30) = NULL    
 ,@temp_ward_no VARCHAR(2) = NULL    
 ,@temp_address VARCHAR(50) = NULL    
 ,@mobile_number VARCHAR(20) = NULL    
 ,@agent_doc_image_front VARCHAR(50) = NULL    
 ,@agent_doc_image_back VARCHAR(50) = NULL    
 ,@agent_individual_image VARCHAR(50) = NULL    
 ,@is_sameAs_per_add BIT = NULL    
 ,@user_full_name VARCHAR(100) = NULL    
 ,@user_name VARCHAR(100) = NULL    
 ,@password VARCHAR(100) = NULL    
 ,@agent_address VARCHAR(500) = NULL    
 ,@usr_type_id INT = NULL    
 ,@user_id INT = NULL    
 ,@role_id INT = NULL    
 ,@is_primary CHAR(3) = NULL    
 )    
AS    
SET NOCOUNT ON;    
    
BEGIN TRY    
 BEGIN    
  IF (@action_user IS NULL)    
   AND @flag != 'drole'    
   AND @flag != 'gdrole'    
   and @flag!='arole'  
  BEGIN    
   EXEC sproc_error_handler @error_code = '1'    
    ,@Msg = 'UserName is required'    
    ,@id = NULL;    
    
   RETURN;    
  END;    
    
  DECLARE @action_agent_type VARCHAR(20)    
   ,@action_parent_id INT    
   ,@action_agent_id INT    
   ,@action_grand_parent_id INT    
   ,@contract_nepali_date VARCHAR(10) = NULL    
   ,@id INT    
   ,@usr_type VARCHAR(20)    
  DECLARE @sql NVARCHAR(MAX)    
   ,@currentdate DATETIME    
   ,@last_online DATETIME = NULL;    
    
  SELECT @action_agent_type = A.agent_type    
   ,@action_parent_id = A.parent_id    
   ,@action_agent_id = U.agent_id    
   ,@action_grand_parent_id = ad.parent_id    
  FROM [dbo].tbl_user_detail AS U    
  LEFT JOIN tbl_agent_detail AS A ON U.agent_id = A.agent_id    
 LEFT JOIN tbl_agent_detail AS ad ON ad.agent_id = A.parent_id    
  WHERE A.agent_id = @agent_id;    
    
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
    
   IF (    
     @action_agent_type = 'subdistributor'    
     AND @agent_type = 'distributor'    
     )    
   BEGIN    
    EXEC sproc_error_handler @error_Code = '1'    
     ,@Msg = 'YOUR ARE NOT ALLOWED TO CREATE DISTRIBUTOR'    
     ,@id = @agent_id;    
   END;    
    
   IF (@parent_Id IS NULL)    
   BEGIN    
    SET @grand_parent_id = NULL;    
   END;    
    
   IF (    
     @action_agent_type = 'subdistributor'    
     AND @action_parent_id IS NOT NULL    
     AND @agent_type IN (    
      'merchant'    
      ,'walletUser'    
      )    
     AND @grand_parent_id IS NULL    
     )    
   BEGIN    
    EXEC sproc_error_handler @error_code = '1'    
     ,@Msg = 'GRAND PARENT ID IS REQUIRED'    
     ,@id = @agent_id;    
   END;    
  END;    
    
  IF @contract_date IS NOT NULL    
   SET @contract_nepali_date = dbo.func_get_nepali_date(@contract_date);    
    
  IF (@Flag = 'i')    
  BEGIN    
   IF @grand_parent_id IS NULL    
    AND @parent_Id IS NOT NULL    
    SELECT @grand_parent_id = parent_id    
    FROM tbl_agent_detail    
    WHERE agent_id = @parent_Id;    
    
   SELECT @agent_id = MAX(agent_id)    
   FROM tbl_agent_detail;    
    
   SELECT @agent_code = RIGHT('0000000000' + CAST((ISNULL(@agent_id, 0) + 1) AS VARCHAR(10)), 10);    
    
   SET @Country = ISNULL(@country, 'Nepal');    
   SET @country_code = ISNULL(@country_code, 'NPL');    
    
   IF EXISTS (    
     SELECT 'x'    
     FROM tbl_agent_detail    
     WHERE agent_email_address = @email_address    
     )    
   BEGIN    
    SELECT '1' Code    
     ,'Email Address already exists' Message    
     ,NULL id;    
    
    RETURN;    
   END;    
    
   IF EXISTS (    
     SELECT 'x'    
     FROM tbl_agent_detail    
     WHERE agent_mobile_no = @mobile_no    
     )    
   BEGIN    
    SELECT '1' Code    
     ,'Mobile Number already exists' Message    
     ,NULL id;    
    
    RETURN;    
   END;    
    
   IF @commission_cat_id IS NULL    
   BEGIN    
    SELECT @commission_cat_id = category_id    
    FROM tbl_commission_category    
    WHERE category_name = 'Default';    
   END;    
    
BEGIN TRANSACTION
   INSERT INTO tbl_agent_detail (    
    agent_code    
    ,agent_operation_type    
    ,first_name    
    ,middle_name    
    ,last_name    
    ,gender    
    ,available_balance    
    ,agent_country    
    ,permanent_province    
    ,permanent_district    
    ,permanent_localbody    
    ,permanent_wardno    
    ,permanent_address    
    ,[Latitude]    
    ,[Longitude]    
    ,agent_phone_no    
    ,agent_email_address    
    ,web_url    
    ,agent_registration_no    
    ,agent_pan_no    
    ,agent_credit_limit    
    ,agent_support_staff    
    ,agent_contract_local_date    
    ,agent_contract_nepali_date    
    ,agent_logo_img    
    ,contact_person_name    
    ,agent_country_code    
    ,contact_person_mobile_no    
    ,contact_person_id_type    
    ,contact_person_id_no    
    ,contact_id_issue_local_date    
    ,contact_id_issued_bs_date    
    ,contact_id_issued_district    
    ,contact_person_address--contact_id_address    
    ,agent_commission_id    
    ,agent_status    
    ,created_UTC_date    
    ,created_local_date    
    ,created_nepali_date    
    ,created_by    
    ,created_ip    
    ,created_platform    
    ,parent_id    
    ,referal_id    
    ,agent_referal_id    
    ,kyc_status    
    ,agent_type    
    ,is_auto_commission    
    ,agent_qr_image    
    ,fund_load_reward    
    ,txn_reward_point    
    ,occupation    
    ,agent_nationality    
    ,date_of_birth_eng    
    ,date_of_birth_nep    
    ,temporary_province    
    ,temporary_district    
    ,temporary_localbody    
    ,temporary_wardno    
    ,temporary_address    
    ,agent_mobile_no    
    ,agent_document_img_front    
    ,agent_document_img_back    
    ,individual_image    
    ,is_sameAs_per_add    
    ,Agent_Name    
    ,agent_address    
    )    
   VALUES (    
    @agent_code    
    ,@agent_operation_type    
    ,@first_name    
    ,@middle_name    
    ,@last_name    
    ,@gender    
    ,ISNULL(@balance, 0)    
    ,@Country    
    ,@Province    
    ,@District    
    ,@local_body    
    ,@ward_no    
    ,@Address    
    ,@Latitude    
    ,@Longitude    
    ,@phone_no    
    ,@email_address    
    ,@web_url    
    ,@registration_no    
    ,@pan_no    
    ,ISNULL(@credit_limit, 0)    
    ,--agent_credit_limit               
    @support_staff    
    ,--agent_support_staff               
    @contract_date    
    ,--agent_contract_nepali_date               
    @contract_nepali_date    
    ,@logo_img    
    ,@contact_name    
    ,@country_code    
    ,@mobile_no    
    ,@Contact_id_type    
    ,@Contact_id_no    
    ,@Contact_id_issue_date    
    ,@Contact_id_issue_date_bs    
    ,@Contact_id_issue_district    
    ,@Contact_id_address    
    ,@commission_cat_id    
    ,ISNULL(@Status, 'Y')    
    ,GETUTCDATE()    
    ,GETDATE()    
    ,dbo.func_get_nepali_date(DEFAULT)    
    ,@action_user    
    ,@action_ip    
    ,@Platform    
    ,@parent_Id    
    ,@referal_id    
    ,@agent_referal_id    
    ,'Pending'    
    ,isnull(@agent_type, 'Distributor')    
    ,ISNULL(@is_auto_commission, 'M')    
    ,@qr_image    
    ,ISNULL(@fund_load_reward, 0)    
    ,ISNULL(@txn_rewardpoint, 0)    
    ,@occupation    
    ,@nationality    
    ,@dob_eng    
    ,@dob_nepali    
    ,@temp_province    
    ,@temp_district    
    ,@temp_local_body    
    ,@temp_ward_no    
    ,@temp_address    
    ,@mobile_number    
    ,@agent_doc_image_front    
    ,@agent_doc_image_back    
    ,@agent_individual_image    
    ,@is_sameAs_per_add    
    ,@agent_name    
    ,@agent_address    
    );    
    
   SET @id = SCOPE_IDENTITY()    
    
   IF @agent_type = 'WalletUser'    
   BEGIN    
    SET @usr_type = 'WalletUser'    
    SET @usr_type_id = '6'    
   END    
    
   -- insert into user detail          
   INSERT INTO tbl_user_detail (    
    agent_id    
    ,full_name    
    ,password    
    ,is_login_enabled    
 ,status  
    ,is_primary    
    ,user_email    
    ,user_mobile_no    
    ,user_name    
    ,usr_type    
    ,usr_type_id    
    ,created_by    
    ,created_ip    
    ,created_local_date    
    ,created_nepali_date    
    ,created_UTC_date    
 ,role_id  
    )    
   VALUES (    
    @id    
    ,@user_full_name    
    ,PWDENCRYPT(@password)    
    ,'y'    
 ,'y'  
    ,'y'    
    ,@email_address    
    ,@mobile_no    
    ,@user_name    
    ,@usr_type    
    ,@usr_type_id    
    ,@action_user    
    ,@action_ip    
    ,getdate()    
    ,dbo.func_get_nepali_date(DEFAULT)    
    ,getUTCDATE()    
 ,@role_id  
    )    
ROLLBACK

   SELECT '0' STATUS    
    ,'Agent created successfully' Message    
    ,NULL id;    
  END;    
    
  IF (@flag = 'u')    
  BEGIN    
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
    
   UPDATE tbl_agent_detail    
   SET agent_code = ISNULL(@agent_code, agent_code)    
    ,agent_operation_type = ISNULL(@agent_operation_type, agent_operation_type)    
    ,first_name = ISNULL(@first_name, first_name)    
    ,middle_name = ISNULL(@middle_name, middle_name)    
    ,last_name = ISNULL(@last_name, last_name)    
    ,available_balance = ISNULL(@Balance, available_balance)    
    ,agent_country = ISNULL(@Country, agent_country)    
    ,permanent_province = ISNULL(@Province, permanent_province)    
    ,permanent_district = ISNULL(@District, permanent_district)    
    ,permanent_localbody = ISNULL(@local_body, permanent_localbody)    
    ,permanent_wardno = ISNULL(@ward_no, permanent_wardno)    
    ,permanent_address = ISNULL(@Address, permanent_address)    
    ,[Latitude] = ISNULL(@Latitude, [Latitude])    
    ,[Longitude] = ISNULL(@Longitude, [Longitude])    
    ,agent_phone_no = ISNULL(@phone_no, agent_phone_no)    
    ,agent_email_address = ISNULL(@email_address, agent_email_address)    
    ,web_url = ISNULL(@web_url, web_url)    
    ,agent_registration_no = ISNULL(@registration_no, agent_registration_no)    
    ,agent_pan_no = ISNULL(@pan_no, agent_pan_no)    
    ,agent_credit_limit = ISNULL(@credit_limit, agent_credit_limit)    
    ,agent_support_staff = ISNULL(@support_staff, agent_support_staff)    
    ,agent_contract_local_date = ISNULL(@contract_date, agent_contract_local_date)    
    ,agent_contract_nepali_date = ISNULL(@contract_nepali_date, agent_contract_nepali_date)    
    ,agent_logo_img = ISNULL(@logo_img, agent_logo_img)    
    ,contact_person_name = ISNULL(@contact_name, contact_person_name)    
    ,agent_country_code = ISNULL(@country_code, agent_country_code)    
    ,contact_person_mobile_no = ISNULL(@mobile_no, contact_person_mobile_no)    
    ,contact_person_id_type = ISNULL(@Contact_id_type, contact_person_id_type)    
    ,contact_person_id_no = ISNULL(@Contact_id_no, contact_person_id_no)    
    ,contact_id_issue_local_date = ISNULL(@Contact_id_issue_date, contact_id_issue_local_date)    
    ,contact_id_issued_bs_date = ISnull(@Contact_id_issue_date_bs, contact_id_issued_bs_date)    
    ,contact_id_issued_district = ISNULL(@Contact_id_issue_district, contact_id_issued_district)    
    ,contact_person_address = isnull(@Contact_id_address, contact_person_address)    
    ,agent_commission_id = ISNULL(@commission_cat_id, agent_commission_id)    
    ,agent_status = ISNULL(@Status, agent_status)    
    ,updated_by = @action_user    
    ,updated_nepali_date = ISNULL(dbo.func_get_nepali_date(DEFAULT), updated_nepali_date)    
    ,updated_UTC_date = GETUTCDATE()    
    ,updated_local_date = GETDATE()    
    ,updated_ip = ISNULL(@action_ip, updated_ip)    
    ,referal_id = ISNULL(@referal_id, referal_id)    
    ,agent_referal_id = ISNULL(@agent_referal_id, agent_referal_id)    
    ,kyc_status = ISNULL(@kyc_status, kyc_status)    
    ,agent_type = ISNULL(@agent_type, agent_type)    
    ,is_auto_commission = ISNULL(@is_auto_commission, is_auto_commission)    
    ,agent_qr_image = ISNULL(@qr_image, agent_qr_image)    
    ,fund_load_reward = ISNULL(@fund_load_reward, fund_load_reward)    
    ,txn_reward_point = ISNULL(@txn_rewardpoint, txn_reward_point)    
    ,Gender = ISNULL(@gender, gender)    
    ,occupation = ISNULL(@occupation, occupation)    
    ,agent_nationality = ISNULL(@nationality, agent_nationality)    
    ,date_of_birth_eng = ISNULL(@dob_eng, date_of_birth_eng)    
    ,date_of_birth_nep = ISNULL(@dob_nepali, date_of_birth_nep)    
    ,temporary_province = ISNULL(@temp_province, temporary_province)    
    ,temporary_district = ISNULL(@temp_district, temporary_district)    
    ,temporary_localbody = ISNULL(@temp_local_body, temporary_localbody)    
    ,temporary_wardno = ISNULL(@temp_ward_no, temporary_wardno)    
    ,temporary_address = ISNULL(@temp_address, temporary_address)    
    ,agent_mobile_no = ISNULL(@mobile_number, agent_mobile_no)    
    ,agent_document_img_front = ISNULL(@agent_doc_image_front, agent_document_img_front)    
    ,agent_document_img_back = ISNULL(@agent_doc_image_back, agent_document_img_back)    
    ,individual_image = ISNULL(@agent_individual_image, individual_image)    
    ,is_sameAs_per_add = ISNULL(@is_sameAs_per_add, is_sameAs_per_add)    
    ,Agent_Name = ISNULL(@agent_name, Agent_Name)    
    ,agent_address = ISNULL(@agent_address, agent_address)    
   WHERE agent_id = @agent_id    
    AND ISNULL(agent_status, 'N') = 'Y';    
    
   SELECT '0' STATUS    
    ,'AGENT UPDATED SUCCESSFULLY' Message    
    ,NULL id;    
  END;    
    
  IF (@flag = 'd')    
  BEGIN    
   IF (@agent_code IS NULL)    
   BEGIN    
    EXEC sproc_error_handler @error_Code = '1'    
     ,@Msg = 'Agent ID cannot  be null'    
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
    
   UPDATE tbl_agent_detail    
   SET agent_status = 'Y'    
   WHERE agent_id = @agent_id;    
    
   SELECT '0' STATUS    
    ,'Agent deleted successfully' Message    
    ,NULL id;    
  END;    
    
  IF (@flag = 'l')    
  BEGIN    
   IF (    
     @agent_id IS NULL    
     OR @locked_reason IS NULL    
     )    
   BEGIN    
    EXEC sproc_error_handler @error_code = '1'    
     ,@Msg = 'Agent ID or Lock Reason is required'    
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
    
   UPDATE tbl_agent_detail    
   SET lock_status = 'Y'    
    ,locked_by = @action_user    
    ,locked_UTC_date = GETUTCDATE()    
    ,locked_reason = @locked_reason    
   WHERE agent_id = @agent_id    
    AND agent_status != 'y';    
    
   EXEC sproc_error_handler @error_code = '0'    
    ,@Msg = 'Agent locked successfully'    
    ,@id = @agent_id;    
  END;    
    
  IF (@flag = 'ul')    
  BEGIN    
   IF (@agent_code IS NULL)    
   BEGIN    
    EXEC sproc_error_handler @error_code = '1'    
     ,@Msg = 'Enter required field before unlocking agent'    
     ,@id = @agent_id;    
    
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
    
   UPDATE tbl_agent_detail    
   SET lock_status = NULL    
    ,locked_by = NULL    
    ,locked_UTC_date = NULL    
    ,locked_reason = NULL    
   --,[UpdatedBy]=@UpdatedBy                              
   --,[UpdatedDateBS]=@UpdatedDateBS                              
   --,[UpdatedDateLocal]=@UpdatedDateLocal                              
   --,[UpdatedDateUTC]=@UpdatedDateUTC                              
   --,[UpdatedIp]=@UpdatedIp                              
   WHERE agent_id = @agent_id    
    AND agent_status != 'Y'    
    AND lock_status = 'Y';    
    
   SELECT '0' AS STATUS    
    ,'Agent Locked successfully' AS Message    
    ,@agent_id AS Id;    
  END;    
    
  IF (@Flag = 's')    
  BEGIN    
   SET @currentdate = dbo.func_get_nepali_date(DEFAULT);    
   SET @sql = 'SELECT ' + 'agent_id' + ',parent_id' + ',agent_code' + ',agent_type' + ',agent_operation_type' + ',agent_name' + ',kyc_status' + ',first_name' + ',middle_name' + ',last_name' + ',available_balance' + ',format(date_of_birth_eng,''yyyy-MM-dd 
 
'')date_of_birth_eng' + ',date_of_birth_nep' + ',gender' + ',agent_phone_no' + ',agent_mobile_no' + ',agent_email_address' + ',occupation' + ',marital_status' + ',spouse_name' + ',father_name' + ',mother_name' + ',grand_father_name' + ',agent_nationality'
  
 + ',agent_country' + ',permanent_province' + ',permanent_district' + ',permanent_localbody' + ',permanent_wardno' + ',permanent_address' + ',temporary_province' + ',temporary_district' + ',temporary_localbody' + ',temporary_wardno' + ',temporary_address'
  
 + ',latitude' + ',longitude' + ',web_url' + ',agent_registration_no' + ',agent_pan_no' + ',agent_credit_limit' + ',agent_support_staff' + ',format(agent_contract_local_date,''yyyy-MM-dd'')agent_contract_local_date' + ',agent_contract_nepali_date' +  
 ',agent_logo_img' + ',agent_document_img_front' + ',agent_document_img_back' + ',contact_person_name' + ',agent_country_code' + ',contact_person_mobile_no' +     
    ',contact_person_id_type' + ',contact_person_id_no' + ',format(contact_id_issue_local_date,''yyyy-MM-dd'')contact_id_issue_local_date' + ',contact_id_issued_bs_date' + ',contact_id_issued_district' + ',agent_commission_id' + ',agent_status'   
 + ',is_auto_commission' + ',agent_qr_image' + ',fund_load_reward' + ',txn_reward_point' + ',admin_remarks' + ',full_name' + ',is_sameAs_per_add' + ',individual_image' + ',referal_id' + ',agent_referal_id' + ',lock_status' + ',locked_reason' + ',locked_UTC_date'   
 + ',locked_by' + ',created_UTC_date' + ',contact_person_address as contact_id_address,created_local_date' + ',created_nepali_date' + ',created_by' + ',created_ip' + ',created_platform' + ',updated_by' + ',updated_UTC_date' + ',updated_local_date' + ',updated_nepali_date' + ',updated_ip' +   
 ',agent_address' + ',contact_person_address' + + ' FROM tbl_agent_detail WHERE 1=1 '    
    
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
    
   IF @kyc_status IS NOT NULL    
   BEGIN    
    SET @sql = @sql + ' AND Kyc_Status = ''' + CAST(@kyc_status AS VARCHAR) + '''';    
   END;    
    
   IF @parent_Id IS NOT NULL    
   BEGIN    
    SET @sql = @sql + ' AND parent_id = ''' + CAST(@parent_Id AS VARCHAR) + '''';    
   END;    
    
   IF @status IS NOT NULL    
   BEGIN    
    SET @sql = @sql + ' AND agent_status = ''' + @Status + '''';    
   END;    
    
   IF @mobile_no IS NOT NULL --or @email is not null or @full_name is not null                                
   BEGIN    
    SET @sql = @sql + ' AND agent_Mobile_No LIKE  ''%' + @mobile_no + '%'' or agent_email_address LIKE ''%' + @mobile_no + '%'' or Name LIKE ''%' + @first_name + '%''';    
   END;    
    
   IF @end_date IS NULL    
    SET @end_date = @currentdate;    
    
   IF @from_date IS NOT NULL    
    AND @end_date IS NOT NULL    
    SET @sql = @sql + ' AND Created_Local_Date BETWEEN ''' + format(@from_date, 'yyyy-MM-dd') + ' 00:00:01'' and ''' + format(@end_date, 'yyyy-MM-dd') + ' 23:59:59.999''';    
    
   PRINT (@sql);    
    
   EXEC (@sql);    
  END;    
    
  IF @flag = 'ddl' --get all active distributors dropdownlist (used in balance topup-refund)                       
  BEGIN    
   IF @agent_type IS NULL    
   BEGIN    
    SELECT agent_id    
     ,first_name    
     ,last_name    
     ,middle_name    
     ,created_local_date AS DISTRIBUTOR_CREATED_DATE    
     ,created_by CREATED_BY    
     ,updated_local_date AS DISTRIBUTOR_UPDATED_DATE    
     ,updated_by UPDATE_BY    
    FROM tbl_agent_detail    
    WHERE agent_id IS NULL;    
   END;    
    
   SELECT agent_id    
    ,first_name    
    ,middle_name    
    ,last_name    
    ,created_UTC_date AS DISTRIBUTOR_CREATED_DATE    
    ,created_by CREATED_BY    
    ,updated_local_date AS DISTRIBUTOR_UPDATED_DATE    
    ,updated_by UPDATE_BY    
   FROM tbl_agent_detail    
   WHERE ISNULL(agent_status, 'Y') = 'Y'    
    AND ISNULL(agent_status, 'N') = 'N'    
    AND agent_type = @agent_type;    
  END;    
    
  IF @Flag = 'si'    
  BEGIN    
   SET @currentdate = dbo.func_get_nepali_date(DEFAULT);    
   SET @sql = 'SELECT * FROM tbl_agent_detail WHERE 1=1 ';    
    
   IF @agent_id IS NOT NULL    
   BEGIN    
    SET @sql = @sql + ' AND Agent_Id = ''' + CAST(@agent_id AS VARCHAR) + '''';    
   END;    
    
   IF (@action_user != 'admin')    
    AND NOT EXISTS (    
     SELECT 'x'    
     FROM tbl_agent_detail ad    
     JOIN tbl_user_detail ud ON ad.agent_id = ud.agent_id    
     WHERE ud.user_name = @action_user    
      AND ISNULL(ud.is_primary, 'n') = 'y'    
     )    
   BEGIN    
    SET @sql = @sql + ' AND Created_By = ''' + @action_user + '''';    
   END;    
   ELSE IF @action_user IS NOT NULL    
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
    SET @sql = @sql + ' AND usr_type = ''' + @agent_type + '''';    
   END;    
    
   IF @kyc_status IS NOT NULL    
   BEGIN    
    SET @sql = @sql + ' AND Kyc_Status = ''' + CAST(@kyc_status AS VARCHAR) + '''';    
   END;    
    
   IF @parent_Id IS NOT NULL    
   BEGIN    
    SET @sql = @sql + ' AND parent_id = ''' + CAST(@parent_Id AS VARCHAR) + '''';    
   END;    
    
   IF @grand_parent_id IS NOT NULL    
   BEGIN    
    SET @sql = @sql + ' AND grand_parent_id = ''' + CAST(@grand_parent_id AS VARCHAR) + '''';    
   END;    
    
   IF @status IS NOT NULL    
   BEGIN    
    SET @sql = @sql + ' AND Status = ''' + @Status + '''';    
   END;    
    
   IF @mobile_no IS NOT NULL --or @email is not null or @full_name is not null                                
   BEGIN    
    SET @sql = @sql + ' AND MobileNo LIKE  ''%' + @mobile_no + '%'' or EMAIL LIKE ''%' + @mobile_no + '%'' or Name LIKE ''%' + @first_name + '%''';    
   END;    
    
   IF @end_date IS NULL    
    SET @end_date = @currentdate;    
    
   IF @from_date IS NOT NULL    
    AND @end_date IS NOT NULL    
    SET @sql = @sql + ' AND Created_Local_Date BETWEEN ''' + format(@from_date, 'yyyy-MM-dd') + ' 00:00:01'' and ''' + format(@end_date, 'yyyy-MM-dd') + ' 23:59:59.999''';    
    
   PRINT @sql;    
    
   EXEC (@sql);    
  END;    
    
  IF @Flag = 'wu' -- wallet user list                
  BEGIN    
   SET @currentdate = dbo.func_get_nepali_date(DEFAULT);    
   SET @sql = 'SELECT * FROM tbl_agent_detail WHERE 1=1 ';    
   SET @sql = @sql + ' AND Agent_Id = ''' + CAST(@agent_id AS VARCHAR) + '''';    
    
   IF (@agent_type IS NOT NULL)    
   BEGIN    
    SET @sql = @sql + ' AND Agent_Type = ''' + @agent_type + '''';    
   END;    
    
   IF @parent_Id IS NOT NULL    
   BEGIN    
    SET @sql = @sql + ' AND parent_id = ''' + CAST(@parent_Id AS VARCHAR) + '''';    
   END;    
    
   IF @grand_parent_id IS NOT NULL    
   BEGIN    
    SET @sql = @sql + ' AND grand_parent_id = ''' + CAST(@grand_parent_id AS VARCHAR) + '''';    
   END;    
    
   PRINT @sql;    
    
   EXEC (@sql);    
  END;    
    
  IF @flag = 'dRole' -- assign distributor role        
  BEGIN    
   UPDATE tbl_user_detail    
   SET role_id = @role_id    
    ,is_primary = @is_primary    
   WHERE user_id = @user_id    
    AND agent_id = @agent_id    
  END    
    
  IF @flag = 'gDRole'    
  BEGIN    
   SELECT '0' code    
    ,'success' message    
    ,is_primary    
    ,role_id    
    ,agent_id    
    ,user_id    
   FROM tbl_user_detail    
   WHERE user_id = @user_id    
    AND agent_id = @agent_id    
  END    
 END;    
END TRY    
    
BEGIN CATCH    
 IF @@trancount > 0    
  ROLLBACK TRANSACTION;    
    
 SELECT 1 CODE    
  ,ERROR_MESSAGE() msg    
  ,NULL id;    
END CATCH; 


GO
