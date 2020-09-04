USE [WePayNepal]
GO
/****** Object:  Trigger [TRG_DELETE_tbl_gateway_detail]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_DELETE_tbl_gateway_detail]
GO


/****** Object:  Trigger [dbo].[TRG_DELETE_tbl_gateway_detail]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRG_DELETE_tbl_gateway_detail] ON [dbo].[tbl_gateway_detail]
FOR Delete
AS
     BEGIN
         INSERT INTO tbl_gateway_detail_audit
         (gateway_id,
gateway_name,
gateway_balance,
gateway_country,
gateway_currency,
gateway_username,
gateway_password,
gateway_access_code,
gateway_security_code,
gateway_api_token,
gateway_url,
gateway_status,
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
is_direct_gateway,
gateway_type,
trigger_log_user,
trigger_action,
trigger_action_local_Date,
trigger_action_UTC_Date,
trigger_action_nepali_Date
         )
                SELECT gateway_id,
gateway_name,
gateway_balance,
gateway_country,
gateway_currency,
gateway_username,
gateway_password,
gateway_access_code,
gateway_security_code,
gateway_api_token,
gateway_url,
gateway_status,
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
is_direct_gateway,
gateway_type,
                       system_user, 
                       'DELETE', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Deleted;
     END;
GO
