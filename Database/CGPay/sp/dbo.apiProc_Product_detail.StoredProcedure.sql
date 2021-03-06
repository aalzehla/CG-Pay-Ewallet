USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[apiProc_Product_detail]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[apiProc_Product_detail]
	@flag char(3) = null,
	@product_id int  =  null,
	@user_name varchar(50) =  null
AS
BEGIN
	Declare @agent_id  varchar(20), @parent_id varchar(20), @grand_parent_id varchar(20), @sql varchar(max)

	if @flag = 's'
	begin
		if not exists(select 'x' from tbl_user_detail u join tbl_agent_detail a on a.agent_id = u.agent_id where u.user_name = @user_name or user_mobile_no = @user_name or user_email = @user_name)
		begin
			select '104' code, 'User Not Found!' message, null id
			return
		end
		else
		begin
			if @user_name is null
			begin
				Select company, product_label, product_logo, product_service_info, product_category from tbl_manage_services where isnull(status,'n') = 'y'
			end
			else
			begin
				select 
					@agent_id = u.agent_id,  -- agent id
					@parent_id = a.parent_id,  -- parent id
					@grand_parent_id = ad.agent_id --grand parent id
				from tbl_user_detail u 
				join tbl_agent_detail a on a.agent_id = u.agent_id
				left join tbl_agent_detail ad on  ad.agent_id = a.parent_id
				where 1 = 1  and (u.user_name = @user_name or user_mobile_no = @user_name or user_email = @user_name)

				select @sql = ' select distinct *';  
                set @sql+=' from (';  
                set @sql+=' select pp.product_id';  
                set @sql+=' ,pp.txn_type+isnull('' - ''+replace(pp.product_type,''internet\television'',''internet''),'''') txn_type';  
                set @sql+=' ,pp.company_id';  
                set @sql+=' ,pp.company';  
                set @sql+=' ,pp.product_type_id';  
                set @sql+=' ,pp.product_type';  
                set @sql+=' ,pp.product_label';  
                set @sql+=' ,pp.product_logo';  
                set @sql+=' ,pp.created_local_date';  
                set @sql+=' ,pp.product_service_info';  
                set @sql+=' ,case ';  
                set @sql+=' when pu.row_Id is null';  
                set @sql+=' then pp.[status]';  
                set @sql+=' else ''n''';  
                set @sql+=' end [status]';  
                set @sql+=' from tbl_manage_services pp';  
                set @sql+=' left join tbl_manage_services_user pu on pu.product_Id = pp.product_Id';
				set @sql+=' and pu.agent_id in (';  
                if @parent_id is not null  
                    set @sql+=' ''' + @parent_id + ''' ,';  
                if @grand_parent_id is not null  
                    set @sql+='''' + @grand_parent_id + ''' ,';  
                set @sql+=' ''' + @agent_id + '''';  
                set @sql+=' )';  
                set @sql+=' where 1 = 1';  
                if @agent_id is not null  
                    --set @sql += ' and pp.status = ''y'''  
  
                    if @parent_id is not null  
                        begin  
                            set @sql+=' and pp.product_id not in (';  
                            set @sql+=' select product_id';  
                            set @sql+=' from tbl_manage_services_user';  
                            set @sql+=' where agent_id = ''' + @parent_id + '''';  
                            set @sql+=' )';  
                    end;  
                if @grand_parent_id is not null  
                    begin  
                        set @sql+=' and pp.product_id not in (';  
                        set @sql+=' select product_id';  
                        set @sql+=' from tbl_manage_services_user';  
                        set @sql+=' where agent_id = ''' + @grand_parent_id + '''';  
                        set @sql+=' )';  
                end;  
                set @sql+=' ) a ';  
                set @sql+=' order by product_id';  
                set @sql+=' ,product_label asc';  
                set @sql+=' ,txn_type';  
                select @sql+=' ,product_logo';  
                set @sql+=' ,status';

				print @sql;  
                exec (@sql) 

			end
		end
	end  -- get product/service list 
	
	if @flag = 'gc' -- get cash back of product
	begin
		if not exists(select 'x' from tbl_user_detail u join tbl_agent_detail a on a.agent_id = u.agent_id where u.user_name = @user_name or user_mobile_no = @user_name or user_email = @user_name)
		begin
			select '104' code, 'User Not Found!' message, null id
			return
		end
		else
		begin
			SELECT *
			INTO #Temp_service_detail
			FROM
			  (
				  select cd.product_id, 
				  com_category_id,
				  m.product_label,
				  Case when
				  commission_type = 'P' then 'Percent'
				  when commission_type = 'F' then 'Flat'
				  end commision_type,
				  commission_value ,
				   s.static_data_label as commission_percent_type,
					ROW_NUMBER() OVER (ORDER BY cd.product_id) AS RowNum
				  from tbl_commission_category_detail cd 
				Join tbl_commission_category c on c.category_id = cd.com_category_id
				Join tbl_manage_services m on m.product_id = cd.product_id
				join tbl_agent_detail a on a.agent_commission_id = c.category_id
				join tbl_user_detail  u on u.agent_id = a.agent_id
				join tbl_static_data s on s.static_data_value = cd.commission_percent_type
				where s.sdata_type_id = 6  -- commission_types
				and u.user_name = @user_name or user_mobile_no = @user_name or user_email = @user_name
			  ) as t
			  select * from #Temp_service_detail
		  		--drop temporary table
				drop table #Temp_service_detail
			  return
			end
	end
	

End




GO
