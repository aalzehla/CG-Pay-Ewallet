USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_send_email_job]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[sproc_send_email_job]
@flag char(1) = null

AS
BEGIN
declare @profile_name varchar(512), @from_address varchar(512), @recipients varchar(512), @subject varchar(512), @body_format varchar(512), @body varchar(max), @email_id int, @total_email int
declare @copy_recipients VARCHAR(MAX) , @blind_copy_recipients VARCHAR(MAX),  @importance VARCHAR(6) ,  @sensitivity  VARCHAR(12), @TheMailID int, @sys_mailId int, @sysemail_Status int

	set @profile_name = 'Support Mail'

	select  @total_email = count(*) from tbl_email_request where email_send_status in ('n','p')
	if @total_email <= 0
		return
	

	if @flag = 'i'
	begin

			select top 1 @email_id = email_req_id,
				@sys_mailId = sys_mail_id,
				@from_address = email_send_by, 
				@recipients = email_send_to, 
				@copy_recipients = email_send_to_cc, 
				@blind_copy_recipients = email_send_to_bcc,
				@subject = email_subject, 
				@body = email_text, 
				@importance = isnull(is_important,'NORMAL'), 
				@sensitivity = isnull(email_sensitivity,'NORMAL')
		from tbl_email_request where 1 =1  and isnull(email_send_status,'n') = 'n' 

			EXEC msdb.dbo.sp_send_dbmail
			@profile_name = @profile_name,
			@from_address = @from_address,
			@recipients = @recipients,
			@copy_recipients = @copy_recipients,
			@subject = @subject,
			@body_format = 'HTML',
			@body = @body,
			--@importance = @importance, 
			--@sensitivity = @sensitivity,
			@mailitem_id = @TheMailID OUTPUT

			update tbl_email_request set sys_mail_id = @TheMailID, email_send_status = 'p' where email_req_id = @email_id
	end


	if @flag = 'u'
	begin

			select top 1 @email_id = email_req_id,
				@sys_mailId = sys_mail_id,
				@from_address = email_send_by, 
				@recipients = email_send_to, 
				@copy_recipients = email_send_to_cc, 
				@blind_copy_recipients = email_send_to_bcc,
				@subject = email_subject, 
				@body = email_text, 
				@importance = isnull(is_important,'NORMAL'), 
				@sensitivity = isnull(email_sensitivity,'NORMAL')
		from tbl_email_request where 1 =1  and isnull(email_send_status,'n') = 'p' 

		select  @sysemail_Status= sent_status from msdb.dbo.sysmail_mailitems  where mailitem_id = @sys_mailId		
		--select @sysemail_Status
		--return
		update tbl_email_request set email_send_status = case when @sysemail_Status  = 1 then 'y'
															  when @sysemail_Status  = 2 then 'n'
															  else email_send_status end 
															  where email_req_id = @email_id
	end
END


GO
