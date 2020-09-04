USE [Wepaynepal]
GO
/****** Object:  UserDefinedFunction [dbo].[func_generate_random_number]    Script Date: 8/8/2020 3:02:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[func_generate_random_number]
(
	 @new_id VARCHAR(255) = null
)
RETURNS Varchar(100) 
AS
BEGIN
Declare @Password varchar(100)
--SELECT @new_id = NewID()


SELECT @Password = CAST((ABS(CHECKSUM(@new_id))%10) AS VARCHAR(1)) + 
CHAR(ASCII('a')+(ABS(CHECKSUM(@new_id))%25)) +
CHAR(ASCII('A')+(ABS(CHECKSUM(@new_id))%25)) +
LEFT(@new_id,3)


return @PASSWORD

END


GO
