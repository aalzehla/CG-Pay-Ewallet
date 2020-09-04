USE [CGPay]
GO
/****** Object:  StoredProcedure [dbo].[sproc_payment_gateway_transaction]    Script Date: 8/8/2020 11:51:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
-- =============================================    
ALTER  
   
  
 PROCEDURE [dbo].[sproc_payment_gateway_transaction]  
 -- Add the parameters for the stored procedure here    
 @flag CHAR(3)  
 ,@pmt_txn_id INT = NULL  
 ,@service_charge DECIMAL(18, 2) = NULL  
 ,@amount DECIMAL(18, 2) = NULL  
 ,@card_no VARCHAR(20) = NULL  
 ,@remarks VARCHAR(max) = NULL  
 ,@user_id INT = NULL  
 ,@gateway_status VARCHAR(50) = NULL  
 ,@pmt_gateway_id INT = NULL  
 ,@action_user VARCHAR(100) = NULL  
 ,@action_browser NVARCHAR(max) = NULL  
 ,@error_code VARCHAR(10) = NULL  
 ,@action_ip VARCHAR(50) = NULL  
 ,@pmt_gateway_txn_id VARCHAR(50) = NULL  
 ,@merchat_txn_id VARCHAR(50) = NULL  
 ,@gateway_process_id VARCHAR(100) = NULL  
 ,@pmt_gateway_name VARCHAR(200) =null 
 ,@txn_type VARCHAR(200)  =null
AS  
DECLARE @card_expiry_date DATE  
 ,@user_name VARCHAR(100)  
 ,@process_id VARCHAR(200)  
 ,@type VARCHAR(30)  
 ,@card_issuer VARCHAR(50)  
 ,@name_on_card VARCHAR(50)  
 ,@email VARCHAR(50)  
 ,@mobile VARCHAR(50)  
 ,@agent_id VARCHAR(50)  
 ,@gateway_timestamp VARCHAR(200)  
 ,@status VARCHAR(10)  
 ,@total_amount DECIMAL(18, 2)  
 ,@agent_name varchar(100)  
 ,@agent_parent_id varchar(100)  
  
--[pmt_gateway_txn_id] [varchar](20) NULL,    
--[gateway_timestamp] [varchar](20) NULL,    
--[gateway_status] [varchar](50) NULL,    
--[process_id] [varchar](max) NULL,    
--[gateway_process_id] [varchar](max) NULL,    
--[type] [varchar](50) NULL,    
--[error_code] [varchar](10) NULL,    
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;  
  
 IF @flag = 'i'  
 BEGIN  
  IF EXISTS (  
    SELECT 'x'  
    FROM tbl_payment_gateway_transaction  
    WHERE pmt_gateway_txn_id = @pmt_gateway_txn_id  
     AND STATUS = 'pending'  
    )  
  BEGIN  
   SELECT '1' Code  
    ,'Transaction already exists, status pening' Message  
    ,NULL Id  
  
   RETURN  
  END  
  
  IF EXISTS (  
    SELECT 'x'  
    FROM tbl_payment_gateway_transaction  
    WHERE pmt_gateway_txn_id = @pmt_gateway_txn_id  
     AND STATUS = 'received'  
    )  
  BEGIN  
   SELECT '1' Code  
    ,'Transaction already exists' Message  
    ,NULL Id  
  
   RETURN  
  END  
  
  SELECT @agent_id = agent_id  
   ,@user_name = user_name  
   ,@mobile = user_mobile_no  
   ,@email = user_email  
  FROM tbl_user_detail  
  WHERE user_id = @user_id  
  
  SET @total_amount = @amount  
  SET @process_id = replace(NEWID(), '-', '_')  
  
  INSERT INTO tbl_payment_gateway_transaction (  
   [amount]  
   ,[service_charge]  
   ,[total_amount]  
   ,[status]  
   ,[remarks]  
   ,[email]  
   ,[mobile]  
   ,[agent_id]  
   ,[user_id]  
   ,[user_name]  
   ,[process_id]  
   ,[created_UTC_date]  
   ,[created_local_date]  
   ,[created_nepali_date]  
   ,[created_by]  
   ,[createdplatform]  
   ,[created_ip]  
   )  
  VALUES (  
   @amount  
   ,@service_charge  
   ,@total_amount  
   ,'pending'  
   ,@remarks  
   ,@email  
   ,@mobile  
   ,@agent_id  
   ,@user_id  
   ,@user_name  
   ,@process_id  
   ,GETUTCDATE()  
   ,GETDATE()  
   ,dbo.func_get_nepali_date(GETDATE())  
   ,@action_user  
   ,@action_browser  
   ,@action_ip  
   )  
  
  SELECT '0' Code  
   ,'Success' Message  
   ,SCOPE_IDENTITY() Id  
  
  RETURN  
 END  
  
 IF @flag = 'u'  
 BEGIN  
  IF EXISTS (  
    SELECT 'x'  
    FROM tbl_payment_gateway_transaction  
    WHERE pmt_gateway_txn_id = @pmt_gateway_txn_id  
     AND STATUS = 'pending'  
    )  
  BEGIN  
   SELECT '1' Code  
    ,'Transaction already exists, status pending' Message  
    ,NULL Id  
  
   RETURN  
  END  
  
  IF EXISTS (  
    SELECT 'x'  
    FROM tbl_payment_gateway_transaction  
    WHERE pmt_gateway_txn_id = @pmt_gateway_txn_id  
    and pmt_txn_id = @pmt_txn_id  
     AND STATUS = 'Recieved'  
     and gateway_status = 'Success'  
    )  
  BEGIN  
   SELECT '1' Code  
    ,'Transaction already exists' Message  
    ,NULL Id  
  
   RETURN  
  END  
  
  UPDATE tbl_payment_gateway_transaction  
  SET pmt_gateway_id = @pmt_gateway_id  
   ,pmt_gateway_name = @pmt_gateway_name  
   ,pmt_gateway_txn_id = @pmt_gateway_txn_id  
   ,gateway_timestamp = @gateway_timestamp  
   ,gateway_status = @gateway_status  
   ,STATUS = 'Recieved'  
   ,gateway_process_id = @gateway_process_id  
   ,updated_by = @action_user  
   ,updated_UTC_date = GETUTCDATE()  
   ,updated_local_date = GETDATE()  
   ,updated_nepali_date = dbo.func_get_nepali_date(GETDATE())  
   ,updated_ip = @action_ip  
  WHERE pmt_txn_id = @pmt_txn_id and gateway_status is null  
  
  IF @agent_id IS NULL  
  BEGIN  
   SELECT @agent_id = u.agent_id  
    ,@amount = pmt.amount  
    ,@agent_parent_id  = parent_id  
    ,@agent_name =  agent_name  
   FROM tbl_user_detail u  
   Join tbl_agent_detail ad on ad.agent_id = u.agent_id  
   JOIN tbl_payment_gateway_transaction pmt ON pmt.created_by = u.user_name  
   WHERE pmt.pmt_txn_id = @pmt_txn_id  
  END  
  
  IF @gateway_status <> 'Success'  
  BEGIN  
   SELECT 1 code  
    ,'Couldn''t get response from gateway' Message  
    ,NULL id  
  
   RETURN  
  END  
    
  declare @oldGatewayStatus varchar(20)  
  select @oldGatewayStatus =  gateway_status from tbl_payment_gateway_transaction where pmt_gateway_txn_id = @pmt_gateway_txn_id  
  
  IF @gateway_status = 'Success'  
  BEGIN  
   --SELECT 0 code  
   -- ,'success' message  
   -- ,*  
   --FROM tbl_payment_gateway_transaction p  
   --JOIN tbl_agent_detail ad ON ad.agent_id = p.agent_id  
   --JOIN tbl_user_detail u ON u.user_id = p.user_id  
   --WHERE pmt_txn_id = @pmt_txn_id  
  
   UPDATE tbl_agent_detail  
   SET available_balance = isnull(available_balance, 0) + isnull(@amount, 0)  
   WHERE agent_id = @agent_id  
  
   INSERT INTO [dbo].[tbl_agent_balance] (  
    [agent_id]  
    ,[agent_parent_id]  
    ,[agent_name]  
    ,[amount]  
    ,[currency_code]  
    ,[agent_remarks]  
    ,[user_id]  
    ,[txn_type]  
    ,[txn_mode]  
    ,[txn_id]  
    ,[pmt_gateway_id]  
    ,[pmt_gateway_txn_id]  
	,bank_name
    ,[created_UTC_date]  
    ,[created_local_date]  
    ,[created_nepali_date]  
    ,[created_by]  
    ,[created_ip]  
    ,[created_platform]  
    )  
   VALUES (  
     @agent_id  
     ,@agent_parent_id  
     ,@agent_name  
     ,@amount  
     ,'NPR'  
     ,'Fund Load of NPR '+cast(@amount as varchar) --+ ' from ' +@pmt_gateway_name  
     ,@user_id  
     ,'Dig'  
     ,'CR'        
     ,@merchat_txn_id  
     ,@pmt_gateway_id  
     ,@pmt_gateway_txn_id
	 ,@pmt_gateway_name
     ,GETUTCDATE()  
     ,GETDATE()  
     ,dbo.func_get_nepali_date(default)  
     ,@action_user  
     ,@action_ip  
     ,'Web'  
    )   
  
   RETURN  
  END  
  
  SELECT '0' Code  
   ,'Success' Message  
   ,@pmt_txn_id Id;  
  
  --@pmt_gateway_txn_id  pmtGatewayTxnid,    
  --  @pmt_txn_id TxnId,    
  --  status TxnStatus,    
  --  amount Amount,    
  --  gateway_status GatewayStatus,    
  --  agent_id ,    
  --  user_name username    
  --  from tbl_payment_gateway_transaction    
  --  where pmt_txn_id = @pmt_txn_id;    
  RETURN  
 END  
  
 IF @flag = 'c'  
 BEGIN  
  IF @pmt_gateway_txn_id IS NULL  
  BEGIN  
   SELECT '1' Code  
    ,'Gateway Txn Id is required' Message  
    ,NULL Id  
  
   RETURN  
  END  
  
  IF @merchat_txn_id IS NULL  
  BEGIN  
   SELECT '1' Code  
    ,'Merchant Txn Id is required' Message  
    ,NULL Id  
  
   RETURN  
  END  
  
  IF EXISTS (  
    SELECT 'x'  
    FROM tbl_payment_gateway_transaction  
    WHERE pmt_gateway_txn_id = @pmt_gateway_txn_id  
     AND pmt_txn_id = @merchat_txn_id  
    )  
  BEGIN  
   SELECT '0' Code  
    ,'Already Received' Message  
    ,NULL id  
  
   RETURN  
  END  
  ELSE IF NOT EXISTS (  
    SELECT 'x'  
    FROM tbl_payment_gateway_transaction  
    WHERE pmt_txn_id = @merchat_txn_id  
    )  
  BEGIN  
   SELECT '1' code  
    ,'Transaction Not Found' message  
    ,NULL id  
  
   RETURN  
  END  
  ELSE  
   SELECT '0' code  
    ,'transaction found' message  
    ,NULL id  
  
  RETURN  
 END  
  
 IF @flag = 's'  
 BEGIN  
  IF NOT EXISTS (  
    SELECT 'x'  
    FROM tbl_payment_gateway_transaction  
    WHERE pmt_gateway_txn_id = @pmt_gateway_txn_id       AND pmt_txn_id = @merchat_txn_id  
    )  
  BEGIN  
   SELECT '0' Code  
    ,'Transaction not found' Message  
    ,NULL id  
  
   RETURN  
  END  
  
  SELECT '0' Code  
   ,'Success' Message  
   ,pmt_gateway_txn_id  
   ,pmt_txn_id  
   ,STATUS TxnStatus  
   ,amount Amount  
   ,gateway_status  
   ,agent_id  
   ,user_name  
  FROM tbl_payment_gateway_transaction  
  WHERE pmt_txn_id = @merchat_txn_id  
   AND pmt_gateway_txn_id = @pmt_gateway_txn_id;  
 END  
  
 IF @flag = 'up'  
 BEGIN  
  IF @gateway_process_id IS NULL  
  BEGIN  
   SELECT '1' Code  
    ,'Gateway Process Id' Message  
    ,NULL Id  
  
   RETURN  
  END  
  
  IF @merchat_txn_id IS NULL  
  BEGIN  
   SELECT '1' Code  
    ,'Merchant Txn Id is required' Message  
    ,NULL Id  
  
   RETURN  
  END  
  
  UPDATE tbl_payment_gateway_transaction  
  SET gateway_process_id = @gateway_process_id  
  WHERE pmt_txn_id = @merchat_txn_id  
  
  SELECT '0' Code  
   ,'Gateway Process Id Updated'  
   ,@merchat_txn_id Id  
 END  
END  
  
  
  