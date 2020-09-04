USE [WePayNepal]
GO

/****** Object:  StoredProcedure [dbo].[sproc_transaction_limit]    Script Date: 5/28/2020 11:39:16 AM ******/
DROP PROCEDURE [dbo].[sproc_transaction_limit]
GO

/****** Object:  StoredProcedure [dbo].[sproc_transaction_limit]    Script Date: 5/28/2020 11:39:16 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[sproc_transaction_limit] 
	@flag  char(3), 
	@kyc_status varchar(15) = null,
	@txnl_Id integer = null,
	@transaction_limit_max decimal = null,
	@daily_max_limit decimal =null,
	@monthly_max_limit decimal =null,
	@action_by varchar(50) =null,
	@txn_type varchar(100) = null,
	@agent_id integer = null

AS

Declare @sql varchar(max),@daily_txn_amount decimal,@monthly_txn_amount decimal,@daily_remaining_limit decimal,@monthly_remaining_limit decimal
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @flag = 's'  --select           
	  BEGIN  
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
	  END; 

	IF @flag = 'u' --update
		BEGIN
			update tbl_NRB_transaction_limit 
				set transaction_limit_max = @transaction_limit_max,
					transaction_daily_limit_max=@daily_max_limit,	
					transaction_monthly_limit_max=@monthly_max_limit,
					updated_by =@action_by,
					updated_local_date=GETDATE(),
					updated_UTC_date=GETUTCDATE() 
				where txnl_Id = @txnl_Id
			select '0' code, 'Transaction limit updated succesfully' message
		END

	IF @flag = 'r' --display remaining daily and monthly limit
		BEGIN

			IF @agent_id is null
			BEGIN
				Select '1' code, 'Agent Id Required' message
				return
			END

			If @txn_type is null
				set @txn_type= 'Wallet Payment';

			set @kyc_status = (select (case kyc_status when 'Approved' THEN 'verified' Else 'not verified' End) from tbl_agent_detail where agent_id = @agent_id);

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


