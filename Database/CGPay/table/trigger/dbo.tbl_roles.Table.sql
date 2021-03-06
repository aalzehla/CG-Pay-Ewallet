USE [WePayNepal]
GO
/****** Object:  Trigger [TRG_UPDATE_tbl_roles]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_UPDATE_tbl_roles]
GO
/****** Object:  Trigger [TRG_Insert_tbl_roles]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_Insert_tbl_roles]
GO
/****** Object:  Trigger [TRG_DELETE_tbl_roles]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_DELETE_tbl_roles]
GO

/****** Object:  Trigger [dbo].[TRG_DELETE_tbl_roles]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRG_DELETE_tbl_roles] ON [dbo].[tbl_roles]
FOR Delete
AS
     BEGIN
         INSERT INTO tbl_roles_audit
         (role_id, 
          role_name, 
          role_type, 
          created_UTC_date, 
          created_local_date, 
          created_nepali_date, 
          created_by, 
          created_ip, 
          role_status, 
          trigger_log_user, 
          trigger_action, 
          trigger_action_local_Date, 
          trigger_action_UTC_Date, 
          trigger_action_nepali_date
         )
                SELECT role_id, 
                       role_name, 
                       role_type, 
                       created_UTC_date, 
                       created_local_date, 
                       created_nepali_date, 
                       created_by, 
                       created_ip, 
                       role_status, 
                    
                       system_user, 
                       'Deleted', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Deleted;
     END;
GO
/****** Object:  Trigger [dbo].[TRG_Insert_tbl_roles]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRG_Insert_tbl_roles] ON [dbo].[tbl_roles]
FOR INSERT
AS
     BEGIN
         INSERT INTO tbl_roles_audit
         (role_id, 
          role_name, 
          role_type, 
          created_UTC_date, 
          created_local_date, 
          created_nepali_date, 
          created_by, 
          created_ip, 
          role_status, 
          trigger_log_user, 
          trigger_action, 
          trigger_action_local_Date, 
          trigger_action_UTC_Date, 
          trigger_action_nepali_date
         )
                SELECT role_id, 
                       role_name, 
                       role_type, 
                       created_UTC_date, 
                       created_local_date, 
                       created_nepali_date, 
                       created_by, 
                       created_ip, 
                       role_status, 
                    
                       system_user, 
                       'Insert', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Inserted;
     END;
GO
/****** Object:  Trigger [dbo].[TRG_UPDATE_tbl_roles]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create TRIGGER [dbo].[TRG_UPDATE_tbl_roles] ON [dbo].[tbl_roles]
FOR UPDATE
AS
     BEGIN
         INSERT INTO tbl_roles_audit
         (role_id, 
          role_name, 
          role_type, 
          created_UTC_date, 
          created_local_date, 
          created_nepali_date, 
          created_by, 
          created_ip, 
          role_status, 
          trigger_log_user, 
          trigger_action, 
          trigger_action_local_Date, 
          trigger_action_UTC_Date, 
          trigger_action_nepali_date
         )
                SELECT role_id, 
                       role_name, 
                       role_type, 
                       created_UTC_date, 
                       created_local_date, 
                       created_nepali_date, 
                       created_by, 
                       created_ip, 
                       role_status, 
                    
                       system_user, 
                       'Update', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Inserted;
     END;
GO
