USE [WePayNepal]
GO
/****** Object:  Trigger [TRG_Update_tbl_agent_detail]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_Update_tbl_agent_detail]
GO
/****** Object:  Trigger [TRG_INSERT_tbl_agent_detail]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_INSERT_tbl_agent_detail]
GO
/****** Object:  Trigger [TRG_Delete_tbl_agent_detail]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_Delete_tbl_agent_detail]
GO

/****** Object:  Trigger [dbo].[TRG_Delete_tbl_agent_detail]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TRG_Delete_tbl_agent_detail] ON [dbo].[tbl_agent_detail]
FOR DELETE
AS
     BEGIN
         INSERT INTO tbl_agent_detail_audit
         (agent_id,
parent_id,
agent_code,
agent_type,
agent_operation_type,
agent_name,
kyc_status,
first_name,
middle_name,
last_name,
available_balance,
date_of_birth_eng,
date_of_birth_nep,
gender,
agent_phone_no,
agent_mobile_no,
agent_email_address,
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
latitude,
longitude,
web_url,
agent_registration_no,
agent_pan_no,
agent_credit_limit,
agent_support_staff,
agent_contract_local_date,
agent_contract_nepali_date,
agent_logo_img,
agent_document_img_front,
agent_document_img_back,
contact_person_name,
agent_country_code,
contact_person_mobile_no,
contact_person_id_type,
contact_person_id_no,
contact_id_issue_local_date,
contact_id_issued_bs_date,
contact_id_issued_district,
agent_commission_id,
agent_status,
is_auto_commission,
agent_qr_image,
fund_load_reward,
txn_reward_point,
admin_remarks,
full_name,
is_sameAs_per_add,
individual_image,
referal_id,
agent_referal_id,
lock_status,
locked_reason,
locked_UTC_date,
locked_by,
created_UTC_date,
created_local_date,
created_nepali_date,
created_by,
created_ip,
created_platform,
updated_by,
updated_UTC_date,
updated_local_date,
updated_nepali_date,
updated_ip,
agent_address,
contact_Person_address,
commission_earned,
trigger_log_user,
trigger_action,
trigger_action_local_Date,
trigger_action_UTC_Date,
trigger_action_nepali_date
         )
                SELECT agent_id,
parent_id,
agent_code,
agent_type,
agent_operation_type,
agent_name,
kyc_status,
first_name,
middle_name,
last_name,
available_balance,
date_of_birth_eng,
date_of_birth_nep,
gender,
agent_phone_no,
agent_mobile_no,
agent_email_address,
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
latitude,
longitude,
web_url,
agent_registration_no,
agent_pan_no,
agent_credit_limit,
agent_support_staff,
agent_contract_local_date,
agent_contract_nepali_date,
agent_logo_img,
agent_document_img_front,
agent_document_img_back,
contact_person_name,
agent_country_code,
contact_person_mobile_no,
contact_person_id_type,
contact_person_id_no,
contact_id_issue_local_date,
contact_id_issued_bs_date,
contact_id_issued_district,
agent_commission_id,
agent_status,
is_auto_commission,
agent_qr_image,
fund_load_reward,
txn_reward_point,
admin_remarks,
full_name,
is_sameAs_per_add,
individual_image,
referal_id,
agent_referal_id,
lock_status,
locked_reason,
locked_UTC_date,
locked_by,
created_UTC_date,
created_local_date,
created_nepali_date,
created_by,
created_ip,
created_platform,
updated_by,
updated_UTC_date,
updated_local_date,
updated_nepali_date,
updated_ip,
agent_address,
contact_Person_address,
commission_earned,
system_user,
'Delete',
GETDATE(),
GETUTCDATE(),
dbo.func_get_nepali_date(DEFAULT)
                FROM DELETED;
     END;

GO
/****** Object:  Trigger [dbo].[TRG_INSERT_tbl_agent_detail]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TRG_INSERT_tbl_agent_detail] ON [dbo].[tbl_agent_detail]
FOR INSERT
AS
     BEGIN
         INSERT INTO tbl_agent_detail_audit
         (agent_id, 
          parent_id, 
          agent_code, 
          agent_type, 
          agent_operation_type, 
          agent_name, 
          kyc_status, 
          first_name, 
          middle_name, 
          last_name, 
          available_balance, 
          date_of_birth_eng, 
          date_of_birth_nep, 
          gender, 
          agent_phone_no, 
          agent_mobile_no, 
          agent_email_address, 
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
          latitude, 
          longitude, 
          web_url, 
          agent_registration_no, 
          agent_pan_no, 
          agent_credit_limit, 
          agent_support_staff, 
          agent_contract_local_date, 
          agent_contract_nepali_date, 
          agent_logo_img, 
          agent_document_img_front, 
          agent_document_img_back, 
          contact_person_name, 
          agent_country_code, 
          contact_person_mobile_no, 
          contact_person_id_type, 
          contact_person_id_no, 
          contact_id_issue_local_date, 
          contact_id_issued_bs_date, 
          contact_id_issued_district, 
          agent_commission_id, 
          agent_status, 
          is_auto_commission, 
          agent_qr_image, 
          fund_load_reward, 
          txn_reward_point, 
          admin_remarks, 
          full_name, 
          is_sameAs_per_add, 
          individual_image, 
          referal_id, 
          agent_referal_id, 
          lock_status, 
          locked_reason, 
          locked_UTC_date, 
          locked_by, 
          created_UTC_date, 
          created_local_date, 
          created_nepali_date, 
          created_by, 
          created_ip, 
          created_platform, 
          updated_by, 
          updated_UTC_date, 
          updated_local_date, 
          updated_nepali_date, 
          updated_ip, 
          agent_address, 
         contact_Person_address, 
		 commission_earned,
          trigger_log_user, 
          trigger_action, 
          trigger_action_local_Date, 
          trigger_action_UTC_Date, 
          trigger_action_nepali_date
         )
                SELECT agent_id, 
                       parent_id, 
                       agent_code, 
                       agent_type, 
                       agent_operation_type, 
                       agent_name, 
                       kyc_status, 
                       first_name, 
                       middle_name, 
                       last_name, 
                       available_balance, 
                       date_of_birth_eng, 
                       date_of_birth_nep, 
                       gender, 
                       agent_phone_no, 
                       agent_mobile_no, 
                       agent_email_address, 
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
                       latitude, 
                       longitude, 
                       web_url, 
                       agent_registration_no, 
                       agent_pan_no, 
                       agent_credit_limit, 
                       agent_support_staff, 
                       agent_contract_local_date, 
                       agent_contract_nepali_date, 
                       agent_logo_img, 
                       agent_document_img_front, 
                       agent_document_img_back, 
                       contact_person_name, 
                       agent_country_code, 
                       contact_person_mobile_no, 
                       contact_person_id_type, 
                       contact_person_id_no, 
                       contact_id_issue_local_date,
					   contact_id_issued_bs_date, 
                       contact_id_issued_district, 
                       agent_commission_id, 
                       agent_status, 
                       is_auto_commission, 
                       agent_qr_image, 
                       fund_load_reward, 
                       txn_reward_point, 
                       admin_remarks, 
                       full_name, 
                       is_sameAs_per_add, 
                       individual_image, 
                       referal_id, 
                       agent_referal_id, 
                       lock_status, 
                       locked_reason, 
                       locked_UTC_date, 
                       locked_by, 
                       created_UTC_date, 
                       created_local_date, 
                       created_nepali_date, 
                       created_by, 
                       created_ip, 
                       created_platform, 
                       updated_by, 
                       updated_UTC_date, 
                       updated_local_date, 
                       updated_nepali_date, 
                       updated_ip, 
                      agent_address, 
                       contact_Person_address,
				   commission_earned,
                       system_user, 
                       'Insert', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM INSERTED;
     END;

GO
/****** Object:  Trigger [dbo].[TRG_Update_tbl_agent_detail]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TRG_Update_tbl_agent_detail] ON [dbo].[tbl_agent_detail]
FOR UPDATE
AS
     BEGIN
         INSERT INTO tbl_agent_detail_audit
         (agent_id, 
          parent_id, 
          agent_code, 
          agent_type, 
          agent_operation_type, 
          agent_name, 
          kyc_status, 
          first_name, 
          middle_name, 
          last_name, 
          available_balance, 
          date_of_birth_eng, 
          date_of_birth_nep, 
          gender, 
          agent_phone_no, 
          agent_mobile_no, 
          agent_email_address, 
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
          latitude, 
          longitude, 
          web_url, 
          agent_registration_no, 
          agent_pan_no, 
          agent_credit_limit, 
          agent_support_staff, 
          agent_contract_local_date, 
          agent_contract_nepali_date, 
          agent_logo_img, 
          agent_document_img_front, 
          agent_document_img_back, 
          contact_person_name, 
          agent_country_code, 
          contact_person_mobile_no, 
          contact_person_id_type, 
          contact_person_id_no, 
          contact_id_issue_local_date, 
          contact_id_issued_bs_date, 
          contact_id_issued_district, 
          agent_commission_id, 
          agent_status, 
          is_auto_commission, 
          agent_qr_image, 
          fund_load_reward, 
          txn_reward_point, 
          admin_remarks, 
          full_name, 
          is_sameAs_per_add, 
          individual_image, 
          referal_id, 
          agent_referal_id, 
          lock_status, 
          locked_reason, 
          locked_UTC_date, 
          locked_by, 
          created_UTC_date, 
          created_local_date, 
          created_nepali_date, 
          created_by, 
          created_ip, 
          created_platform, 
          updated_by, 
          updated_UTC_date, 
          updated_local_date, 
          updated_nepali_date, 
          updated_ip, 
          agent_address, 
          contact_Person_address,
		  commission_earned,
          trigger_log_user, 
          trigger_action, 
          trigger_action_local_Date, 
          trigger_action_UTC_Date, 
          trigger_action_nepali_date
         )
                SELECT agent_id, 
                       parent_id, 
                       agent_code, 
                       agent_type, 
                       agent_operation_type, 
                       agent_name, 
                       kyc_status, 
                       first_name, 
                       middle_name, 
                       last_name, 
                       available_balance, 
                       date_of_birth_eng, 
                       date_of_birth_nep, 
                       gender, 
                       agent_phone_no, 
                       agent_mobile_no, 
                       agent_email_address, 
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
                       latitude, 
                       longitude, 
                       web_url, 
                       agent_registration_no, 
                       agent_pan_no, 
                       agent_credit_limit, 
                       agent_support_staff, 
                       agent_contract_local_date, 
                       agent_contract_nepali_date, 
                       agent_logo_img, 
                       agent_document_img_front, 
                       agent_document_img_back, 
                       contact_person_name, 
                       agent_country_code, 
                       contact_person_mobile_no, 
                       contact_person_id_type, 
                       contact_person_id_no, 
                       contact_id_issue_local_date,
					   contact_id_issued_bs_date, 
                       contact_id_issued_district, 
                       agent_commission_id, 
                       agent_status, 
                       is_auto_commission, 
                       agent_qr_image, 
                       fund_load_reward, 
                       txn_reward_point, 
                       admin_remarks, 
                       full_name, 
                       is_sameAs_per_add, 
                       individual_image, 
                       referal_id, 
                       agent_referal_id, 
                       lock_status, 
                       locked_reason, 
                       locked_UTC_date, 
                       locked_by, 
                       created_UTC_date, 
                       created_local_date, 
                       created_nepali_date, 
                       created_by, 
                       created_ip, 
                       created_platform, 
                       updated_by, 
                       updated_UTC_date, 
                       updated_local_date, 
                       updated_nepali_date, 
                       updated_ip, 
                       agent_address, 
                       contact_Person_address, 
					   commission_earned,
                       system_user, 
                       'Update', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM INSERTED;
     END;

GO
