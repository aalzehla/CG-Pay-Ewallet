-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Alter PROCEDURE dbo.sproc_send_email_job


AS
BEGIN
declare @profile_name varchar(512), @from_address varchar(512), @recipients varchar(512), @subject varchar(512), @body_format varchar(512), @body varchar(max)
declare @copy_recipients VARCHAR(MAX) , @blind_copy_recipients VARCHAR(MAX),  @importance VARCHAR(6) ,  @sensitivity  VARCHAR(12)

	set @profile_name = 'Support'


	select top 1 @from_address = email_send_by, 
				@recipients = email_send_to, 
				@copy_recipients = email_send_to_cc, 
				@blind_copy_recipients = email_send_to_bcc,
				@subject = email_subject, 
				@body = email_text, 
				@importance = isnull(is_important,'NORMAL'), 
				@sensitivity = isnull(email_sensitivity,'NORMAL')
	from tbl_email_request where 1 =1  and email_send_status = 'n' 


			EXEC msdb.dbo.sp_send_dbmail
			@profile_name = @profile_name,
			@from_address = @from_address,
			@recipients = @recipients,
			@copy_recipients = @copy_recipients,
			@subject = @subject,
			@body_format = 'HTML',
			@body = @body,
			@importance = @importance, 
			@sensitivity = @sensitivity

END
GO


