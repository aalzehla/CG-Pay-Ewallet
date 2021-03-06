USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_wallet_balance]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sproc_wallet_balance]      
@flag   VARCHAR(20),      
@id    BIGINT   = NULL,           
@user   VARCHAR(50)  = NULL,      
@search   VARCHAR(50)  = NULL,      
@page_size  VARCHAR(5)  = 10,     
@action_user  VARCHAR(30)  = NULL,      
@balance_type  VARCHAR(30)  = NULL,   
@amount  VARCHAR(30)  = NULL,   
@agent_id  VARCHAR(30)  = NULL,   
@user_id   INT    = NULL,      
@phone_number  VARCHAR(50)  = NULL,         
@is_active  CHAR(1)   = NULL,       
@remarks   VARCHAR(500) = NULL     
      
AS      
SET NOCOUNT ON;      
BEGIN TRY  
	DECLARE @sql varchar(max);
	   
	IF @flag = 'transfer'      
	BEGIN 
	     
	IF EXISTS(SELECT 'X' FROM tbl_agent_detail WHERE agent_mobile_no=@phone_number)
		
		BEGIN
			--DECLARE @oldBalance VARCHAR(10) = (SELECT Balance FROM DtaAgentDetail WHERE PhoneNo=@phoneNumber)
			--minus balance cases handle?
		   IF @balance_type='tu'
				BEGIN
					UPDATE tbl_agent_detail
					SET available_balance= (CAST(available_balance AS DECIMAL(18,2)))+(CAST(@amount AS DECIMAL(18,2)))
						,updated_by = @action_user
						,updated_UTC_date= GETUTCDATE()
					WHERE agent_mobile_no= @phone_number
				END
				ELSE IF @balance_type='rm'
				BEGIN
					UPDATE tbl_agent_detail
					SET available_balance= (CAST(available_balance AS DECIMAL(18,2)))-(CAST(@amount AS DECIMAL(18,2)))
						,updated_by = @action_user
						,updated_UTC_date= GETUTCDATE()
					WHERE agent_mobile_no= @phone_number
				END

			   SELECT '0' Code, 'Balance updated successfully. New Balance is: '+ CAST((SELECT available_balance FROM tbl_agent_detail WHERE agent_phone_no=@phone_Number) AS VARCHAR) MESSAGE, null id   
		   RETURN;     
		END
		ELSE
		BEGIN
			SELECT '1' Code, 'Customer not found: '+CAST(@phone_number AS VARCHAR) MESSAGE, null id 
			RETURN;
		END
	   
	END  

	IF @flag = 'detail'      
		BEGIN  
			IF EXISTS(SELECT 'X' FROM tbl_agent_detail WHERE agent_mobile_no=@phone_number)
				BEGIN
					SELECT TOP 1 '0' as code, * FROM tbl_agent_detail  WHERE agent_mobile_no=@phone_number
				   RETURN;     
				END
				ELSE
				BEGIN
					SELECT '1' Code, 'Agent not found: '+CAST(@phone_Number AS VARCHAR) MESSAGE, null id 
					RETURN;
				END
		END  
END TRY  
    
BEGIN CATCH      
IF @@trancount > 0      
ROLLBACK TRANSACTION      
      
SELECT 1 CODE,ERROR_MESSAGE() msg,null id       
END CATCH 


GO
