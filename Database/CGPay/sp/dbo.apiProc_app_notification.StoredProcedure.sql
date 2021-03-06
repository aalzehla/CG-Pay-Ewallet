USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[apiProc_app_notification]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================        
-- Author:  <Author,,Name>        
-- Create date: <Create Date,,>        
-- Description: <Description,,>        
-- =============================================        
CREATE     PROCEDURE [dbo].[apiProc_app_notification] @flag CHAR(3) = NULL
	,@user_Name VARCHAR(100) = NULL
	,@device_id NVARCHAR(max) = NULL
	,@txn_id VARCHAR(10) = NULL
	,@notification_id VARCHAR(10) = NULL
	,@subscriber_no VARCHAR(50) = NULL
AS
BEGIN
	DECLARE @temp_reg_id VARCHAR(MAX)

	IF @flag = 'g' -- get  notifications of the user one user        
	BEGIN
		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_user_detail
				WHERE user_name = @user_Name
					OR user_email = @user_Name
				)
		BEGIN
			SELECT '104' code
				,'User Not Found!' message
				,NULL id

			RETURN
		END
		ELSE
		BEGIN
			SELECT TOP (1) n.created_local_date AS [Date]
				,n.notification_subject
				,n.notification_subtitle
				,n.notification_image_url
				,n.notification_body
				,a.device_info AS deviceId
			FROM tbl_authorization_request a
			JOIN tbl_user_detail u ON u.user_id = a.request_user
			JOIN tbl_agent_notification n ON n.user_id = u.user_id
			WHERE u.user_Name = @user_Name
			And n.notification_status = 'y'
		END
	END

	IF @flag = 'gv' -- get all  notifications of the user        
	BEGIN
		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_user_detail
				WHERE user_name = @user_Name
					OR user_email = @user_Name
					OR user_mobile_no = @user_Name
				)
		BEGIN
			SELECT '104' code
				,'User Not Found!' message
				,NULL id

			RETURN
		END
		ELSE
		BEGIN
			SELECT n.created_local_date AS [Date]
				,n.notification_subject
				,n.notification_subtitle
				,n.notification_image_url
				,n.notification_body
				,a.device_info AS deviceId
				,n.notification_type notification_type
			FROM tbl_authorization_request a
			JOIN tbl_user_detail u ON u.user_id = a.request_user
			JOIN tbl_agent_notification n ON n.user_id = u.user_id
			WHERE (u.user_Name = @user_Name
				OR u.user_email = @user_Name or user_mobile_no = @user_Name)
				And n.notification_status = 'y'
			GROUP BY n.created_local_date
				,n.notification_subject
				,n.notification_subtitle
				,n.notification_image_url
				,n.notification_body
				,a.device_info
				,n.notification_type
			ORDER BY n.created_local_date DESC
		END
	END

	IF @flag = 'gn' -- get all  notifications of the user        
	BEGIN
		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_user_detail
				WHERE user_name = @user_Name
					OR user_email = @user_Name
					OR user_mobile_no = @user_Name
				)
		BEGIN
			SELECT '104' code
				,'User Not Found!' message
				,NULL id

			RETURN
		END
		ELSE
		BEGIN
			SELECT n.created_local_date AS [Date]
				,n.notification_subject
				,n.notification_subtitle
				,n.notification_image_url
				,n.notification_body
				,a.device_info AS deviceId
				,n.notification_type notification_type
			FROM tbl_authorization_request a
			JOIN tbl_user_detail u ON u.user_id = a.request_user
			JOIN tbl_agent_notification n ON n.notification_to = u.user_id
			WHERE (
					u.user_Name = @user_Name
					OR u.user_email = @user_Name
					OR u.user_mobile_no = @user_Name
					)
				AND a.STATUS = 'y'
				And n.notification_status = 'y'
			GROUP BY n.created_local_date
				,n.notification_subject
				,n.notification_subtitle
				,n.notification_image_url
				,n.notification_body
				,a.device_info
				,n.notification_type
			ORDER BY n.created_local_date DESC
		END
	END

	IF @flag = 'gan' -- get all un-sent notifications of the user        
	BEGIN
		DECLARE @user_id INT

		IF @user_Name IS NOT NULL
			SELECT @user_id = user_id
				,@device_id = device_token
			FROM tbl_user_detail
			WHERE user_Name = @user_Name
				OR user_email = @user_Name
				OR user_mobile_no = @user_Name

		SELECT n.created_local_date AS created_local_date
			,n.notification_subject
			,n.notification_subtitle
			,n.notification_image_url
			,n.notification_body
			,a.device_info AS deviceId
			,n.notification_type notification_type
			--,isnull(@device_id, u.device_token) AS device_token\
			 ,u.device_token AS device_token
			,n.data_payload
		FROM tbl_authorization_request a
		JOIN tbl_user_detail u ON u.user_id = a.request_user
		--JOIN tbl_agent_notification n ON isnull(n.user_id, n.notification_to) = u.user_id
		JOIN tbl_agent_notification n ON n.notification_to= u.user_id
		WHERE isnull(n.notification_status, 'n') = 'n'
			AND isnull(nullif(@user_id, 0), u.user_id) = u.user_id
			AND ISNULL(@notification_id, notification_id) = notification_id
			AND a.STATUS = 'y'
		GROUP BY n.created_local_date
			,n.notification_subject
			,n.notification_subtitle
			,n.notification_image_url
			,n.notification_body
			,a.device_info
			,n.notification_type
			,u.device_token
			,n.data_payload
			,n.notification_id
		ORDER BY n.created_local_date DESC

		UPDATE n
		SET n.notification_status = 'y'
		FROM tbl_authorization_request a
		JOIN tbl_user_detail u ON u.user_id = a.request_user
		JOIN tbl_agent_notification n ON isnull(n.user_id, n.notification_to) = u.user_id
		WHERE isnull(n.notification_status, 'n') = 'n'
			AND isnull(nullif(@user_id, 0), u.user_id) = u.user_id
			AND ISNULL(@notification_id, notification_id) = notification_id
			AND a.STATUS = 'y'
	END

	IF @flag = 'gr' --get device Id         
	BEGIN
		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_user_detail
				WHERE user_name = @user_Name
					OR user_email = @user_Name
					OR user_mobile_no = @user_Name
				)
		BEGIN
			SELECT '104' code
				,'User Not Found!' message
				,NULL id

			RETURN
		END
		ELSE
		BEGIN
			SELECT TOP (1) @temp_reg_id = device_token
			FROM tbl_authorization_request a
			JOIN tbl_user_detail u ON u.user_id = a.request_user
			JOIN tbl_agent_notification n ON n.user_id = u.user_id
			WHERE u.user_Name = @user_Name
				OR user_email = @user_Name
				OR user_mobile_no = @user_Name

			SELECT @temp_reg_id AS token_id
		END
	END

	--update device id        
	IF @flag = 'ur'
	BEGIN
		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_user_detail
				WHERE user_name = @user_Name
					AND user_email = @user_Name
				)
		BEGIN
			SELECT '104' code
				,'User Not Found!' message
				,NULL id

			RETURN
		END
		ELSE
		BEGIN
			UPDATE tbl_user_detail
			SET device_id = @device_id
			WHERE user_name = @user_Name
				AND user_email = @user_Name

			SELECT '0' code
				,'device Id succesfully updated' message
				,NULL id

			RETURN
		END
	END

	--update device token        
	IF @flag = 'ud'
	BEGIN
		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_user_detail
				WHERE user_name = @user_Name
					OR user_email = @user_Name or user_mobile_no = @user_Name
				)
		BEGIN
			SELECT '104' code
				,'User Not Found!' message
				,NULL id

			RETURN
		END
		ELSE
		BEGIN
			UPDATE tbl_user_detail
			SET device_token = @device_id
			WHERE user_name = @user_Name
				OR user_email = @user_Name or user_mobile_no = @user_Name

			SELECT '0' code
				,'device token succesfully updated' message
				,NULL id

			RETURN
		END
	END

	IF @flag = 'ti'
		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_transaction
				WHERE txn_id = @txn_id
				)
		BEGIN
			SELECT '1' code
				,'transaction not found' message
				,NULL id

			RETURN
		END
		ELSE
		BEGIN
			SELECT notification_subject
				,notification_subtitle
				,notification_body
				,notification_type
				,notification_image_url
				,tn.created_local_date
			FROM tbl_agent_notification tn
			INNER JOIN tbl_transaction tl ON tl.txn_id = tn.txn_id
			WHERE tn.txn_id = @txn_id
		END

	IF @flag = 'tii'
	BEGIN
		DECLARE @sql VARCHAR(max);
		DECLARE @notification_to VARCHAR(10);

		SELECT @notification_to = a.agent_id
		FROM tbl_user_detail u
		JOIN tbl_agent_detail a ON a.agent_id = u.agent_id
		WHERE user_email = @subscriber_no
			OR user_mobile_no = @subscriber_no

		SET @sql = 'select notification_subject, notification_subtitle,notification_body ,notification_type, notification_image_url ,tn.created_local_date, isnull(ad.available_balance,0)available_balance, notification_to as receiver_id,     
  ad.agent_mobile_no as subscriber_no from tbl_agent_notification tn     
  join tbl_agent_Detail ad on ad.agent_id = tn.agent_id'

		IF (@txn_id IS NULL)
		BEGIN
			SET @sql += ' where notification_id = ' + '(select max(notification_id) from tbl_agent_notification where notification_to = ' + @notification_to + ')'
		END
		ELSE
		BEGIN
			SET @sql += ' inner join tbl_transaction tl on tl.txn_id = tn.txn_id        
   where tn.txn_id = ' + @txn_id
		END

		PRINT (@sql)

		EXECUTE (@sql)
	END
END




GO
