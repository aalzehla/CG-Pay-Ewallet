USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_pmt_gatewayTxn_report]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE
	

 PROCEDURE [dbo].[sproc_pmt_gatewayTxn_report]
	-- Add the parameters for the stored procedure here
	@flag CHAR(3)
	,@fromDate VARCHAR(20) = NULL
	,@toDate VARCHAR(20) = NULL
	,@userMobileNo VARCHAR(20) = NULL
	,@pmtGatewayId INT = NULL
	,@pmtGatewayTxnId VARCHAR(20) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @sql VARCHAR(max)

	IF @flag = 's'
	BEGIN
		IF @fromdate IS NULL
		BEGIN
			SET @fromdate = Convert(DATE, (DATEADD(Hour, - 1, GETDATE())), 120) -- as varchar)
		END
		ELSE
		BEGIN
			SET @fromdate = convert(DATE, @fromdate, 120)
		END

		IF @todate IS NULL
		BEGIN
			SET @todate = Convert(DATE, (DATEADD(hour, 0, GETDATE())), 120) -- as varchar)
		END
		ELSE
		BEGIN
			SET @todate = convert(DATE, @todate, 120)
		END

		SET @sql = '
		select pmt_txn_id TxnId,
isnull(pgt.amount,0)Amount, 
isnull(service_charge,0)ServiceCharge, 
isnull(total_amount,0)TotalAmount,
status,
pmt_gateway_name as GatewayName,
pgt.pmt_gateway_txn_id as GatewayTxnId,
pgt.agent_id as AgentId,
pgt.user_id as UserId,
type as TxnType,
agent_name as AgentName ,
pgt.created_local_date as createdDate
from tbl_payment_gateway_transaction pgt
join tbl_agent_balance  ab  on ab.txn_id =  pgt.pmt_txn_id
where pgt.status = ''Success'' '

		IF @userMobileNo IS NOT NULL
		BEGIN
			SET @sql = @sql + ' AND pgt.mobile = ' + @userMobileNo
		END

		IF @pmtGatewayId IS NOT NULL
		BEGIN
			SET @sql = @sql + ' AND pgt.pmt_gateway_id = ' + cast(@pmtGatewayId AS VARCHAR)
		END

		IF @pmtGatewayTxnId IS NOT NULL
		BEGIN
			SET @sql = @sql + ' AND pgt.pmt_gateway_txn_id = ' + @pmtGatewayTxnId
		END
		ELSE
		BEGIN
			IF (
					@fromdate IS NOT NULL
					AND @todate IS NOT NULL
					)
			BEGIN
				SET @sql = @sql + ' and pgt.Created_local_Date between ''' + @fromdate + ''' and ''' + @todate + ' 23:59:59.997''';
			END
		END

		SET @sql = @sql + ' ORDER BY pgt.created_local_date DESC'

		PRINT (@sql)

		EXEC (@sql)
	END
END


GO
