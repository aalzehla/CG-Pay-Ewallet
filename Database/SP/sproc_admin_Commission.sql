USE [CGPay]
GO

/****** Object:  StoredProcedure [dbo].[sproc_admin_Commission]    Script Date: 22/08/2020 21:49:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE OR ALTER          
	

 PROCEDURE [dbo].[sproc_admin_Commission]
	-- Add the parameters for the stored procedure here
	@flag CHAR(5)
	,@from_Date VARCHAR(30) = NULL
	,@to_Date VARCHAR(30) = NULL
	,@product_id VARCHAR(20) = NULL
	,@currentDate datetime = NULL
	,@txn_id varchar(20) =  Null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @parent_id INT
		,@commision_type BIT
		,@userName VARCHAR(20)
		,@ccy VARCHAR(5)
		,@sql VARCHAR(max)

	IF @from_date IS NULL
	BEGIN
		SET @from_date = format(DATEADD(Day, 0, GETDATE()), 'yyyy-MM-dd')
	END

	IF @to_Date IS NULL
	BEGIN
		SET @to_Date = format(DATEADD(Day, 0, GETDATE()), 'yyyy-MM-dd')
	END

	IF @flag = 's'
	BEGIN
		SET @sql = '
		SELECT Convert(DATE,t.created_local_date,102) AS Transaction_date
			,t.product_label AS Service
			,t.product_id 
			,tms.txn_type as TransactionType
			,count(txn_id) AS TotalTransaction
			,Sum(Amount) AS TotalAmount
			,Sum(isnull(admin_commission,0)) AS CommissionEarned
		FROM tbl_transaction t WITH (NOLOCK)
		join tbl_manage_services tms WITH (NOLOCK) on tms.txn_type_id = t.txn_type_id and t.product_id = tms.product_id
		where 1= 1 and t.status = ''Success'''

		IF @from_Date IS NOT NULL
			AND @to_Date IS NOT NULL
		BEGIN
			SET @sql = @sql + ' and convert(DATE,t.created_local_date,102) between ''' + @from_Date + ''' and ''' + @to_Date + ' 23:59:59.997'''
		END

		SET @sql = @sql + ' Group by Convert(DATE,t.created_local_date,102) ,tms.txn_type, t.product_label, t.product_id'
		SET @sql = @sql + ' order by Convert(DATE,t.created_local_date,102) desc '

		print (@sql)
		exec (@sql)
	END

	IF @flag = 'dt'
	BEGIN
	
		SELECT txn_id AS TxnId
			,t.product_label AS [Services]
			,t.created_local_date
			,subscriber_no AS SubscriberNo
			,amount
			,t.created_local_date AS CreatedDate
			,gateway_txn_id AS GatewayTxnId
			,t.created_by
			,admin_commission
			,m.txn_type
		FROM tbl_transaction t WITH (NOLOCK)
		left join tbl_manage_services m on m.txn_type_id = t.txn_type_id and m.product_id = t.product_id
		WHERE t.product_id = @product_id
			AND  convert(date,t.created_local_date,102) = convert(date,@currentDate,102)
			AND t.STATUS = 'Success'
	END

	if @flag = 'dd'
	Begin
		SELECT txn_id AS TxnId
			,t.product_label AS [Services]
			,subscriber_no AS SubscriberNo
			,isnull(amount,0) Amount
			,t.created_local_date AS CreatedDate
			,gateway_txn_id AS GatewayTxnId
			,t.created_by
			,isnull(admin_commission,0) AdminCommission
			,isnull(admin_cost_amount,0)AdminCostAmount
			,t.admin_remarks
			,agent_remarks
			,g.gateway_name
			,m.txn_type
			,ad.agent_name
			,t.status
			,isnull(t.service_charge,0)ServiceCharge
			,isnull(t.bonus_amt,0)BonusAmount
			,m.company
		FROM tbl_transaction t WITH (NOLOCK) 
		left join tbl_manage_services m on m.txn_type_id  =  t.txn_type_id and m.product_id = t.product_id
		left join tbl_gateway_Detail g on g.gateway_id = t.gateway_id
		left join tbl_agent_detail  ad on ad.agent_id =  t.agent_id
		where txn_id = @txn_id
	End
END
GO


