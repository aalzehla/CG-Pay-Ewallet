USE [CGPay]
GO

/****** Object:  StoredProcedure [dbo].[sproc_Agent_Registration]    Script Date: 20/08/2020 12:13:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


    
    
    
-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
-- =============================================    
CREATE OR ALTER    PROCEDURE [dbo].[sproc_Agent_Registration]    
 @flag char(3),    
 @temp_user_id  int  =  null,    
 @agent_mobile_number varchar(20) = null,    
 @agent_email_address varchar(50) =  null,    
 @agent_full_name varchar(50) =  null,    
 @agent_verification_code varchar(60) = null,    
 @agent_new_password varchar(50) =  null,    
 @agent_confirm_password varchar(50) = null    
AS    
BEGIN    
 Declare @gen_verification_code varchar(max), @agent_verification_status char(23), @agent_verification_code_pr varchar(30), @action_ip_address varchar(20),@send_datetime datetime, @id int,@new_card_no varchar(20)    
 Declare @user_name varchar(100), @userID int    
    
 if @action_ip_address is null    
 begin    
  set @action_ip_address = ':1'    
 end    
     
 set @new_card_no = '1000'+cast(convert(numeric(12,0),rand() * 899999999999) + 100000000000 as varchar)    
    
 if @flag = 'i'    
 Begin    
  if exists(select 'x' from tbl_agent_Detail where (agent_email_address = @agent_email_address or agent_mobile_no =@agent_mobile_number) and agent_type = 'WalletUser')    
  Begin    
   Select '1' Code, 'Email or Mobile Number already exists' Message, null id    
   return    
  End    
  else if exists (select 'x' from tbl_User_registration where Agent_Email_address = @agent_email_address and Agent_Mobile_Number = @agent_mobile_number and Isnull(Agent_verification_Status,'Sent') = ltrim('Verified'))    
  begin    
   Select '1' Code, 'Customer already Verified'Message , null id    
   return    
  end    
  Else    
  Begin    
     --send email verification code by email/sms    
        
   set @gen_verification_code = dbo.[func_generate_verify_code](6)     
       
   insert into tbl_User_registration(Agent_Mobile_Number, Agent_Email_address,Agent_full_Name,Agent_verification_code,generate_date_time) values(@agent_mobile_number, @agent_email_address, @agent_full_name, @gen_verification_code,getdate())    
       
   exec sproc_email_request @flag = 'd',@full_name = @agent_full_name, @agent_verification_code =@gen_verification_code, @email_id = @agent_email_address     
   INSERT INTO tbl_sms_transaction (
			country
			,agent_id
			,sms_destination_no
			,sms_message_type
			,message
			,STATUS
			,created_by
			,created_date
			)
		VALUES 
		(
			'Nepal'
			,null
			,@agent_mobile_number
			,1
			,'Your verification code is ' + @gen_verification_code
			,'Pending'
			,@agent_mobile_number
			,GETDATE()
		)
   
   update tbl_User_registration set Agent_verification_Status = 'Sent',send_date_time=getdate() where Agent_Mobile_Number = @agent_mobile_number and Agent_Email_address =@agent_email_address and Agent_verification_code=@gen_verification_code    
    
  ENd    
    
  select '0' Code, 'Successfully sent Verification Code' Message --from tbl_User_registration    
 ENd  -- check user detail and send verification code by email    
    
 if @flag = 'vi' -- verify code web    
 begin    
  select top 1 @agent_verification_code_pr = Agent_verification_code,     
  @agent_verification_status = Agent_verification_Status ,    
  @agent_email_address = Agent_Email_address,    
  @agent_full_name = Agent_full_Name,    
  @send_datetime=send_date_time    
  from tbl_User_registration where (UserId =  @temp_user_id) or (Agent_Mobile_Number = @agent_mobile_number)    
  order by UserId desc    
      
  --select @agent_verification_code_pr,     
  --@agent_verification_status ,    
  --@agent_email_address,    
  --@agent_full_name    
  --return    
    
 -- DECLARE @initial_password VARCHAR(200),@encrypted_password VARCHAR(600);          
          
 --EXEC sproc_generate_password @initial_password OUTPUT;          
          
 --SELECT @encrypted_password = (          
 --  SELECT cast(@initial_password + '23472@asd' AS VARBINARY(max))          
 --  FOR XML path('')          
 --   ,BINARY base64          
 --  );          
          
 --PRINT (@initial_password);          
 --PRINT (@encrypted_password);    
    
  --if @agent_verification_status  is null or ISNULL(@agent_verification_status,'Sent') = ltrim('Verified')    
  --begin    
  ----- verifcation checked chase, if user is already verified we drop the temp table    
  -- select '01' Code, 'Something went wrong please try again from the beginning' MEssage, null id    
  -- return    
  --end    
      
  --else     
  if (@agent_verification_code_pr = @agent_verification_code)    
  begin    
       
   update tbl_User_registration set Agent_verification_status  = 'Verified' where  (UserId =  @temp_user_id or Agent_Mobile_Number = @agent_mobile_number) and Agent_verification_code=@agent_verification_code    
   Select '0' Code, 'User verified Succesfully' Message, @temp_user_id id    
   return    
       
  end    
      
  --else    
  --begin    
  -- select '1' Code, 'Something Went Wrong, Please Try again from the beginning' Message, null id    
  -- return    
  --end    
 end    
    
    
 if @flag = 'v' -- verify code api    
 begin    
  select top 1 @agent_verification_code_pr = Agent_verification_code,     
  @agent_verification_status = Agent_verification_Status ,    
  @agent_email_address = Agent_Email_address,    
  @agent_full_name = Agent_full_Name,    
  @send_datetime=send_date_time    
  from tbl_User_registration where (UserId =  @temp_user_id) or (Agent_Mobile_Number = @agent_mobile_number)    
  order by UserId desc    
       
      
  --select @agent_verification_code_pr,     
  --@agent_verification_status ,    
  --@agent_email_address,    
  --@agent_full_name    
  --return    
    
 -- DECLARE @initial_password VARCHAR(200),@encrypted_password VARCHAR(600);          
          
 --EXEC sproc_generate_password @initial_password OUTPUT;          
          
 --SELECT @encrypted_password = (          
 --  SELECT cast(@initial_password + '23472@asd' AS VARBINARY(max))          
 --  FOR XML path('')          
 --   ,BINARY base64          
 --  );          
          
 --PRINT (@initial_password);          
 --PRINT (@encrypted_password);    
    
  --if @agent_verification_status  is null or ISNULL(@agent_verification_status,'Sent') = ltrim('Verified')    
  --begin    
  ----- verifcation checked chase, if user is already verified we drop the temp table    
  -- select '01' Code, 'Something went wrong please try again from the beginning' MEssage, null id    
  -- return    
  --end    
      
  --else     
  if (@agent_verification_code_pr = @agent_verification_code)    
  begin    
       
       
   set @user_name = 'User' + @agent_mobile_number    
      
   insert into tbl_agent_detail (agent_operation_type, agent_commission_id, agent_email_address, agent_mobile_no, full_name, agent_status,agent_type, kyc_status, created_by,created_local_date,created_UTC_date, created_nepali_date, available_balance,is_auto_commission)    
   values('I',1,@agent_email_address, @agent_mobile_number, @agent_full_name,'Y' ,'WalletUser','N','System',GETDATE(), GETUTCDATE(),dbo.func_get_nepali_date(default), 0,1)    
       
    
   set @id = SCOPE_IDENTITY()    
    
   if exists(select 'x' from tbl_user_detail where user_email = @agent_email_address or user_mobile_no = @agent_mobile_number)    
   begin    
    select '1' code, 'Mobile Number or Email already exists' message, null id    
    return    
   end    
       
    
   --insert into user detail    
   insert into tbl_user_detail(agent_id, user_name,password,user_email, user_mobile_no, full_name,status, is_login_enabled,created_by, created_ip, created_local_date, created_UTC_date, created_nepali_date,usr_type, usr_type_id,role_id )    
   values(@id,@user_name,PWDENCRYPT(@agent_new_password),@agent_email_address, @agent_mobile_number, @agent_full_name,'Y', 'Y','System',@action_ip_address, GETDATE(), GETUTCDATE(), dbo.func_get_nepali_date(default),'WalletUser','6','6')    
       
    
   set @userID = SCOPE_IDENTITY()    
   insert into tbl_kyc_documents (agent_id, KYC_Verified, created_by, created_local_date, created_UTC_date, created_nepali_date)    
   values(@id, 'N','System',GEtDATE(), GETUTCDATE(), dbo.func_get_nepali_date(default))    
      
       
   insert into tbl_agent_card_management(agent_id,is_active,  card_no, user_name, user_id,card_type,card_issued_date, card_expiry_date,created_by,created_local_date,created_utc_date,created_nepali_date)    
   values(@id,'y',@new_card_no,@user_name, @userID, '1', GETDATE(), DATEADD(YEAR, 4, GETDATE()),'System',GETDATE(), GETUTCDATE(), dbo.func_get_nepali_date(default))    
    
   --exec sproc_email_request @flag = 'dr',@full_name = @agent_full_name, @email_id = @agent_email_address ,@password = @agent_new_password    
   -- --drop temp table    
       
    
    
   update tbl_User_registration set Agent_verification_status  = 'Verified' where  (UserId =  @temp_user_id or Agent_Mobile_Number = @agent_mobile_number) and Agent_verification_code=@agent_verification_code    
   Select '0' Code, 'User verified Succesfully' Message, @userID id    
       
    
   return    
       
  end    
      
  else    
  begin    
   select '1' Code, 'Please enter verification code' Message, null id    
   return    
  end    
 end    
    
    
 if @flag = 's' --set pwd    
 begin    
    
  if not exists(select 'x' from tbl_User_registration where Agent_verification_Status = 'Verified' and Agent_Mobile_Number = @agent_mobile_number or Agent_Email_address =@agent_email_address)    
  begin    
   select '1' code, 'Agent Not Verified' message, null id    
   return    
  end    
  else if len(@agent_new_password) < 8    
  begin    
   select '1' code, 'Password must be more than 8 characters' message, null id    
   return    
  end    
  else if (@agent_new_password <> @agent_confirm_password)    
  begin    
   Select '1' code, 'Password and Confirm Password doesn''t match' message, null id    
   return    
  end    
  else    
  begin    
   --set @user_name = 'User' + @agent_mobile_number    
    
   --insert into tbl_agent_detail (agent_operation_type, agent_commission_id, agent_email_address, agent_mobile_no, full_name, agent_status,agent_type, kyc_status, created_by,created_local_date,created_UTC_date, created_nepali_date)    
   --values('I',1,@agent_email_address, @agent_mobile_number, @agent_full_name,'Y' ,'WalletUser','N','System',GETDATE(), GETUTCDATE(),dbo.func_get_nepali_date(default))    
    
   --set @id = SCOPE_IDENTITY()    
   ----insert into user detail    
   --insert into tbl_user_detail(agent_id, user_name,password,user_email, user_mobile_no, full_name,status, is_login_enabled,created_by, created_ip, created_local_date, created_UTC_date, created_nepali_date,usr_type, usr_type_id,role_id )    
   --values(@id,@user_name,PWDENCRYPT(@agent_new_password),@agent_email_address, @agent_mobile_number, @agent_full_name,'Y', 'Y','System',@action_ip_address, GETDATE(), GETUTCDATE(), dbo.func_get_nepali_date(default),'WalletUser','6','6')    
    
   --set @userID = SCOPE_IDENTITY()    
   --insert into tbl_kyc_documents (agent_id, KYC_Verified, created_by, created_local_date, created_UTC_date, created_nepali_date)    
   --values(@id, 'Pending','System',GEtDATE(), GETUTCDATE(), dbo.func_get_nepali_date(default))    
       
   --insert into tbl_agent_card_management(agent_id, card_no, user_name, user_id,card_type,card_issued_date, card_expiry_date,created_by,created_local_date,created_utc_date,created_nepali_date)    
   --values(@id,@new_card_no,@user_name, @userID, '1', GETDATE(), DATEADD(YEAR, 4, GETDATE()),'System',GETDATE(), GETUTCDATE(), dbo.func_get_nepali_date(default))    
    
   update tbl_user_detail set password  = PWDENCRYPT(@agent_new_password) where user_mobile_no = @agent_mobile_number or user_email = @agent_email_address    
    
   exec sproc_email_request @flag = 'dr',@full_name = @agent_full_name, @email_id = @agent_email_address --,@password = @encrypted_password     
    
   select '0' code, 'User Registration Successfull' message, null id    
   return    
  end    
    
    
 end    
     
    
END    

GO


