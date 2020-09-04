USE [CGPay]
GO

/****** Object:  StoredProcedure [dbo].[sproc_topup_report]    Script Date: 27/08/2020 16:47:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER
	

 PROCEDURE [dbo].[sproc_topup_report] @flag CHAR(3)
	,@agent_id INT = NULL
	,@txn_id INT = NULL
	,@parent_id INT = NULL
	,@grandparent_id INT = NULL
	,@product_id INT = NULL
	,@product_name VARCHAR(100) = NULL
	,@gateway_id INT = NULL
	,@from_date DATETIME = NULL
	,@to_date DATETIME = NULL
	,@status VARCHAR(100) = NULL
	,@distributor_id INT = NULL
	,@sub_dist_id INT = NULL
	,@txn_type_id INT = NULL
	,@product_type VARCHAR(20) = NULL
	,@created_by VARCHAR(50) = NULL
	,@action_user VARCHAR(50) = NULL
	,@processId VARCHAR(max) = NULL
AS
BEGIN
	-- set nocount on added to prevent extra result sets from
	-- interfering with select statements.
	SET NOCOUNT ON;

	DECLARE @sql VARCHAR(max);

	IF @from_date IS NULL
	BEGIN
		SET @from_date = Convert(DATE, (DATEADD(Hour, - 1, GETDATE())), 120) -- as varchar)
	END
	ELSE
	BEGIN
		SET @from_date = convert(DATE, @from_date, 120)
	END

	IF @to_date IS NULL
	BEGIN
		SET @to_date = Convert(DATE, (DATEADD(hour, 0, GETDATE())), 120) -- as varchar)
	END
	ELSE
	BEGIN
		SET @to_date = convert(DATE, @to_date, 120)
	END

	IF @flag = 's'
	BEGIN
		SET @sql = 'select right(''0000000000'' + cast(dt.txn_id as varchar), 8) as txnid, 
       product_label, 
       grand_parent_id, 
       parent_id, 
       dt.agent_id, 
       subscriber_no, 
       amount, 
       status as txnstatus, 
       user_id, 
       created_local_date as txndate,
	   agent_remarks
from tbl_transaction dt
    left join tbl_transaction_commission dtc with (NOLOCK) on dt.txn_id = dtc.txn_id
     left join tbl_transaction_detail dtd with (NOLOCK) on dtd.txn_id = dt.txn_id
where 1 = 1 ';

		IF @agent_id IS NOT NULL
		BEGIN
			SET @sql = @sql + ' and dt.agentid = ' + cast(@agent_id AS VARCHAR);
		END;

		IF @txn_id IS NOT NULL
		BEGIN
			SET @sql = @sql + ' and dt.txnid = ' + cast(@txn_id AS VARCHAR);
		END;

		IF @product_id IS NOT NULL
		BEGIN
			SET @sql = @sql + ' and dt.productid = ' + cast(@product_id AS VARCHAR);
		END;

		IF @gateway_id IS NOT NULL
		BEGIN
			SET @sql = @sql + ' and dt.gatewayid = ' + cast(@gateway_id AS VARCHAR);
		END;

		IF @status IS NOT NULL
		BEGIN
			SET @sql = @sql + ' and dt.status = ''' + @status + '''';
		END;

		IF @from_date IS NOT NULL
			AND @to_date IS NOT NULL
		BEGIN
			SET @sql += ' and dt.created_local_date between ''' + convert(VARCHAR(10), @from_date, 101) + ''' and ''' + convert(VARCHAR(10), dateadd(dd, 1, @to_date), 101) + '''';
		END;

		PRINT @sql;

		EXEC (@sql);
	END;-- get customer topup report

	IF @flag = 'smt'
	BEGIN
		SELECT TOP 10 right('0000000000' + cast(dt.txn_id AS VARCHAR), 8) AS txnid
			,dt.product_label
			,grand_parent_id
			,parent_id
			,dt.agent_id
			,subscriber_no
			,amount
			,dt.STATUS AS txnstatus
			,user_id
			,dt.created_local_date AS txndate
		FROM tbl_transaction dt WITH (NOLOCK)
		JOIN tbl_transaction_commission dtc WITH (NOLOCK) ON dt.txn_id = dtc.txn_id
		LEFT JOIN tbl_transaction_commission dtd WITH (NOLOCK) ON dtd.txn_id = dt.txn_id
		JOIN tbl_manage_services ms WITH (NOLOCK) ON ms.product_id = dt.product_id
		WHERE CASE 
				WHEN @created_by IS NOT NULL
					THEN dt.created_by
				ELSE cast(dt.agent_id AS VARCHAR)
				END = CASE 
				WHEN @created_by IS NOT NULL
					THEN @created_by
				ELSE cast(@agent_id AS VARCHAR)
				END
			AND ms.product_type = @product_type
		ORDER BY dt.created_local_date DESC;
	END;-- customer top 10 txns

	IF @flag = 'rct'
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

	IF @flag = 'sp'
	BEGIN
		SET @sql = 
			'SELECT RIGHT(''0000000000'' + CAST(dt.txn_id AS VARCHAR), 8) AS txnid, 
       dm.txn_type, 
       du.[user_name], 
       dt.[product_label], 
       subscriber_no, 
       dt.created_local_date AS txndate, 
       amount, 
       dt.admin_remarks, 
       dg.gateway_name AS gatewayname
FROM tbl_transaction dt
     JOIN tbl_transaction_commission dtc with (NOLOCK) ON dt.txn_id = dtc.txn_id
     LEFT JOIN tbl_transaction_detail dtd with (NOLOCK) ON dtd.txn_id = dt.txn_id
     INNER JOIN tbl_agent_detail dta with (NOLOCK) ON dta.agent_id = dt.agent_id
     INNER JOIN tbl_agent_detail dta1 with (NOLOCK) ON dta1.agent_id = dt.parent_id
     INNER JOIN tbl_agent_detail dta2 with (NOLOCK) ON dta2.agent_id = dt.grand_parent_id
     INNER JOIN tbl_manage_services dm with (NOLOCK) ON dm.product_id = dt.product_id
     INNER JOIN tbl_gateway_detail dg with (NOLOCK) ON dg.gateway_id = dt.gateway_id
     INNER JOIN tbl_user_detail du with (NOLOCK) ON du.[user_id] = dt.[user_id]
            where 1 = 1'
			;

		IF @distributor_id IS NOT NULL
		BEGIN
			SET @sql = @sql + ' and dt.parent_id = ' + cast(@distributor_id AS VARCHAR);
		END;

		IF @sub_dist_id IS NOT NULL
		BEGIN
			IF @distributor_id IS NULL
			BEGIN
				SELECT '1' code
					,' parent id is required' message
					,NULL id;

				RETURN;
			END;
			ELSE
			BEGIN
				SET @sql = @sql + ' and dt.parent_id = ' + cast(@sub_dist_id AS VARCHAR) + 'and dt.grandparentid = ' + cast(@distributor_id AS VARCHAR);
			END;
		END;

		IF @txn_type_id IS NOT NULL
		BEGIN
			SET @sql = @sql + ' and dt.txn_type_id = ' + cast(@txn_type_id AS VARCHAR);
		END;

		IF @product_id IS NOT NULL
		BEGIN
			SET @sql = @sql + ' and dt.product_id = ' + cast(@product_id AS VARCHAR);
		END;

		IF @status IS NOT NULL
		BEGIN
			SET @sql = @sql + '  and dt.status = ''' + @status + '''';
		END;

		IF @from_date IS NOT NULL
			AND @to_date IS NOT NULL
		BEGIN
			SET @sql += ' and dt.created_local_date between ''' + convert(VARCHAR(10), @from_date, 101) + ''' and ''' + convert(VARCHAR(10), dateadd(dd, 1, @to_date), 101) + '''';
		END;

		PRINT @sql;

		EXEC (@sql);
	END;-- merchant detail/topup report

	IF @flag = 'txn' -- search individual txn
	BEGIN
		IF @txn_id IS NULL
		BEGIN
			SELECT '1' code
				,'transaction id/subscriber no/partner txn id is required' message
				,NULL id;

			RETURN;
		END;

		SET @sql = 
			'select right(''0000000000'' +cast(dt.txn_id as varchar), 8) as txnid, dm.txn_type, du.user_name,
dt.product_label,subscriber_no, convert(varchar,dt.created_local_date,103) as txndate,cast(amount as varchar) amount,dt.admin_remarks,dg.gateway_name as gatewayname 
            from tbl_transaction dt 
            join tbl_transaction_commission dtc with (NOLOCK) on dt.txn_id = dtc.txn_id
            left join tbl_transaction_detail dtd with (NOLOCK) on dtd.txn_id = dt.txn_id
            inner join tbl_agent_detail dta with (NOLOCK) on dta.agent_id  =  dt.agent_id
            inner join tbl_agent_detail dta1 with (NOLOCK) on dta1.agent_id  =  dt.parent_id 
            inner join tbl_agent_detail dta2 with (NOLOCK) on dta2.agent_id  =  dt.grand_parent_id
            inner join tbl_manage_services dm with (NOLOCK) on dm.product_id = dt.product_id
            inner join tbl_gateway_detail dg with (NOLOCK) on dg.gateway_id = dt.gateway_id
            inner join tbl_user_detail du with (NOLOCK) on du.[user_id] =  dt.[user_id]
            where 1 = 1  
            and dt.txn_id = ' 
			+ cast(@txn_id AS VARCHAR) + '
            or dt.subscriber_no like ''%' + cast(@txn_id AS VARCHAR) + '%''
            or dt.partner_txn_id like ' + cast(@txn_id AS VARCHAR) + '';

		PRINT @sql;

		EXEC (@sql);
	END;

	IF @flag = 'rcc'
	BEGIN
		IF @txn_id IS NULL
		BEGIN
			SELECT '1' code
				,'transaction id is required' message
				,NULL id;

			RETURN;
		END;
		ELSE
		BEGIN
			IF NOT EXISTS (
					SELECT 'x'
					FROM tbl_transaction
					WHERE created_by = @action_user
						AND @txn_id = @txn_id
					)
			BEGIN
				SELECT '1' code
					,'transaction not found' message
					,NULL id;

				RETURN;
			END;
		END;

		SELECT '0' code
			,'nea' templatename
			,-- reciept template
			ms.product_logo AS servicelogourl
			,ms.product_label AS servicetitle
			,ms.company AS fullservicename
			,
			--for nea
			nea.nea_txn_id AS receiptno
			,nea.office_code AS officeid
			,nea.office AS countername
			,nea.consumer_id AS consumerid
			,nea.bill_date
			,nea.due_bill_of AS duebillof
			,nea.no_of_days
			,nea.sc_no
			,nea.consumed_units AS consumedunit
			,nea.payable_amt AS payableamount
			,nea.rebate AS rebate
			,nea.fine_rate AS finerate
			,nea.payable_amt AS payableamount
			,nea.service_charge AS servicecharge
			,nea.total_due_amt AS totaldueamt
			,nea.paid_amt AS paidamount
			,nea.amount_due_left AS amountdueleft
			,nea.customer_name AS [name]
			,dt.txn_id
			,dt.product_id
			,subscriber_no
			,amount
			,dt.service_charge
			,bonus_amt
			,dt.created_local_date AS DATE
			,dt.created_nepali_date
			,dt.created_by
			,dt.STATUS AS [status]
			,'1111' billno
			,'' logourlextra
		FROM tbl_transaction dt WITH (NOLOCK)
		JOIN tbl_manage_services ms WITH (NOLOCK) ON ms.product_id = dt.product_id
		LEFT JOIN tbl_transaction_detail_nea nea WITH (NOLOCK) ON nea.txn_id = dt.txn_id
		WHERE dt.txn_id = @txn_id
		ORDER BY 1 DESC;
	END;-- transaction reciept copy

	IF @flag = 'p' -- pending txns
	BEGIN
		SELECT right('0000000000' + cast(dt.txn_id AS VARCHAR), 8) AS txnid
			,product_label
			,grand_parent_id
			,parent_id
			,dt.agent_id
			,subscriber_no
			,amount
			,STATUS AS txnstatus
			,user_id
			,created_local_date AS txndate
			,agent_remarks
		FROM tbl_transaction dt
		LEFT JOIN tbl_transaction_commission dtc WITH (NOLOCK) ON dt.txn_id = dtc.txn_id
		LEFT JOIN tbl_transaction_detail dtd WITH (NOLOCK) ON dtd.txn_id = dt.txn_id
		WHERE 1 = 1
			AND dt.STATUS = 'Pending'
	END

	IF @flag = 'mt' -- merchant transactions
	BEGIN
		SET @sql = '	SELECT qr.agent_id as MerchantID
				,ad.agent_name as MerchantName
			,qr.agent_code as MerchantCode
			,u.full_name as MerchantName
			,isnull(qr.amount, 0) Amount
			,isnull(qr.commission_amt, 0) CommissionAmt
			,u.user_mobile_no UserId
			,pid as TxnId
			,qr.created_local_date createdDate
		FROM tbl_agent_QR_transaction qr with (NOLOCK)
		join tbl_user_detail u with (NOLOCK) on u.user_id = qr.created_by
		join tbl_agent_detail ad with (NOLOCK) on ad.agent_id =  qr.agent_id
		where 1  = 1 '

		IF @agent_id IS NOT NULL
		BEGIN
			SET @sql = @sql + ' and qr.agent_id = ' + cast(@agent_id AS VARCHAR)
		END

		IF (
				@from_date IS NOT NULL
				AND @to_date IS NOT NULL
				)
		BEGIN
			SET @sql = @sql + ' and qr.created_local_date between ''' + convert(VARCHAR(10), @from_date, 101) + ''' and ''' + convert(VARCHAR(10), dateadd(dd, 1, @to_date), 101) + ' 23:59:59.997'''
			SET @sql += ' order by qr.created_local_date desc'
		END;

		PRINT @sql;

		EXEC (@sql);
	END

	IF @flag = 'b' -- bulk topup reciept
	BEGIN
		SELECT product_label
			,subscriber_no
			,isnull(amount, 0)amount
			,isnull(service_charge, 0)service_charge
			,isnull(bonus_amt, 0)bonus_amt
			,isnull(tc.agent_commission, 0)agent_commission
			,STATUS
			,created_local_date AS TxnCreatedDate
			,updated_local_date AS TxnUpdatedDate
			,agent_remarks
		FROM tbl_transaction t WITH (NOLOCK)
		JOIN tbl_transaction_commission tc WITH (NOLOCK) ON tc.txn_id = t.txn_id
		WHERE process_id = @processId
	END
END;
GO


