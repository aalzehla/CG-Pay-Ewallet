USE [WePayNepal]
GO

/****** Object:  StoredProcedure [dbo].[Sproc_mobile_notification]    Script Date: 06/08/2020 5:41:46 PM ******/
DROP PROCEDURE [dbo].[Sproc_mobile_notification]
GO

/****** Object:  StoredProcedure [dbo].[Sproc_mobile_notification]    Script Date: 06/08/2020 5:41:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Sproc_mobile_notification] @flag CHAR(1)
	,@notification_id VARCHAR(100) = NULL
	,@notification_subject VARCHAR(100) = NULL
	,@notification_subtitle VARCHAR(100) = NULL
	,@notification_body VARCHAR(500) = NULL
	,@notification_image_url VARCHAR(200) = NULL
	,@action_id VARCHAR(50) = NULL
	,@notification_type VARCHAR(100) = NULL
	,@notification_importance_level VARCHAR(10) = NULL
	,@notification_status VARCHAR(10) = NULL
	,@is_background CHAR(1) = NULL
	,@notification_to VARCHAR(30) = NULL
	,@agent_id VARCHAR(10) = NULL
	,@user_id VARCHAR(10) = NULL
	,@action_user VARCHAR(100) = NULL
	,@txn_id VARCHAR(100) = NULL
	,@read_status VARCHAR(1) = NULL
	,@txn_status_id VARCHAR(100) = NULL
	,@txn_status VARCHAR(20) = NULL
AS
BEGIN
	

	IF @flag = 's'
	BEGIN
		SELECT [notification_id]
			,[notification_subject]
			,[notification_subtitle]
			,[notification_body]
			,[notification_image_url]
			,[action_id]
			,[notification_type]
			,[notification_importance_level]
			,[notification_status]
			,[is_background]
			,[notification_to]
			,[agent_id]
			,[user_id]
			,[created_UTC_date]
			,[created_local_date]
			,[created_nepali_date]
			,[created_by]
			,[updated_by]
			,[updated_UTC_date]
			,[updated_local_date]
			,[updated_nepali_date]
			,[txn_id]
			,[read_status]
			,[txn_status_id]
			,[txn_status]

		FROM tbl_agent_notification
		ORDER BY notification_id DESC
		return;
	END
	IF NOT EXISTS (
			SELECT 'x'
			FROM tbl_user_detail
			WHERE user_name = @action_user
			)
	BEGIN
		EXEC sproc_error_handler @error_code = '1'
			,@Msg = 'UserName is required'
			,@id = NULL;
	END
	IF @flag = 'sid'
	BEGIN
		SELECT [notification_id]
			,[notification_subject]
			,[notification_subtitle]
			,[notification_body]
			,[notification_image_url]
			,[action_id]
			,[notification_type]
			,[notification_importance_level]
			,[notification_status]
			,[is_background]
			,[notification_to]
			,[agent_id]
			,[user_id]
			,[created_UTC_date]
			,[created_local_date]
			,[created_nepali_date]
			,[created_by]
			,[updated_by]
			,[updated_UTC_date]
			,[updated_local_date]
			,[updated_nepali_date]
			,[txn_id]
			,[read_status]
			,[txn_status_id]
			,[txn_status]
		FROM [dbo].[tbl_agent_notification]
		WHERE notification_id = @notification_id
		return;
	END

	IF @flag = 'i'
	BEGIN
		INSERT INTO dbo.tbl_agent_notification (
			notification_subject
			,notification_subtitle
			,notification_body
			,notification_image_url
			,action_id
			,notification_type
			,notification_importance_level
			,notification_status
			,is_background
			,notification_to
			,agent_id
			,user_id
			,created_UTC_date
			,created_local_date
			,created_nepali_date
			,created_by
			,txn_id
			,read_status
			,txn_status_id
			,txn_status
			)
		--VALUES (
		select
			@notification_subject
			,@notification_subtitle
			,@notification_body
			,@notification_image_url
			,@action_id
			,'Promotional'--@notification_type
			,@notification_importance_level
			,'Y' --@notification_status
			,@is_background
			,agent_id--@notification_to
			,agent_id--@agent_id
			,user_id--@user_id
			,GETUTCDATE()
			,GETDATE()
			,dbo.func_get_nepali_date(NULL)
			,@action_user
			,@txn_id
			,'N'--@read_status
			,@txn_status_id
			,@txn_status from tbl_user_detail
			--)

			if @@ROWCOUNT>1
			SELECT '0' Code
			,'Notification Succesfully Inserted' Message
			,NULL id;
			
			return;
	END

	IF @flag = 'u'
	BEGIN
		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_agent_notification
				WHERE notification_id = @notification_id
				)
		BEGIN
				SELECT '1' Code
				,'Notification Doesnot exist' Message
				,NULL id;
				return
		END

		UPDATE tbl_agent_notification
		SET notification_subject = @notification_subject
			,notification_subtitle = @notification_subtitle
			,notification_body = @notification_body
			,notification_image_url = @notification_image_url
			,action_id = @action_id
			,notification_type = @notification_type
			,notification_importance_level = @notification_importance_level
			,notification_status = @notification_status
			,is_background = @is_background
			,notification_to = @notification_to
			,agent_id = @agent_id
			,user_id = @user_id
			,updated_UTC_date = GETUTCDATE()
			,updated_local_date = GETDATE()
			,updated_nepali_date = dbo.func_get_nepali_date(NULL)
			,updated_by = @action_user
			,txn_id = @txn_id
			,read_status = @read_status
			,txn_status_id = @txn_status_id
			,txn_status = @txn_status
		WHERE notification_id = @notification_id

		SELECT '0' Code
			,'Notification Succesfully Updated' Message
			,NULL id;
	END

	IF @flag = 'e'
	BEGIN
		IF EXISTS (
				SELECT 'x'
				FROM tbl_agent_notification
				WHERE notification_id = @notification_id
				)
		BEGIN
			UPDATE tbl_agent_notification
			SET notification_status = @notification_status
				,updated_UTC_date = GETUTCDATE()
				,updated_local_date = GETDATE()
				,updated_nepali_date = dbo.func_get_nepali_date(NULL)
				,updated_by = @action_user
			WHERE notification_id = @notification_id

			SELECT '0' Code
				,'Notification Succesfully Updated' Message
				,NULL id;
				return
		END
		SELECT '1' Code
				,'Notification Doesnot exist' Message
				,NULL id;
				return
	END
END
GO


