USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_agent_balance]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE PROC [dbo].[sproc_agent_balance]
	(
	 @flag					VARCHAR(10) --i=INSERT,u=UPDATE,d=DELETE,s=SEARCH
	,@balance_id				INT				 =NULL
	,@agent_id				VARCHAR(20)		 =NULL
	,@agent_name				VARCHAR(50)		 =NULL
	,@amount				DECIMAL(18,2)	 =NULL
	,@currency				CHAR(3)			 =NULL
	,@remarks				VARCHAR(500)	 =NULL
	,@user_id				VARCHAR(50)		 =NULL
	,@type					CHAR(3)			 =NULL
	,@bank_id				INT				 =NULL
	,@bank_name				VARCHAR(100)	 =NULL
	,@pmt_gateway_id			INT				 =NULL
	,@pmt_gateway_txn_id			varchar(20)		 =NULL
	,@remit_pay_id			INT				 =NULL
	,@remit_ref_no			Varchar(50)		 =NULL
	,@fund_load_reward		INT				 =NULL
	,@action_ip				NVARCHAR(50)	 =NULL
	,@action_user			NVARCHAR(200)	 =NULL
	,@platform		        VARCHAR(20)		 =NULL
	,@txn_id					VARCHAR(20)		 =NULL
	,@balance_type			VARCHAR(20)		 =NULL  --cash/digital/p2p
	,@from_date				VARCHAR(20)		 =NULL
	,@to_date				VARCHAR(20)		 =NULL
	)

	AS
	SET NOCOUNT ON
	BEGIN TRY
  
	BEGIN
	Declare @sql varchar (max)

	IF(@Flag='i')
	BEGIN

	IF(@action_user IS NULL)
		BEGIN
	 EXEC sproc_error_handler @error_code='1',@Msg='Action User is required', @id=NULL
	 RETURN
	END

	  IF EXISTS (SELECT TOP 1 'X' FROM tbl_agent_balance WHERE agent_id = @agent_id)  
	 BEGIN  
	  EXEC sproc_error_handler @error_code='1',@Msg='Agent Id already exists', @id=NULL
	  RETURN  
	 END 

	INSERT INTO tbl_agent_balance
	(
   		 [agent_id]
		,[agent_name]
		,[Amount] 
		,[currency_code] 
		,[agent_remarks] 
		,[user_id]
		,[txn_type] 
		,[bank_id] 
		,[bank_name] 
		,[pmt_gateway_id] 
		,[pmt_gateway_txn_id] 
		,[remit_pay_id]
		,[remit_ref_no] 
		,[fund_load_reward]
		,[created_UTC_date] 
		,[created_local_date]
		,[created_nepali_date] 
		,[created_by] 
		,[created_ip]
		,[created_platform]

	)
	VALUES
	(
	  @agent_id
	 ,@agent_name
	 ,@Amount
	 ,@Currency
	 ,@Remarks
	 ,@user_id
	 ,@Type
	 ,@bank_id
	 ,@bank_name
	 ,@pmt_gateway_id
	 ,@pmt_gateway_txn_id
	 ,@remit_pay_id
	 ,@remit_ref_no
	 ,@fund_load_reward
	 ,GETUTCDATE()
	 ,GETDATE()
	 ,dbo.func_get_nepali_date(DEFAULT)
	 ,@action_user
	 ,@action_ip
	 ,@Platform

	)
	update tbl_agent_detail set available_balance = Isnull(available_balance,0) +  Isnull(@Amount,0) where agent_id = @agent_id
	EXEC sproc_error_handler @error_code='0',@Msg='Agent balance updated successfully', @id=NULL

	RETURN 
	END

	IF(@Flag='u')
	BEGIN
		
	IF(@action_user IS NULL)
	BEGIN
	 EXEC sproc_error_handler @error_code='1',@Msg='Action User is required', @id=NULL
	 RETURN
	END

	 IF (@balance_id IS NULL)  
	  BEGIN  
	   EXEC sproc_error_handler @error_code='1',@Msg='Balance ID is required', @id=NULL      
	   RETURN  
	  END  
  
	 IF((SELECT COUNT(*)FROM tbl_agent_balance WHERE balance_id=@balance_id AND agent_id=@agent_id)=0)  
	 BEGIN  
		EXEC sproc_error_handler @error_code='1',@msg='Agent Balance record is not found', @id=@balance_id    
	  RETURN  
   
	 END  

	UPDATE tbl_agent_balance 
	SET
	
	     [agent_id]=ISNULL(@agent_id,[agent_id])
		,[agent_name]=ISNULL(@agent_name,[agent_name])
		,[Amount] =ISNULL(@Amount,[Amount])
		,[currency_code] =ISNULL(@Currency,[currency_code])
		,[agent_remarks] =ISNULL(@Remarks,[agent_remarks])
		,[user_id]=ISNULL(@user_id,[user_id])
		,[txn_type] =ISNULL(@Type,[txn_type])
		,[bank_id] =ISNULL(@bank_id,[bank_id])
		,[bank_name] =ISNULL(@bank_name,[bank_name])
		,[pmt_gateway_id] =ISNULL(@pmt_gateway_id,[pmt_gateway_id])
		,[pmt_gateway_txn_id] =ISNULL(@pmt_gateway_txn_id,[pmt_gateway_txn_id])
		,[remit_pay_id]=ISNULL(@remit_pay_id,[remit_pay_id])
		,[remit_ref_no] =ISNULL(@remit_ref_no,[remit_ref_no])
		,[fund_load_reward]=ISNULL(@fund_load_reward,[fund_load_reward])
		,[updated_UTC_date]=GETUTCDATE()
		,[updated_local_date]=GETDATE()
		,[updated_nepali_date] = dbo.func_get_nepali_date(DEFAULT)
		,[updated_by] =ISNULL(@action_user,[updated_by])
		,[updated_ip]=ISNULL(@action_ip,[updated_ip])

	     WHERE balance_id=@balance_id AND agent_id=@agent_id
		 EXEC sproc_error_handler @error_code='0',@Msg='BALANCE UPDATED SUCCESSFULLY', @id=NULL 
		 RETURN

	END

	IF(@Flag='s')
	BEGIN
	set @sql = ' SELECT BalanceId, AgentName,Amount, Currency, Remarks, Type, BankName, PGatewayId, PGatewayTxnId, RemitPayId, RemitRefNo, FundLoadReward, CreatedDateLocal, CreatedDateBS,ParentId, Txnid, Mode FROM DtaAgentBalance where 1 = 1'
		if @agent_id is not  null
		Begin
			set @sql = @sql + ' and agentid ='''+@agent_id+''''
		End

		if @Type is not null
		begin
			set @sql = @sql + ' and Type = '''+@Type+''''
		end

		if @bank_id is not null
		begin
			set @sql = @sql + ' and BankId = '''+cast(@bank_id as Varchar)+''''
		end

		if @pmt_gateway_id is not null
		begin
			set @sql = @sql + ' and PGatewayId = '''+cast(@pmt_gateway_id as varchar)+''''
		end

		if @remit_pay_id is not null
		begin
			set @sql = @sql + ' and RemitPayId = '''+cast(@remit_pay_id as varchar)+''''
		end
		
		if @from_date is not null or @to_date is not null
		begin
			set @sql = @sql + ' and CreatedDateLocal between '''+cast(@from_date as varchar)+''' and '''+ cast(@to_date as varchar)+'' + ' 23:59:59.997'''
		end

		-- for txn search using txn id or remitrefNo or pgatewaytxnId
		if @txn_id is not null
		begin
			set @sql =  ' select BalanceId, AgentName,Amount, Currency, Remarks, Type, BankName, PGatewayId, PGatewayTxnId, RemitPayId, RemitRefNo, FundLoadReward, CreatedDateLocal, CreatedDateBS,ParentId, Txnid, Mode from DtaAgentBalance where 1=1 and txnID = '''+cast(@txn_id as varchar)+''' 
			or RemitRefNo = '''+cast(@txn_id as varchar)+''' 
			or PGatewayTxnId = '''+cast(@txn_id as varchar)+''''
		end

		set @sql = @sql + ' order by 1 desc'
	
		print (@sql)
		exec (@sql)
	END

	If (@Flag = 'si')
	Begin
		Select balance_id, agent_name,Amount, currency_code, agent_remarks, txn_type, bank_name, pmt_gateway_id, pmt_gateway_txn_id, remit_pay_id, remit_ref_no, fund_load_reward, created_local_date, created_UTC_date,created_nepali_date,  agent_parent_id, txn_id, txn_mode from tbl_agent_balance where balance_id = @balance_id
		return
	End
	END

	END TRY   
	BEGIN CATCH  
	 IF @@trancount > 0
	  ROLLBACK TRANSACTION  
  
	 SELECT 1 CODE  
	  ,ERROR_MESSAGE() msg  
	  ,NULL id  
	END CATCH  



GO
