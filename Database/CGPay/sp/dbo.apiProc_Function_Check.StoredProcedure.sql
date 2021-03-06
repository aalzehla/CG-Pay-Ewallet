USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[apiProc_Function_Check]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[apiProc_Function_Check] @function_name VARCHAR(20)
AS
BEGIN
	IF NOT EXISTS (
			SELECT 'X'
			FROM tbl_Api_List
			WHERE function_Name = @function_name and Status = 'y'
			)
	BEGIN
		SELECT '157' code
			,'No Matching Function Name' message
	END
	ELSE
	BEGIN
		SELECT '0' code
			,'Success' message
	END
END



GO
