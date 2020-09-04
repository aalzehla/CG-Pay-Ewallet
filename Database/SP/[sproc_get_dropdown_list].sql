  
  
  
  --ALTER FOR COLUMN DISPLAY AS FOR @flag='029'
/*                                              
[spagetdropdownlist] @flag='013',@search_field1='1002'  ,@search_field2='hospital'                                         
*/  
ALTER proc [dbo].[sproc_get_dropdown_list] @flag varchar(20) = null  
 ,@search_field1 varchar(100) = null  
 ,@search_field2 varchar(100) = null  
 ,@search_field3 varchar(100) = null  
 ,@search_field4 varchar(100) = null  
 ,@search_field5 varchar(100) = null  
as  
begin  
 create table #temp (  
  value nvarchar(200)  
  ,[text] nvarchar(200)  
  ,additional_value nvarchar(200)  
  ,additional_text nvarchar(200)  
  ,additional_value2 nvarchar(200)  
  ,additional_text2 nvarchar(200)  
  ,dropdown_data nvarchar(max)  
  ,[language] nvarchar(2)  
  );  
  
 /*                                              
flag starts from 001 to 999                                              
write down all the flag name and search fields name mapped with corresponding data type and column                                              
*/  
 if @flag = 'fundtransfer'  
 begin  
  --2 banklist                        
  --select * from dtastaticdatatype                        
  select '0' code  
   ,agent_id as value  
   ,first_name + ' ' + middle_name + ' ' + last_name  as text  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
  from tbl_agent_detail(nolock)  
  where agent_type = 'distributor' --other params?   ;      
  
  if @search_field1 is null  
   select '0' code  
    ,agent_id as value  
    ,full_name as text  
    ,'' additional_value  
    ,'' additional_text  
    ,'' additional_value2  
    ,'' additional_text2  
    ,'' dropdown_data  
   from tbl_agent_detail(nolock)  
   where agent_type = 'merchant' --other params?                 
    and parent_id is null;  
  else  
   select '0' code  
    ,agent_id as value  
    ,full_name as text  
    ,'' additional_value  
    ,'' additional_text  
    ,'' additional_value2  
    ,'' additional_text2  
    ,'' dropdown_data  
   from tbl_agent_detail(nolock)  
   where agent_type = 'merchant'  
    and parent_id = @search_field1;  
  
  select '0' code  
   ,funding_bank_id as value  
   ,funding_bank_name as text  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
  from tbl_funding_bank_account;  
  
  return;  
 end;  
  
 if @flag = 'usersetup'  
 begin  
  select '0' code ,'y' as [value] ,'verified' as text ,'' additional_value ,'' additional_text ,'' additional_value2 ,'' additional_text2 ,'' dropdown_data  
  union all  
  select '0' code ,'n' as [value] ,'non-verified' as text ,'' additional_value ,'' additional_text ,'' additional_value2 ,'' additional_text2 ,'' dropdown_data  
  union all  
  select '0' code ,'r' as [value] ,'rejected' as text ,'' additional_value ,'' additional_text ,'' additional_value2 ,'' additional_text2 ,'' dropdown_data  
  union all  
  select '0' code ,'p' as [value] ,'pending' as text ,'' additional_value ,'' additional_text ,'' additional_value2 ,'' additional_text2 ,'' dropdown_data;  
  
  select '0' code  
   ,product_id as [value]  
   ,product_label as text  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
  from tbl_manage_services;  
  
  return;  
 end;  
  
 if @flag = 'operatorsms'  
 begin  
  select '0' code  
   ,sms_operator_id as [value]  
   ,sms_operator_name as text  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
  from tbl_sms_operator_setup;  
  
  return;  
 end;  
  
 if @flag = 'customer'  
 begin  
  select '0' code  
   ,agent_id as [value]  
   ,first_name + ' ' + middle_name + ' ' + last_name as text  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
  from tbl_agent_detail;--where agenttype='wallet'                        
  
  return;  
 end;  
  
 if @flag = 'txnreport'  
 begin  
  select '0' code  
   ,agent_id as [value]  
   ,first_name + ' ' + middle_name + ' ' + last_name as [text]  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
  from tbl_agent_detail  
  where agent_type = 'distributor';  
  
  select '0' code  
   ,additional_value1 as [value]  
   ,static_data_label as [text]  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
  from tbl_static_data  
  where static_data_row_id = '3';--txn type                       
  
  select '0' code  
   ,product_id as [value]  
   ,product_label as [text]  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
  from tbl_manage_services;  
  
  select '0' code  
   ,'success' as [value]  
   ,'success' as [text]  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
    
  union all  
    
  select '0' code  
   ,'processing' as [value]  
   ,'processing' as [text]  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
    
  union all  
    
  select '0' code  
   ,'pending' as [value]  
   ,'pending' as [text]  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
    
  union all  
    
  select '0' code  
   ,'hold' as [value]  
   ,'hold' as [text]  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
    
  union all  
    
  select '0' code  
   ,'cancelled' as [value]  
   ,'cancelled' as [text]  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
    
  union all  
    
  select '0' code  
   ,'failed' as [value]  
   ,'failed' as [text]  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data;  
  
  select '0' code  
   ,gateway_id as [value]  
   ,gateway_name as [text]  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
  from tbl_gateway_detail;  
  
  return;  
 end;  
  
 if @flag = 'gatewaybalance'  
 begin  
  select '0' code  
   ,gateway_id as [value]  
   ,gateway_name as [text]  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
  from tbl_gateway_detail;  
  
  select '0' code  
   ,funding_bank_id as [value]  
   ,funding_bank_name as [text]  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
  from tbl_funding_bank_account  
  where isnull(bank_status, 'y') = 'y'  
   or isnull(bank_status, 'active') = 'active';  
  
  return;  
 end;  
  
 if @flag = 'supportkyc'  
 begin  
  select distinct province as [value]  
   ,province as [name]  
  from tbl_state_local_nepal;  
  
  select distinct district as [value]  
   ,district as [name]  
  from tbl_state_local_nepal;  
  
  select static_data_value as [value]  
   ,static_data_label as [name]  
  from tbl_static_data  
  where static_data_row_id = 4;  
  
  select static_data_value as [value]  
   ,static_data_label as [name]  
  from tbl_static_data  
  where static_data_row_id = 1;  
  
  select 'customer' as [value]  
   ,'customer' as [name]  
    
  union all  
    
  select 'merchant' as [value]  
   ,'merchant' as [name];  
   --union all                
   --select 'distributor' as [value], 'distributor' as [name]                
 end;  
  
 if @flag = 'getsubdistributor'  
  or @flag = 'subdistributor'  
 begin  
  --set @search_field1='1000'--dist id                      
  select '0' code  
   ,agent_id as [value]  
   ,first_name + '' + middle_name +'' + last_name as [text]  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
  from tbl_agent_detail  
  where parent_id = @search_field1  
   and agent_type = 'subdistributor';  
  
  return;  
 end;  
  
 if @flag = 'distributor'  
 begin  
  --set @search_field1='1000'--dist id                      
  select '0' code  
   ,agent_id as [value]  
   ,first_name + '' + middle_name +'' + last_name as [text]  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
  from tbl_agent_detail  
  where parent_id is null  
   and agent_type = 'distributor';  
  
  return;  
 end;  
  
 if @flag = 'balancetype'  
 begin  
  select '0' code  
   ,static_data_value as [value]  
   ,static_data_label as text  
   ,additional_value1 additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
  from tbl_static_data where static_data_row_id='7'                        
  
  return;  
 end;  
  
 if @flag = 'kycstatus'  
 begin  
  select '0' code  
   ,static_data_value as [value]  
   ,static_data_label as text  
   ,additional_value1 additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
  from tbl_static_data where static_data_row_id='18'                        
  
  return;  
 end;  
 --------user setup--------                                              
 if @flag = '000'  
 begin  
  insert into #temp (  
   value  
   ,text  
   )  
  select '1' value  
   ,'admin' text  
    
  union  
    
  select '2' value  
   ,'user' text;  
  
  select '0' code  
   ,'y' value  
   ,'active' text  
    
  union  
    
  select '0' code  
   ,'n' value  
   ,'in active' text;  
 end;  
  
 --------role list(rolelist)--------                         
 if @flag = '001'  
  or @flag = 'rolelist'  
 begin  
  insert into #temp (  
   value  
   ,text  
   )  
  select role_id  
   ,role_name  
  from tbl_roles(nolock)  
  where (  
    isnull(role_status, 'y') = 'y'  
    or isnull(role_status, 'active') = 'active'  
    )  
   and role_name not like 'gateway%';  
 end  
   ------zone list(zonelist)--------                                        ;      
 else if @flag = '002'  
  or @flag = 'zonelist'  
 begin  
  insert into #temp (  
   value  
   ,text  
   )  
  select  a.province,a.province   
  from (  
   select distinct a.province_Code,a.province  
   from tbl_state_local_nepal a(nolock) where country_code= 'np'  
  ) a order by a.province_Code;  
 end  
         
   --------country list(country)--------                                        ;      
 else if @flag = '004'  
  or @flag = 'country'  
 begin  
  insert into #temp (  
   value  
   ,text  
   )  
  select static_data_value  
   ,static_data_label  
  from tbl_static_Data(nolock)  
  where sdata_type_id = '1';  
 end  
   --------gender list(genderlist)--------                                        ;      
 else if @flag = '005'  
  or @flag = 'genderlist'  
 begin  
  insert into #temp (  
   value  
   ,text  
   )  
  select static_data_value  
   ,static_data_label  
  from tbl_static_Data(nolock)  
  where sdata_type_id = '5';  
 end  
   --------admin user list(userlist)--------                                        ;      
 else if @flag = '006'  
  or @flag = 'userlist'  
 begin  
  insert into #temp (  
   value  
   ,text  
   )  
  select user_id userid  
   ,full_name fullname  
  from tbl_user_detail(nolock)  
  where isnull(status, 'n') = 'Y'  
  order by fullname;  
 end  
   --------district list(getdistrictlist)--------                                              
   --------@search_field1=province_id                                        ;      
 else if @flag = '007'  
  or @flag = 'getdistrictlist'  
 begin  
  declare @districtsql varchar(max) = '';  
  
  set @districtsql += 'insert into #temp (';  
  set @districtsql += 'value';  
  set @districtsql += ',text';  
  set @districtsql += ')';  
  set @districtsql += 'select distinct (a.district)';  
  set @districtsql += ',a.district';  
  set @districtsql += ' from tbl_state_local_nepal a(nolock) where countrycode= ''np'' ';  
  
  if @search_field1 is not null  
   set @districtsql += ' and province=''' + @search_field1 + '''';  
  set @districtsql += ' order by a.district';  
  
  print (@districtsql);  
  
  exec (@districtsql);  
 end  
   --------local unit(getlocalunit)--------                                              
   --------@search_field1=district                                        ;      
 else if @flag = '008'  
  or @flag = 'getlocalunit'  
 begin  
  insert into #temp (  
   value  
   ,text  
   )  
  --select distinct value = localuniteng,name = localuniteng from tblprovince(nolock) where district = @param order by name                                                       
  select distinct value = local_level  
   ,name = local_level  
  from tbl_state_local_nepal(nolock)  
  where country_code= 'np' and district = isnull(@search_field1, district)  
  order by name;  
 end  
   --------fund transfer list(fundtransfer)--------                                              
   --------@search_field1=sub distributor id                                  
   --------@search_field2=dustributor id                                      ;      
 else if @flag = '009'  
  or @flag = 'fundtransfer'  
 begin  
  insert into #temp (  
   value  
   ,text  
   )  
  select value = agent_id  
   ,name = full_name  
  from tbl_agent_detail  
  where isnull(agent_status, 'n') in (  
    'Y'  
    ,'0'  
    )  
   and (  
    parent_id = @search_field1  
    or @search_field2 = grand_parent_id  
    )  
  order by name asc;  
 end  
   --------company list(companylist)--------                                        ;      
 else if @flag = '010'  
  or @flag = 'companylist'  
 begin  
  select additional_value1 + '|' + static_data_value as company_id  
   ,static_data_label  
  from tbl_Static_data(nolock)  
  where sdata_type_id = 2;  
  
 end  
   --------txn type(txn_type)--------                                        ;      
 else if @flag = '011'  
  or @flag = 'txn_type'  
 begin  
  --insert into #temp (  
  -- value  
  -- ,text  
  -- )  
  select additional_value1 + '|' + static_data_value as txn_type_id  
   ,static_data_label  
  from tbl_Static_data(nolock)  
  where sdata_type_id = 3;  
  
  return;  
 end  
   --------gateway list(gateway)--------                                        ;      
 else if @flag = '012'  
  or @flag = 'gateway'  
 begin  
  --insert into #temp (  
  -- value  
  -- ,text  
  -- )  
  select gateway_id  
   ,gateway_name  
  from tbl_gateway_detail;  
 end  
   --------client mobile topup(client_mobiletopup)--------                                              
   --------@search_field1=merchant_id                                                              
   --------@search_field2= search type(airticket,electricity,epin,insurancepremium,internetpayment,                                      
   -----------------------landline,gsm,tv_payment,water,)      ;      
 else if @flag = 'rcpins'  
 begin  
  if @search_field2 = '5'  
   or @search_field2 = '8' ----ntc, smart          
  begin  
   select '50' as [value]  
     
   union all  
     
   select '100' as [value]  
     
   union all  
     
   select '200' as [value]  
     
   union all  
     
   select '500' as [value]  
     
   union all  
     
   select '1000' as [value];  
  end;  
  else if @search_field2 = '7' ----utl recharge pin          
  begin  
   select '100' as [value]  
     
   union all  
     
   select '250' as [value]  
     
   union all  
     
   select '500' as [value];  
  end;  
  else if @search_field2 = '12' ----broadlink recharge pin          
  begin  
   select '550' as [value]  
     
   union all  
     
   select '565' as [value]  
     
   union all  
     
   select '1200' as [value]  
     
   union all  
     
   select '1500' as [value]  
     
   union all  
     
   select '2260' as [value];  
  end;  
  else if @search_field2 = '13' ----broadtel recharge pin          
  begin  
   select '550' as [value]  
     
   union all  
     
   select '565' as [value]  
     
   union all  
     
   select '1200' as [value]  
     
   union all  
     
   select '1500' as [value]  
     
   union all  
     
   select '2260' as [value];  
  end;  
  else if @search_field2 = '35' ----prabhutv ott epin          
  begin  
   select '50' as [value]  
     
   union all  
     
   select '100' as [value]  
     
   union all  
     
   select '200' as [value];  
  end;  
  else if @search_field2 = '38' ----mero tv recharge pin          
  begin  
   select '350' as [value]  
     
   union all  
     
   select '500' as [value]  
     
   union all  
     
   select '650' as [value];  
  end;  
  else  
  begin  
   return;  
  end;  
  
  return;  
 end;  
 else if @flag = '013'  
  or @flag = 'client_mobiletopup'  
 begin  
  select @search_field3 = grand_parent_id  
  from tbl_agent_detail  
  where agent_id = @search_field1  
   and agent_type in (  
    'merchant'  
    ,'wallet'  
    );  
  
  declare @sql nvarchar(max) = '';  
  
  set @sql += ' select a.product_id';  
  set @sql += ' ,''['' + stuff((';  
  set @sql += ' select n'',{"value":"'' + cast(b.amount as varchar) + ''","text":"'' + cast(b.amount as varchar) + ''"}''';  
  set @sql += ' from tbl_product_Denomination b';  
  set @sql += ' where a.product_id = b.product_id';  
  set @sql += ' for xml path(n'''')';  
  set @sql += ' ,type';  
  set @sql += ' ).value(n''.[1]'', n''nvarchar(max)''), 1, 1, n'''') + '']'' value';  
  set @sql += ' into #datatable';  
  set @sql += ' from tbl_product_Denomination a';  
  set @sql += ' where isnull(nullif(denomination_status,''active''), ''y'') = ''y'' group by a.product_id;';  
  set @sql += ' ';  
  set @sql += ' insert into #temp (';  
  set @sql += ' text';  
  set @sql += ' ,value';  
  set @sql += ' ,additional_value';  
  set @sql += ' ,additional_text';  
  set @sql += ' ,additional_text2';  
  set @sql += ' ,additional_value2';  
  set @sql += ' ,dropdown_data';  
  set @sql += ' )';  
  set @sql += ' select distinct product_code text';  
  set @sql += ' ,sno value';  
  set @sql += ' ,service_label additional_value';  
  set @sql += ' ,additional_text';  
  set @sql += ' ,service_logo';  
  set @sql += ' ,additional_value2';  
  set @sql += ' ,dropdown_data';  
  set @sql += ' from (';  
  set @sql += ' select pp.product_id sno';  
  set @sql += ' ,ddlt.slabel txn_type';  
  set @sql += ' ,pp.productid as product_code';  
  set @sql += ' ,productlogo service_logo';  
  set @sql += ' ,productlabel service_label';  
  set @sql += ' ,pp.status is_enabled';  
  set @sql += ' ,pg.name additional_text';  
  set @sql += ' ,case when ''' + isnull(@search_field2, '') + '''=''hospital'' then lower(ddlt2.additionalvalue1) else  psg.name end additional_value2';  
  set @sql += ' ,dt.value as dropdown_data';  
  set @sql += ' from tbl_manage_services pp';  
  set @sql += ' left join tbl_gateway_Detail pg on pp.primarygateway = pg.gatewayid';  
  set @sql += ' left join tbl_gateway_Detail psg on isnull(pp.secondarygateway, '''') = psg.gatewayid';  
  set @sql += ' join tbl_static_data ddlt on ddlt.static_row_id = 3';  
  set @sql += ' and pp.txn_type_id = ddlt.additional_value1';  
  set @sql += ' left join tbl_static_data ddlt2 on ddlt2.static_row_id = 13';  
  set @sql += ' and pp.product_id = ddlt2.static_data_value';  
  set @sql += ' left outer join #datatable dt on dt.productid = pp.productid';  
  set @sql += ' where 1 = 1';  
  set @sql += ' and product_type like ''%' + @search_field2 + '%''';  
  set @sql += ' and (isnull(pp.status, ''n'') = ''y'' or isnull(pp.status, ''inactive'') = ''active'')';  
  set @sql += ' and pp.product_id not in (';  
  set @sql += ' select product_id';  
  set @sql += ' from tbl_manage_service_user';  
  set @sql += ' where agent_id = ''' + @search_field1 + '''';  
  set @sql += ' )';  
  set @sql += ' ) a';  
  set @sql += ' where (is_enabled = ''y'' or is_enabled = ''active'')';  
  
  if nullif(@search_field4, '') is not null  
   and isnumeric(@search_field4) = 1  
  begin  
   set @sql += ' and product_code=' + @search_field4;  
  end  
  
  set @sql += ' order by text';  
  set @sql += ' ,service_label asc';  
  set @sql += ' ,sno;';  
  set @sql += ' ';  
  set @sql += ' drop table #datatable;';  
  
  print (@sql);  
  
  exec (@sql);  
 end  
   --------id type(id_type)--------                                        ;      
 else if @flag = '014'  
  or @flag = 'id_type'  
 begin  
  insert into #temp (  
   value  
   ,text  
   )  
  select distinct value = static_data_value  
   ,name = static_data_label  
  from tbl_static_data with (nolock)  
  where sdata_type_id = 4 and additional_value1 = 'np';  
 end  
   --------gateway role list(rolelistgateway)--------                                        ;      
 else if @flag = '015'  
  or @flag = 'rolelistgateway'  
 begin  
  insert into #temp (  
   value  
   ,text  
   )  
  select role_id  
   ,role_name  
  from tbl_roles with (nolock)  
  where (  
    isnull(role_status, 'y') = 'y'  
    or isnull(role_status, 'active') = 'active'  
    )  
   and role_name like 'gateway%';  
 end;  
 else if @flag = '016'  
 begin  
  insert into #temp (  
   value  
   ,text  
   )  
  select category_id  
   ,category_name  
  from tbl_commission_category  
  where isnull(is_active, 'n') = 'y';  
 end;  
 else if @flag = '017' ---bank list                  
 begin  
  insert into #temp (  
   value  
   ,text  
   )  
  select funding_bank_id as [value]  
   ,funding_bank_name as [text]  
  from tbl_funding_bank_account  
  where isnull(bank_status, 'y') = 'y'  
   or isnull(bank_status, 'active') = 'active';  
 end  
   ------@search_field1 for gateway list          ;      
 else if (@flag = 'servicesetup')  
  or @flag = '018'  
 begin  
  select '0' code  
   ,'y' as [value]  
   ,'enabled' as [text]  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
    
  union all  
    
  select '0' code  
   ,'n' as [value]  
   ,'disabled' as [text]  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data;  
  
  select '0' code  
   ,static_data_value as [value]  
   ,static_data_label as [text]  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
  from tbl_static_data  
  where static_data_row_id = '2';--company list                        
  
  select '0' code  
   ,additional_value1 + '|' + static_data_value as [value]  
   ,static_data_label as [text]  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
  from tbl_static_data  
  where static_data_row_id = '3';--txn type                        
  
  select '0' code  
   ,gateway_id as [value]  
   ,gateway_name as [text]  
   ,'' additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
  from tbl_gateway_detail  
  where isnull(gateway_status, 'y') = 'y'  
   or isnull(gateway_status, 'active') = 'active';--gatewaylist(all)                
  
  select '0' code  
   ,pg.gateway_id as [value]  
   ,gd.gateway_name as [text]  
   ,pg.gateway_id additional_value  
   ,'' additional_text  
   ,'' additional_value2  
   ,'' additional_text2  
   ,'' dropdown_data  
  from tbl_gateway_products pg  
  join tbl_gateway_detail gd on gd.gateway_id = pg.gateway_id --gatewaylist(selectedgatewaysonly)                
  where pg.product_id = @search_field1  
   and (  
    isnull(gateway_status, 'y') = 'y'  
    or isnull(gateway_status, 'active') = 'active'  
    );  
  
  return;  
 end;  
 else if @flag = '019' ---nea office code          
 begin  
  insert into #temp (  
   value  
   ,text  
   )  
  select static_data_value as [value]  
   ,static_data_label as [text]  
  from tbl_static_data  
  where isnull(is_deleted, 'n') = 'n'  
   and static_data_row_id = 9;  
 end;  
 else if @flag = '020' --airlines sector codes        
 begin  
  insert into #temp (  
   value  
   ,text  
   )  
  select static_data_value as [value]  
   ,static_data_label as [text]  
  from tbl_static_data  
  where isnull(is_deleted, 'n') = 'n'  
   and static_data_row_id = 10;  
 end  
 else if @flag = '021' -- coop deposit location and branch list  
 begin  
  begin  
   if @search_field1 is not null  
   begin -- branch list  
    insert into #temp (  
     value  
     ,text  
     )  
    select sub_data_value as [value]  
     ,sub_data_label as [text]  
    from tbl_sub_static_data  
    where sub_id = @search_field1;  
   end  
   else  
   begin -- location list  
    insert into #temp (  
     value  
     ,text  
     )  
    select static_data_value as [value]  
     ,static_data_label as [text]  
    from tbl_static_data  
    where isnull(is_deleted, 'n') = 'n'  
     and static_data_row_id = 11;  
   end  
  end  
 end  
 else if @flag = '022' -- cash withdraw location list  
 begin  
  begin  
   insert into #temp (  
    value  
    ,text  
    )  
   select static_data_value as [value]  
    ,static_data_label as [text]  
   from tbl_static_data  
   where isnull(is_deleted, 'n') = 'n'  
    and static_data_row_id = 14;  
  end  
 end  
 else if @flag = '023' -- province of india  
 begin  
  begin  
   insert into #temp (  
    value  
    ,text  
    )  
   select distinct (a.province)  
    ,a.province  
   from tbl_state_local_nepal a(nolock) where country_code= 'in'  
   order by a.province;  
  end  
 end  
 else if @flag = '024' -- occupation list  
 begin  
  begin  
   insert into #temp (  
    value  
    ,text  
    )  
   select static_data_value as [value]  
    ,static_data_label as [text]  
   from tbl_static_data  
   where isnull(is_deleted, 'n') = 'n'  
    and sdata_type_id = 13;  
  end  
 end  
 else if @flag = '025' -- marital status  
 begin  
  begin  
   insert into #temp (  
    value  
    ,text  
    )  
   select static_data_value as [value]  
    ,static_data_label as [text]  
   from tbl_static_data  
   where isnull(is_deleted, 'n') = 'n'  
    and sdata_type_id = 14;  
  end  
 end  
 else if @flag = '026' -- id type indian  
 begin  
  begin  
   insert into #temp (  
   value  
   ,text  
   )  
   select distinct value = static_data_value  
    ,name = static_data_label  
   from tbl_static_data with (nolock)  
   where static_data_row_id = 4 and additional_value1 = 'in';  
  end  
 end  
  
 else if @flag = '027' or @flag = 'productType'  
 begin  
 select static_data_value+'|'+static_data_label as productTypeId  
   ,static_data_label  
  from tbl_Static_data(nolock)  
  where sdata_type_id = 8;  
 end  
  
 else if @flag = '028' or @flag = 'productCategory'  
 begin  
  select static_data_value as productTypeId  
   ,static_data_label  
  from tbl_Static_data(nolock)  
  where sdata_type_id = 18;  
 end  
  
 else if @flag ='029' or @flag = 'kycRemarks'  
 begin  
  select static_data_value   as value
   ,static_data_label   as text
  from tbl_Static_data(nolock)  
  where sdata_type_id = 17;  
 end  
 -----if data exists then return it                                              
 if exists (  
   select *  
   from #temp  
   )  
 begin  
  select 'data' + value sdata  
   ,'0' code  
   ,*  
  from #temp;  
 end  
   -----else return error                                        ;      
 else  
 begin  
  return;  
 end;  
  
 drop table #temp;  
end;  