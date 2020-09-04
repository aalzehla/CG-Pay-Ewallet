USE [CGPay]
GO

/****** Object:  StoredProcedure [dbo].[sproc_commission_report]    Script Date: 8/21/2020 12:50:23 PM ******/
DROP PROCEDURE [dbo].[sproc_commission_report]
GO

/****** Object:  StoredProcedure [dbo].[sproc_commission_report]    Script Date: 8/21/2020 12:50:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
-- =============================================      
-- Author:  <Author,,Name>      
-- Create date: <Create Date,,>      
-- Description: <Description,,>      
-- =============================================      
CREATE     PROCEDURE [dbo].[sproc_commission_report]      
 @flag char(3) =  null,      
 @user_id int =  null,      
 @agent_id int  = null,      
 @from_Date datetime = NULL,                                                    
    @to_Date datetime = NULL       
      
AS      
BEGIN      
 -- SET NOCOUNT ON added to prevent extra result sets from      
 -- interfering with SELECT statements.      
 SET NOCOUNT ON;      
  declare @parent_id int , @commision_type bit, @userName varchar(20),@ccy varchar(5), @sql varchar(max)        
      
 if @from_date is null        
  begin        
   set @from_date = format(DATEADD(Day, -15, GETDATE()),'yyyy-MM-dd')        
  end        
        
 if @to_Date is null        
  begin        
   set @to_Date = DATEADD(Day, 1, GETDATE())        
  end        
      
  select @parent_id=a.parent_id,        
    @agent_id=a.agent_id,        
    @userName=u.user_Name         
  from tbl_user_detail u with (nolock)        
  join tbl_agent_detail a with (nolock)                                
  on a.agent_id=u.agent_id         
  where u.user_id=@user_id        
      
    if @flag = 'a'      
 begin      
  select u.agent_id, t.created_local_date as Txn_Date,      
  case when t.txn_type_id = 1 then 'Mobile Topup'      
   when t.txn_type_id =2 then 'E-Pin'      
   else 'bill payment' end Txn_Type,       
   product_label,       
   amount,      
   tc.agent_commission as CommissionEarned,      
   t.agent_remarks as Remarks, 
   u.user_mobile_no
    from tbl_transaction t  with (nolock)    
  join tbl_transaction_commission tc with (nolock) on tc.txn_id = t.txn_id      
  join tbl_user_detail u with (nolock) on u.user_id = t.user_id      
  join tbl_agent_detail ad with (nolock) on ad.agent_id = u.agent_id      
  where  --isnull(ad.is_auto_commission,0) = 0      
 -- AND   
  t.created_local_date BETWEEN @from_Date                                                     
  AND @to_Date +' 23:59:59'      
  and t.user_id = @user_id      
 end      
END   
  
  
GO


