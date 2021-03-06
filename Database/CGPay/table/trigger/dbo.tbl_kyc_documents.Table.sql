USE [WePayNepal]
GO
/****** Object:  Trigger [TRG_UPDATE_tbl_kyc_documents]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_UPDATE_tbl_kyc_documents]
GO
/****** Object:  Trigger [TRG_INSERT_tbl_kyc_documents]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_INSERT_tbl_kyc_documents]
GO
/****** Object:  Trigger [TRG_DELETE_tbl_kyc_documents]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_DELETE_tbl_kyc_documents]
GO


/****** Object:  Trigger [dbo].[TRG_DELETE_tbl_kyc_documents]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TRG_DELETE_tbl_kyc_documents] ON [dbo].[tbl_kyc_documents]
FOR DELETE
AS
     BEGIN
         INSERT INTO tbl_kyc_documents_audit
         (kycDoc_id,
agent_id,
user_name,
Identification_type,
Identification_NO,
Identification_issued_date,
Identification_issued_date_nepali,
Identification_expiry_date,
Identification_expiry_date_nepali,
Identification_issued_place,
Identification_photo_Logo,
Id_document_front,
Id_document_back,
KYC_Verified,
created_by,
created_UTC_date,
created_local_date,
created_nepali_date,
updated_by,
updated_UTC_date,
updated_local_date,
updated_nepali_date,
encrypted_identification_photo_log,
encrypted_id_document_front,
encrypted_id_document_back,
encrypted_identification_photo_logs,
trigger_log_user,
trigger_action,
trigger_action_local_Date,
trigger_action_UTC_Date,
trigger_action_nepali_date
         )
                SELECT kycDoc_id,
agent_id,
user_name,
Identification_type,
Identification_NO,
Identification_issued_date,
Identification_issued_date_nepali,
Identification_expiry_date,
Identification_expiry_date_nepali,
Identification_issued_place,
Identification_photo_Logo,
Id_document_front,
Id_document_back,
KYC_Verified,
created_by,
created_UTC_date,
created_local_date,
created_nepali_date,
updated_by,
updated_UTC_date,
updated_local_date,
updated_nepali_date,
encrypted_identification_photo_log,
encrypted_id_document_front,
encrypted_id_document_back,
encrypted_identification_photo_logs,

                       system_user, 
                       'Delete', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Deleted;
     END;

GO
/****** Object:  Trigger [dbo].[TRG_INSERT_tbl_kyc_documents]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TRG_INSERT_tbl_kyc_documents] ON [dbo].[tbl_kyc_documents]
FOR INSERT
AS
     BEGIN
         INSERT INTO tbl_kyc_documents_audit
         (kycDoc_id,
agent_id,
user_name,
Identification_type,
Identification_NO,
Identification_issued_date,
Identification_issued_date_nepali,
Identification_expiry_date,
Identification_expiry_date_nepali,
Identification_issued_place,
Identification_photo_Logo,
Id_document_front,
Id_document_back,
KYC_Verified,
created_by,
created_UTC_date,
created_local_date,
created_nepali_date,
updated_by,
updated_UTC_date,
updated_local_date,
updated_nepali_date,
encrypted_identification_photo_log,
encrypted_id_document_front,
encrypted_id_document_back,
encrypted_identification_photo_logs,
trigger_log_user,
trigger_action,
trigger_action_local_Date,
trigger_action_UTC_Date,
trigger_action_nepali_date
         )
                SELECT kycDoc_id,
agent_id,
user_name,
Identification_type,
Identification_NO,
Identification_issued_date,
Identification_issued_date_nepali,
Identification_expiry_date,
Identification_expiry_date_nepali,
Identification_issued_place,
Identification_photo_Logo,
Id_document_front,
Id_document_back,
KYC_Verified,
created_by,
created_UTC_date,
created_local_date,
created_nepali_date,
updated_by,
updated_UTC_date,
updated_local_date,
updated_nepali_date,
encrypted_identification_photo_log,
encrypted_id_document_front,
encrypted_id_document_back,
encrypted_identification_photo_logs,
                       system_user, 
                       'Insert', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Inserted;
     END;

GO
/****** Object:  Trigger [dbo].[TRG_UPDATE_tbl_kyc_documents]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TRG_UPDATE_tbl_kyc_documents] ON [dbo].[tbl_kyc_documents]
FOR UPDATE
AS
     BEGIN
         INSERT INTO tbl_kyc_documents_audit
         (kycDoc_id,
agent_id,
user_name,
Identification_type,
Identification_NO,
Identification_issued_date,
Identification_issued_date_nepali,
Identification_expiry_date,
Identification_expiry_date_nepali,
Identification_issued_place,
Identification_photo_Logo,
Id_document_front,
Id_document_back,
KYC_Verified,
created_by,
created_UTC_date,
created_local_date,
created_nepali_date,
updated_by,
updated_UTC_date,
updated_local_date,
updated_nepali_date,
encrypted_identification_photo_log,
encrypted_id_document_front,
encrypted_id_document_back,
encrypted_identification_photo_logs,
trigger_log_user,
trigger_action,
trigger_action_local_Date,
trigger_action_UTC_Date,
trigger_action_nepali_date
         )
                SELECT kycDoc_id,
agent_id,
user_name,
Identification_type,
Identification_NO,
Identification_issued_date,
Identification_issued_date_nepali,
Identification_expiry_date,
Identification_expiry_date_nepali,
Identification_issued_place,
Identification_photo_Logo,
Id_document_front,
Id_document_back,
KYC_Verified,
created_by,
created_UTC_date,
created_local_date,
created_nepali_date,
updated_by,
updated_UTC_date,
updated_local_date,
updated_nepali_date,
encrypted_identification_photo_log,
encrypted_id_document_front,
encrypted_id_document_back,
encrypted_identification_photo_logs,

                       system_user, 
                       'Update', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Inserted;
     END;

GO
