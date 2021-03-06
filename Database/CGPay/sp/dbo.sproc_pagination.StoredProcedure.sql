USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_pagination]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sproc_pagination] (
	@table_name VARCHAR(60)
	,@datatable BIT = 1
	,@page_number VARCHAR(10) = 0
	,@no_of_records VARCHAR(10) = 10
	
	)
AS
BEGIN
	DECLARE @sql NVARCHAR(max) = NULL

	

	SET @sql = 'DECLARE @RECORD INT = 0;
	SELECT @RECORD = CAST(COUNT(row_id) AS INT)  
	from ' + @table_name + ';

	SELECT *,@RECORD total_no_of_records, ' + isnull(@no_of_records, '10') + ' no_of_records , case when  @RECORD  % '+ isnull(@no_of_records, '10') +'=0 then 10 else @RECORD  % '+ isnull(@no_of_records, '10') +' end  showing_records_per_page from ' + @table_name

	IF isnull(@datatable, 1) = 0
		SET @sql += ' ORDER BY row_id
	OFFSET ' + isnull(@page_number, '0') + '*' + isnull(@no_of_records, '10') + ' ROWS FETCH NEXT ' + isnull(@no_of_records, '10') + ' ROWS ONLY;'

	PRINT (@sql)

	EXEC (@sql)
END




GO
