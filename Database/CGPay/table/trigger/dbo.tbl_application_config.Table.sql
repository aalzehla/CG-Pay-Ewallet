USE [WePayNepal]
GO
/****** Object:  Trigger [TRG_UPDATE_tbl_application_config]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_UPDATE_tbl_application_config]
GO
/****** Object:  Trigger [TRG_INSERT_tbl_application_config]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_INSERT_tbl_application_config]
GO
/****** Object:  Trigger [TRG_Delete_tbl_application_config]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_Delete_tbl_application_config]
GO


/****** Object:  Trigger [dbo].[TRG_Delete_tbl_application_config]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TRG_Delete_tbl_application_config] ON [dbo].[tbl_application_config]
FOR Delete
AS
     BEGIN
         INSERT INTO tbl_application_config_audit
         (config_id, 
          config_label, 
          config_value, 
          config_value1, 
          config_value2, 
          config_value3, 
          config_value4, 
          config_value5, 
          created_by, 
          created_ts, 
          updated_by, 
          updated_ts, 
          trigger_log_user, 
          trigger_action, 
          trigger_action_local_Date, 
          trigger_action_UTC_Date, 
          trigger_action_nepali_date
         )
                SELECT [id], 
                       config_label, 
                       config_value, 
                       config_value1 ,
					   config_value2, 
                       config_value3, 
                       config_value4, 
                       config_value5, 
                       created_by, 
                       created_ts, 
                       updated_by,
					   updated_ts, 
                       system_user, 
                       'Delete', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Deleted;
     END;
GO
/****** Object:  Trigger [dbo].[TRG_INSERT_tbl_application_config]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TRG_INSERT_tbl_application_config] ON [dbo].[tbl_application_config]
FOR INSERT
AS
     BEGIN
         INSERT INTO tbl_application_config_audit
         (config_id, 
          config_label, 
          config_value, 
          config_value1, 
          config_value2, 
          config_value3, 
          config_value4, 
          config_value5, 
          created_by, 
          created_ts, 
          updated_by, 
          updated_ts, 
          trigger_log_user, 
          trigger_action, 
          trigger_action_local_Date, 
          trigger_action_UTC_Date, 
          trigger_action_nepali_date
         )
                SELECT [id], 
                       config_label, 
                       config_value, 
                       config_value1 ,
					   config_value2, 
                       config_value3, 
                       config_value4, 
                       config_value5, 
                       created_by, 
                       created_ts, 
                       updated_by,
					   updated_ts, 
                       system_user, 
                       'Insert', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Inserted;
     END;
GO
/****** Object:  Trigger [dbo].[TRG_UPDATE_tbl_application_config]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TRG_UPDATE_tbl_application_config] ON [dbo].[tbl_application_config]
FOR Update
AS
     BEGIN
         INSERT INTO tbl_application_config_audit
         (config_id, 
          config_label, 
          config_value, 
          config_value1, 
          config_value2, 
          config_value3, 
          config_value4, 
          config_value5, 
          created_by, 
          created_ts, 
          updated_by, 
          updated_ts, 
          trigger_log_user, 
          trigger_action, 
          trigger_action_local_Date, 
          trigger_action_UTC_Date, 
          trigger_action_nepali_date
         )
                SELECT [id], 
                       config_label, 
                       config_value, 
                       config_value1 ,
					   config_value2, 
                       config_value3, 
                       config_value4, 
                       config_value5, 
                       created_by, 
                       created_ts, 
                       updated_by,
					   updated_ts, 
                       system_user, 
                       'Update', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Inserted;
     END;
GO
