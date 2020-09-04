  
  
  
ALTER procedure [dbo].[sproc_kyc_manage] @flag              char(5)        = null,   
                                      @mode              char(5)        = null,   
                                      @user_id            int            = null,   
                                      @agent_id           int            = null,   
                                      @action_user        varchar(100)   = null,   
                                      @action_ip_address     varchar(20)    = null,   
                                      @created_platform   varchar(20)    = null,   
                                      @agent_type         varchar(200)   = null,   
                                      @nationality       varchar(200)   = 'Nepali',   
                                      @first_name         varchar(200)   = null,   
                                      @middle_name        varchar(200)   = null,   
                                      @last_name          varchar(200)   = null,   
                                      @full_name          varchar(200)   = null,   
                                      @dob_eng            date           = null,   
                                      @dob_nep            varchar(200)   = null,   
                                      @gender            varchar(200)   = null,   
                                      @occupation        varchar(200)   = null,   
                                      @marital_status     varchar(200)   = null,   
                                      @spouse_name        varchar(200)   = null,   
                                      @father_name        varchar(200)   = null,   
                                      @mother_name        varchar(200)   = null,   
                                      @grand_father_name   varchar(200)   = null,   
                                      @email_address      varchar(50)    = null,   
                                      @province          varchar(200)   = null,   
                                      @district          varchar(200)   = null,   
                                      @local_body         varchar(200)   = null,   
                                      @ward_no            int            = null,   
                                      @address           varchar(200)   = null,   
                                      @temp_province      varchar(200)   = null,   
                                      @temp_district      varchar(200)   = null,   
                                      @temp_local_body     varchar(200)   = null,   
                                      @temp_ward_no        int            = null,   
                                      @temp_address       varchar(200)   = null,   
                                      @contact_id_type           varchar(200)   = null,   
                                      @contact_id_no             varchar(200)   = null,   
                                      @contact_id_issued_date      date           = null,   
                                      @contact_id_issued_date_nep   varchar(10)    = null,   
                                      @contact_id_issued_district  varchar(200)   = null,   
                                      @logo_img      varchar(1000)  = null,   
           @ppPhoto_img      varchar(1000)  = null,  
                                      @id_front_img     varchar(1000)  = null,   
                                      @id_back_photo_img      varchar(1000)  = null,   
                                      @mobile_no          varchar(10)    = null,   
                                      @country           varchar(100)   = null,   
                                      @password          varchar(500)   = null,   
                                      @device_id          varchar(30)    = null,   
                                      @m_pin              varchar(10)    = null,   
                                      @latitude          varchar(200)   = null,   
                                      @longitude         varchar(200)   = null,   
                                      @phone_no           varchar(200)   = null,   
                                      @pan_no             varchar(200)   = null,   
                                      @web_url            varchar(200)   = null,   
                                      @registration_no    varchar(200)   = null,   
                                      @credit_limit       decimal(18, 2)  = null,   
                                      @support_staff      varchar(200)   = null,   
                                      @contract_date      datetime       = null,   
                                      @contact_name             varchar(200)   = null,   
                                      @parent_id          int            = null,   
                                      @grand_parent_id     int            = null,   
                                      @id_type_id          varchar(200)   = null,   
                                      @id_type            varchar(200)   = null,   
                                      @id_number          varchar(200)   = null,   
                                      @id_issuedate_local  datetime       = null,   
                                      @id_expiry_date_local datetime       = null,   
                                      @id_issue_by         varchar(200)   = null,   
                                      @id_issue_district   varchar(200)   = null,   
                                      @file_path          varchar(1000)  = null,   
                                      @file_extension     varchar(200)   = null,   
                                      @is_deleted         varchar(200)   = null,   
                                      @remarks           varchar(200)   = null,   
                                      @registration_type  varchar(200)   = null  
