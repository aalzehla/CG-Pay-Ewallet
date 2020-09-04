USE [WePayNepal]
GO

/****** Object:  StoredProcedure [dbo].[apiproc_UserBlncTrf]    Script Date: 6/5/2020 3:56:46 PM ******/
DROP PROCEDURE [dbo].[apiproc_UserBlncTrf]
GO

/****** Object:  StoredProcedure [dbo].[apiproc_UserBlncTrf]    Script Date: 6/5/2020 3:56:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE         PROCEDURE [dbo].[apiproc_UserBlncTrf]
	@flag char(3) = null,
	@subscriber_no varchar(50) = null,
	@description varchar(500) = null,
	@bt_purpose varchar(100) = null,
	@amount decimal(18,2) = null,
	@action_user varchar(50) = null
	,@created_ip  varchar(50) = null         
   ,@created_platform  varchar(50) = null         


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @user_mobile_number varchar(15), @user_email varchar(50), @user_full_name varchar(50),@reciever_id int,@sender_agent_id int, @reciever_agent_id int,@reciever_full_name varchar(50),@reciever_email varchar(50)
	Declare @agent_current_balance decimal(18,2),@parent_id int, @sender_name varchar(50), @user_id int, @remarks_agent varchar(max), @desc varchar(max),@sender_user_id int,@reciever_user_id int
	--send request
	If @flag = 'trq'
	begin
		if not exists(select 'x' from tbl_user_detail where user_name = @action_user or user_mobile_no =@action_user or user_email = @action_user )
		begin
			select '104' code, 'User not found' message,  null id
			return
		end
		else
		begin
			Select @user_mobile_number =user_mobile_no, 
			@user_email = user_email, 
			@user_full_name = u.full_name,
			@sender_agent_id =u.agent_id,
			@sender_user_id = u.user_id
			from tbl_user_detail u
			join tbl_agent_detail a on a.agent_id = u.agent_id
			where u.user_name = @action_user
		end
	
	if not exists(select 'x' from tbl_user_detail where user_email = @subscriber_no or user_mobile_no = @subscriber_no)
	begin
		Select '104' code, 'Requested User not Found' message, null id
		return
	end
	else
	begin
		select @reciever_id = user_id,
		@reciever_agent_id = u.agent_id,
		@reciever_full_name = u.full_name,
		@reciever_email = u.user_email,
		@reciever_user_id = u.user_id
		from tbl_user_detail u
		join tbl_agent_detail a on a.agent_id = u.agent_id
		where user_email = @subscriber_no or user_mobile_no = @subscriber_no

	end

	if (@sender_user_id = @reciever_user_id )
	begin
		select '160' code, 'Cannot Make Balance Transfer Request to Yourself' message, null id
		return
	end

	insert into tbl_agent_notification(
		notification_subject, 
		notification_body, 
		notification_type, 
		notification_status, 
		notification_to, 
		agent_id,
		user_id, 
		read_status,
		created_by,
		created_local_date, 
		created_UTC_date, 
		created_nepali_date)
	values(
		'Balance Transfer Request',
		@description, 
		'Balance Transfer', 
		'Y',
		@reciever_id,
		@reciever_agent_id,
		@sender_user_id, 
		'n',
		@action_user, 
		GETDATE(), 
		GETUTCDATE(), 
		dbo.func_get_nepali_date(default)
		)

	exec sproc_email_request @flag = 'bt',@agent_id= @reciever_agent_id, @user_name = @user_mobile_number,@full_name = @reciever_full_name, @email_id = @reciever_email,@amount = @amount,@subscriber_no = @subscriber_no

	select '0' code, 'Successfully sent Balance Transfer request to User: ' +@reciever_full_name message, @sender_user_id id
	return
	end

	-- trf request
	if @flag = 'trf'
	begin
		if not exists(Select 'x' from tbl_user_detail u
		join tbl_agent_detail a on a.agent_id = u.agent_id
		
		where u.user_name = @action_user)
		begin
			Select '104' code, 'User not found' message, null id
			return
		end
	 else
		begin
			select @user_id = user_id,
					@user_mobile_number =user_mobile_no, 
				@user_email = user_email, 
				@user_full_name = u.full_name,
				@sender_agent_id =u.agent_id 
			from tbl_user_detail u where user_name = @action_user          
		end
		 
		 if not exists ( select 'x' from tbl_user_detail u
		 join tbl_agent_detail a on a.agent_id = u.agent_id
		 where  user_mobile_no = @subscriber_no or user_email = @subscriber_no )
	 begin
		select '104' code, 'User Not found' message, null id
		return
	 end
	 else
	 begin
		select @reciever_id = user_id,
		@reciever_agent_id = u.agent_id,
		@reciever_full_name = u.full_name,
		@reciever_email = u.user_email,
		@reciever_user_id = u.user_id
		from tbl_user_detail u          
		where           
		user_mobile_no = @subscriber_no or user_email = @subscriber_no 
	 end

	  if @amount <= 0          
		 begin          
		  select '161' code          
		   ,'Amount should be more than 0' message          
		   ,null id            
		  return    
	end
	 select @agent_current_balance = Isnull(a.available_balance,0)          
			,@parent_id = a.parent_id          
			,@sender_name = u.full_name  ,
			@sender_agent_id   =u.agent_id,
			@sender_user_id = u.user_id
			from tbl_user_detail u
			join tbl_agent_detail a on a.agent_id = u.agent_id
			where user_id = @user_id  

		if (@sender_user_id = @reciever_user_id )
		begin
			select '160' code, 'Cannot Make Balance Transfer to Yourself' message, null id
			return
		end

	 if @agent_current_balance < @amount          
	 begin          
	  select '162' code          
	   ,'Sender''s balance is less the amount to be transfered' message          
	   ,null id          
          
	  return          
	 end 
	 
	 set @remarks_agent = 'Balance transfered by ' + @sender_name + '(id: ' + @sender_name+ ') of ' + cast(@amount as varchar) + ' NPR'        

	  begin try          
  begin transaction usertouserbalancetrf          
          
  update tbl_agent_detail          
  set available_balance = available_balance + @amount          
  where agent_id = @reciever_agent_id          
          
  update tbl_agent_detail          
  set available_balance = available_balance - @amount          
  where agent_id = @sender_agent_id  
                
  -- insert into agent balance table for user transfered to            

  insert into tbl_agent_balance(          
   agent_id          
   ,agent_name          
   ,amount          
   ,currency_code          
   ,agent_parent_id          
   ,txn_type          
   ,created_by          
   ,created_UTC_date          
   ,created_local_date          
   ,created_nepali_date          
   ,created_ip          
   ,created_platform          
   ,user_id          
   ,agent_remarks 
   ,txn_mode
   )          
  values (          
   @sender_agent_id          
   ,@sender_name          
   ,@amount          
   ,'NPR'          
   ,@parent_id          
   ,'p2p'          
   ,@sender_name          
   ,[dbo].func_get_nepali_date(default)          
   ,getdate()          
   ,getutcdate()          
   ,@created_ip          
   ,@created_platform          
   ,@user_id          
   ,@remarks_agent 
   ,'DR'
   )          
       
	--- insert into notification table    
	insert into tbl_agent_notification(  
		notification_subject, 
		notification_body, 
		notification_type, 
		notification_status, 
		notification_to, 
		agent_id,
		user_id, 
		read_status,
		created_by,
		created_local_date, 
		created_UTC_date, 
		created_nepali_date)  
	 values(
		'Balance Transfer',
		@remarks_agent, 
		'Balance_Transfer', 
		'Y',
		@reciever_agent_id,
		@reciever_agent_id,
		@reciever_id,
		'n',
		@action_user, 
		GETDATE(), 
		GETUTCDATE(), 
		dbo.func_get_nepali_date(default)
		)  --- notification for receiver (receiving user)

  commit transaction usertouserbalancetrf          
          
  select '0' code, @remarks_agent message, @sender_user_id sender_id, @reciever_user_id reciever_id          
 end try          
          
 begin catch          
  if @@trancount > 0          
   rollback transaction usertouserbalancetrf          
          
  set @desc = 'sql error found:(' + error_message() + ')' + ' at ' + error_line()          
          
  insert into tbl_error_log_sql(          
   sql_error_desc          
   ,sql_error_script          
   , sql_query_string          
   ,sql_error_category          
   ,sql_error_source          
   ,sql_error_local_date          
   ,sql_error_UTC_date          
   ,sql_error_nepali_date          
   )          
  select @desc          
   ,'sproc_balance_transfer(user to user balance trf:flag ''trf'')'          
   ,'sql'          
   ,'sql'          
   ,'sproc_balance_transfer((user to user balance trf)'          
   ,getdate()          
   ,getutcdate()          
   ,[dbo].func_get_nepali_date(default)          
          
  select '1' code          
   ,'errorid: ' + cast(scope_identity() as varchar) message          
   ,null id          
 end catch          
 end

END

GO


