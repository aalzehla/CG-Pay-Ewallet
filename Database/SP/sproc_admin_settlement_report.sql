-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE     or alter           PROCEDURE [dbo].[sproc_admin_settlement_report]  
 @flag  char(3) = null,  
 @user_id VARCHAR(50) = NULL,                                              
    @from_Date datetime = NULL,                                              
    @to_Date datetime = NULL,                                  
    @agent_id VARCHAR(50)=NULL,
	@txn_id varchar(50)=Null
  
AS  
BEGIN  
 declare @parent_id int , @commision_type bit, @userName varchar(20),@ccy varchar(5), @sql varchar(max) 
 declare @user_type varchar(50),@is_auto_commission tinyint,@from_Date_search datetime
  
 set @ccy='NPR'    
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  --set @from_Date_search = isnull( @from_date,format(DATEADD(Day, -1, GETDATE()),'yyyy-MM-dd'))
  set @from_Date_search = format(DATEADD(Day, -1,isnull(@from_Date, GETDATE())),'yyyy-MM-dd')
 if @from_date is null  
 begin  
  set @from_date =format(DATEADD(DAY, DATEDIFF(DAY, 0 , CURRent_TIMESTAMP),0),'yyyy-MM-dd')
  --set @from_date = format(DATEADD(Day, -1, GETDATE()),'yyyy-MM-dd')  
 end 
 
  
 if @to_Date is null  
 begin  
  set @to_Date = DATEADD(Day, 1, GETDATE())  
 end  
 
  
 CREATE TABLE #temp  
 (                                  
   sno INT IDENTITY(1,1),                                  
   Txn_Date VARCHAR(50),                                  
   Txn_Type VARCHAR(50),                                  
   Remarks VARCHAR(250),                                  
   Dr MONEY,                                  
   Cr MONEY,                                  
   Settlement_Amount MONEY                                  
 )  
   select @parent_id=a.parent_id,  
   @agent_id=a.agent_id,  
   @userName=u.user_Name,
   @user_type= a.agent_type,
   @is_auto_commission = isnull(a.is_auto_commission,0)
   from tbl_user_detail u   
   join tbl_agent_detail a                           
   on a.agent_id=u.agent_id   
   where u.user_id=@user_id  

 IF @flag='a'                                              
    BEGIN    
   SELECT SUM(Settlement_Amount) OpeningAmount INTO #tempOpening FROM   
   (  
	select ISNULL(ad.available_balance,0) *1 Settlement_Amount
	from tbl_user_detail u
	join tbl_agent_detail ad on ad.agent_id = u.agent_id 
	where user_id =  @user_id and ad.agent_id = @agent_id

	UNION ALL

    SELECT SUM(amount)*1 Settlement_Amount   
    FROM tbl_transaction bt WITH (NOLOCK)                                               
    WHERE [USER_ID]=@user_id    
    AND agent_id=@agent_id                                            
    AND created_local_date > @from_Date_search  + ' 23:59:59.997'                                               
    --AND Status NOT IN ('Fail')   
        
    UNION ALL   
        
   select  SUM(CASE WHEN txn_mode='DR' THEN bt.amount   
   ELSE bt.amount*-1 END) Settlement_Amount                                             
   FROM dbo.tbl_agent_balance bt   
   JOIN tbl_agent_detail ad                                                
   ON bt.agent_id=ad.agent_id                                             
   WHERE ad.agent_id=@agent_id                                              
   AND bt.created_local_date > @from_Date_search  + ' 23:59:59.997'  

   UNION ALL

   select sum(agent_commission)*-1 Settlement_Amount from tbl_transaction_commission tc WITH (NOLOCK) join tbl_transaction ttx on tc.txn_id = ttx.txn_id                                                
    WHERE [USER_ID]=@user_id    
    AND ttx.agent_id=@agent_id                                            
    AND created_local_date > @from_Date_search  + ' 23:59:59.997'                                               
    AND ttx.Status NOT IN ('Failed') 
	 AND @is_auto_commission = 1

   )l   

    INSERT #temp(Txn_Date,Txn_Type,Remarks,Dr,Cr,Settlement_Amount)                                  
     SELECT CONVERT(VARCHAR,@from_Date,101),NULL,'Opening Balance',NULL,NULL,OpeningAmount FROM #tempOpening   
   
  INSERT #temp                                  
    SELECT * FROM   
 (  
  
  SELECT bt.created_local_date as Txn_Date,   
	  (case when txn_type = 'r' then 'Balance Refund' when txn_type='ct' then 'Card Transaction' else 'Balance Transfer' end) Txn_Type,                                              
	  'ID: [' +CAST(bt.balance_id AS VARCHAR)+'] - ' + ISNULL(bt.agent_remarks,'Purchase Credit') AS Remarks,                       
	  (CASE WHEN txn_mode='dr' THEN ISNULL(bt.amount,0) ELSE 0 end) DR,                                              
	  (CASE WHEN txn_mode='cr' THEN ISNULL(bt.amount,0) ELSE 0 end) CR,             
	  (CASE WHEN txn_mode='dr' THEN bt.amount*-1 ELSE bt.amount end) Settlement_Amount              
	  FROM tbl_agent_balance bt   
	  JOIN tbl_agent_detail ad                                                
	  ON bt.agent_id=ad.agent_id                                              
	  WHERE ad.agent_id=@agent_id       
	  AND bt.created_local_date BETWEEN @from_Date                                               
	  AND @to_Date +' 23:59:59'   
  
  UNION ALL  
  
  SELECT created_local_date as Txn_Date,   
	  case when bt.txn_type_id = 1 then 'Mobile TopUp'  
	  else 'Bill Payment' end  Txn_Type,        
	  CASE WHEN status<>'SUCCESS' THEN                           
	  'Recharge '+ Status + ' for Subscriber: '+ subscriber_no +' of '+CAST(Amount  AS VARCHAR) ELSE bt.agent_remarks END AS Remarks,                                              
	  (amount) DR,  
	  0 CR,  
	  (amount)*-1  as Settlement_Amount   
	  FROM tbl_transaction bt WITH (NOLOCK)                                                                                    
	  WHERE [USER_ID]=@user_id    
	  AND agent_id=@agent_id                                            
	  AND created_local_date BETWEEN @from_Date                                               
	  AND @to_Date +' 23:59:59.997'                                              
	  AND bt.Status  not in ('Confirming','Fail')  
  
  UNION ALL  
  
	  select bt.created_local_date as Txn_Date,   
	  case when @user_type = 'WalletUser' then 'Cash Back' else 'Commission' end as Txn_Type,  
	  --CASE WHEN bt.status<>'SUCCESS' THEN                           
	  case when @user_type = 'WalletUser' then 'Cashback for Subscriber:' + subscriber_no +' of '+CAST(cbt.agent_commission  AS VARCHAR)   else 'Commission' end + ' on txn_id: ' + cast(cbt.txn_id as varchar) AS Remarks,  
	  --ELSE bt.agent_remarks END AS Remarks,                                              
	  (0) DR,  
	  cbt.agent_commission CR,  
	  (cbt.agent_commission)*1  as Settlement_Amount   
	  from tbl_transaction_commission cbt  
	  join tbl_transaction bt on bt.txn_id = cbt.txn_id  
	  WHERE [USER_ID]=@user_id    
	  AND bt.agent_id=@agent_id                                            
	  AND created_local_date BETWEEN @from_Date                                               
	  AND @to_Date +' 23:59:59.997'                                              
	  AND bt.Status in ('Success')  
	  AND @is_auto_commission = 1
  
  
 ) as temp1  
  
 ORDER BY Txn_Date ASC 
 
 --select * from #temp
                                
  SELECT Txn_Date,isnull(Txn_Type,' ') Txn_Type ,Remarks,isnull(DR,' ') DR, isnull(Cr,' ') Cr,                          
 (select sum(ISNULL(Settlement_Amount,0)) from #temp                                    
   where sno<= t.sno) Balance ,@ccy CCY                                  
   FROM #temp t  

drop table #tempOpening
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

END  


GO


