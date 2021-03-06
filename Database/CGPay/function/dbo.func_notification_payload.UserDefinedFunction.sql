USE [Wepaynepal]
GO
/****** Object:  UserDefinedFunction [dbo].[func_notification_payload]    Script Date: 8/8/2020 3:02:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[func_notification_payload] (
	@notiId int,
	@subscriber_no VARCHAR(100) = null,
	@amount VARCHAR(100)  = null
	)
RETURNS VARCHAR(max)
AS
BEGIN
declare @notification_subject VARCHAR(500) 
declare 	@notification_body VARCHAR(max) 
declare 	@notification_type VARCHAR(100) 
declare 	@created_date datetime 
declare 	@image_url VARCHAR(max) 
declare 	@available_balance VARCHAR(100) 	
declare 	@receiver_id VARCHAR(100) 

	-- Declare the return variable here
	DECLARE @dataPayload VARCHAR(max);

SELECT @notification_subject = notification_subject
	,@notification_body = notification_body
	,@notification_type = notification_type
	,@created_date = created_local_date
	,@image_url = notification_image_url
	,@available_balance = Remaining_Balance
	,@receiver_id = notification_to
FROM tbl_agent_notification
WHERE notification_id =@notiId

	-- Add the T-SQL statements to compute the return value here
	set @dataPayload = '{'
	set @dataPayload += '"notification_subject" : "'+isnull(@notification_subject, '') +'",'
	set @dataPayload += '"notification_body" :  "'+isnull(@notification_body, '') +'",'
	set @dataPayload += '"notification_type" :  "'+isnull(@notification_type , '')+'",'
	set @dataPayload += '"created_date" :  "'+format(@created_date,'yyyy-MM-dd') +'",'
	set @dataPayload += '"image_url" :  "'+isnull(@image_url, '') +'",'
	set @dataPayload += '"available_balance":  "'+isnull(@available_balance, '') +'",'
	set @dataPayload += '"receiver_id" :  "'+isnull(@receiver_id, '') +'",'
	set @dataPayload += '"subscriber_no":  "'+isnull(@subscriber_no, '') +' ",'
	set @dataPayload += '"amount" :  "'+isnull(@amount, '') +' "'
	set @dataPayload += '}'
	

	-- Return the result of the function
	RETURN  @dataPayload
END



GO
