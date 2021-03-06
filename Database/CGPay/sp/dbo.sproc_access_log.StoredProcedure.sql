USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_access_log]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE   PROCEDURE [dbo].[sproc_access_log]   
    @flag varchar(10),
	@from_date varchar(20) = null,
	@to_date varchar(20) = null	,
    @page_name varchar(100)=null ,
	@action_user varchar(100)=null,
	@page_url varchar(500)=null,
	@action_ip_address varchar(100)=null,
	@browser_info varchar(500)=null,
	@log_type varchar(100)=null
AS
declare @sql varchar(max)
BEGIN  


 IF @flag = 's' --select all log  
  BEGIN    

  if @from_date is null 
  begin
	set @from_date =  Convert(date,(DATEADD(Hour,-1, GETDATE())),120)-- as varchar)
  end
  else
  begin
	set @from_date = convert(date, @from_date, 120)
  end

  if @to_date is null
  begin
	set @to_date = Convert(date,(DATEADD(hour,0,GETDATE())),120)-- as varchar)
  end
  else
  begin
	set @to_date = convert(date, @to_date, 120)
  end
  

  set @sql =' SELECT page_name,log_type,from_ip_address,browser_info,remarks,created_by,created_local_date,created_UTC_date from tbl_login_log where 1=1';
	if(@from_date is not null and @to_date is not null)
	begin
		set @sql = @sql + ' and created_local_date between '''+ @from_date + ''' and '''+ @to_date +' 23:59:59.997'''; 
		set @sql = @sql +  ' order by created_local_date desc'
	end
		

		print @sql
		exec (@sql)
  END  



END  



GO