as  
  
 --flag   
 --  i: insert KYC Details by Admin  
 --    list : display list of KYC filled  
 --    v : view detail of KYC filled  
 --    u : update KYC/ by admin  
 --    a : approve KYC  
 --    r : reject KYC  
      
    begin  
        set nocount on;  
    
      --flag i --  register customer  
        declare @id int, @comm_cat_id int, @country_code char(3);  
        if @flag = 'i'  
            begin  
                if exists  
                (  
                    select 'x'  
                    from tbl_agent_detail  
                    where agent_mobile_no = @mobile_no  
                          or agent_email_address = @email_address  
                )  
                    begin  
                        select '1' code,   
                               'mobile no or email address already exists.' message,   
                               null id;  
                        return;  
                end;      
            
                ----- insert into agentdetail table  
                insert into dbo.tbl_agent_detail  
                (   
                 first_name,   
     middle_name,  
     last_name,  
     date_of_birth_eng,  
     date_of_birth_nep,  
    [gender]       
    ,[occupation]     
    ,[marital_status]     
    ,[spouse_name]     
    ,[father_name]    
    ,[mother_name]     
    ,[grand_father_name]  
                 ,agent_country,   
                 permanent_province,   
                 permanent_district,   
                 permanent_localbody,   
                  permanent_wardno,   
                 permanent_address,   
                 [temporary_province]    
    ,[temporary_district]  
    ,[temporary_localbody]  
    ,[temporary_wardno]  
    ,[temporary_address]  
                 ,agent_phone_no,   
                 agent_email_address,    
                 agent_mobile_no,   
                 created_UTC_date,   
                 created_local_date,   
                 created_nepali_date,   
                 created_by,   
                 created_ip,   
                 created_platform,   
                 kyc_status  
  
            )  
                values  
                (  
                 @first_name,  
     @middle_name,  
     @last_name,  
     @dob_eng,  
     dbo.func_get_nepali_date(@dob_eng),  
     @gender,  
     @occupation,  
     @marital_status,  
     @spouse_name,  
     @father_name,  
     @mother_name,  
     @grand_father_name,  
                 @country,   
                 @province,   
                 @district,   
                 @local_body,   
                 @ward_no,   
                 @address,  
     @temp_province,  
     @temp_district,  
     @temp_local_body,  
     @temp_ward_no,  
     @temp_address,  
                 @phone_no,   
                 @email_address,    
                 @mobile_no,   
                 getutcdate(),   
                 getdate(),   
                 [dbo].func_get_nepali_date(default),   
                 @action_user,   
                 @action_ip_address,   
                 @created_platform,   
                 'verified'  
                );  
                ---------------------------  
                select @agent_id = scope_identity();  
  
    insert into tbl_kyc_documents  
  (  
   [agent_id],  
   [Identification_type],  
   [Identification_NO],  
   [Identification_issued_date],  
   [Identification_expiry_date],  
   [Identification_issued_place],  
   [Identification_photo_Logo],  
   [Id_document_front],  
   [Id_document_back],  
   [created_by] ,  
   [created_UTC_date],  
   [created_local_date],  
   [created_nepali_date]  
  )  
  values  
  (  
   @agent_id,  
   @id_type,  
   @id_number,  
   @id_issuedate_local,  
   @id_expiry_date_local,  
   @id_issue_district,  
   @ppPhoto_img,  
   @id_front_img,  
   @id_back_photo_img,  
   @action_user,  
   getUTCDate(),  
   GetDate(),  
   dbo.func_get_nepali_date(default)  
  )  
  
                -- insert into kyc detail table  
                insert into dbo.tbl_kyc_approval_detail  
                (agent_id,   
                 created_UTC_date,   
                 created_local_date,   
                 created_nepali_date,   
                 created_by,   
                 remarks,   
                 kyc_approval_id   
                
                )  
                values  
                (@agent_id,   
                 getutcdate(),   
                 getdate(),   
                 [dbo].func_get_nepali_date(default),   
                 @action_user,   
                 @remarks,   
                 'verified'   
  
            
                );  
                select '0' code,   
                       'inserted successfully.' message,   
                       null id;  
                return;  
        end;  
  
 If @flag = 'u'  -- update KYC for Agent By Admin  
 Begin  
    
  
  UPDATE [dbo].[tbl_agent_detail]  
   SET   
      [first_name]    = ISNULL(@first_name,[first_name])  
      ,[middle_name]   = ISNULL(@middle_name,[middle_name])  
      ,[last_name]    = ISNULL(@last_name,[last_name])  
      ,[date_of_birth_eng]  = ISNULL(@dob_eng,[date_of_birth_eng])  
      ,[date_of_birth_nep]  = ISNULL(dbo.func_get_nepali_date(@dob_eng),[date_of_birth_nep])  
      ,[gender]     = ISNULL(@gender,[gender])  
      ,[occupation]    = ISNULL(@occupation,[occupation])  
      ,[marital_status]   = ISNULL(@marital_status,[marital_status])  
      ,[spouse_name]   = ISNULL(@spouse_name,[spouse_name])  
      ,[father_name]   = ISNULL(@father_name,[father_name])  
      ,[mother_name]   = ISNULL(@mother_name,[mother_name])  
      ,[grand_father_name]  = ISNULL(@grand_father_name,[grand_father_name])  
      ,[agent_nationality]  = ISNULL(@nationality,[agent_nationality])  
      ,[agent_country]   = ISNULL(@country,[agent_country])  
      ,[permanent_province]  = ISNULL(@province,[permanent_province])  
      ,[permanent_district]  = ISNULL(@district,[permanent_district])  
      ,[permanent_localbody] = ISNULL(@local_body,[permanent_localbody])  
      ,[permanent_wardno]  = ISNULL(@ward_no,[permanent_wardno])  
      ,[permanent_address]  = ISNULL(@address,[permanent_address])  
      ,[temporary_province]  = ISNULL(@temp_province,[temporary_province])  
      ,[temporary_district]  = ISNULL(@temp_district,[temporary_district])  
      ,[temporary_localbody] = ISNULL(@temp_local_body,[temporary_localbody])  
      ,[temporary_wardno]  = ISNULL(@temp_ward_no,[temporary_wardno])  
      ,[temporary_address]  = ISNULL(@temp_address,[temporary_address])  
      ,[agent_phone_no]   = ISNULL(@phone_no,[agent_phone_no])  
      ,[agent_email_address] = ISNULL(@email_address,[agent_email_address])  
      ,[updated_by]    = ISNULL(@action_user,[updated_by])  
      ,[updated_UTC_date]  = ISNULL(GETUTCDATE(),[updated_UTC_date])  
      ,[updated_local_date]  = ISNULL(GETDATE(),[updated_local_date])  
      ,[updated_nepali_date] = ISNULL(dbo.func_get_nepali_date(DEFAULT),[updated_nepali_date])  
      ,[updated_ip]    = ISNULL(@action_ip_address,[updated_ip])  
      ,[agent_mobile_no]  = ISNULL(@mobile_no,[agent_mobile_no])  
 WHERE agent_id = @agent_id  
     
     
  insert into tbl_kyc_documents  
  (  
   [agent_id],  
   [Identification_type],  
   [Identification_NO],  
   [Identification_issued_date],  
   [Identification_expiry_date],  
   [Identification_issued_place],  
   [Identification_photo_Logo],  
   [Id_document_front],  
   [Id_document_back],  
   [created_by] ,  
   [created_UTC_date],  
   [created_local_date],  
   [created_nepali_date]  
  )  
  values  
  (  
   @agent_id,  
   @id_type,  
   @id_number,  
   @id_issuedate_local,  
   @id_expiry_date_local,  
   @id_issue_district,  
   @ppPhoto_img,  
   @id_front_img,  
   @id_back_photo_img,  
   @action_user,  
   getUTCDate(),  
   GetDate(),  
   dbo.func_get_nepali_date(default)  
  )  
  
  Select '0' Code, 'KYC Update Successfull' Message, null id  
  return  
 End  
  
 If @flag = 'list'  
 Begin  
  select agent_id as [Agent Id], agent_mobile_no as Mobile, agent_email_address as Email, created_local_date as [Submitted Date] from tbl_agent_detail where kyc_status = 'F'  
 End  
  
 If @flag = 'v'  
 Begin  
  select   
  first_name,  
  middle_name,  
  last_name,  
  date_of_birth_eng,  
  date_of_birth_nep,  
  gender,  
  occupation,  
  marital_status,  
  spouse_name,  
  father_name,  
  mother_name,  
  grand_father_name,  
  agent_nationality,  
  agent_country,  
  permanent_province,  
  permanent_district,  
  permanent_localbody,  
  permanent_wardno,  
  permanent_address,  
  temporary_province,  
  temporary_district,  
  temporary_localbody,  
  temporary_wardno,  
  temporary_address,  
  agent_phone_no,  
  agent_email_address,  
  agent_mobile_no,  
  admin_remarks,  
  kd.Identification_type,  
  kd.Identification_type,  
  kd.Identification_NO,  
  kd.Identification_issued_date,  
  kd.Identification_expiry_date,  
  kd.Identification_issued_place,  
  kd.Identification_photo_Logo,  
  kd.Id_document_front,  
  kd.Id_document_back,  
  * from tbl_agent_detail ad  
  join tbl_kyc_documents kd on kd.agent_id = ad.agent_id  
  where kyc_status = 'F' AND Kd.agent_id = @agent_id 
 End  
  
 If @flag = 'r'  
 Begin  
  update tbl_agent_detail set kyc_status = 'R', admin_remarks = @remarks where agent_id = @agent_id  
 End  
  
 if @flag = 'a'  
 BEgin  
  update tbl_agent_detail set kyc_status = 'A', admin_remarks = 'Approved' where agent_id = @agent_id  
 End  
End  