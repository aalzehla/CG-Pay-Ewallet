USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_errors]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sproc_errors]        
@flag   VARCHAR(10),        
@user   VARCHAR(50),        
@row_Id   BIGINT   = NULL,        
@error_Page  VARCHAR(100) = NULL,        
@error_Msg  VARCHAR(MAX) = NULL,        
@error_Detail VARCHAR(MAX) = NULL,
@ip_address VARCHAR (50) =NULL
        
AS        
SET NOCOUNT ON;        
        
DECLARE @InvalidCount INT,@LogId INT         
        
IF @FLAG = 'i'        
BEGIN        
 INSERT INTO tbl_error_log(error_page,error_msg,error_detail,created_by,error_local_date,error_UTC_date,error_nepali_date,ip_address)        
 SELECT @error_Page,@error_Msg,@error_Detail,@USER, GETDATE(), GETUTCDATE(), dbo.func_get_nepali_date(default) ,@ip_address       
        
 SET @row_Id = SCOPE_IDENTITY()        
        
 SELECT @InvalidCount = COUNT('A') FROM tbl_error_log(NOLOCK) WHERE created_by = @user AND ISNULL(is_active,'N') = 'Y'        
        
 IF (SELECT ISNULL(apperror,0) FROM tbl_invalid_attempt_limit(NOLOCK) WHERE ISNULL(is_active,'N') = 'Y') >= ISNULL(@InvalidCount,0)        
 BEGIN        
   --PP_INVALID_ATTEMPTS_LOGS --tblFraudLogs        
  INSERT INTO tbl_Invalid_Attempt_Log(page_name,log_type,attempt_details,from_ip_address,from_browser,created_by,is_active)        
  SELECT 'Blocked','Error','ACCOUNT IS BLOCKED DUE TO TOO MANY ERROR ATTEMPT','','',@USER,'Y'        
        
          
  UPDATE tbl_user_detail SET is_currently_logged_in = 'N' WHERE user_id = @user        
        
  EXEC sproc_Error_handler @error_Code='1',@msg='Error', @Error_Source = 'sproc_errors @FLAG = ''i''', @id='Error'        
          
  RETURN        
 END        
         
 EXEC sproc_Error_handler @error_Code='0',@msg='RECORD ADDED SUCCESSFULLY', @Error_Source ='@FLAG = ''i''', @id=@Row_Id        
         
 RETURN        
END        
ELSE IF @FLAG ='detail'        
BEGIN        
 SELECT error_page as ERRORPAGE, error_msg as ERRORMSG, error_detail, created_by, error_local_date as CREATEDDATE FROM tbl_Error_Log (NOLOCK) WHERE error_id = @Row_Id        
 RETURN        
END 

GO
