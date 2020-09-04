USE [WePayNepal]
GO
/****** Object:  Trigger [TRG_UPDATE_tbl_application_functions_role]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_UPDATE_tbl_application_functions_role]
GO
/****** Object:  Trigger [TRG_INSERT_tbl_application_functions_role]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_INSERT_tbl_application_functions_role]
GO
/****** Object:  Trigger [TRG_DELETE_tbl_application_functions_role]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_DELETE_tbl_application_functions_role]
GO


/****** Object:  Trigger [dbo].[TRG_DELETE_tbl_application_functions_role]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRG_DELETE_tbl_application_functions_role] ON [dbo].[tbl_application_functions_role]
FOR DELETE
AS
     BEGIN
         INSERT INTO tbl_application_functions_role_audit
         (function_role_id,
function_id,
role_id,
created_UTC_date,
created_local_date,
created_nepali_date,
created_by,
updated_by,
updated_UTC_date,
updated_local_date,
updated_nepali_date,
trigger_log_user,
trigger_action,
trigger_action_local_Date,
trigger_action_UTC_Date,
trigger_action_nepali_date
         )
                SELECT function_role_id,
function_id,
role_id,
created_UTC_date,
created_local_date,
created_nepali_date,
created_by,
updated_by,
updated_UTC_date,
updated_local_date,
updated_nepali_date,

                       system_user, 
                       'Delete', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Deleted;
     END;
GO
/****** Object:  Trigger [dbo].[TRG_INSERT_tbl_application_functions_role]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRG_INSERT_tbl_application_functions_role] ON [dbo].[tbl_application_functions_role]
FOR INSERT
AS
     BEGIN
         INSERT INTO tbl_application_functions_role_audit
         (function_role_id,
function_id,
role_id,
created_UTC_date,
created_local_date,
created_nepali_date,
created_by,
updated_by,
updated_UTC_date,
updated_local_date,
updated_nepali_date,
trigger_log_user,
trigger_action,
trigger_action_local_Date,
trigger_action_UTC_Date,
trigger_action_nepali_date
         )
                SELECT function_role_id,
function_id,
role_id,
created_UTC_date,
created_local_date,
created_nepali_date,
created_by,
updated_by,
updated_UTC_date,
updated_local_date,
updated_nepali_date,

                       system_user, 
                       'Insert', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Inserted;
     END;
GO
/****** Object:  Trigger [dbo].[TRG_UPDATE_tbl_application_functions_role]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRG_UPDATE_tbl_application_functions_role] ON [dbo].[tbl_application_functions_role]
FOR UPDATE
AS
     BEGIN
         INSERT INTO tbl_application_functions_role_audit
         (function_role_id,
function_id,
role_id,
created_UTC_date,
created_local_date,
created_nepali_date,
created_by,
updated_by,
updated_UTC_date,
updated_local_date,
updated_nepali_date,
trigger_log_user,
trigger_action,
trigger_action_local_Date,
trigger_action_UTC_Date,
trigger_action_nepali_date
         )
                SELECT function_role_id,
function_id,
role_id,
created_UTC_date,
created_local_date,
created_nepali_date,
created_by,
updated_by,
updated_UTC_date,
updated_local_date,
updated_nepali_date,

                       system_user, 
                       'Update', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Inserted;
     END;
GO
