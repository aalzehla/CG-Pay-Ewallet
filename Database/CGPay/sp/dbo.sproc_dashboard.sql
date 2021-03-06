USE [CGPay]
GO
/****** Object:  StoredProcedure [dbo].[sproc_dashboard]    Script Date: 8/12/2020 12:21:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
ALTER procedure [dbo].[sproc_dashboard]              
(              
 @flag  nvarchar(50),              
 @user  varchar(50)              
)              
as              
  declare @totalcustomercounttotal  int, @newcustomercounttotal int, @merchantcounttotal int,   @newmerchantcounttotal int,  @txnamounttotal decimal(18,2), @txnamountfortheweektotal decimal(18,2), @txnamountforthemonthtotal decimal(18,2)      
  declare @activecustomertotal int, @activemerchanttotal int, @txncounttotal int, @currentdate  datetime, @lastmonthdate datetime, @lastweek datetime      
  select @currentdate = current_timestamp, @lastmonthdate = dateadd(m, -1, current_timestamp),  @lastweek =dateadd(week, -1, current_timestamp)      
      
if @flag='dashboardsummary'              
begin                
 select @totalcustomercounttotal   = count(*)  from tbl_agent_detail where agent_type = 'distributor'      
 select @merchantcounttotal    = count(*)  from tbl_agent_detail where agent_type in ('merchant', 'walletuser')      
 select @txnamounttotal     = sum(amount) from tbl_transaction where status = 'success' and convert(varchar(10), created_local_date, 120) = convert(varchar(10), getdate(), 120)      
 select @activecustomertotal    = count(*)  from tbl_agent_detail where agent_type = 'distributor'  and agent_status = 'y'      
 select @activemerchanttotal    = count(*)  from tbl_agent_detail where agent_type in ('merchant', 'walletuser') and agent_status = 'y'      
 select @txncounttotal     = count(txn_id) from tbl_transaction       
 select @newcustomercounttotal   = count(*)  from tbl_agent_detail where agent_type = 'distributor' and created_local_date between @lastmonthdate and @currentdate      
 select @newmerchantcounttotal   = count(*)  from tbl_agent_detail where agent_type in ('merchant', 'walletuser') and created_local_date between @lastmonthdate and @currentdate      
 select @txnamountforthemonthtotal  = sum(amount) from tbl_transaction where status = 'success'       
 select @txnamountfortheweektotal  = sum(amount) from tbl_transaction where status = 'success' and created_local_date between @lastweek and @currentdate      
      
select       
isnull(@totalcustomercounttotal,0)  as customercounttotal,      
isnull(@newcustomercounttotal,0)  as newcustomercounttotal,      
isnull(@merchantcounttotal,0)   as merchantcounttotal,      
isnull(@newmerchantcounttotal,0)  as newmerchantcounttotal,      
isnull(@txnamounttotal,0)    as txnamounttotal,              
isnull(@txnamountfortheweektotal,0)  as txnamountfortheweektotal,      
isnull(@txnamountforthemonthtotal,0) as txnamountforthemonthtotal,      
isnull(@activecustomertotal,0)   as activecustomertotal,      
isnull(@activemerchanttotal,0)   as activemerchanttotal,      
isnull(@txncounttotal,0)    as txncounttotal              
              
end             
      
if @flag='dashboardsummary2'              
begin              
              
 select m.available_balance balance,'45080' as customercounttotal,'1335' as newcustomercounttotal,'7880' as merchantcounttotal,'1575' as newmerchantcounttotal,'23,85,470.00' as txnamounttotal,              
 '1,55,00,000.00' as txnamountfortheweektotal,'25,78,42,580.00' as txnamountforthemonthtotal,'32305' as activecustomertotal,'5303' as activemerchanttotal,'58910' as txncounttotal              
  from tbl_agent_detail m   
  join tbl_user_detail pu on pu.agent_id=m.agent_id   
  where pu.user_name=@user and pu.usr_type in('merchant','walletUser')         
end               
              
if(@flag='dashboardchart')              
begin              
   
 ---bar chart  
 select count(dt.txn_id) as value, ms.product_label as label   
 from tbl_manage_services ms   
 join tbl_transaction dt on dt.product_id = ms.product_id      
 where dt.status = 'success' and  
 dt.created_local_date between @lastmonthdate and @currentdate  
 group by ms.product_label   
      
 ----pie chart  
   select count(dt.txn_id) as value, ms.product_label as label   
   from tbl_manage_services ms   
   join tbl_transaction dt on dt.product_id = ms.product_id   
   where dt.status not in ('confirming','pending')  
   and dt.created_local_date between @lastmonthdate and @currentdate  
   group by ms.product_label      
      
 --select 'ntc' as label,'1.9' as value              
 --union all              
 --select 'ncell' as label,'19' as value              
 --union all              
 --select 'prabhutv' as label,'3' as value              
 --union all              
 --select 'vianet' as label,'5' as value              
 --union all              
 --select 'worldlink' as label,'2' as value              
 --union all              
 --select 'other' as label,'3' as value              
 ---------------------------------------------              
                 
               
 --select 'ntc' as label,'5.9' as value              
 --union all              
 --select 'ncell' as label,'19' as value              
 --union all              
 --select 'prabhutv' as label,'3' as value              
 --union all              
 --select 'vianet' as label,'5' as value              
 --union all              
 --select 'worldlink' as label,'2' as value              
 --union all              
 --select 'other' as label,'3' as value              
                    
               
   ---------------------------------------------              
   select 'january' as label,'12' as value,'target' as [type]              
   union all              
   select 'february' as label,'19' as value,'target' as [type]              
   union all              
   select 'march' as label,'3' as value,'target' as [type]              
   union all              
   select 'april' as label,'5' as value,'target' as [type]              
   union all              
   select 'may' as label,'2' as value,'target' as [type]              
   union all              
   select 'june' as label,'3' as value,'target' as [type]              
   union all              
   select 'july' as label,'' as value,'target' as [type]              
   union all              
   select 'january' as label,'20' as value,'achievement' as [type]              
   union all              
   select 'february' as label,'14' as value,'achievement' as [type]              
   union all              
   select 'march' as label,'7' as value,'achievement' as [type]              
   union all              
   select 'april' as label,'5' as value,'achievement' as [type]              
   union all              
   select 'may' as label,'0' as value,'achievement' as [type]              
   union all              
   select 'june' as label,'1' as value,'achievement' as [type]              
   union all              
   select 'july' as label,'' as value,'achievement' as [type]              
                 
              
  end              
              
if(@flag='dashboarddetails')              
begin              
              
 select 'new kyc added' as title,'50%' as progresspercentage,'success' as cssclass              
 union all              
 select 'new merchant expansion' as title,'15%' as progresspercentage,'info'  as cssclass              
 union all              
 select 'pending settlement <strong>30 days</strong>' as title,'5%' as progresspercentage ,'warning'  as cssclass              
 union all              
 select 'outstanding decreased' as title,'20%' as progresspercentage,'danger'  as cssclass              
 union all              
 select 'market area covered in <strong>70 days</strong>' as title,'40%' as progresspercentage,'primary'  as cssclass              
 union all              
 select 'failed txn decreased' as title,'10%' as progresspercentage,'default'  as cssclass              
              
              
              
 select '05 july, 2019' as titledate, 'meeting with merchant' as title,'meeting detail' as contenttext,'info'  as cssclass              
 union all              
 select '17 july, 2019' as titledate,'product launching' as title,'new product launching on 17th junly, 2019' as contenttext,'danger'  as cssclass              
 union all     
 select '29 july, 2019' as titledate,'merchant visit' as title,'merchant visit for business promotion.' as contenttext,'warning'  as cssclass              
                 
 -- activitymonth, activitydate, activityday,agentname,activitytext,activitystats              
              
 select 'june' as activitymonth,'16' as activitydate,'sunday' as activityday, 'sanjaya' as [hostname], 'published promotion campaign' as activitytext,'attendance' as activitystats,'50' as participants              
 union all              
 select 'june' as activitymonth,'24' as activitydate,'monday' as activityday, '' as [hostname], 'regional training' as activitytext,'participant' as activitystats,'40' as participants              
                 
               
              
 select 'june 14th, 2019' as schemedate,'refer a friend' as schemetitle,'refer a friend and family and get 500 cash back.' as schemetext,'2019-06-14 - 2019-07-14' as schemerange              
 union all              
 select 'june 24th, 2019' as schemedate,'buy 2 and get 1 free' as schemetitle,'buy 2 movie tickets and get one for free.' as schemetext,'2019-06-24 - 2019-06-29' as schemerange              
                 
              
end   

if (@flag='md') --merchant dashboard
Begin
	declare @agent_id varchar(50)
	set @agent_id =(Select agent_id from tbl_user_detail where user_id=@user)
	SELECT year(created_local_date) TxnYear, month(created_local_date) TxnMonth, day(created_local_date) TxnDay, count(*) TotalTxn,sum(amount) TotalAmount
	FROM tbl_agent_QR_transaction 
	where agent_id= @agent_id
	and year(created_local_date)=YEAR(GETDATE())
	and month(created_local_date) = MONTH(GETDATE())
	GROUP BY year(created_local_date), month(created_local_date), day(created_local_date)
End

