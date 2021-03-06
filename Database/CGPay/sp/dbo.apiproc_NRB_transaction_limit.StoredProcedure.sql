USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[apiproc_NRB_transaction_limit]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[apiproc_NRB_transaction_limit] 
	@flag char(3),
	@kyc_status varchar(15) = null,
	@txnl_Id integer = null,
	@transaction_limit_max decimal(18,2) = null,
	@daily_max_limit decimal(18,2) =null,
	@monthly_max_limit decimal(18,2) =null,
	@action_by varchar(50) =null,
	@txn_type varchar(100) = null,
	@user_name varchar(512) =  null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   Declare @agent_id int, @user_id int , @sql varchar(max)

   if @user_name is null
   begin
	select '105' code, 'User name is required' message, null id
	return
   end

   if not exists(select 'x' from tbl_user_detail u join tbl_agent_detail a on a.agent_id =  u.agent_id where user_mobile_no = @user_name or user_email = @user_name)
   begin
	select '104' code, 'User Not Found'  message, null id
	return
   end
   else
   begin
	select @agent_id = u.agent_id, @user_id = u.user_id, @kyc_status = a.kyc_status from tbl_user_detail u 
	join tbl_agent_detail a on a.agent_id =  u.agent_id
	where user_mobile_no = @user_name or user_email = @user_name
   end	
   			set @kyc_status = (select (case kyc_status when 'Approved' THEN 'verified' Else 'not verified' End) from tbl_agent_detail where agent_id = @agent_id);



   if @flag = 's'
   begin
	 SET @sql = 'SELECT txnl_Id,txn_type,transaction_limit_max,transaction_daily_limit_max,transaction_monthly_limit_max,KYC_Status,created_by,
					created_local_date,created_UTC_date FROM tbl_NRB_transaction_limit WHERE 1=1 '; 
	   
	   IF (@kyc_status IS NOT NULL)  
	   BEGIN  
		SET @sql = @sql + ' AND KYC_Status = ''' + @kyc_status + '''';  
	   END;  
	   IF (@txnl_Id IS NOT NULL)  
	   BEGIN  
		SET @sql = @sql + ' AND txnl_Id =' + CAST(@txnl_Id as varchar(10)) ;  
	   END;  

	   PRINT @sql;  
  
	   EXEC (@sql);  
   end

   IF @flag = 'r' --display remaining daily and monthly limit
		BEGIN

			IF @agent_id is null
			BEGIN
				Select '114' code, 'Agent Id Required' message
				return
			END

			If @txn_type is null
				set @txn_type= 'Wallet Payment';


			select
				@transaction_limit_max=transaction_limit_max,
				@daily_max_limit=transaction_daily_limit_max,
				@monthly_max_limit=transaction_monthly_limit_max 
			from tbl_NRB_transaction_limit 
			where 
				KYC_Status=@kyc_status 
			and
				txn_type=@txn_type  --Wallet Payment
		
			select 
				@transaction_limit_max transaction_limit_max,
				@daily_max_limit transaction_daily_limit_max,
				(@daily_max_limit - isnull(sum( case when (DAY(created_UTC_date) = DAY(getutcdate()) AND MONTH(created_UTC_date) = MONTH(getutcdate()) AND YEAR(created_UTC_date) = YEAR(getutcdate()))  then amount end),0)) as daily_remaining_limit,
				@monthly_max_limit transaction_monthly_limit_max,
				(@monthly_max_limit - isnull(sum( case when (MONTH(created_UTC_date) = MONTH(getutcdate()) AND YEAR(created_UTC_date) = YEAR(getutcdate())) then amount end),0)) as monthly_remaining_limit
			FROM 
				tbl_transaction
			WHERE 
				status = 'success'
			and
				agent_id = @agent_id
		
		END

END


GO
