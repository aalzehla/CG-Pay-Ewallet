USE [WePayNepal]
GO

/****** Object:  UserDefinedFunction [dbo].[func_generate_verify_code]    Script Date: 6/4/2020 11:30:37 PM ******/
DROP FUNCTION [dbo].[func_generate_verify_code]
GO

/****** Object:  UserDefinedFunction [dbo].[func_generate_verify_code]    Script Date: 6/4/2020 11:30:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:	ajar
-- Create date: 2020/06/04
-- Description:	generate random code
-- =============================================
CREATE FUNCTION [dbo].[func_generate_verify_code] 
(
	-- Add the parameters for the function here
	@length int = null
)
RETURNS varchar(100) 
AS
BEGIN
	Declare @stringCode varchar(200),@newId varchar(255)

	IF @length is null
	SET @length = 6

	SET @newId = (Select new_id from rndView)

	SET @stringCode = SUBSTRING(cast(ABS(CHECKSUM(@newId)) as varchar), 1, @length)

	RETURN @stringCode

END
GO


