CREATE TRIGGER [dbo].[TRG_UPDATE_tbl_application_functions] ON [dbo].[tbl_application_functions]
FOR UPDATE
AS
     BEGIN
         INSERT INTO tbl_application_functions_audit
         (function_id,
parent_menu_id,
function_name,
function_Url,
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
                SELECT function_id,
parent_menu_id,
function_name,
function_Url,
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