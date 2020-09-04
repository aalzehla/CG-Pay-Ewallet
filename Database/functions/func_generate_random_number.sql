-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
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

