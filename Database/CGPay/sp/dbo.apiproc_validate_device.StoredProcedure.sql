USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[apiproc_validate_device]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE   PROCEDURE [dbo].[apiproc_validate_device] @device_id VARCHAR(500) = NULL
	,@token_id NVARCHAR(max) = NULL
	,@version_id VARCHAR(200) = NULL
AS
BEGIN
	IF NOT EXISTS (
			SELECT 'x'
			FROM tbl_authorization_request
			WHERE device_info = @device_id
				AND authorization_token = @token_id
				AND version_id = @version_id
			)
	BEGIN
		SELECT '99' code
			,'Technical Error: unauthorised access' message
			,NULL available_balance

		RETURN
	END
	ELSE
	BEGIN
		SELECT 0 code,'success'message,isnull(a.available_balance, 0) AS available_balance
		FROM tbl_authorization_request r
		left JOIN tbl_user_detail u ON r.request_user = u.user_id
		left JOIN tbl_agent_detail a ON a.agent_id = u.agent_id
		WHERE r.encryption_key = @token_id
			AND device_info = @device_id
			AND version_id = @version_id
	END
END


GO
