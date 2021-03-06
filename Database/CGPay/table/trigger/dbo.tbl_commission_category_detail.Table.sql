USE [WePayNepal]
GO
/****** Object:  Trigger [TRG_UPDATE_tbl_commission_category_detail]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_UPDATE_tbl_commission_category_detail]
GO
/****** Object:  Trigger [TRG_INSERT_tbl_commission_category_detail]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_INSERT_tbl_commission_category_detail]
GO
/****** Object:  Trigger [TRG_Delete_tbl_commission_category_detail]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_Delete_tbl_commission_category_detail]
GO

/****** Object:  Trigger [dbo].[TRG_Delete_tbl_commission_category_detail]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRG_Delete_tbl_commission_category_detail] ON [dbo].[tbl_commission_category_detail]
FOR Delete
AS
     BEGIN
         INSERT INTO tbl_commission_category_detail_audit
         (com_detail_id,
com_category_id,
product_id,
commission_type,
commission_value,
commission_percent_type,
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
trigger_Action,
trigger_action_local_Date,
trigger_action_UTC_Date,
trigger_action_nepali_Date
         )
                SELECT com_detail_id,
com_category_id,
product_id,
commission_type,
commission_value,
commission_percent_type,
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
/****** Object:  Trigger [dbo].[TRG_INSERT_tbl_commission_category_detail]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRG_INSERT_tbl_commission_category_detail] ON [dbo].[tbl_commission_category_detail]
FOR INSERT
AS
     BEGIN
         INSERT INTO tbl_commission_category_detail_audit
         (com_detail_id,
com_category_id,
product_id,
commission_type,
commission_value,
commission_percent_type,
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
trigger_Action,
trigger_action_local_Date,
trigger_action_UTC_Date,
trigger_action_nepali_Date
         )
                SELECT com_detail_id,
com_category_id,
product_id,
commission_type,
commission_value,
commission_percent_type,
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
/****** Object:  Trigger [dbo].[TRG_UPDATE_tbl_commission_category_detail]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRG_UPDATE_tbl_commission_category_detail] ON [dbo].[tbl_commission_category_detail]
FOR UPDATE
AS
     BEGIN
         INSERT INTO tbl_commission_category_detail_audit
         (com_detail_id,
com_category_id,
product_id,
commission_type,
commission_value,
commission_percent_type,
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
trigger_Action,
trigger_action_local_Date,
trigger_action_UTC_Date,
trigger_action_nepali_Date
         )
                SELECT com_detail_id,
com_category_id,
product_id,
commission_type,
commission_value,
commission_percent_type,
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
