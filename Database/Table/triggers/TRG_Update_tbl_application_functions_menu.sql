CREATE TRIGGER [dbo].[TRG_Update_tbl_application_functions_menu] ON [dbo].[tbl_application_functions_menu]
FOR Update
AS
     BEGIN
         INSERT INTO tbl_application_functions_menu_audit
         (function_menu_id,
role_id,
menu_id,
created_by,
created_local_date,
created_UTC_date,
created_Nepali_date,
created_ip,
trigger_log_user,
trigger_action,
trigger_action_local_Date,
trigger_action_UTC_Date,
trigger_action_nepali_date
         )
                SELECT function_menu_id,
role_id,
menu_id,
created_by,
created_local_date,
created_UTC_date,
created_Nepali_date,
created_ip,
system_user, 
                       'Update', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Inserted;
     END;