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