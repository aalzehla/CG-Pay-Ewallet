USE [WePayNepal]
GO

/****** Object:  StoredProcedure [dbo].[sproc_access_log]    Script Date: 6/2/2020 8:59:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE OR ALTER PROCEDURE [dbo].[sproc_access_log]   
    @flag varchar(10),
	@from_date varchar(20) = null,
	@to_date varchar(20) = null	
          
AS
declare @sql varchar(max)
BEGIN  
 IF @flag = 's' --select all log  
  BEGIN    
  set @sql =' SELECT page_name,log_type,from_ip_address,browser_info,remarks,created_by,created_UTC_date,created_local_date from tbl_login_log where 1=1';
	if(@from_date is not null and @to_date is not null)
	begin
	set @sql = @sql + ' and created_UTC_date between '''+ @from_date + ''' and '''+ @to_date +''''; 
		end
		

		print @sql
		exec (@sql)
  END  




END  
GO


