USE [CGPay]
GO

/****** Object:  StoredProcedure [dbo].[sproc_settlement_report_2]    Script Date: 28/08/2020 11:52:19 ******/
DROP PROCEDURE [dbo].[sproc_settlement_report_2]
GO

/****** Object:  StoredProcedure [dbo].[sproc_settlement_report_2]    Script Date: 28/08/2020 11:52:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE PROCEDURE [dbo].[sproc_settlement_report_2] @flag CHAR(3) = NULL
	,@user_id VARCHAR(50) = NULL
	,@from_Date DATETIME = NULL
	,@to_Date DATETIME = NULL
	,@agent_id VARCHAR(50) = NULL
	,@txn_id VARCHAR(50) = NULL
	,@service VARCHAR(50) = NULL
	,@txnStatus VARCHAR(15) = NULL
	,@txnType VARCHAR(50) = NULL
	,@username VARCHAR(50) = NULL
AS
BEGIN
	DECLARE @parent_id INT
		,@commision_type BIT
		,@ccy VARCHAR(5)
		,@sql VARCHAR(max)
	DECLARE @user_type VARCHAR(50)
		,@is_auto_commission TINYINT
		,@from_Date_search DATETIME

	SET @ccy = 'NPR'

	SET NOCOUNT ON;

	SELECT @parent_id = a.parent_id
		,@agent_id = a.agent_id
		,@user_type = a.agent_type
		,@is_auto_commission = isnull(a.is_auto_commission, 0)
	FROM tbl_user_detail u with (NOLOCK)
	JOIN tbl_agent_detail a with (NOLOCK) ON a.agent_id = u.agent_id
	WHERE u.user_id = @user_id

	IF @from_date IS NULL
	BEGIN
		SET @from_Date = (
				SELECT convert(DATE, created_local_date, 23)
				FROM tbl_agent_detail with (NOLOCK)
				WHERE agent_id = @agent_id
				)
	END

	SET @from_Date_search = format(DATEADD(Day, 0, isnull(@from_Date, GETDATE())), 'yyyy-MM-dd')

	IF @to_Date IS NULL
	BEGIN
		SET @to_Date = DATEADD(Day, 1, GETDATE())
	END

	CREATE TABLE #temp (
		sno INT IDENTITY(1, 1)
		,Txn_Date DATETIME
		,Txn_Type VARCHAR(50)
		,Remarks VARCHAR(500)
		,Dr MONEY
		,Cr MONEY
		,Settlement_Amount MONEY
		,txn_title VARCHAR(250)
		,txn_mode VARCHAR(10)
		,txn_id VARCHAR(10)
		,txn_status VARCHAR(15)
		,txn_service VARCHAR(50)
		,search_data VARCHAR(100)
		)

	IF @flag = 'a'
	BEGIN
		WHILE @from_Date_search <= @to_Date
		BEGIN
			PRINT @from_date_search

			SELECT SUM(Settlement_Amount) OpeningAmount
			INTO #tempOpening
			FROM (
				SELECT ISNULL(ad.available_balance, 0) * 1 Settlement_Amount
				FROM tbl_user_detail u with (NOLOCK)
				JOIN tbl_agent_detail ad with (NOLOCK) ON ad.agent_id = u.agent_id
				WHERE user_id = @user_id
					AND ad.agent_id = @agent_id
				
				UNION ALL
				
				SELECT SUM(amount) * 1 Settlement_Amount
				FROM tbl_transaction bt WITH (NOLOCK)
				WHERE [USER_ID] = @user_id
					AND agent_id = @agent_id
					AND created_local_date > @from_Date_search + ' 23:59:59.997'
				--AND Status NOT IN ('Fail')   
				
				UNION ALL
				
				SELECT SUM(CASE 
							WHEN txn_mode = 'DR'
								THEN bt.amount
							ELSE bt.amount * - 1
							END) Settlement_Amount
				FROM dbo.tbl_agent_balance bt with (NOLOCK)
				JOIN tbl_agent_detail ad with (NOLOCK) ON bt.agent_id = ad.agent_id
				WHERE ad.agent_id = @agent_id
					AND bt.created_local_date > @from_Date_search + ' 23:59:59.997'
				
				UNION ALL
				
				SELECT sum(agent_commission) * - 1 Settlement_Amount
				FROM tbl_transaction_commission tc WITH (NOLOCK)
				JOIN tbl_transaction ttx with (NOLOCK) ON tc.txn_id = ttx.txn_id
				WHERE [USER_ID] = @user_id
					AND ttx.agent_id = @agent_id
					AND created_local_date > @from_Date_search + ' 23:59:59.997'
					AND ttx.STATUS NOT IN ('Failed')
					AND @is_auto_commission = 1
				) l

			INSERT #temp (
				Txn_Date
				,Txn_Type
				,Remarks
				,Dr
				,Cr
				,Settlement_Amount
				)
			SELECT CONVERT(VARCHAR, @from_date_search, 101) + ' 23:59:59.997'
				,NULL
				,'Opening(closing) Balance'
				,NULL
				,NULL
				,OpeningAmount
			FROM #tempOpening

			SET @from_Date_search = DATEADD(day, 1, @from_date_search)

			DROP TABLE #tempOpening
		END

		INSERT #temp
		SELECT *
		FROM (
			SELECT bt.created_local_date AS Txn_Date
				,(
					CASE 
						WHEN txn_type = 'r'
							THEN 'Balance Refund'
						WHEN txn_type = 'ct'
							THEN 'Card Transaction'
						WHEN txn_type = 'p2p'
							THEN 'Balance Transfer'
						WHEN txn_type = 'mp'
							THEN 'Merchant Payment'
						ELSE 'Fund Transfer'
						END
					) Txn_Type
				,CASE 
					WHEN txn_type = 'p2p'
						THEN CASE 
								WHEN txn_mode = 'DR'
									THEN '<div class="transaction-value">To : ' + (
											SELECT isnull(tu.full_name, '') + ' (' + tu.user_mobile_no + ')'
											FROM tbl_user_detail tu with (NOLOCK)
											WHERE user_id = bt.user_id
											) + '</div><div class="transaction-value">From : ' + isnull(ad.full_name, '') + ' (' + ad.agent_mobile_no + ')</div>'
								ELSE '<div class="transaction-value">To : ' + isnull(ad.full_name, '') + ' (' + ad.agent_mobile_no + ')</div><div class="transaction-value">From : ' + (
										SELECT isnull(tu.full_name, '') + ' (' + tu.user_mobile_no + ')'
										FROM tbl_user_detail tu with (NOLOCK)
										WHERE user_id = bt.user_id
										) + '</div>'
								END
					WHEN txn_type = 'r'
						THEN '<div class="transaction-value">Number : ' + (
								SELECT subscriber_no
								FROM tbl_transaction t
								WHERE t.txn_id = bt.txn_id
								) + '</div>'
					WHEN txn_type = 'ct'
						THEN '<div class="transaction-value">Card : ' + (
								SELECT sd.static_data_label + ' (' + REPLACE(card_no, LEFT(card_no, 12), 'xxxxxxxxxxxx') + ')'
								FROM tbl_agent_card_management c with (NOLOCK)
								JOIN tbl_static_data sd with (NOLOCK) ON sd.static_data_value = c.card_type
								WHERE c.agent_id = @agent_id
									AND card_id = dbo.func_GetNumeric(agent_remarks)
									AND sd.sdata_type_id = 23
								) + '</div>'
					WHEN txn_type = 'T'
						THEN '<div class="transaction-value">Bank : ' + bank_name + '</div>'
					WHEN txn_type = 'mp'
						THEN '<div class="transaction-value">To : ' + (
								SELECT isnull(qt.agent_name, '') + ' (' + qt.agent_code + ')'
								FROM tbl_agent_QR_transaction qt with (NOLOCK)
								WHERE pid = bt.txn_id
								) + '</div><div class="transaction-value">From : ' + isnull(ad.full_name, '') + ' (' + ad.agent_mobile_no + ')</div>'
					ELSE 'ID: [' + CAST(bt.balance_id AS VARCHAR) + '] - ' + ISNULL(bt.agent_remarks, 'Purchase Credit')
					END AS Remarks
				,(
					CASE 
						WHEN txn_mode = 'dr'
							THEN ISNULL(bt.amount, 0)
						ELSE 0
						END
					) DR
				,(
					CASE 
						WHEN txn_mode = 'cr'
							THEN ISNULL(bt.amount, 0)
						ELSE 0
						END
					) CR
				,(
					CASE 
						WHEN txn_mode = 'dr'
							THEN bt.amount * - 1
						ELSE bt.amount
						END
					) Settlement_Amount
				,(
					CASE 
						WHEN txn_type = 'r'
							THEN 'Balance Refund'
						WHEN txn_type = 'ct'
							THEN 'Card Transaction'
						WHEN txn_type = 'mp'
							THEN 'Merchant Payment'
						ELSE 'Balance Transfer'
						END
					) AS txn_title
				,txn_mode
				,balance_id
				,'success' txn_status
				,'' txn_service
				,isnull(ad.full_name, '') + ',' + ad.agent_mobile_no + ',' + (
					SELECT isnull(tu.full_name, '') + ',' + tu.user_mobile_no
					FROM tbl_user_detail tu with (NOLOCK)
					WHERE user_id = bt.user_id
					) search_data
			FROM tbl_agent_balance bt with (NOLOCK)
			JOIN tbl_agent_detail ad with (NOLOCK) ON bt.agent_id = ad.agent_id
			WHERE ad.agent_id = @agent_id
				AND bt.created_local_date BETWEEN @from_Date
					AND @to_Date + ' 23:59:59'
			
			UNION ALL
			
			SELECT created_local_date AS Txn_Date
				,CASE 
					WHEN bt.txn_type_id = 1
						THEN 'Mobile TopUp'
					ELSE 'Bill Payment'
					END Txn_Type
				,
				
				'<div class="transaction-value">Number : ' + subscriber_no + '</div>'
				,(amount) DR
				,0 CR
				,(amount) * - 1 AS Settlement_Amount
				,product_label AS txn_title
				,'DR'
				,txn_id
				,STATUS txn_status
				,product_id txn_service
				,subscriber_no search_data
			FROM tbl_transaction bt WITH (NOLOCK)
			WHERE [USER_ID] = @user_id
				AND agent_id = @agent_id
				AND created_local_date BETWEEN @from_Date
					AND @to_Date + ' 23:59:59.997'
			
			UNION ALL
			
			SELECT bt.created_local_date AS Txn_Date
				,CASE 
					WHEN @user_type = 'WalletUser'
						THEN 'Cash Back'
					ELSE 'Commission'
					END AS Txn_Type
				,
				'<div class="transaction-value">Number : ' + subscriber_no + '</div>'
				,
				(0) DR
				,cbt.agent_commission CR
				,(cbt.agent_commission) * 1 AS Settlement_Amount
				,'Cashback | ' + product_label AS txn_title
				,'CR'
				,bt.txn_id
				,'success' txn_status
				,'' txn_service
				,subscriber_no search_data
			FROM tbl_transaction_commission cbt with (NOLOCK)
			JOIN tbl_transaction bt with (NOLOCK) ON bt.txn_id = cbt.txn_id
			WHERE [USER_ID] = @user_id
				AND bt.agent_id = @agent_id
				AND created_local_date BETWEEN @from_Date
					AND @to_Date + ' 23:59:59.997'
				AND bt.STATUS IN ('Success')
				AND @is_auto_commission = 1
			) AS temp1
		ORDER BY Txn_Date ASC

		--select * from #temp
		SET @sql = '	SELECT
			txn_id,
			(case when txn_type is null then convert(date,Txn_Date,23) else Txn_Date end) as Txn_Dates
			,isnull(Txn_Type, '' '') Txn_Type
			,Remarks
			,txn_title
			,txn_mode
			,txn_service
			,txn_status
			,isnull(DR, '' '') DR
			,isnull(Cr, '' '') Cr
			,case 
				when txn_mode = ''CR'' then ''<span class="color-green">+''+cast(Settlement_Amount as varchar) + ''</span>''
				when txn_mode = ''DR'' then ''<span class="color-red">''+cast(Settlement_Amount as varchar)+ ''</span>''
				else cast(Settlement_Amount as varchar)
			END as Settlement_Amount
			
			
			,''' + @ccy + ''' CCY
			,search_data
		FROM #temp t where  convert(date,Txn_Date,101) in(select convert(date,Txn_Date,101) from #temp  group by convert(date,Txn_Date,101) having count(convert(date,Txn_Date,101))>1)'

		IF @txnStatus IS NOT NULL
			SET @sql = @sql + ' and txn_status=''' + @txnStatus + ''''

		IF @txnType IS NOT NULL
			SET @sql = @sql + ' and Txn_Type=''' + @txnType + ''''

		IF @service IS NOT NULL
			SET @sql = @sql + ' and txn_service=''' + @service + ''''

		IF @username IS NOT NULL
			SET @sql = @sql + ' and search_data like ''%' + @username + '%'''
		--set @username is not null
		SET @sql = @sql + ' order by Txn_Date desc'

		PRINT (@sql)

		EXEC (@sql)

		--drop table #tempOpening
		DROP TABLE #temp
	END

	IF @flag = 'M'
	BEGIN
		SET @sql = 
			'SELECT RIGHT(''0000000000'' + CAST(dt.txn_id AS VARCHAR), 8) AS txnid, 
       dt.product_label, 
       dt.company_id, 
       dm.company, 
       dm.txn_type, 
       dt.agent_id, 
       dt.subscriber_no, 
       dt.amount, 
       dt.service_charge, 
       dt.bonus_amt, 
       dt.[status], 
       dt.status_code, 
       dt.[user_id], 
       dt.created_local_date, 
       dt.created_by, 
       dt.created_platform, 
       dt.admin_commission, 
       dtc.agent_commission, 
       dtc.parent_commission, 
       dtc.grand_parent_commission, 
       dtc.txn_reward_point, 
       dtd.customer_id, 
       dtd.customer_name, 
       dtd.plan_id, 
       dtd.plan_name, 
       dtd.extra_field1, 
       dtd.extra_field2, 
       dtd.extra_field3, 
       dtd.extra_field4, 
       dt.admin_remarks, 
       dg.gateway_name AS gatewayname
FROM tbl_transaction dt
     LEFT JOIN tbl_transaction_commission dtc with (NOLOCK) ON dt.txn_id = dtc.txn_id
     JOIN tbl_manage_services dm with (NOLOCK) ON dm.product_id = dt.product_id
     LEFT JOIN tbl_transaction_detail dtd with (NOLOCK) ON dtd.txn_id = dt.txn_id
     INNER JOIN tbl_gateway_detail dg with (NOLOCK) ON dg.gateway_id = dt.gateway_id
      and dt.txn_id = ' 
			+ cast(@txn_id AS VARCHAR);

		IF @txn_id IS NULL
		BEGIN
			SELECT '1' code
				,'transaction id is required' message
				,NULL id;

			RETURN;
		END;

		IF @agent_id IS NOT NULL
		BEGIN
			SET @sql = @sql + ' and dt.agent_id= ' + cast(@agent_id AS VARCHAR);
		END;

		PRINT @sql;

		EXEC (@sql);
	END;-- transaction reciept 

	IF @flag = 'T'
	BEGIN
		SELECT created_local_date
			,created_platform
			,'Transfer' txntype
			,agent_name
			,amount
			,currency_code
			,agent_remarks
			,bank_name
		FROM tbl_agent_balance with (NOLOCK)
		WHERE balance_id = @txn_id
	END

	IF @flag = 'F'
	BEGIN
		SELECT ab.created_local_date
			,ab.created_platform
			,'Fund Transfer' txntype
			,ab.agent_name
			,ab.amount
			,ab.currency_code
			,ab.agent_remarks
			,ab.bank_name
			,pgt.service_charge
		FROM tbl_agent_balance ab with (NOLOCK)
		LEFT JOIN tbl_payment_gateway_transaction pgt with (NOLOCK) ON ab.txn_id = pgt.pmt_txn_id
		WHERE balance_id = @txn_id
	END

	IF @flag = 'MP'
	BEGIN
		SELECT ab.created_local_date
			,created_platform
			,'Merchant Payment' txntype
			,qt.agent_name
			,ab.amount
			,currency_code
			,agent_remarks
			,bank_name
		FROM tbl_agent_balance ab
		LEFT JOIN tbl_agent_QR_transaction qt with (NOLOCK) ON ab.txn_id = qt.pid
		WHERE balance_id = @txn_id
	END
END
GO


