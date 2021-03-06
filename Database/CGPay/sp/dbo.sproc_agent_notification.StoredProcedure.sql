USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_agent_notification]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[sproc_agent_notification] 
	@flag varchar(3) = null, 
	@user_id varchar(50) = null,
	@notification_id int = null,
	@update_flag char(1) =null,
	@formDate varchar(50) = null,
	@toDate varchar(50) = null
AS
Declare @sql varchar(max)
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @flag = 's' --select new notification
	BEGIN
		SET @sql = 'Select top 5 notification_id as id,notification_subject as subject,(DATENAME(m,created_local_date) +'' ''+ cast(day(created_local_date) as varchar) +'',''+ FORMAT(CAST(created_local_date AS datetime2), N''hh:mm tt'')  ) as CreatedDate,notification_body as notification,read_status readStatus from tbl_agent_notification where 1=1';

		IF (@user_id IS NOT NULL)
		BEGIN
			SET @sql =@sql + ' and notification_to ='''+ @user_id +'''';
		END

		SET @sql = @sql + ' and notification_status in (''y'',''n'') order by created_local_date desc';

		PRINT @sql;  
  
	    EXEC (@sql); 

	END

	IF @flag = 'us' --update read status and display status
	BEGIN	
		IF @update_flag = 'a' --update read status of all notification of agent
			BEGIN
				IF (@user_id IS NULL)
				BEGIN
					select '1' code, 'Agent id required' message;
					RETURN;
				END

				UPDATE tbl_agent_notification SET read_status ='y' where notification_to=@user_id;
				select '0' code , 'updated' message, 'r' Extra1 ;  --r for redirect
			END
		IF @update_flag = 'o' -- update one read status
			BEGIN
				IF (@notification_id is null or @notification_id = 0)
				BEGIN
					select '1' code, 'Notification id required' message;
					RETURN;
				END

				UPDATE tbl_agent_notification SET read_status ='y' where notification_id= @notification_id;
				select '0' code , 'updated' message;
			END
		
		IF @update_flag = 'd' -- update display status of all notification
			BEGIN
				IF (@user_id IS NULL)
				BEGIN
					select '1' code, 'Agent id required' message;
					RETURN;
				END

				UPDATE tbl_agent_notification SET notification_status ='d',read_status ='y' where notification_to=@user_id;
				select '0' code , 'updated' message ,'r' Extra1 ;  --r for redirect
			END
		IF @update_flag = 's' -- update single display status
			BEGIN
				IF (@notification_id is null or @notification_id = 0)
				BEGIN
					select '1' code, 'Notification id required' message;
					RETURN;
				END
				
				UPDATE tbl_agent_notification SET notification_status ='d',read_status ='y' where notification_id=@notification_id;
			
				select '0' code , 'updated'  message,'r' Extra1 ;
			END
		
	END

	IF @flag = 'sa' --select all notification
	BEGIN
	
		SET @sql = 'Select top 20 notification_id as id,notification_subject as subject,CONVERT(VARCHAR, created_local_date,23 ) as CreatedDate,notification_body as notification,read_status readStatus,notification_type as type from tbl_agent_notification where 1=1';
		
		IF (@user_id IS NOT NULL)
		BEGIN
			SET @sql =@sql + ' and notification_to ='''+ @user_id +'''';
		END

		IF (@formDate IS NOT NULL)
		BEGIN
			if nullif(@toDate ,'') is null
			set @toDate=format(GETDATE(),'yyyy-MM-dd')
		
			SET @sql =@sql + ' and created_local_date between '''+ format(convert(date, @formDate, 120),'yyyy-MM-dd') + ''' and '''+ @toDate +' 23:59:59.997'''
			
		END

		SET @sql = @sql + ' and notification_status in (''y'',''n'') order by created_local_date desc';

		PRINT @sql;  
  
	    EXEC (@sql);
	END

END


GO
