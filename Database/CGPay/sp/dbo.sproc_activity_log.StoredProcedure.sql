USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_activity_log]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[sproc_activity_log]
@flag char(3),
@action_user varchar(50) =  null,
@page_name varchar(50) =  null,
@page_url varchar(max) =  null,
@log_type varchar(512) =  null,
@action_ip_address varchar(10) =  null,
@action_browser varchar(50) = null,
@from_date varchar(50) = null,
@to_date varchar(50) = null

as
declare @sql varchar(max)
begin
	Declare @user_id int

	if @flag = 'i'
	begin
		if not exists(select 'x' from tbl_user_detail where user_name = @action_user)
		begin
			select '1' code, 'User Doesn''t exists' message, null id
			return
		end

		insert into tbl_activity_log (page_url, page_name, log_type, from_ip_address, from_browser, created_by, created_UTC_DATE, CREATED_LOcal_Date, created_nepali_date)
		values(@page_url,@page_name, @log_type, @action_ip_address, @action_browser, @action_user, GETUTCDATE(), GETDATE(), dbo.func_get_nepali_date(default))
	end  --insert logs into table

	if @flag = 's' -- select all logs
	begin
	
	  set @sql = 'select page_name, Page_url, from_ip_address, from_browser, created_by, created_local_Date from tbl_activity_log where 1=1 '
	    if @action_user = ''
		set @action_user = null
		if @action_user is not null 
		begin
		set @sql = @sql + ' and created_by  ='''+ @action_user+ ''''
			if @from_date is not null and @to_date is not null
			Begin
				set @sql =@sql+ ' and created_local_date between '''+@from_date +''' and '''+@to_date +' 23:59:59.997'''
			End
			--select page_name, Page_url, from_ip_address, from_browser, created_by, created_local_Date from tbl_activity_log where created_by  = @action_user order by created_local_date desc
		end
		else
		begin
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

			set @sql =@sql+ ' and created_local_date between '''+@from_date +''' and '''+@to_date +' 23:59:59.997'''
			--select page_name, Page_url, from_ip_address, from_browser, created_by, created_local_Date from tbl_activity_log where created_local_date  between @from_date and @to_date +' 23:59:59.997' order by created_local_date desc
		end

		set @sql =@sql + ' order by created_local_date desc'

		print(@sql)

		exec(@sql)
	end

end


GO
