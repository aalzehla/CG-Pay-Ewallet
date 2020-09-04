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
CREATE
	OR

ALTER PROCEDURE [dbo].[sproc_msg_bulk_topup] @flag CHAR(3)
	,@processID VARCHAR(200)
	,@actionuser VARCHAR(200) = NULL
	,@dataImportSource VARCHAR(200) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @flag = 's' -- select error
	BEGIN
		SELECT TOP 10 *
		FROM tbl_data_import_status
		WHERE data_import_source = @dataImportSource
			AND created_by = @actionUser
		ORDER BY created_local_date DESC

		RETURN
	END

	IF @flag = 'sd'  --select error detail
	BEGIN
		SELECT *
		FROM tbl_Data_import_status_detail
		WHERE process_id = @processId
	END

	IF @flag = 'c' --clear error
	BEGIN
		DELETE
		FROM tbl_data_import_status
		WHERE data_import_source = @dataImportSource
			AND created_by = @actionUser

		Delete from tbl_data_import_status_detail 		WHERE data_import_source = @dataImportSource
			AND created_by = @actionUser

		SELECT 0 code
			,'deleted succesfully'
			,NULL id

		RETURN
	END
END
GO


