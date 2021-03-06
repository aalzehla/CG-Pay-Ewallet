USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[apiproc_api_log]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[apiproc_api_log] 
	@flag char(5) 
	,@log_id INT = NULL
	,@user_id nvarchar(max)=  null,
	@function_name varchar(100) = null
	,@request NVARCHAR(max) = NULL  
	,@response NVARCHAR(max) = NULL  
	,@from_ip_address varchar(20) =  NULL
	 ,@partner_Id VARCHAR(50) = NULL
	 ,@txn_id VARCHAR(50) = NULL 
	 ,@partner_tran_id VARCHAR(50) = NULL 

AS
DECLARE @log_sno VARCHAR(50)  
BEGIN
	--insert api log
	IF @flag = 'i'  
		BEGIN  
			-- select * from tbl_api_log     
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
			,@function_name  
			)  
  
			SET @log_sno = @@identity  
  
			SELECT @log_sno AS sno  
		END  

		--update tbl for req/res
	IF @flag = 'u'  
		BEGIN  
			UPDATE tbl_api_log  
			SET txn_id = isnull(@txn_id, txn_id)  
			,api_response = @response  
			,updated_local_date = GETDATE()  
			,updated_UTC_date = GETUTCDATE()  
			,updated_by = @user_id  
			,updated_nepali_date = [dbo].func_get_nepali_date(default)  
			,updated_ip = @from_ip_address  
			WHERE api_log_id = @log_id  
		END  

		--update txn id
	if @flag='ut'
	begin
		update tbl_api_log set txn_id=@txn_id where api_log_id=@log_id
	end

	if @flag='s'
	begin
		select api_request,api_response from tbl_api_log where api_log_id=@log_id
	end

	End


GO
