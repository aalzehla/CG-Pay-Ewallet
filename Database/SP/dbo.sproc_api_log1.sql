USE [CGPay]
GO
/****** Object:  StoredProcedure [dbo].[sproc_api_log]    Script Date: 8/19/2020 7:40:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER     PROCEDURE [dbo].[sproc_api_log] @flag VARCHAR(2)  
 ,@log_id INT = NULL  
 ,@partner_Id VARCHAR(50) = NULL  
 ,@txn_id VARCHAR(50) = NULL  
 ,@partner_tran_id VARCHAR(50) = NULL  
 ,@request NVARCHAR(max) = NULL  
 ,@response NVARCHAR(max) = NULL  
 ,@user_id VARCHAR(50) = NULL  
 ,@func_Name VARCHAR(50) = NULL  
 ,@from_ip_address varchar(20) =  NULL  
AS  
DECLARE @log_sno VARCHAR(50)  
if @flag='s'
begin
	select api_request,api_response from tbl_api_log where api_log_id=@log_id
end

IF @flag = 'i'  
BEGIN  
 -- select * from DtaApiLog     
 INSERT INTO tbl_api_log(  
  partner_id  
  ,txn_id  
  ,partner_txn_id  
  ,api_request  
  ,api_response  
  ,created_UTC_date  
  ,created_local_date  
  ,created_nepali_date  
  ,created_ip  
  ,user_id  
  ,function_ame  
  )  
 VALUES (  
  @partner_Id  
  ,@txn_id  
  ,@partner_tran_id  
  ,@request  
  ,@response  
  ,GETUTCDATE()  
  ,GETDATE()  
  ,[dbo].func_get_nepali_date(default)  
  ,@from_ip_address  
  ,@user_id  
  ,@func_Name  
  )  
  
 SET @log_sno = @@identity  
  
 SELECT @log_sno AS sno  

END  

  if @flag='ut'
begin
	update tbl_api_log set partner_txn_id=@partner_id where api_log_id=@log_id
end

IF @flag = 'u'  
BEGIN  
 UPDATE tbl_api_log  
 SET txn_id = isnull(@txn_id, txn_id)  
  ,api_response = @response
  ,partner_txn_id=@partner_id  
  ,updated_local_date = GETDATE()  
  ,updated_UTC_date = GETUTCDATE()  
  ,updated_by = @user_id  
  ,updated_nepali_date = [dbo].func_get_nepali_date(default)  
  ,updated_ip = @from_ip_address  
 WHERE api_log_id = @log_id  
END  



GO
