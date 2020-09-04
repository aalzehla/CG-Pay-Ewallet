USE [CGPay]
GO

/****** Object:  StoredProcedure [dbo].[sproc_get_dropdown_list]    Script Date: 20/08/2020 14:26:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--ALTER FOR COLUMN DISPLAY AS FOR @flag='029'      
/*                                                    
[spagetdropdownlist] @flag='013',@search_field1='1002'  ,@search_field2='hospital'                                               
*/
CREATE
	OR

ALTER PROC [dbo].[sproc_get_dropdown_list] @flag VARCHAR(20) = NULL
	,@search_field1 VARCHAR(100) = NULL
	,@search_field2 VARCHAR(100) = NULL
	,@search_field3 VARCHAR(100) = NULL
	,@search_field4 VARCHAR(100) = NULL
	,@search_field5 VARCHAR(100) = NULL
AS
BEGIN
	CREATE TABLE #temp (
		value NVARCHAR(200)
		,[text] NVARCHAR(200)
		,additional_value NVARCHAR(200)
		,additional_text NVARCHAR(200)
		,additional_value2 NVARCHAR(200)
		,additional_text2 NVARCHAR(200)
		,dropdown_data NVARCHAR(max)
		,[language] NVARCHAR(2)
		);

	/*                                                    
flag starts from 001 to 999                                                    
write down all the flag name and search fields name mapped with corresponding data type and column                                                    
*/
	DECLARE @sql NVARCHAR(max) = '';

	IF @flag = 'fundtransfer'
	BEGIN
		--2 banklist                              
		--select * from dtastaticdatatype                              
		SELECT '0' code
			,agent_id AS value
			,first_name + ' ' + middle_name + ' ' + last_name AS TEXT
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		FROM tbl_agent_detail(NOLOCK)
		WHERE agent_type = 'distributor' --other params?   ;            

		IF @search_field1 IS NULL
			SELECT '0' code
				,agent_id AS value
				,full_name AS TEXT
				,'' additional_value
				,'' additional_text
				,'' additional_value2
				,'' additional_text2
				,'' dropdown_data
			FROM tbl_agent_detail(NOLOCK)
			WHERE agent_type = 'merchant' --other params?                       
				AND parent_id IS NULL;
		ELSE
			SELECT '0' code
				,agent_id AS value
				,full_name AS TEXT
				,'' additional_value
				,'' additional_text
				,'' additional_value2
				,'' additional_text2
				,'' dropdown_data
			FROM tbl_agent_detail(NOLOCK)
			WHERE agent_type = 'merchant'
				AND parent_id = @search_field1;

		SELECT '0' code
			,funding_bank_id AS value
			,funding_bank_name AS TEXT
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		FROM tbl_funding_bank_account;

		RETURN;
	END;

	IF @flag = 'usersetup'
	BEGIN
		SELECT '0' code
			,'y' AS [value]
			,'verified' AS TEXT
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		
		UNION ALL
		
		SELECT '0' code
			,'n' AS [value]
			,'non-verified' AS TEXT
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		
		UNION ALL
		
		SELECT '0' code
			,'r' AS [value]
			,'rejected' AS TEXT
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		
		UNION ALL
		
		SELECT '0' code
			,'p' AS [value]
			,'pending' AS TEXT
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data;

		SELECT '0' code
			,product_id AS [value]
			,product_label AS TEXT
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		FROM tbl_manage_services;

		RETURN;
	END;

	IF @flag = 'operatorsms'
	BEGIN
		SELECT '0' code
			,sms_operator_id AS [value]
			,sms_operator_name AS TEXT
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		FROM tbl_sms_operator_setup;

		RETURN;
	END;

	IF @flag = 'customer'
	BEGIN
		SELECT '0' code
			,agent_id AS [value]
			,first_name + ' ' + middle_name + ' ' + last_name AS TEXT
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		FROM tbl_agent_detail;--where agenttype='wallet'                              

		RETURN;
	END;

	IF @flag = 'txnreport'
	BEGIN
		SELECT '0' code
			,agent_id AS [value]
			,first_name + ' ' + middle_name + ' ' + last_name AS [text]
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		FROM tbl_agent_detail
		WHERE agent_type = 'distributor';

		SELECT '0' code
			,additional_value1 AS [value]
			,static_data_label AS [text]
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		FROM tbl_static_data
		WHERE static_data_row_id = '3';--txn type                             

		SELECT '0' code
			,product_id AS [value]
			,product_label AS [text]
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		FROM tbl_manage_services;

		SELECT '0' code
			,'success' AS [value]
			,'success' AS [text]
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		
		UNION ALL
		
		SELECT '0' code
			,'processing' AS [value]
			,'processing' AS [text]
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		
		UNION ALL
		
		SELECT '0' code
			,'pending' AS [value]
			,'pending' AS [text]
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		
		UNION ALL
		
		SELECT '0' code
			,'hold' AS [value]
			,'hold' AS [text]
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		
		UNION ALL
		
		SELECT '0' code
			,'cancelled' AS [value]
			,'cancelled' AS [text]
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		
		UNION ALL
		
		SELECT '0' code
			,'failed' AS [value]
			,'failed' AS [text]
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data;

		SELECT '0' code
			,gateway_id AS [value]
			,gateway_name AS [text]
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		FROM tbl_gateway_detail;

		RETURN;
	END;

	IF @flag = 'gatewaybalance'
	BEGIN
		SELECT '0' code
			,gateway_id AS [value]
			,gateway_name AS [text]
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		FROM tbl_gateway_detail;

		SELECT '0' code
			,funding_bank_id AS [value]
			,funding_bank_name AS [text]
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		FROM tbl_funding_bank_account
		WHERE isnull(bank_status, 'y') = 'y'
			OR isnull(bank_status, 'active') = 'active';

		RETURN;
	END;

	IF @flag = 'supportkyc'
	BEGIN
		SELECT DISTINCT province AS [value]
			,province AS [name]
		FROM tbl_state_local_nepal;

		SELECT DISTINCT district AS [value]
			,district AS [name]
		FROM tbl_state_local_nepal;

		SELECT static_data_value AS [value]
			,static_data_label AS [name]
		FROM tbl_static_data
		WHERE static_data_row_id = 4;

		SELECT static_data_value AS [value]
			,static_data_label AS [name]
		FROM tbl_static_data
		WHERE static_data_row_id = 1;

		SELECT 'customer' AS [value]
			,'customer' AS [name]
		
		UNION ALL
		
		SELECT 'merchant' AS [value]
			,'merchant' AS [name];
			--union all                      
			--select 'distributor' as [value], 'distributor' as [name]                      
	END;

	IF @flag = 'getsubdistributor'
		OR @flag = 'subdistributor'
	BEGIN
		--set @search_field1='1000'--dist id                            
		SELECT '0' code
			,agent_id AS [value]
			,first_name + '' + middle_name + '' + last_name AS [text]
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		FROM tbl_agent_detail
		WHERE parent_id = @search_field1
			AND agent_type = 'subdistributor';

		RETURN;
	END;

	IF @flag = 'distributor'
	BEGIN
		--set @search_field1='1000'--dist id                            
		SELECT '0' code
			,agent_id AS [value]
			,Agent_name AS [text]
		FROM tbl_agent_detail
		WHERE parent_id IS NULL
			AND agent_type = 'distributor';

		RETURN;
	END;

	IF @flag = 'getAgent'
	BEGIN
		--set @search_field1='1000'--agent id      
		SET @sql = '    
   select ''0'' code,   
 ad.agent_id as [value],  
 isnull(ad.Agent_Name, ad.agent_email_address) + '' '' + ''('' + ad.agent_mobile_no + '')'' as [text],   
 atd.agent_id as Agent_Parent_Id,   
 atd.Agent_Name as AgentParentName 
 
 from tbl_agent_detail ad  
 left join tbl_agent_detail atd on atd.agent_id = ad.parent_id  
 where  ad.agent_type in (''Agent'')'

		IF @search_field1 IS NOT NULL
		BEGIN
			SET @sql += ' and ad.agent_id = ' + @search_field1
		END

		PRINT @sql

		EXEC (@sql)

		RETURN;
	END;

	IF @flag = 'getsubagent'
		OR @flag = 'subagent'
	BEGIN
		--set @search_field1='1000'--dist id                            
		SELECT '0' code
			,agent_id AS [value]
			,first_name + '' + middle_name + '' + last_name AS [text]
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		FROM tbl_agent_detail
		WHERE parent_id = @search_field1
			AND agent_type = 'Sub-Agent';

		RETURN;
	END;

	IF @flag = 'balancetype'
	BEGIN
		SELECT '0' code
			,static_data_value AS [value]
			,static_data_label AS TEXT
			,additional_value1 additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		FROM tbl_static_data
		WHERE static_data_row_id = '7'

		RETURN;
	END;

	IF @flag = 'servicelist'
	BEGIN
		SET @sql = 'select isnull(product_id,''''),product_label from tbl_manage_services(nolock)'

		IF @search_field1 IS NOT NULL
			SET @sql += 'where primary_gateway=' + @search_field1 + ' or secondary_gateway=' + @search_field1

		PRINT @sql

		EXEC (@sql)

		RETURN;
	END;

	IF @flag = 'kycstatus'
	BEGIN
		SELECT '0' code
			,static_data_value AS [value]
			,static_data_label AS TEXT
			,additional_value1 additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		FROM tbl_static_data
		WHERE static_data_row_id = '18'

		RETURN;
	END;

	--------user setup--------                                                    
	IF @flag = '000'
	BEGIN
		INSERT INTO #temp (
			value
			,TEXT
			)
		SELECT '1' value
			,'admin' TEXT
		
		UNION
		
		SELECT '2' value
			,'user' TEXT;

		SELECT '0' code
			,'y' value
			,'active' TEXT
		
		UNION
		
		SELECT '0' code
			,'n' value
			,'in active' TEXT;
	END;

	--------role list(rolelist)--------                               
	IF @flag = '001'
		OR @flag = 'rolelist'
	BEGIN
		--insert into #temp (        
		-- value        
		-- ,text        
		-- )        
		SELECT role_id value
			,role_name TEXT
		FROM tbl_roles(NOLOCK)
		WHERE (
				isnull(role_status, 'y') = 'y'
				OR isnull(role_status, 'active') = 'active'
				)
			AND role_name NOT LIKE 'gateway%';
	END
			------zone list(zonelist)--------                                        ;            
	ELSE IF @flag = '002'
		OR @flag = 'zonelist'
	BEGIN
		--insert into #temp (        
		-- value        
		-- ,text        
		-- )        
		SELECT DISTINCT a.province_Code value
			,a.province TEXT
		FROM tbl_state_local_nepal a(NOLOCK)
		WHERE country_code = 'np'
		ORDER BY a.province_Code;
	END
			--------country list(country)--------                                        ;            
	ELSE IF @flag = '004'
		OR @flag = 'country'
	BEGIN
		--insert into #temp (        
		-- value        
		-- ,text        
		-- )        
		SELECT static_data_value value
			,static_data_label TEXT
		FROM tbl_static_Data(NOLOCK)
		WHERE sdata_type_id = '1';
	END
			--------gender list(genderlist)--------                                        ;            
	ELSE IF @flag = '005'
		OR @flag = 'genderlist'
	BEGIN
		--insert into #temp (        
		-- value        
		-- ,text        
		-- )        
		SELECT static_data_value value
			,static_data_label TEXT
		FROM tbl_static_Data(NOLOCK)
		WHERE sdata_type_id = '5';
	END
			--------admin user list(userlist)--------                                        ;            
	ELSE IF @flag = '006'
		OR @flag = 'userlist'
	BEGIN
		INSERT INTO #temp (
			value
			,TEXT
			)
		SELECT user_id userid
			,full_name fullname
		FROM tbl_user_detail(NOLOCK)
		WHERE isnull(STATUS, 'n') = 'Y'
		ORDER BY fullname;
	END
			--------district list(getdistrictlist)--------                                                    
			--------@search_field1=province_id                                        ;            
	ELSE IF @flag = '007'
		OR @flag = 'getdistrictlist'
	BEGIN
		DECLARE @districtsql VARCHAR(max) = '';

		--set @districtsql += 'insert into #temp (';        
		--set @districtsql += 'value';        
		--set @districtsql += ',text';        
		--set @districtsql += ')';        
		SET @districtsql += 'select distinct (a.district) value';
		SET @districtsql += ',a.district text';
		SET @districtsql += ' from tbl_state_local_nepal a(nolock) where country_code= ''np'' ';

		IF @search_field1 IS NOT NULL
			SET @districtsql += ' and province_code=''' + @search_field1 + '''';
		SET @districtsql += ' order by a.district';

		PRINT (@districtsql);

		EXEC (@districtsql);
	END
			--------local unit(getlocalunit)--------                                                    
			--------@search_field1=district                                        ;            
	ELSE IF @flag = '008'
		OR @flag = 'getlocalunit'
	BEGIN
		--insert into #temp (        
		-- value        
		-- ,text        
		-- )        
		--select distinct value = localuniteng,name = localuniteng from tblprovince(nolock) where district = @param order by name                                                             
		SELECT DISTINCT local_level value
			,local_level TEXT
		FROM tbl_state_local_nepal(NOLOCK)
		WHERE country_code = 'np'
			AND district = isnull(@search_field1, district)
		ORDER BY value;
	END
			--------fund transfer list(fundtransfer)--------                                                    
			--------@search_field1=sub distributor id                                        
			--------@search_field2=dustributor id                                      ;            
	ELSE IF @flag = '009'
		OR @flag = 'fundtransfer'
	BEGIN
		INSERT INTO #temp (
			value
			,TEXT
			)
		SELECT value = agent_id
			,name = full_name
		FROM tbl_agent_detail
		WHERE isnull(agent_status, 'n') IN (
				'Y'
				,'0'
				)
			AND (parent_id = @search_field1)
		--or @search_field2 = grand_parent_id        
		ORDER BY name ASC;
	END
			--------company list(companylist)--------                                        ;            
	ELSE IF @flag = '010'
		OR @flag = 'companylist'
	BEGIN
		SELECT additional_value1 + '|' + static_data_value AS company_id
			,static_data_label
		FROM tbl_Static_data(NOLOCK)
		WHERE sdata_type_id = 2;
	END
			--------txn type(txn_type)--------                                        ;            
	ELSE IF @flag = '011'
		OR @flag = 'txn_type'
	BEGIN
		--insert into #temp (        
		-- value        
		-- ,text        
		-- )        
		SELECT additional_value1 + '|' + static_data_value AS txn_type_id
			,static_data_label
		FROM tbl_Static_data(NOLOCK)
		WHERE sdata_type_id = 3;

		RETURN;
	END
			--------gateway list(gateway)--------                                        ;            
	ELSE IF @flag = '012'
		OR @flag = 'gateway'
	BEGIN
		--insert into #temp (        
		-- value        
		-- ,text        
		-- )        
		SELECT gateway_id
			,gateway_name
		FROM tbl_gateway_detail;
	END
			--------client mobile topup(client_mobiletopup)--------                                                    
			--------@search_field1=merchant_id                                                                    
			--------@search_field2= search type(airticket,electricity,epin,insurancepremium,internetpayment,                         
			-----------------------landline,gsm,tv_payment,water,)      ;            
	ELSE IF @flag = 'rcpins'
	BEGIN
		IF @search_field2 = '5'
			OR @search_field2 = '8' ----ntc, smart                
		BEGIN
			SELECT '50' AS [value]
			
			UNION ALL
			
			SELECT '100' AS [value]
			
			UNION ALL
			
			SELECT '200' AS [value]
			
			UNION ALL
			
			SELECT '500' AS [value]
			
			UNION ALL
			
			SELECT '1000' AS [value];
		END;
		ELSE IF @search_field2 = '7' ----utl recharge pin                
		BEGIN
			SELECT '100' AS [value]
			
			UNION ALL
			
			SELECT '250' AS [value]
			
			UNION ALL
			
			SELECT '500' AS [value];
		END;
		ELSE IF @search_field2 = '12' ----broadlink recharge pin                
		BEGIN
			SELECT '550' AS [value]
			
			UNION ALL
			
			SELECT '565' AS [value]
			
			UNION ALL
			
			SELECT '1200' AS [value]
			
			UNION ALL
			
			SELECT '1500' AS [value]
			
			UNION ALL
			
			SELECT '2260' AS [value];
		END;
		ELSE IF @search_field2 = '13' ----broadtel recharge pin                
		BEGIN
			SELECT '550' AS [value]
			
			UNION ALL
			
			SELECT '565' AS [value]
			
			UNION ALL
			
			SELECT '1200' AS [value]
			
			UNION ALL
			
			SELECT '1500' AS [value]
			
			UNION ALL
			
			SELECT '2260' AS [value];
		END;
		ELSE IF @search_field2 = '35' ----prabhutv ott epin                
		BEGIN
			SELECT '50' AS [value]
			
			UNION ALL
			
			SELECT '100' AS [value]
			
			UNION ALL
			
			SELECT '200' AS [value];
		END;
		ELSE IF @search_field2 = '38' ----mero tv recharge pin                
		BEGIN
			SELECT '350' AS [value]
			
			UNION ALL
			
			SELECT '500' AS [value]
			
			UNION ALL
			
			SELECT '650' AS [value];
		END;
		ELSE
		BEGIN
			RETURN;
		END;

		RETURN;
	END;
	ELSE IF @flag = '013'
		OR @flag = 'client_mobiletopup'
	BEGIN
		SELECT @search_field3 = ad.parent_id
		FROM tbl_agent_detail a
		JOIN tbl_agent_detail ad ON ad.agent_id = a.parent_id
		WHERE a.agent_id = @search_field1
			AND a.agent_type IN (
				'merchant'
				,'wallet'
				);

		SET @sql += ' select a.product_id';
		SET @sql += ' ,''['' + stuff((';
		SET @sql += ' select n'',{"value":"'' + cast(b.amount as varchar) + ''","text":"'' + cast(b.amount as varchar) + ''"}''';
		SET @sql += ' from tbl_product_Denomination b';
		SET @sql += ' where a.product_id = b.product_id';
		SET @sql += ' for xml path(n'''')';
		SET @sql += ' ,type';
		SET @sql += ' ).value(n''.[1]'', n''nvarchar(max)''), 1, 1, n'''') + '']'' value';
		SET @sql += ' into #datatable';
		SET @sql += ' from tbl_product_Denomination a';
		SET @sql += ' where isnull(nullif(denomination_status,''active''), ''y'') = ''y'' group by a.product_id;';
		SET @sql += ' ';
		SET @sql += ' insert into #temp (';
		SET @sql += ' text';
		SET @sql += ' ,value';
		SET @sql += ' ,additional_value';
		SET @sql += ' ,additional_text';
		SET @sql += ' ,additional_text2';
		SET @sql += ' ,additional_value2';
		SET @sql += ' ,dropdown_data';
		SET @sql += ' )';
		SET @sql += ' select distinct product_code text';
		SET @sql += ' ,sno value';
		SET @sql += ' ,service_label additional_value';
		SET @sql += ' ,additional_text';
		SET @sql += ' ,service_logo';
		SET @sql += ' ,additional_value2';
		SET @sql += ' ,dropdown_data';
		SET @sql += ' from (';
		SET @sql += ' select pp.product_id sno';
		SET @sql += ' ,ddlt.slabel txn_type';
		SET @sql += ' ,pp.productid as product_code';
		SET @sql += ' ,productlogo service_logo';
		SET @sql += ' ,productlabel service_label';
		SET @sql += ' ,pp.status is_enabled';
		SET @sql += ' ,pg.name additional_text';
		SET @sql += ' ,case when ''' + isnull(@search_field2, '') + '''=''hospital'' then lower(ddlt2.additionalvalue1) else  psg.name end additional_value2';
		SET @sql += ' ,dt.value as dropdown_data';
		SET @sql += ' from tbl_manage_services pp';
		SET @sql += ' left join tbl_gateway_Detail pg on pp.primarygateway = pg.gatewayid';
		SET @sql += ' left join tbl_gateway_Detail psg on isnull(pp.secondarygateway, '''') = psg.gatewayid';
		SET @sql += ' join tbl_static_data ddlt on ddlt.static_row_id = 3';
		SET @sql += ' and pp.txn_type_id = ddlt.additional_value1';
		SET @sql += ' left join tbl_static_data ddlt2 on ddlt2.static_row_id = 13';
		SET @sql += ' and pp.product_id = ddlt2.static_data_value';
		SET @sql += ' left outer join #datatable dt on dt.productid = pp.productid';
		SET @sql += ' where 1 = 1';
		SET @sql += ' and product_type like ''%' + @search_field2 + '%''';
		SET @sql += ' and (isnull(pp.status, ''n'') = ''y'' or isnull(pp.status, ''inactive'') = ''active'')';
		SET @sql += ' and pp.product_id not in (';
		SET @sql += ' select product_id';
		SET @sql += ' from tbl_manage_service_user';
		SET @sql += ' where agent_id = ''' + @search_field1 + '''';
		SET @sql += ' )';
		SET @sql += ' ) a';
		SET @sql += ' where (is_enabled = ''y'' or is_enabled = ''active'')';

		IF nullif(@search_field4, '') IS NOT NULL
			AND isnumeric(@search_field4) = 1
		BEGIN
			SET @sql += ' and product_code=' + @search_field4;
		END

		SET @sql += ' order by text';
		SET @sql += ' ,service_label asc';
		SET @sql += ' ,sno;';
		SET @sql += ' ';
		SET @sql += ' drop table #datatable;';

		PRINT (@sql);

		EXEC (@sql);
	END
			--------id type(id_type)--------                                        ;            
	ELSE IF @flag = '014'
		OR @flag = 'id_type'
	BEGIN
		--insert into #temp (        
		-- value        
		-- ,text        
		-- )        
		SELECT DISTINCT static_data_value value
			,static_data_label TEXT
		FROM tbl_static_data WITH (NOLOCK)
		WHERE sdata_type_id = 4
			AND additional_value1 = 'np';
	END
			--------gateway role list(rolelistgateway)--------                                        ;            
	ELSE IF @flag = '015'
		OR @flag = 'rolelistgateway'
	BEGIN
		INSERT INTO #temp (
			value
			,TEXT
			)
		SELECT role_id
			,role_name
		FROM tbl_roles WITH (NOLOCK)
		WHERE (
				isnull(role_status, 'y') = 'y'
				OR isnull(role_status, 'active') = 'active'
				)
			AND role_name LIKE 'gateway%';
	END;
	ELSE IF @flag = '016' -- commission category    
	BEGIN
		SET @sql = '  
  select category_id        
   ,category_name        
  from tbl_commission_category        
  where isnull(is_active, ''n'') = ''y'''

		IF @search_field1 IS NOT NULL
			SET @sql += ' and agent_id=''' + @search_field1 + '''';
		ELSE
			SET @sql += ' and agent_id is null'

		PRINT (@sql)

		EXEC (@sql)

		RETURN;
	END;
	ELSE IF @flag = '017' ---bank list                        
	BEGIN
		SELECT funding_bank_id AS [value]
			,funding_bank_name + ' (' + funding_account_number + ')' AS [text]
		FROM tbl_funding_bank_account
		WHERE isnull(bank_status, 'y') = 'y'
	END
			------@search_field1 for gateway list          ;            
	ELSE IF (@flag = 'servicesetup')
		OR @flag = '018'
	BEGIN
		SELECT '0' code
			,'y' AS [value]
			,'enabled' AS [text]
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		
		UNION ALL
		
		SELECT '0' code
			,'n' AS [value]
			,'disabled' AS [text]
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data;

		SELECT '0' code
			,static_data_value AS [value]
			,static_data_label AS [text]
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		FROM tbl_static_data
		WHERE static_data_row_id = '2';--company list                              

		SELECT '0' code
			,additional_value1 + '|' + static_data_value AS [value]
			,static_data_label AS [text]
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		FROM tbl_static_data
		WHERE static_data_row_id = '3';--txn type                              

		SELECT '0' code
			,gateway_id AS [value]
			,gateway_name AS [text]
			,'' additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		FROM tbl_gateway_detail
		WHERE isnull(gateway_status, 'y') = 'y'
			OR isnull(gateway_status, 'active') = 'active';--gatewaylist(all)                      

		SELECT '0' code
			,pg.gateway_id AS [value]
			,gd.gateway_name AS [text]
			,pg.gateway_id additional_value
			,'' additional_text
			,'' additional_value2
			,'' additional_text2
			,'' dropdown_data
		FROM tbl_gateway_products pg
		JOIN tbl_gateway_detail gd ON gd.gateway_id = pg.gateway_id --gatewaylist(selectedgatewaysonly)                      
		WHERE pg.product_id = @search_field1
			AND (
				isnull(gateway_status, 'y') = 'y'
				OR isnull(gateway_status, 'active') = 'active'
				);

		RETURN;
	END;
	ELSE IF @flag = '019' ---nea office code                
	BEGIN
		PRINT ('nea')

		--insert into #temp (        
		-- value        
		-- ,text        
		-- )        
		SELECT static_data_value AS [value]
			,static_data_label AS [text]
		FROM tbl_static_data
		WHERE isnull(is_deleted, 'n') = 'n'
			AND sdata_type_id = 9
		ORDER BY static_data_label;

		RETURN;
	END;
	ELSE IF @flag = '020' --airlines sector codes              
	BEGIN
		INSERT INTO #temp (
			value
			,TEXT
			)
		SELECT static_data_value AS [value]
			,static_data_label AS [text]
		FROM tbl_static_data
		WHERE isnull(is_deleted, 'n') = 'n'
			AND static_data_row_id = 10;
	END

	IF @flag = '034'
		OR @flag = 'arole'
	BEGIN
		SELECT role_id value
			,role_name TEXT
		FROM tbl_roles(NOLOCK)
		WHERE (
				isnull(role_status, 'y') = 'y'
				AND role_type = 'Admin'
				)
	END

	IF @flag = '035'
		OR @flag = 'drole'
	BEGIN
		SELECT role_id value
			,role_name TEXT
		FROM tbl_roles(NOLOCK)
		WHERE (
				isnull(role_status, 'y') = 'y'
				AND role_type = 'Distributor'
				)
	END

	IF @flag = '036'
		OR @flag = 'sdrole'
	BEGIN
		SELECT role_id value
			,role_name TEXT
		FROM tbl_roles(NOLOCK)
		WHERE (
				isnull(role_status, 'y') = 'y'
				AND role_type = 'Sub-Distributor'
				)
	END

	IF @flag = '037'
		OR @flag = 'agrole'
	BEGIN
		SELECT role_id value
			,role_name TEXT
		FROM tbl_roles(NOLOCK)
		WHERE (
				isnull(role_status, 'y') = 'y'
				AND role_type = 'Agent'
				)
	END

	IF @flag = '038'
		OR @flag = 'sagrole'
	BEGIN
		SELECT role_id value
			,role_name TEXT
		FROM tbl_roles(NOLOCK)
		WHERE (
				isnull(role_status, 'y') = 'y'
				AND role_type = 'Sub-Agent'
				)
	END

	IF @flag = '039'
		OR @flag = 'mrole'
	BEGIN
		SELECT role_id value
			,role_name TEXT
		FROM tbl_roles(NOLOCK)
		WHERE (
				isnull(role_status, 'y') = 'y'
				AND role_type = 'Merchant'
				)
	END

	IF @flag = '040'
		OR @flag = 'cardT'
	BEGIN
		SELECT static_data_value value
			,static_data_label TEXT
		FROM tbl_static_data
		WHERE sdata_type_id = 23
			AND isnull(is_deleted, 'n') <> 'y'
	END

	if @flag = '041' or @flag = 'pmtGt'
	Begin
		 select  pmt_gateway_name  as value,
					pmt_gateway_name as text
		 from tbl_payment_gateway_transaction with (nolock) where pmt_gateway_name is not null group by  pmt_gateway_name
	ENd

	-----if data exists then return it                                                    
	IF EXISTS (
			SELECT *
			FROM #temp
			)
	BEGIN
		SELECT 'data' + value sdata
			,'0' code
			,*
		FROM #temp;
	END
			-----else return error                                        ;            
	ELSE
	BEGIN
		RETURN;
	END;

	DROP TABLE #temp;
END;
GO


