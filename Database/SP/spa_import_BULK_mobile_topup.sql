USE [CGPay]
GO

/****** Object:  StoredProcedure [dbo].[spa_import_BULK_mobile_topup]    Script Date: 17/08/2020 19:17:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE OR ALTER       procedure  [dbo].[spa_import_BULK_mobile_topup]        
 @FilePath varchar(500)=Null,        
 @FileName varchar(500)=Null,        
 @tablename varchar(100)=Null,        
 @jobName varchar(100)=Null,        
 @processId varchar(100)=Null,        
 @actionUser varchar(50)=Null,      
 @agentId VARCHAR(20),        
 @actionIPAddress varchar(50)=NULL        
       
         
 as        
 Declare @sql varchar(MAX)        
 Declare @sql1 varchar(MAX)        
 Declare @temptablename varchar(100)        
 declare @errorMsg varchar(500)        
        
 declare @today_time varchar(20)        
 set @today_time=(getdate())        
         
 --Create temporary table to log import status        
 CREATE TABLE #import_data_status        
  (        
  temp_id int,        
  process_id varchar(100),        
  ErrorCode varchar(50),        
  Module varchar(100),        
  [Source] varchar(100),        
  [type] varchar(100),        
  [description] varchar(500),        
  [nextstep] varchar(250)        
  )        
         
 --create temporary table to store count        
 create table #temp_tot_count (totcount int)        
      SET @processId = REPLACE(newid(),'-','_') 
	  Set @tablename = 'Bulk_Mobile_TopUp'
 --Check for table_code and select table_name        
         
 --set @temptablename='temp_bulk_topup'       
         
 --create temporary table to store data from external file        
         
  set @sql='create table temp_bulk_topup(        
   [MobileNo] [varchar] (50) ,        
   [Amount] varchar (50),  
   [Remarks]varchar(200)          
   )'        
     
	 if exists (select * from CGPay.dbo.sysobjects where id =  object_id('temp_bulk_topup') )
	 Begin
			 drop table temp_bulk_topup
	 End

	       
 print @sql        
 Exec(@sql)        
       
 --Bulk Insert from external file to temporary table        
 SET @SQL = ' BULK INSERT temp_bulk_topup  FROM '''+@FilePath+''' WITH (FIELDTERMINATOR = '','',FIRSTROW  = 2) '        
 PRINT @sql        
 --return        
 exec (@sql)        
         
 --Add identity column in the temporary table to track data in temporary table        
 exec('alter table temp_bulk_topup add temp_id int identity')        
       
 --if any error found while doing bulk insert then return with error        
   if @@ERROR<>0        
   Begin        
   insert into #import_data_status select 1,@processId,'Error','Import Mobile Data',@tablename,'Data Error',        
    'It is possible that the file format may be incorrect' ,'Please Check your file format'         
            
   GOTO FinalStep        
   return        
   End        
        
         
  --Delete from temp table if all the fields are null        
         
   -- insert into #temp_tot_count tot count from temp table        
   exec (' insert into #temp_tot_count select count(*) as totcount  from temp_bulk_topup')        
           
   -- check mobile no         
   exec('insert into #import_data_status select a.temp_id,'''+ @processId+''',''Error'',''Import Data'','''+@tablename+''',''Data Error'',        
   ''Invalid Mobile No :''+ isnull(a.MobileNo,''NULL'')+'',Amount:''+isnull(a.Amount,''NULL'')+''.'', ''Please check your data''         
   from temp_bulk_topup a where ISNUMERIC(a.MobileNo)=0 or len(a.MobileNo)<>10 or FLOOR(a.MobileNo) <> CEILING(a.MobileNo) or LEFT(MobileNo,2)<>''98''')         
           
   -- check amount         
   exec('insert into #import_data_status select a.temp_id,'''+ @processId+''',''Error'',''Import Data'','''+@tablename+''',''Data Error'',        
   ''Invalid Amount for Mobile No :''+ isnull(a.MobileNo,''NULL'')+'',Amount:''+isnull(a.Amount,''NULL'')+''.'', ''Please check your data''         
   from temp_bulk_topup a where ISNUMERIC(a.Amount)=0 or len(a.Amount)=0 or cast(a.Amount as money)<10 or cast(a.Amount as money)>5000        
   or FLOOR(a.Amount) <> CEILING(a.Amount)')          
           
   -- check NTC-PREPAID Valid amount         
   exec('insert into #import_data_status select a.temp_id,'''+ @processId+''',''Error'',''Import Data'','''+@tablename+''',''Data Error'',        
   ''Invalid Amount for Mobile No :''+ isnull(a.MobileNo,''NULL'')+'',Amount:''+isnull(a.Amount,''NULL'')+''.'', ''Please check your data''         
   from temp_bulk_topup a where a.temp_id not in (select temp_id from #import_data_status) and         
   LEFT(MobileNo,3) not in (''985'',''980'',''981'',''982'') and         
   a.Amount not in (''10'',''20'',''30'',''40'',''50'',''100'',''150'',''200'',''300'',''500'',''1000'',''1500'',''2000'',''2500'',''3000'',''4000'',''5000'')')                    
           
   -- check NTC-POSTPAID Valid amount         
   exec('insert into #import_data_status select a.temp_id,'''+ @processId+''',''Error'',''Import Data'','''+@tablename+''',''Data Error'',        
   ''Invalid Amount for Mobile No :''+ isnull(a.MobileNo,''NULL'')+'',Amount:''+isnull(a.Amount,''NULL'')+''.'', ''Please check your data''         
   from temp_bulk_topup a where a.temp_id not in (select temp_id from #import_data_status) and LEFT(MobileNo,3)=''985'' and         
   a.Amount not in (''100'',''150'',''200'',''300'',''500'',''1000'',''1500'',''2000'',''2500'',''3000'',''4000'',''5000'')')                    
                  
        
   -- delete from temp table all the invalid data        
   exec('delete temp_bulk_topup from #import_data_status inner join temp_bulk_topup a on        
   #import_data_status.temp_id=a.temp_id')        
              
       --Delete All Previous Entries        
  --delete temp_mobile_topup       
         
   --insert into actual table from temp table         
   set @sql1=' insert into tbl_temp_mobile_topup(SubscriberNo,Amount,created_local_date,UserId,AgentId,productId,FileName,Remarks)        
   select  MobileNo,Amount,GETDATE(),'''+@actionUser+''','''+@agentId+''',        
   CASE WHEN LEFT(MobileNo,3)=''980'' or LEFT(MobileNo,3)=''981'' or LEFT(MobileNo,3)=''982''  THEN 2        
   ELSE 1 END ,'''+@FileName+''',Remarks FROM temp_bulk_topup'      
        
  print @sql1  + char(9)      
          
   set @sql1 = @sql1 + ' update tbl_temp_mobile_topup set CostAmount = t.Amount - (t.Amount  * ( s.commission_value/ 100 ) )           
       from tbl_temp_mobile_topup t join tbl_commission_category_detail s on s.product_id = t.productId         
       where  s.com_category_id=(select ISNULL(agent_commission_id,1)  from tbl_agent_detail        
       where  agent_mobile_no='''+@actionUser+''') and  t.FileName='''+@FileName+''''        
            
 print @sql1        
    exec (@sql1)       
        
 --print @sql        
 --        
         
 FinalStep:        
 declare @sql3 varchar(1000)        
 ---SET @sql3 = dbo.FNAProcessDeleteTbl(@temptablename)        
-- exec (@sql3)        
  declare @count int,@totalcount int        
  set @count=(select count(distinct temp_id) from #import_data_status)        
  set @totalcount=(select totcount from #temp_tot_count)        
  if @count>0        
  begin        
   if @totalcount>0        
    select @errorMsg = cast(@totalcount-@count as varchar(100))+' Data imported Successfully out of '+cast(@totalcount as varchar(100))+'. Some Error found while importing. Please review Errors'        
   else        
    select @errorMsg = cast(@totalcount as varchar(100))+' Data imported Successfully. Some Error found while importing. Please review Errors'        
           
    insert into tbl_data_import_status(process_id,data_import_status,module,data_import_source,type,[data_import_description],admin_remarks,created_UTC_date, created_local_Date, created_nepali_date, created_by,created_ip, ms_repl_tran_version)         
    select @processId,'Error','Import Data',@tablename,'Data Error',@errorMsg,'Please Check your data',GETUTCDATE(),GETDATE(),dbo.func_get_nepali_Date(default),@actionUser, @actionIpAddress, newID()        
            
    insert into tbl_data_import_status_detail(process_id,data_import_source,type,[data_import_description], created_UTC_DATE, created_local_date, created_nepali_Date, Created_by,Created_ip, ms_repl_tran_version)         
    select @processId,@tablename,type,[description], GETUTCDATE(), GETDATE(), dbo.func_get_nepali_date(default),@actionUser, @actionIpAddress, newId()  from #import_data_status where process_id=@processId        
        
		  select 0 code, 'Successfully Imported Data' message, null id
  return
  end        
  else        
  begin        
   select @errorMsg = cast(@totalcount-@count as varchar(100))+' Data imported Successfully out of '+cast(@totalcount as varchar(100))        
           
   insert into tbl_data_import_status(process_id,data_import_status,module,data_import_source,type,[data_import_description],admin_remarks,created_UTC_date, created_local_Date, created_nepali_date, created_by,created_ip)         
   select @processId,'Success','Import Data',@tablename,'Data Success',@errorMsg,'',GETUTCDATE(),GETDATE(),dbo.func_get_nepali_Date(default),@actionUser, @actionIpAddress

  select 0 code, 'Successfully Imported Data' message, null id
  return

  end 
GO


