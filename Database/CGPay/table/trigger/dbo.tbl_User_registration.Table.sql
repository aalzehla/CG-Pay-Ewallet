USE [WePayNepal]
GO
/****** Object:  Trigger [TRG_UPDATE_tbl_User_registration]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_UPDATE_tbl_User_registration]
GO
/****** Object:  Trigger [TRG_INSERT_tbl_User_registration]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_INSERT_tbl_User_registration]
GO
/****** Object:  Trigger [TRG_DELETE_tbl_User_registration]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_DELETE_tbl_User_registration]
GO


/****** Object:  Trigger [dbo].[TRG_DELETE_tbl_User_registration]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRG_DELETE_tbl_User_registration] ON [dbo].[tbl_User_registration]
FOR DELETE
AS
     BEGIN
         INSERT INTO tbl_User_registration_audit
         (UserId,
Agent_Mobile_Number,
Agent_Email_address,
Agent_full_Name,
Agent_verification_code,
Agent_verification_Status,
generate_date_time,
send_date_time,
username,
trigger_log_user,
trigger_action,
trigger_action_local_Date,
trigger_action_UTC_Date,
trigger_action_nepali_date
         )
                SELECT UserId,
Agent_Mobile_Number,
Agent_Email_address,
Agent_full_Name,
Agent_verification_code,
Agent_verification_Status,
generate_date_time,
send_date_time,
username,
                       system_user, 
                       'Delete', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Deleted;
     END;
GO
/****** Object:  Trigger [dbo].[TRG_INSERT_tbl_User_registration]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRG_INSERT_tbl_User_registration] ON [dbo].[tbl_User_registration]
FOR INSERT
AS
     BEGIN
         INSERT INTO tbl_User_registration_audit
         (UserId,
Agent_Mobile_Number,
Agent_Email_address,
Agent_full_Name,
Agent_verification_code,
Agent_verification_Status,
generate_date_time,
send_date_time,
username,
trigger_log_user,
trigger_action,
trigger_action_local_Date,
trigger_action_UTC_Date,
trigger_action_nepali_date
         )
                SELECT UserId,
Agent_Mobile_Number,
Agent_Email_address,
Agent_full_Name,
Agent_verification_code,
Agent_verification_Status,
generate_date_time,
send_date_time,
username,
                       system_user, 
                       'Insert', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Inserted;
     END;
GO
/****** Object:  Trigger [dbo].[TRG_UPDATE_tbl_User_registration]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRG_UPDATE_tbl_User_registration] ON [dbo].[tbl_User_registration]
FOR INSERT
AS
     BEGIN
         INSERT INTO tbl_User_registration_audit
         (UserId,
Agent_Mobile_Number,
Agent_Email_address,
Agent_full_Name,
Agent_verification_code,
Agent_verification_Status,
generate_date_time,
send_date_time,
username,
trigger_log_user,
trigger_action,
trigger_action_local_Date,
trigger_action_UTC_Date,
trigger_action_nepali_date
         )
                SELECT UserId,
Agent_Mobile_Number,
Agent_Email_address,
Agent_full_Name,
Agent_verification_code,
Agent_verification_Status,
generate_date_time,
send_date_time,
username,
                       system_user, 
                       'UPDATE', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Inserted;
     END;
GO
