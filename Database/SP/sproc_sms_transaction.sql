

/****** Object:  StoredProcedure [dbo].[sproc_sms_transaction]    Script Date: 20/08/2020 11:34:18 ******/
DROP PROCEDURE [dbo].[sproc_sms_transaction]
GO

/****** Object:  StoredProcedure [dbo].[sproc_sms_transaction]    Script Date: 20/08/2020 11:34:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



  
  
  
CREATE      
   
  
 PROCEDURE [dbo].[sproc_sms_transaction] (  
 @flag VARCHAR(3)  
 ,@sms_country VARCHAR(100) = NULL  
 ,@sms_destination_no VARCHAR(20) = NULL  
 ,@sms_sender_id VARCHAR(20) = NULL  
 ,@message NVARCHAR(max) = NULL  
 ,@gateway_message_id VARCHAR(100)= NULL  
 ,@api_status VARCHAR(20) = NULL  
 ,@agent_id INT = NULL  
 ,@created_by VARCHAR(20) = NULL  
 ,@created_ip VARCHAR(100) = NULL  
 ,@user_name VARCHAR(512) = NULL  
 ,@sms_gateway_message_id varchar(512) = NULL  
 ,@sms_operator VARCHAR(20) = NULL  
 ,@sms_txn_id INT = NULL  
 ,@from_date varchar(15) = null  
 ,@to_date varchar(15) = null  
 ,@sms_gateway_response nvarchar(max) =  null
  
 )  
AS  
BEGIN  
 DECLARE @sms_operator_id INT  
  ,@gateway_id INT  
  , @sql varchar(max)  
  
 IF @flag = 'i'  
 BEGIN  
  INSERT INTO tbl_sms_transaction (  
   country  
   ,sms_operator_id  
   ,sms_destination_no  
   ,sms_sender_id  
   ,sms_message_type  
   ,[message]  
   ,sms_gateway_message_id  
   ,STATUS  
   ,agent_id  
   ,created_by  
   ,created_date  
   ,sms_gateway_id  
   )  
  VALUES (  
   @sms_country  
   ,@sms_operator_id  
   ,@sms_destination_no  
   ,@sms_sender_id  
   ,1  
   ,@message  
   ,@gateway_message_id  
   ,'Pending'  
   ,@agent_id  
   ,@created_by  
   ,getutcdate()  
   ,@gateway_id  
   );  
  
 END;  
  
 IF @flag = 'u'  
 BEGIN  
  UPDATE tbl_sms_transaction  
  SET sms_gateway_message_id = isnull(@sms_gateway_message_id, sms_gateway_message_id)  
   ,sms_operator = isnull(@sms_operator, sms_operator)  
   ,[status] = isnull(@api_status, [status])  
   , sms_gateway_response = isnull(@sms_gateway_response, [sms_gateway_response])
  WHERE sms_txn_id = @sms_txn_id  
 END  
  
 IF @flag = 's'  
 BEGIN  
  set @sql = 'SELECT sms_operator  
   ,sms_destination_no  
   ,[message] AS SMS_message  
   ,[status] AS sms_Sent_status  
   ,sms_gateway_id  
   ,created_date  
  FROM tbl_sms_transaction  
  where 1=1 '  
  
    IF(@from_date IS NOT NULL  
                   AND @to_date IS NOT NULL)  
                    BEGIN  
                        SET @sql = @sql + ' and created_date between ''' + @from_date + ''' and ''' + @to_date + ' 23:59:59.997'''  
  
                END;  

				SET @sql= @sql + 'order by created_date desc'
			 PRINT @sql;  
            EXEC (@sql);  
 END  
  
 IF @flag = 'p'  
 Begin  

 set @sql =  ' select sms_txn_id, sms_destination_no, message from tbl_sms_transaction where status = ''pending''  '

 IF @sms_txn_id IS NOT NULL
	begin
		set	@sql = @sql + ' and sms_txn_id= '+cast(@sms_txn_id as varchar) 
	end
 
	print (@sql)
	exec (@sql)
  
 End  
END;  
GO


