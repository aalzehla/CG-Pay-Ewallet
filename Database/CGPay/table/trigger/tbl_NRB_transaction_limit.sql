USE [WePayNepal]
GO

/****** Object:  Trigger [TRG_UPDATE_tbl_NRB_transaction_limit]    Script Date: 8/8/2020 12:57:28 PM ******/
DROP TRIGGER [dbo].[TRG_UPDATE_tbl_NRB_transaction_limit]
GO
/****** Object:  Trigger [TRG_INSERT_tbl_NRB_transaction_limit]    Script Date: 8/8/2020 12:57:19 PM ******/
DROP TRIGGER [dbo].[TRG_INSERT_tbl_NRB_transaction_limit]
GO
/****** Object:  Trigger [TRG_DELETE_tbl_NRB_transaction_limit]    Script Date: 8/8/2020 12:57:11 PM ******/
DROP TRIGGER [dbo].[TRG_DELETE_tbl_NRB_transaction_limit]
GO

/****** Object:  Trigger [dbo].[TRG_UPDATE_tbl_NRB_transaction_limit]    Script Date: 8/8/2020 12:57:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TRG_UPDATE_tbl_NRB_transaction_limit] ON [dbo].[tbl_NRB_transaction_limit]
FOR UPDATE
AS
     BEGIN
         INSERT INTO tbl_NRB_transaction_limit_audit
         (txnl_Id, 
          KYC_Status, 
          txn_type, 
          transaction_limit_max, 
          transaction_daily_limit_max, 
          transaction_monthly_limit_max, 
          created_by, 
          created_local_date, 
          created_UTC_date, 
          updated_by, 
          updated_local_date, 
          updated_UTC_date, 
          trigger_log_user, 
          trigger_action, 
          trigger_action_local_Date, 
          trigger_action_UTC_Date, 
          trigger_action_nepali_date
         )
                SELECT txnl_Id, 
                       KYC_Status, 
                       txn_type, 
                       transaction_limit_max, 
                       transaction_daily_limit_max, 
                       transaction_monthly_limit_max, 
                       created_by, 
                       created_local_date, 
                       created_UTC_date, 
                       updated_by, 
                       updated_local_date, 
                       updated_UTC_date, 
                       system_user, 
                       'Update', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Inserted;
     END;
GO

/****** Object:  Trigger [dbo].[TRG_INSERT_tbl_NRB_transaction_limit]    Script Date: 8/8/2020 12:57:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TRG_INSERT_tbl_NRB_transaction_limit] ON [dbo].[tbl_NRB_transaction_limit]
FOR INSERT
AS
     BEGIN
         INSERT INTO tbl_NRB_transaction_limit_audit
         (txnl_Id, 
          KYC_Status, 
          txn_type, 
          transaction_limit_max, 
          transaction_daily_limit_max, 
          transaction_monthly_limit_max, 
          created_by, 
          created_local_date, 
          created_UTC_date, 
          updated_by, 
          updated_local_date, 
          updated_UTC_date, 
          trigger_log_user, 
          trigger_action, 
          trigger_action_local_Date, 
          trigger_action_UTC_Date, 
          trigger_action_nepali_date
         )
                SELECT txnl_Id, 
                       KYC_Status, 
                       txn_type, 
                       transaction_limit_max, 
                       transaction_daily_limit_max, 
                       transaction_monthly_limit_max, 
                       created_by, 
                       created_local_date, 
                       created_UTC_date, 
                       updated_by, 
                       updated_local_date, 
                       updated_UTC_date, 
                       system_user, 
                       'Insert', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Inserted;
     END;
GO

/****** Object:  Trigger [dbo].[TRG_DELETE_tbl_NRB_transaction_limit]    Script Date: 8/8/2020 12:57:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TRG_DELETE_tbl_NRB_transaction_limit] ON [dbo].[tbl_NRB_transaction_limit]
FOR DELETE
AS
     BEGIN
         INSERT INTO tbl_NRB_transaction_limit_audit
         (txnl_Id, 
          KYC_Status, 
          txn_type, 
          transaction_limit_max, 
          transaction_daily_limit_max, 
          transaction_monthly_limit_max, 
          created_by, 
          created_local_date, 
          created_UTC_date, 
          updated_by, 
          updated_local_date, 
          updated_UTC_date, 
          trigger_log_user, 
          trigger_action, 
          trigger_action_local_Date, 
          trigger_action_UTC_Date, 
          trigger_action_nepali_date
         )
                SELECT txnl_Id, 
                       KYC_Status, 
                       txn_type, 
                       transaction_limit_max, 
                       transaction_daily_limit_max, 
                       transaction_monthly_limit_max, 
                       created_by, 
                       created_local_date, 
                       created_UTC_date, 
                       updated_by, 
                       updated_local_date, 
                       updated_UTC_date, 
                       system_user, 
                       'Delete', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Deleted;
     END;
GO

ALTER TABLE [dbo].[tbl_NRB_transaction_limit] ENABLE TRIGGER [TRG_UPDATE_tbl_NRB_transaction_limit]
GO

ALTER TABLE [dbo].[tbl_NRB_transaction_limit] ENABLE TRIGGER [TRG_INSERT_tbl_NRB_transaction_limit]
GO

ALTER TABLE [dbo].[tbl_NRB_transaction_limit] ENABLE TRIGGER [TRG_DELETE_tbl_NRB_transaction_limit]
GO




