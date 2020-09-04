DROP TRIGGER [dbo].[TRG_Delete_tbl_agent_card_management]
GO

CREATE TRIGGER [dbo].[TRG_Delete_tbl_agent_card_management] ON [dbo].[tbl_agent_card_management]
FOR Delete
AS
     BEGIN
         INSERT INTO tbl_agent_card_management_audit
         (card_id, 
          agent_id, 
          user_id, 
          user_name, 
          card_no, 
          card_uid, 
          card_type, 
          card_txn_type, 
          card_issued_date, 
          card_expiry_date, 
          is_active, 
          created_by, 
          created_local_date, 
          created_utc_date, 
          created_nepali_date, 
          updated_by, 
          updated_local_date, 
          updated_utc_date, 
          updated_nepali_date, 
          Amount, 
		  is_transfer,
		  transfer_to,
          trigger_log_user, 
          trigger_action, 
          trigger_action_local_Date, 
          trigger_action_UTC_Date, 
          trigger_action_nepali_date
         )
                SELECT card_id, 
                       agent_id, 
                       user_id, 
                       user_name, 
                       card_no, 
                       card_uid, 
                       card_type, 
                       card_txn_type, 
                       card_issued_date, 
                       card_expiry_date, 
                       is_active, 
                       created_by, 
                       created_local_date, 
                       created_utc_date, 
                       created_nepali_date, 
                       updated_by, 
                       updated_local_date, 
                       updated_utc_date, 
                       updated_nepali_date, 
                       Amount,
					   is_transfer,
					   transfer_to,
                       system_user, 
                       'Delete', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Deleted;
     END;