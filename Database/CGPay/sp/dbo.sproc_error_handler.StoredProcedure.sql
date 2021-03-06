USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_error_handler]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sproc_error_handler] (
	@error_code VARCHAR(10) = NULL
	,@id VARCHAR(50) = NULL
	,@error_desc NVARCHAR(550) = NULL
	,@error_script NVARCHAR(150) = NULL
	,@url NVARCHAR(100) = NULL
	,@query_string VARCHAR(200) = NULL
	,@error_source VARCHAR(300) = NULL
	,@error_category VARCHAR(200) = NULL
	,@msg VARCHAR(100) = NULL
	/*            
  0: Nothing            
  1: Self Refresh            
  2: Redirect to desired url            
 */
	)
AS
SET NOCOUNT ON

--select * from DtaErrorLogsSQL    
INSERT INTO tbl_Error_log_sql (
	sql_error_desc
	,sql_error_script
	,sql_query_string
	,sql_error_category
	,sql_error_source
	,sql_error_UTC_date
	,sql_error_local_date
	,sql_error_nepali_date
	)
VALUES (
	@msg
	,@error_script
	,@query_string
	,@error_category
	,@error_source
	,GETUTCDATE()
	,GETDATE()
	,dbo.func_get_nepali_date(DEFAULT)
	)

SELECT @error_code CODE
	,@msg Message
	,@ID id
	,@msg msg
	,@error_script errorType
	,@URL url
	,@error_source ErrorSource
	,@error_category ErrorCategory
	, @error_code errorcode


GO
