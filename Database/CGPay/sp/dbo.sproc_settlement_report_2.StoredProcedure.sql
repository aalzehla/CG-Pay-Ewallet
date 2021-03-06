USE [CGPay]
GO
/****** Object:  StoredProcedure [dbo].[sproc_settlement_report_2]    Script Date: 8/13/2020 2:59:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Drop Procedure [sproc_settlement_report_2]
go


-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
Create     PROCEDURE [dbo].[sproc_settlement_report_2] 
	@flag CHAR(3) = NULL
	,@user_id VARCHAR(50) = NULL
	,@from_Date DATETIME = NULL
	,@to_Date DATETIME = NULL
	,@agent_id VARCHAR(50) = NULL
	,@txn_id varchar(50)=null
	,@service varchar(50)=null
	,@txnStatus varchar(15)=null
	,@txnType varchar(50)=null
	,@username varchar(50)=null
AS
BEGIN  
 declare @parent_id int , @commision_type bit,@ccy varchar(5), @sql varchar(max) 
 declare @user_type varchar(50),@is_auto_commission tinyint,@from_Date_search datetime
  
 set @ccy='NPR'    
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  --set @from_Date_search = isnull( @from_date,format(DATEADD(Day, -1, GETDATE()),'yyyy-MM-dd'))
  --set @from_Date = '2020-06-09'
  SELECT @parent_id = a.parent_id
		,@agent_id = a.agent_id
		
		,@user_type = a.agent_type
		,@is_auto_commission = isnull(a.is_auto_commission, 0)
	FROM tbl_user_detail u
	JOIN tbl_agent_detail a ON a.agent_id = u.agent_id
	WHERE u.user_id = @user_id
 
 if @from_date is null  
 begin 
  set @from_Date = (select convert(date,created_local_date,23) from tbl_agent_detail where agent_id = @agent_id)
  --set @from_date =format(DATEADD(DAY, DATEDIFF(DAY, 0 , CURRent_TIMESTAMP),0),'yyyy-MM-dd')
  --set @from_date = format(DATEADD(Day, -1, GETDATE()),'yyyy-MM-dd')  
 end 
 SET @from_Date_search = format(DATEADD(Day, 0, isnull(@from_Date, GETDATE())), 'yyyy-MM-dd')

  
 if @to_Date is null  
 begin  
  set @to_Date = DATEADD(Day, 1, GETDATE())  
 end  
 
  
 CREATE TABLE #temp (
		sno INT IDENTITY(1, 1)
		,Txn_Date datetime
		,Txn_Type VARCHAR(50)
		,Remarks VARCHAR(500)
		,Dr MONEY
		,Cr MONEY
		,Settlement_Amount MONEY
		,txn_title varchar(250)
		,txn_mode varchar(10)
		,txn_id varchar(10)
		,txn_status varchar(15)
		,txn_service varchar(50)
		,search_data varchar(100)
		)
		
   

 IF @flag='a'                                              
    BEGIN    
   while @from_Date_search<=@to_Date
	begin
		print @from_date_search
		SELECT SUM(Settlement_Amount) OpeningAmount
		INTO #tempOpening
		FROM (
			SELECT ISNULL(ad.available_balance, 0) * 1 Settlement_Amount
			FROM tbl_user_detail u
			JOIN tbl_agent_detail ad ON ad.agent_id = u.agent_id
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
			FROM dbo.tbl_agent_balance bt
			JOIN tbl_agent_detail ad ON bt.agent_id = ad.agent_id
			WHERE ad.agent_id = @agent_id
				AND bt.created_local_date > @from_Date_search + ' 23:59:59.997'
			
			UNION ALL
			
			SELECT sum(agent_commission) * - 1 Settlement_Amount
			FROM tbl_transaction_commission tc WITH (NOLOCK)
			JOIN tbl_transaction ttx ON tc.txn_id = ttx.txn_id
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
		SELECT CONVERT(VARCHAR, @from_date_search, 101)+' 23:59:59.997'
			,NULL
			,'Opening(closing) Balance'
			,NULL
			,NULL
			,OpeningAmount
		FROM #tempOpening
		set @from_Date_search=DATEADD(day,1,@from_date_search)
		DROP TABLE #tempOpening
	end  
   
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
				,
				CASE 
					WHEN txn_type = 'p2p' 
						THEN 
						CASE 
							WHEN txn_mode ='DR'
								THEN '<div class="transaction-value">To : '+(select isnull(tu.full_name,'') +' ('+tu.user_mobile_no+')' from tbl_user_detail tu where user_id=bt.user_id)+'</div><div class="transaction-value">From : '+isnull(ad.full_name,'') +' ('+ad.agent_mobile_no+')</div>'
							ELSE
								'<div class="transaction-value">To : '+isnull(ad.full_name,'') +' ('+ad.agent_mobile_no+')</div><div class="transaction-value">From : '+(select isnull(tu.full_name,'') +' ('+tu.user_mobile_no+')' from tbl_user_detail tu where user_id=bt.user_id)+'</div>'
						END
					WHEN txn_type = 'r' 
						THEN '<div class="transaction-value">Number : '+(select subscriber_no from tbl_transaction t where t.txn_id=bt.txn_id)+'</div>'
					WHEN txn_type = 'ct'
						THEN '<div class="transaction-value">Card : '+ (select sd.static_data_label+' ('+REPLACE(card_no,LEFT ( card_no , 12 ),'xxxxxxxxxxxx')+')' from tbl_agent_card_management c JOIN tbl_static_data sd ON sd.static_data_value = c.card_type where c.agent_id=@agent_id and card_id = dbo.func_GetNumeric(agent_remarks) AND sd.sdata_type_id = 23)+'</div>'
					WHEN txn_type = 'T'
						THEN '<div class="transaction-value">Bank : '+bank_name+'</div>'
					WHEN txn_type = 'mp'
						THEN '<div class="transaction-value">To : '+(select isnull(qt.agent_name,'')+' ('+qt.agent_code+')' from tbl_agent_QR_transaction qt where pid= bt.txn_id)+'</div><div class="transaction-value">From : '+isnull(ad.full_name,'') +' ('+ad.agent_mobile_no+')</div>'
					
					ELSE 'ID: [' + CAST(bt.balance_id AS VARCHAR) + '] - ' + ISNULL(bt.agent_remarks, 'Purchase Credit')
					END
				AS Remarks
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
					) Settlement_Amount,
					(case when txn_type = 'r' then 'Balance Refund' when txn_type='ct' then 'Card Transaction' when txn_type='mp' then 'Merchant Payment' else 'Balance Transfer' end) as txn_title
					,txn_mode
					,balance_id
					,'success' txn_status
					,'' txn_service
					,isnull(ad.full_name,'') +','+ad.agent_mobile_no+','+(select isnull(tu.full_name,'') +','+tu.user_mobile_no from tbl_user_detail tu where user_id=bt.user_id) search_data
			FROM tbl_agent_balance bt
			JOIN tbl_agent_detail ad ON bt.agent_id = ad.agent_id
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
				--CASE 
				--	WHEN STATUS <> 'SUCCESS'
				--		THEN 'Recharge ' + STATUS + ' for Subscriber: ' + subscriber_no + ' of ' + CAST(Amount AS VARCHAR)
				--	ELSE bt.agent_remarks
				--	END AS Remarks
				'<div class="transaction-value">Number : '+subscriber_no+'</div>'

				,(amount) DR
				,0 CR
				,(amount) * - 1 AS Settlement_Amount
				,product_label as txn_title
				,'DR'
				,txn_id
				,status txn_status
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
				--CASE WHEN bt.status<>'SUCCESS' THEN                           
				--CASE 
				--	WHEN @user_type = 'WalletUser'
				--		THEN 'Cashback for Subscriber:' + subscriber_no + ' of ' + CAST(cbt.agent_commission AS VARCHAR)
				--	ELSE 'Commission'
				--	END + ' on txn_id: ' + cast(cbt.txn_id AS VARCHAR) AS Remarks
				'<div class="transaction-value">Number : '+subscriber_no+'</div>'
				,
				--ELSE bt.agent_remarks END AS Remarks,                                              
				(0) DR
				,cbt.agent_commission CR
				,(cbt.agent_commission) * 1 AS Settlement_Amount
				,'Cashback | ' + product_label as txn_title
				,'CR'
				,bt.txn_id
				,'success' txn_status
				,'' txn_service
				,subscriber_no search_data
			FROM tbl_transaction_commission cbt
			JOIN tbl_transaction bt ON bt.txn_id = cbt.txn_id
			WHERE [USER_ID] = @user_id
				AND bt.agent_id = @agent_id
				AND created_local_date BETWEEN @from_Date
					AND @to_Date + ' 23:59:59.997'
				AND bt.STATUS IN ('Success')
				AND @is_auto_commission = 1
			) AS temp1
		ORDER BY Txn_Date ASC

		--select * from #temp
	set @sql='	SELECT
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
			
			
			,'''+@ccy+''' CCY
			,search_data
		FROM #temp t where  convert(date,Txn_Date,101) in(select convert(date,Txn_Date,101) from #temp  group by convert(date,Txn_Date,101) having count(convert(date,Txn_Date,101))>1)'

		if @txnStatus is not null
		set @sql=@sql+' and txn_status='''+@txnStatus+''''
		if @txnType is not null
		set @sql=@sql+' and Txn_Type='''+@txnType+''''
		if @service is not null
		set @sql=@sql+' and txn_service='''+@service+''''
		if @username is not null
		set @sql = @sql + ' and search_data like ''%'+@username+'%'''

		--set @username is not null

		set @sql=@sql+' order by Txn_Date desc'
		print(@sql)
		exec (@sql)
 

--drop table #tempOpening
drop table #temp                         
    END    


	
if @flag='M'
begin
	   set @sql = 'SELECT RIGHT(''0000000000'' + CAST(dt.txn_id AS VARCHAR), 8) AS txnid, 
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
     LEFT JOIN tbl_transaction_commission dtc ON dt.txn_id = dtc.txn_id
     JOIN tbl_manage_services dm ON dm.product_id = dt.product_id
     LEFT JOIN tbl_transaction_detail dtd ON dtd.txn_id = dt.txn_id
     INNER JOIN tbl_gateway_detail dg ON dg.gateway_id = dt.gateway_id
      and dt.txn_id = ' + cast(@txn_id as varchar);
                if @txn_id is null
                    begin
                        select '1' code, 
                               'transaction id is required' message, 
                               null id;
                        return;
                end;
                if @agent_id is not null
                    begin
                        set @sql = @sql + ' and dt.agent_id= ' + cast(@agent_id as varchar);
                end;
                print @sql;
                exec (@sql);
        end; -- transaction reciept 

if @flag='T'
begin
     select created_local_date,created_platform,'Transfer'txntype,agent_name,amount,currency_code,agent_remarks,bank_name from tbl_agent_balance where balance_id=@txn_id             
end

if @flag = 'F'
begin
	select ab.created_local_date,ab.created_platform,'Fund Transfer' txntype,ab.agent_name,ab.amount,ab.currency_code,ab.agent_remarks,ab.bank_name,pgt.service_charge 
	from tbl_agent_balance ab 
	left join tbl_payment_gateway_transaction pgt on ab.txn_id=pgt.pmt_txn_id
	where balance_id=@txn_id
End

if @flag = 'MP'
begin
	select ab.created_local_date,created_platform,'Merchant Payment' txntype, qt.agent_name,ab.amount,currency_code,agent_remarks,bank_name from tbl_agent_balance ab
	left join tbl_agent_QR_transaction qt 
	on ab.txn_id = qt.pid
	where balance_id=@txn_id  
End
END  


