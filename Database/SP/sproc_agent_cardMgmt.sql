USE [WePayNepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_agent_cardMgmt]    Script Date: 8/5/2020 1:03:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
    
-- =============================================                
-- Author:  <Author,,samir khadka>                
-- Create date: <14/05/2020,,>                
-- Description: <agent card management,,>                
-- =============================================                
ALTER    
      
    
 PROCEDURE [dbo].[sproc_agent_cardMgmt] @flag CHAR(3) = NULL    
 ,@agent_id INT = NULL    
 ,@user_name VARCHAR(50) = NULL    
 ,@card_no VARCHAR(20) = NULL    
 ,@card_uid NVARCHAR(max) = NULL    
 ,@card_type VARCHAR(50) = NULL    
 ,@card_txn_type VARCHAR(50) = NULL    
 ,@is_active CHAR(3) = NULL    
 ,@action_user VARCHAR(50) = NULL    
 ,@issue_date DATETIME = NULL    
 ,@user_mobile_no VARCHAR(10) = NULL    
 ,@user_email VARCHAR(20) = NULL    
 ,@created_ip VARCHAR(30) = NULL    
 ,@req_id INT = NULL    
 ,@req_status VARCHAR(20) = NULL    
 ,@user_id INT = NULL    
 ,@requested_amount DECIMAL(18, 2) = NULL    
 ,@card_id INT = NULL    
 ,@transfer_to_mobile VARCHAR(10) = NULL    
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from                
 -- interfering with SELECT statements.                
 SET NOCOUNT ON;    
    
 DECLARE @sql VARCHAR(max)    
  ,@new_card_no VARCHAR(100)    
  ,@id INT    
  ,@available_balance DECIMAL(18, 2)    
  ,@available_card_balance DECIMAL(18, 2)    
  ,@transfer_to_user_id INT;    
 DECLARE @transfer_to_agent_id INT    
  ,@transfer_to_user_name VARCHAR(250)    
  ,@desc VARCHAR(max)   
  ,@agent_name varchar(512)
    
 -- check if user exists               
 IF @user_id IS NOT NULL    
 BEGIN    
  IF NOT EXISTS (    
    SELECT 'x'    
    FROM tbl_user_detail u    
    JOIN tbl_agent_detail a ON a.agent_id = u.agent_id    
    WHERE u.user_id = @user_id    
    )    
  BEGIN    
   SELECT '1' Code    
    ,'User Not Found' message    
    ,NULL id    
    
   RETURN    
  END    
  ELSE    
  BEGIN    
   SELECT @available_balance = available_Balance    
   FROM tbl_user_detail u    
   JOIN tbl_agent_detail a ON a.agent_id = u.agent_id    
   WHERE u.user_id = @user_id    
    
   IF @available_balance < @requested_amount    
   BEGIN    
    SELECT '1' code    
     ,'User Balance is less than the Card requested Amount' message    
     ,NULL id    
    
    RETURN    
   END    
  END    
 END    
    
 IF @requested_amount < 0    
 BEGIN    
  SET @requested_amount = @requested_amount * - 1    
 END    
    
 SET @new_card_no = '1000' + cast(convert(NUMERIC(12, 0), rand() * 899999999999) + 100000000000 AS VARCHAR)    
    
 IF @flag = 's' --select all cards or by username                
 BEGIN    
  SELECT a.agent_id    
   ,a.agent_name    
   ,u.user_id    
   ,u.user_email    
   ,u.user_mobile_no    
   ,ac.card_id    
   ,ac.card_no    
   ,    
   --case when ac.card_type = 1 then 'Virtual'    
   --when ac.card_type = 2 then 'Gift'    
   --when ac.card_type = 4 then 'Prepaid'    
   --when ac.card_type = 3 then 'Discount'else    
   --ac.card_type end     
   ac.card_type    
   ,ac.card_issued_date    
   ,ac.card_expiry_date    
   ,ac.is_active    
   ,u.full_name    
   ,ac.amount AS available_balance    
   ,ac.is_transfer    
   ,ac.transfer_to    
  --a.available_balance           
  FROM tbl_user_detail u    
  JOIN tbl_agent_detail a ON a.agent_id = u.agent_id    
  JOIN tbl_agent_card_management ac ON ac.agent_id = a.agent_id    
  WHERE u.user_id = @user_id    
      
  UNION    
      
  SELECT a.agent_id    
   ,a.agent_name    
   ,u.user_id    
   ,u.user_email    
   ,u.user_mobile_no    
   ,ac.card_id    
   ,ac.card_no    
   ,    
   --case when ac.card_type = 1 then 'Virtual'    
   --when ac.card_type = 2 then 'Gift'    
   --when ac.card_type = 4 then 'Prepaid'    
   --when ac.card_type = 3 then 'Discount'else    
   --ac.card_type end     
   ac.card_type    
   ,ac.card_issued_date    
   ,ac.card_expiry_date    
   ,ac.is_active    
   ,u.full_name    
   ,ac.amount AS available_balance    
   ,ac.is_transfer    
   ,ac.transfer_to    
  --a.available_balance           
  FROM tbl_user_detail u    
  JOIN tbl_agent_detail a ON a.agent_id = u.agent_id    
  JOIN tbl_agent_card_management ac ON ac.agent_id = a.agent_id    
  WHERE ac.transfer_to = @user_id    
 END    
    
 --insert/add cards for agent/customer                
 IF @flag = 'i'    
 BEGIN    
  IF EXISTS (    
    SELECT 'x'    
    FROM tbl_agent_card_management    
    WHERE card_no = @new_card_no    
    )    
  BEGIN    
   SELECT '1' code    
    ,'Card No already Exists' message    
    ,NULL id    
    
   RETURN    
  END    
    
  INSERT INTO tbl_agent_card_management (    
   agent_id    
   ,user_id    
   ,user_name    
   ,card_no    
   ,card_type    
   ,card_issued_date    
   ,card_expiry_date    
   ,card_txn_type    
   ,is_active    
   ,created_by    
   ,created_local_date    
   ,created_utc_date    
   ,created_nepali_date    
   )    
  VALUES (    
   @agent_id    
   ,@user_id    
   ,@user_name    
   ,@new_card_no    
   ,@card_type    
   ,GETDATE()    
   ,DATEADD(year, 4, GETDATE())    
   ,@card_txn_type    
   ,'y'    
   ,@action_user    
   ,GETDATE()    
   ,GETUTCDATE()    
   ,dbo.func_get_nepali_date(DEFAULT)    
   )    
    
  SELECT '0' Code    
   ,'Card Issued Successfully' message    
   ,@user_id id    
    
  RETURN    
 END    
    
 IF @flag = 'u'    
 BEGIN    
  IF NOT EXISTS (    
    SELECT 'x'    
    FROM tbl_agent_card_management    
    WHERE card_no = @card_no    
    )    
  BEGIN    
   SELECT '1' code    
    ,'Card Detail Not Found' message    
    ,NULL id    
    
   RETURN    
  END    
    
  IF EXISTS (    
    SELECT 'x'    
    FROM tbl_agent_card_management    
    WHERE card_no = @card_no    
     AND isnull(is_active, 'n') = 'n'    
    )    
  BEGIN    
   SELECT '1' Code    
    ,'Card Deactivated, please activate the card first to continue' message    
    ,NULL id    
    
   RETURN    
  END    
    
  UPDATE tbl_agent_card_management    
  SET card_type = Isnull(@card_type, card_type)    
   ,card_txn_type = Isnull(@card_txn_type, card_type)    
  WHERE card_no = @card_no    
   AND user_id = @user_id    
    
  SELECT '0' code    
   ,'Card Details Succesfully activated' message    
   ,NULL id    
    
  RETURN    
 END --update card details/ only card type, card txn type can be updated                
    
 IF @flag = 'e' -- enable/disable card                
 BEGIN    
  IF NOT EXISTS (    
    SELECT 'x'    
    FROM tbl_agent_card_management    
    WHERE card_no = @card_no    
    )    
  BEGIN    
   SELECT '1' code    
    ,'Card Detail Not Found' message    
    ,NULL id    
    
   RETURN    
  END    
  ELSE    
  BEGIN    
   UPDATE tbl_agent_card_management    
   SET is_active = CASE     
     WHEN is_active = 'y'    
      THEN 'n'    
     WHEN is_active = 'n'    
      THEN 'y'    
     END    
   WHERE card_no = @card_no    
    AND user_id = @user_id    
    
   SELECT '0' code    
    ,'Card Status changed succesfully' message    
    ,NULL id    
    
   RETURN    
  END    
 END    
    
 IF @flag = 'r' --request card                
 BEGIN    
  IF @user_id IS NULL    
  BEGIN    
   SELECT '1' code    
    ,'User Id is required' message    
    ,NULL id    
    
   RETURN    
  END    
  ELSE    
  BEGIN    
   SELECT @user_email = user_email    
    ,@user_mobile_no = user_mobile_no    
    ,@agent_id = a.agent_id    
    ,@available_balance = available_balance   
	,@agent_name = a.agent_name
   FROM tbl_user_Detail u    
   JOIN tbl_agent_detail a ON a.agent_id = u.agent_id    
   WHERE u.user_id = @user_id    
  END    
    
  IF @available_balance < @requested_amount    
  BEGIN    
   SELECT '1' Code    
    ,'Your available balance is less than the requested Balance' Message    
    ,NULL id    
    
   RETURN    
  END    
    
  IF @requested_amount < 100  or @requested_amount is null  
  BEGIN    
   SELECT '1' Code    
    ,'Your requested balance is invalid' Message    
    ,NULL id    
    
   RETURN    
  END    
  
  IF @card_type IS NULL    
  BEGIN    
   SELECT '1' code    
    ,'Card Type is required' message    
    ,NULL id    
    
   RETURN    
  END    
    
  INSERT INTO tbl_agent_card_request (    
   user_name    
   ,user_mobile_no    
   ,user_email    
   ,request_status    
   ,created_local_date    
,created_UTC_Date    
   ,created_by    
   ,created_ip    
   ,Card_type    
   ,requested_amount    
   )    
  VALUES (    
   @user_name    
   ,@user_mobile_no    
   ,@user_email    
   ,'Approved'    
   ,GETDATE()    
   ,GETUTCDATE()    
   ,@action_user    
   ,@created_ip    
   ,@card_type    
   ,@requested_amount    
   )    
    
  INSERT INTO tbl_agent_card_management (    
   user_id    
   ,user_name    
   ,agent_id    
   ,card_no    
   ,card_type    
   ,is_active    
   ,card_issued_date    
   ,card_expiry_date    
   ,created_by    
   ,created_local_date    
   ,created_utc_date    
   ,created_nepali_date    
   ,amount    
   )    
  VALUES (    
   @user_id    
   ,@user_name    
   ,@agent_id    
   ,@new_card_no    
   ,@card_type    
   ,'Y'    
   ,GETDATE()    
   ,DATEADD(YEAR, 4, GETDATE())    
   ,@action_user    
   ,GETDATE()    
   ,GETUTCDATE()    
   ,dbo.func_get_nepali_date(DEFAULT)    
   ,@requested_amount    
   )    
  
   set @card_id = SCOPE_IDENTITY()  
    
  UPDATE tbl_agent_detail    
  SET available_balance = isnull(available_balance, 0) - @requested_amount    
  WHERE agent_id = @agent_id    
    
  --insert into tbl_agent_balance      
  INSERT INTO tbl_agent_balance (    
   agent_id    
   ,agent_name    
   ,amount    
   ,currency_code    
   ,agent_remarks    
   ,user_id    
   ,txn_mode    
   ,txn_type    
   ,created_utc_date    
   ,created_local_date    
   ,created_nepali_date    
   ,created_by    
   ,created_ip    
   )    
  VALUES (    
   @agent_id    
   ,@agent_name    
   ,@requested_amount    
   ,'npr'    
   ,'New Card Issued Card id:' + cast(@card_id AS VARCHAR)    
   ,@user_id    
   ,'DR'    
   ,'ct'    
   ,GETUTCDATE()    
   ,GETDATE()    
   ,[dbo].func_get_nepali_date(DEFAULT)    
   ,@action_user    
   ,@created_ip    
   );    
    
  SELECT '0' code    
   ,'Card requested successfully' message    
   ,NULL id    
    
  RETURN    
 END    
    
 IF @flag = 'a' --approve/reject card                
 BEGIN    
  IF NOT EXISTS (    
    SELECT 'x'    
    FROM tbl_agent_card_request    
    WHERE req_id = @req_id    
    )    
  BEGIN    
   SELECT '0' code    
    ,'Requested Data Not found' message    
    ,NULL id    
    
   RETURN    
  END    
  ELSE IF EXISTS (    
    SELECT 'x'    
    FROM tbl_agent_card_request    
    WHERE req_id = @req_id    
     AND trim(request_status) <> 'Pending'    
    )    
  BEGIN    
   SELECT '0' code    
    ,'Card already Approved or Rejected' message    
    ,NULL id    
    
   RETURN    
  END    
  ELSE    
  BEGIN    
   UPDATE tbl_agent_card_request    
   SET request_status = @req_status    
    ,updated_local_date = getdate()    
    ,updated_UTC_Date = GETUTCDATE()    
    ,updated_by = @action_user    
    ,updated_ip = @Created_ip    
   WHERE req_id = @req_id    
    
   SELECT @requested_amount = requested_amount    
   FROM tbl_agent_card_request    
   WHERE req_id = @req_id    
    
   IF @req_status = 'Approved'    
   BEGIN    
    INSERT INTO tbl_agent_card_management (    
     user_id    
     ,user_name    
     ,agent_id    
     ,card_no    
     ,card_type    
     ,is_active    
     ,card_issued_date    
     ,card_expiry_date    
     ,created_by    
     ,created_local_date    
     ,created_utc_date    
     ,created_nepali_date    
     ,amount    
     )    
    VALUES (    
     @user_id    
     ,@user_name    
     ,@agent_id    
     ,@new_card_no    
     ,@card_type    
     ,'Y'    
     ,GETDATE()    
     ,DATEADD(YEAR, 4, GETDATE())    
     ,@action_user    
     ,GETDATE()    
     ,GETUTCDATE()    
     ,dbo.func_get_nepali_date(DEFAULT)    
     ,@requested_amount    
     )    
    
    UPDATE tbl_agent_detail    
    SET available_balance = isnull(available_balance, 0) - @requested_amount    
    WHERE agent_id = @agent_id    
    
    SELECT '0' code    
     ,'Card ' + @req_status + ' succesfully.' message    
     ,NULL id    
    
    RETURN    
   END    
    
   SELECT '1' code    
    ,'Card ' + @req_status + ' succesfully.' message    
    ,NULL id    
    
   RETURN    
  END    
 END    
    
 IF @flag = 'l' --get all requested card                
 BEGIN    
  SELECT req_id    
   ,user_name    
   ,user_mobile_no    
   ,user_email    
   ,card_type    
   ,request_status    
   ,created_local_date    
   ,requested_amount    
  FROM tbl_agent_card_request    
  WHERE request_status = 'Pending'    
  ORDER BY 1 DESC    
 END    
    
 IF @flag = 'ad' --add balance in card        
 BEGIN    
  IF @card_id IS NULL    
  BEGIN    
   SELECT '1' code    
    ,'Invalid card or Card not Found' message    
    ,NULL id    
    
   RETURN    
  END    
  ELSE    
  BEGIN    
   SELECT @available_card_balance = amount    
    ,@user_id = user_id    
    ,@agent_id = agent_id    
   FROM tbl_agent_card_management    
   WHERE card_id = @card_id    
    
   SELECT @available_balance = available_balance    
   FROM tbl_user_Detail u    
   JOIN tbl_agent_detail a ON a.agent_id = u.agent_id    
   WHERE u.user_id = @user_id    
  END    
    
  IF @requested_amount IS NULL    
   OR @requested_amount = 0    
  BEGIN    
   SELECT '1' code    
    ,'Requested Amount is invalid' message    
    ,NULL id    
    
   RETURN    
  END    
    
  IF @available_balance < @requested_amount    
  BEGIN    
   SELECT '1' code    
    ,'Your available balance is less than the requested Balance' Message    
    ,NULL id    
    
   RETURN    
  END    
    
  IF @action_user IS NULL    
   SET @action_user = (    
     SELECT user_name    
     FROM tbl_user_detail    
     WHERE user_id = @user_id    
     )    
    
  UPDATE tbl_agent_card_management    
  SET updated_by = @action_user    
   ,updated_utc_date = GETUTCDATE()    
   ,updated_local_date = GETDATE()    
   ,updated_nepali_date = dbo.func_get_nepali_date(GETDATE())    
   ,Amount = (@available_card_balance + @requested_amount)    
  WHERE card_id = @card_id    
    
  UPDATE tbl_agent_detail    
  SET available_balance = isnull(available_balance, 0) - @requested_amount    
  WHERE agent_id = @agent_id    
    
  --insert into tbl_agent_balance      
  INSERT INTO tbl_agent_balance (    
   agent_id    
   ,agent_name    
   ,amount    
   ,currency_code    
   ,agent_remarks    
   ,user_id    
   ,txn_mode    
   ,txn_type    
   ,created_utc_date    
   ,created_local_date    
   ,created_nepali_date    
   ,created_by    
   ,created_ip    
   )    
  VALUES (    
   @agent_id    
   ,@action_user    
   ,@requested_amount    
   ,'npr'    
   ,'Balance added in Card id:' + cast(@card_id AS VARCHAR)    
   ,@user_id    
   ,'DR'    
   ,'ct'    
   ,GETUTCDATE()    
   ,GETDATE()    
   ,[dbo].func_get_nepali_date(DEFAULT)    
   ,@user_id    
   ,@created_ip    
   );    
    
  SELECT '0' code    
   ,'Balance transfer to card successfully' message    
   ,NULL id    
 END    
    
 IF @flag = 'rb' -- remove blance from card        
 BEGIN    
  IF @card_id IS NULL    
  BEGIN    
   SELECT '1' code    
    ,'Invalid card or Card not Found' message    
    ,NULL id    
    
   RETURN    
  END    
  ELSE    
  BEGIN    
   SELECT @available_card_balance = amount    
    ,@user_id = user_id    
    ,@agent_id = agent_id    
   FROM tbl_agent_card_management    
   WHERE card_id = @card_id    
    
   SELECT @available_balance = available_balance    
   FROM tbl_user_Detail u    
   JOIN tbl_agent_detail a ON a.agent_id = u.agent_id    
   WHERE u.user_id = @user_id    
  END    
    
  IF @requested_amount IS NULL    
   OR @requested_amount = 0    
  BEGIN    
   SELECT '1' code    
    ,'Requested Amount is invalid' message    
    ,NULL id    
    
   RETURN    
  END    
    
  IF @available_card_balance < @requested_amount    
  BEGIN    
   SELECT '1' code    
    ,'The requested Balance is more than your card balance' Message    
    ,NULL id    
    
   RETURN    
  END    
    
  BEGIN TRY    
   BEGIN TRANSACTION removeBalanceFromCard    
    
   UPDATE tbl_agent_card_management    
   SET updated_by = @action_user    
    ,updated_utc_date = GETUTCDATE()    
    ,updated_local_date = GETDATE()    
    ,updated_nepali_date = dbo.func_get_nepali_date(GETDATE())    
    ,Amount = (@available_card_balance - @requested_amount)    
   WHERE card_id = @card_id    
    
   UPDATE tbl_agent_detail    
   SET available_balance = isnull(available_balance, 0) + @requested_amount    
   WHERE agent_id = @agent_id    
    
   --insert into tbl_agent_balance      
   INSERT INTO tbl_agent_balance (    
    agent_id    
    ,agent_name    
    ,amount    
    ,currency_code    
    ,agent_remarks    
    ,user_id    
    ,txn_mode    
    ,txn_type    
    ,created_utc_date    
    ,created_local_date    
    ,created_nepali_date    
    ,created_by    
    ,created_ip    
    )    
   VALUES (    
    @agent_id    
    ,@action_user    
    ,@requested_amount    
    ,'npr'    
    ,'Balance retrived From Card id:' + cast(@card_id AS VARCHAR)    
    ,@user_id    
    ,'CR'    
    ,'ct'    
    ,GETUTCDATE()    
    ,GETDATE()    
    ,[dbo].func_get_nepali_date(DEFAULT)    
    ,@user_id    
    ,@created_ip    
    );    
    
   EXEC sproc_error_handler @error_code = '0'    
    ,@msg = 'Balance transfer to wallet successfully'    
    ,@id = NULL;    
    
   COMMIT TRANSACTION removeBalanceFromCard    
  END TRY    
    
  BEGIN CATCH    
   IF @@trancount > 0    
    ROLLBACK TRANSACTION removeBalanceFromCard    
    
   SET @desc = 'sql error found:(' + error_message() + ')'    
    
   INSERT INTO tbl_error_log_sql (    
    sql_error_desc    
    ,sql_error_script    
    ,sql_query_string    
    ,sql_error_category    
    ,sql_error_source    
    ,sql_error_local_date    
    ,sql_error_UTC_date    
    ,sql_error_nepali_date    
    )    
   SELECT @desc    
    ,'sproc_agent_cardMgmt(update card, available_balance and insert agent balance:flag ''rb'')'    
    ,'sql'    
    ,'sql'    
    ,'sproc_agent_cardMgmt(update card, available_balance and insert agent balance)'    
    ,getdate()    
    ,getutcdate()    
    ,[dbo].func_get_nepali_date(DEFAULT)    
    
   SELECT '1' code    
    ,'errorid: ' + cast(scope_identity() AS VARCHAR) message    
    ,NULL id    
  END CATCH    
    
  RETURN    
   --Select '0' code, 'Balance transfer to wallet successfully' message, null id               
 END    
    
 IF @flag = 'tr' --transfer card authority      
 BEGIN    
  IF @card_id IS NULL    
  BEGIN    
   SELECT '1' code    
    ,'Invalid card or Card not Found' message    
    ,NULL id    
    
   RETURN    
  END    
    
  IF @transfer_to_mobile IS NULL    
  BEGIN    
   SELECT '1' code    
    ,'Invalid User Info' message    
    ,NULL id    
    
   RETURN    
  END    
    
  IF @transfer_to_mobile IS NOT NULL    
   IF NOT EXISTS (    
     SELECT 'x'    
     FROM tbl_user_detail u    
     JOIN tbl_agent_detail a ON a.agent_id = u.agent_id    
     WHERE u.user_mobile_no = @transfer_to_mobile    
     )    
   BEGIN    
    SELECT '1' Code    
     ,'User Not Found' message    
     ,NULL id    
    
    RETURN    
   END    
   ELSE    
   BEGIN    
    SELECT @transfer_to_user_id = user_id    
     ,@transfer_to_agent_id = u.agent_id    
     ,@transfer_to_user_name = user_name    
    FROM tbl_user_Detail u    
    JOIN tbl_agent_detail a ON a.agent_id = u.agent_id    
    WHERE u.user_mobile_no = @transfer_to_mobile    
   END    
    
  UPDATE tbl_agent_card_management    
  SET updated_by = @action_user    
   ,updated_utc_date = GETUTCDATE()    
   ,updated_local_date = GETDATE()    
   ,updated_nepali_date = dbo.func_get_nepali_date(GETDATE())    
   ,is_transfer = 'Y'    
   ,transfer_to = @transfer_to_user_id    
  WHERE card_id = @card_id    
    
  SELECT '0' code    
   ,'Card transfer successfully to ' + @transfer_to_mobile message    
   ,NULL id    
 END    
    
 IF @flag = 're' --retrieve card authority      
 BEGIN    
  IF @card_id IS NULL    
  BEGIN    
   SELECT '1' code    
    ,'Invalid card or Card not Found' message    
    ,NULL id    
    
   RETURN    
  END    
    
  UPDATE tbl_agent_card_management    
  SET updated_by = @action_user    
   ,updated_utc_date = GETUTCDATE()    
   ,updated_local_date = GETDATE()    
   ,updated_nepali_date = dbo.func_get_nepali_date(GETDATE())    
   ,is_transfer = NULL    
   ,transfer_to = NULL    
  WHERE card_id = @card_id    
    
  SELECT '0' code    
   ,'Card retrieve successfully ' message    
   ,NULL id    
 END    
END    