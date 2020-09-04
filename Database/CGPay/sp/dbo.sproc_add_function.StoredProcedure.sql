USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_add_function]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[sproc_add_function] (
	 @function_id VARCHAR(8)
	,@parent_function_id VARCHAR(8)
	,@function_text VARCHAR(200)
)
AS
IF NOT EXISTS (SELECT 'X' FROM tbl_application_functions WHERE function_id = @function_id)
BEGIN
	INSERT INTO tbl_application_functions (function_id, parent_menu_id, function_name,created_by)
	SELECT @function_id, @parent_function_id, @function_id,'system'
	PRINT 'Added function ' + @function_id
END	




GO
