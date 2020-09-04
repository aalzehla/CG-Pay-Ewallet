
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter PROCEDURE sproc_agent_notification 
	@flag varchar(3) = null, 
	@user_id varchar(50) = null,
	@notification_id int = null,
	@update_flag char(1) =null
AS
Declare @sql varchar(max)
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @flag = 's' --select new notification
	BEGIN
		SET @sql = 'Select top 5 notification_id as id,notification_subject as subject,(DATENAME(m,created_UTC_date) +'' ''+ cast(day(created_UTC_date) as varchar) +'',''+ FORMAT(CAST(created_UTC_date AS datetime2), N''hh:mm tt'')  ) as CreatedDate,notification_body as notification,read_status readStatus from tbl_agent_notification where 1=1';

		IF (@user_id IS NOT NULL)
		BEGIN
			SET @sql =@sql + ' and notification_to ='''+ @user_id +'''';
		END

		SET @sql = @sql + ' order by created_UTC_date desc';

		PRINT @sql;  
  
	    EXEC (@sql); 

	END

	IF @flag = 'us' --update read status
	BEGIN	
		IF @update_flag = 'a' --update all notification of agent
			BEGIN
				IF (@user_id IS NULL)
				BEGIN
					select '1' code, 'Agent id required' message;
					RETURN;
				END

				UPDATE tbl_agent_notification SET read_status ='y' where notification_to=@user_id;
				select '0' code , 'updated' message, 'r' Extra1 ;  --r for redirect
			END
		ELSE
			BEGIN
				IF (@notification_id is null or @notification_id = 0)
				BEGIN
					select '1' code, 'Notification id required' message;
					RETURN;
				END
				UPDATE tbl_agent_notification SET read_status ='y' where notification_id= @notification_id;
				select '0' code , 'updated' message;
			END
		
	END

	IF @flag = 'sa' --select all notification
	BEGIN
		SET @sql = 'Select notification_id as id,notification_subject as subject,CONVERT(VARCHAR, created_UTC_date,103 ) as CreatedDate,notification_body as notification,read_status readStatus,notification_type as type from tbl_agent_notification where 1=1';

		IF (@user_id IS NOT NULL)
		BEGIN
			SET @sql =@sql + ' and notification_to ='''+ @user_id +'''';
		END

		SET @sql = @sql + ' order by created_UTC_date desc';

		PRINT @sql;  
  
	    EXEC (@sql);
	END

END
GO
