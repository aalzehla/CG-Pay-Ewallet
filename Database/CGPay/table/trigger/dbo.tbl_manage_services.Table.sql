USE [WePayNepal]
GO
/****** Object:  Trigger [TRG_UPDATE_tbl_manage_services]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_UPDATE_tbl_manage_services]
GO
/****** Object:  Trigger [TRG_INSERT_tbl_manage_services]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_INSERT_tbl_manage_services]
GO
/****** Object:  Trigger [TRG_DELETE_tbl_manage_services]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_DELETE_tbl_manage_services]
GO


/****** Object:  Trigger [dbo].[TRG_DELETE_tbl_manage_services]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRG_DELETE_tbl_manage_services] ON [dbo].[tbl_manage_services]
FOR DELETE
AS
     BEGIN
         INSERT INTO tbl_manage_services_audit
         (product_id,
txn_type_id,
txn_type,
company_id,
company,
product_type_id,
product_type,
product_label,
product_logo,
product_service_info,
product_category,
subscriber_regex,
min_denomination_amount,
max_denomination_amount,
primary_gateway,
secondary_gateway,
status,
created_UTC_date,
created_local_date,
created_nepali_date,
created_by,
created_ip,
updated_by,
updated_UTC_date,
updated_local_date,
updated_nepali_date,
updated_ip,
trigger_log_user,
trigger_action,
trigger_action_local_Date,
trigger_action_UTC_Date,
trigger_action_nepali_Date
         )
                SELECT 
				product_id,
txn_type_id,
txn_type,
company_id,
company,
product_type_id,
product_type,
product_label,
product_logo,
product_service_info,
product_category,
subscriber_regex,
min_denomination_amount,
max_denomination_amount,
primary_gateway,
secondary_gateway,
status,
created_UTC_date,
created_local_date,
created_nepali_date,
created_by,
created_ip,
updated_by,
updated_UTC_date,
updated_local_date,
updated_nepali_date,
updated_ip,
                       system_user, 
                       'Delete', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Deleted;
     END;
GO
/****** Object:  Trigger [dbo].[TRG_INSERT_tbl_manage_services]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRG_INSERT_tbl_manage_services] ON [dbo].[tbl_manage_services]
FOR INSERT
AS
     BEGIN
         INSERT INTO tbl_manage_services_audit
         (product_id,
txn_type_id,
txn_type,
company_id,
company,
product_type_id,
product_type,
product_label,
product_logo,
product_service_info,
product_category,
subscriber_regex,
min_denomination_amount,
max_denomination_amount,
primary_gateway,
secondary_gateway,
status,
created_UTC_date,
created_local_date,
created_nepali_date,
created_by,
created_ip,
updated_by,
updated_UTC_date,
updated_local_date,
updated_nepali_date,
updated_ip,
trigger_log_user,
trigger_action,
trigger_action_local_Date,
trigger_action_UTC_Date,
trigger_action_nepali_Date
         )
                SELECT 
				product_id,
txn_type_id,
txn_type,
company_id,
company,
product_type_id,
product_type,
product_label,
product_logo,
product_service_info,
product_category,
subscriber_regex,
min_denomination_amount,
max_denomination_amount,
primary_gateway,
secondary_gateway,
status,
created_UTC_date,
created_local_date,
created_nepali_date,
created_by,
created_ip,
updated_by,
updated_UTC_date,
updated_local_date,
updated_nepali_date,
updated_ip,
                       system_user, 
                       'Insert', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Inserted;
     END;
GO
/****** Object:  Trigger [dbo].[TRG_UPDATE_tbl_manage_services]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRG_UPDATE_tbl_manage_services] ON [dbo].[tbl_manage_services]
FOR UPDATE
AS
     BEGIN
         INSERT INTO tbl_manage_services_audit
         (product_id,
txn_type_id,
txn_type,
company_id,
company,
product_type_id,
product_type,
product_label,
product_logo,
product_service_info,
product_category,
subscriber_regex,
min_denomination_amount,
max_denomination_amount,
primary_gateway,
secondary_gateway,
status,
created_UTC_date,
created_local_date,
created_nepali_date,
created_by,
created_ip,
updated_by,
updated_UTC_date,
updated_local_date,
updated_nepali_date,
updated_ip,
trigger_log_user,
trigger_action,
trigger_action_local_Date,
trigger_action_UTC_Date,
trigger_action_nepali_Date
         )
                SELECT 
				product_id,
txn_type_id,
txn_type,
company_id,
company,
product_type_id,
product_type,
product_label,
product_logo,
product_service_info,
product_category,
subscriber_regex,
min_denomination_amount,
max_denomination_amount,
primary_gateway,
secondary_gateway,
status,
created_UTC_date,
created_local_date,
created_nepali_date,
created_by,
created_ip,
updated_by,
updated_UTC_date,
updated_local_date,
updated_nepali_date,
updated_ip,
                       system_user, 
                       'Update', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Inserted;
     END;
GO
