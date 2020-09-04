
  
      
      
alter     PROCEDURE [dbo].[sproc_manage_services] @flag CHAR(3)      
 ,@product_id INT = NULL      
 ,@product VARCHAR(20) = NULL      
 ,@txn_type VARCHAR(50) = NULL      
 ,@txn_type_id VARCHAR(50) = NULL      
 ,@product_code int = NULL      
 ,@is_enabled CHAR(3) = NULL      
 ,@operator_code INT = NULL      
 ,@prefix VARCHAR(60) = NULL      
 ,@denomination VARCHAR(10) = NULL      
 ,@primary_gateway VARCHAR(100) = NULL      
 ,@secondary_gateway VARCHAR(100) = NULL      
 ,@created_by VARCHAR(50) = NULL      
 ,@updated_by VARCHAR(50) = NULL      
 ,@services_description VARCHAR(10) = NULL      
 ,@denomination_max DECIMAL(18, 2) = NULL      
 ,@denomination_min DECIMAL(18, 2) = NULL      
 ,@is_deno_enabled CHAR(3) = NULL      
 ,@action_ip_address VARCHAR(10) = NULL      
 ,@selected_values VARCHAR(max) = NULL      
 ,@agent_id VARCHAR(10) = NULL      
 ,@service_logo NVARCHAR(max) = NULL      
 ,@service_info NVARCHAR(max) = NULL      
 ,@company_id INT = NULL      
 ,@company VARCHAR(50) = NULL      
 ,@product_type_id INT = NULL      
 ,@product_type VARCHAR(50) = NULL      
 ,@product_label VARCHAR(100) = NULL      
 ,@product_logo VARCHAR(200) = NULL      
 ,@product_service_info VARCHAR(200) = NULL      
 ,@product_category VARCHAR(30) = NULL      
 ,@subscriber_regex VARCHAR(50) = NULL      
 ,@product_status CHAR(3) = NULL      
 --@status            char            = null   ,        
 ,@user_id INT = NULL     
 ,@created_ip VARCHAR(200) = NULL     
 ,@product_url varchar(200) = null  
AS      
SET NOCOUNT ON;      
      
BEGIN TRY      
 --- Flag 'i' is not Required for now            
 IF @flag = 'i'      
 BEGIN      
  INSERT INTO [dbo].tbl_manage_services (      
   txn_type_id      
   ,txn_type      
   ,company_id      
   ,company      
   ,product_type_id      
   ,product_type      
   ,product_label      
   ,product_logo      
   ,product_service_info      
   ,product_category      
   ,subscriber_regex      
   ,min_denomination_amount      
   ,max_denomination_amount      
   ,primary_gateway      
   ,secondary_gateway      
   ,STATUS      
   ,created_UTC_date      
   ,created_local_date      
   ,created_nepali_date      
   ,created_by      
   ,created_ip  
   ,product_url  
   ,product_code  
   )      
  VALUES (      
   (@txn_type_id)      
   ,(@txn_type)      
   ,(@company_id)      
   ,(@company)      
   ,(@product_type_id)      
   ,(@product_type)      
   ,(@product_label)      
   ,(@product_logo)      
   ,(@product_service_info)      
   ,(@product_category)      
   ,(@subscriber_regex)      
   ,@denomination_min      
   ,@denomination_max      
   ,@primary_gateway      
   ,@secondary_gateway      
   ,@product_status      
   ,getutcdate()      
   ,getdate()      
   ,[dbo].func_get_nepali_date(DEFAULT)      
   ,@created_by     
   ,@created_ip  
   ,@product_url  
   ,@product_code  
   );      
      
  SELECT '0' code      
   ,'Product added successfully' message      
   ,NULL id;      
      
  RETURN;      
 END;      
      
 ---Flag 'i' is note Required for Now            
 IF @flag = 'u'      
 BEGIN      
  IF NOT EXISTS (      
    SELECT 'x'      
    FROM tbl_manage_services with (nolock)   
    WHERE product_id = @product_id      
    )      
  BEGIN      
   SELECT '1' code      
    ,'Product doesn''t exists ! please try again.' message      
    ,NULL id;      
      
   RETURN;      
  END;      
  ELSE      
  BEGIN      
   UPDATE [dbo].tbl_manage_services      
   SET txn_type = isnull(@txn_type, txn_type)      
    ,product_type = isnull(@product_type, product_type)      
    ,product_type_id = isnull(@product_type_id, product_type_id)      
    ,product_label = isnull(@product_label, product_label)      
    ,product_logo = isnull(@product_logo, product_logo)      
    ,product_service_info = isnull(@product_service_info, product_service_info)      
    ,product_category = isnull(@product_category, product_category)      
    ,min_denomination_amount = isnull(@denomination_min, min_denomination_amount)      
    ,max_denomination_amount = isnull(@denomination_max, max_denomination_amount)      
    ,[status] = isnull(@product_status, [status])      
    ,updated_by = isnull(@updated_by, updated_by)      
    ,updated_UTC_date = isnull(getutcdate(), updated_UTC_date)      
    ,updated_local_date = isnull(getdate(), updated_local_date)      
    ,updated_nepali_date = isnull([dbo].func_get_nepali_date(DEFAULT), updated_nepali_date)      
 ,product_url = isnull(@product_url, Product_url)  
   WHERE product_id = @product_id;      
      
   SELECT '0' code      
    ,'Product details updated successfully' message      
    ,NULL id;      
      
   RETURN;      
  END;      
 END;-- update services detail            
      
 IF @flag = 'v'      
 BEGIN      
  IF @user_id IS NOT NULL      
  BEGIN      
   SELECT @agent_id = ad.agent_id      
   FROM tbl_user_detail  u   with (nolock)   
   JOIN tbl_agent_detail ad with (nolock) ON ad.agent_id = u.agent_id      
   WHERE user_id = @user_id      
  END      
--  print(@agent_id)      
  IF @agent_id IS NULL      
  BEGIN      
--  print('test1')      
        
   SELECT isnull(txn_type, '') txn_type      
    ,      
     isnull(txn_type_id, 0) txn_type_id,             
    ms.product_id      
    ,isnull(company, '') company      
    ,      
    -- isnull(company_id, 0) company_id,             
    isnull(product_type, '') product_type      
    ,isnull(product_label, '') product_label      
    ,isnull(product_category, '') product_category      
    ,isnull(product_logo, '') product_logo      
    ,isnull(product_service_info, '') product_service_info      
    ,isnull(primary_gateway, 0) primary_gateway      
    ,isnull(secondary_gateway, 0) secondary_gateway      
    ,isnull([status], '') AS [product_status]      
    ,sc.additional_value1 AS clientPmtUrl      
    ,isnull(ms.created_by, 'system') created_by      
    ,(ms.updated_by) AS updated_by      
    ,ms.created_local_date AS created_date   
	,ms.product_code, 
	ms.product_url
    ,isnull(CAST(min_denomination_amount AS VARCHAR), 0.00) min_denomination_amount      
    ,isnull(CAST(max_denomination_amount AS VARCHAR), 0.00) max_denomination_amount      
    ,isnull(CAST(min_denomination_amount AS VARCHAR), 0.00) + ' - ' + isnull(CAST(max_denomination_amount AS VARCHAR), 0.00) AS Denomination      
   FROM tbl_manage_services ms with (nolock)     
   LEFT JOIN tbl_static_data sc with (nolock) ON ms.product_type_id = sc.static_data_value      
    AND sdata_type_id = '18'  and isnull(ms.is_deleted,'y') = 'n'    
  END      
  ELSE      
  BEGIN      
  --print(@agent_id)      
       
      
   SELECT isnull(txn_type, '') txn_type      
    ,      
    -- isnull(txn_type_id, 0) txn_type_id,             
    ms.product_id      
    ,isnull(company, '') company      
    ,      
    -- isnull(company_id, 0) company_id,             
    isnull(product_type, '') product_type      
    ,isnull(product_label, '') product_label      
    ,isnull(product_category, '') product_category      
    ,isnull(product_logo, '') product_logo      
    ,isnull(product_service_info, '') product_service_info      
    ,isnull(primary_gateway, 0) primary_gateway      
    ,isnull(secondary_gateway, 0) secondary_gateway      
    ,isnull(ms.[status], '') AS [product_status]      
    ,sc.additional_value1 AS clientPmtUrl      
    ,isnull(ms.created_by, 'system') created_by      
    ,(ms.updated_by) AS updated_by      
    ,ms.created_local_date AS created_date      
    ,cd.commission_value      
    ,cd.commission_type  
	,ms.product_code, 
	ms.product_url
    ,isnull(CAST(min_denomination_amount AS VARCHAR), 0.00) min_denomination_amount      
    ,isnull(CAST(max_denomination_amount AS VARCHAR), 0.00) max_denomination_amount      
    ,isnull(CAST(min_denomination_amount AS VARCHAR), 0.00) + ' - ' + isnull(CAST(max_denomination_amount AS VARCHAR), 0.00) AS Denomination      
   FROM tbl_manage_services ms with (nolock)      
   LEFT JOIN tbl_static_data sc with (nolock) ON ms.product_type_id = sc.static_data_value      
    AND sdata_type_id = '18'     and isnull(ms.is_deleted,'y') = 'n'   
   LEFT JOIN tbl_commission_category_detail cd with (nolock) ON cd.product_id = ms.product_id      
   LEFT JOIN tbl_agent_detail ad with (nolock) ON ad.agent_commission_id = cd.com_category_id      
   LEFT JOIN tbl_user_detail u with (nolock) ON u.agent_id = ad.agent_id      
   WHERE ad.agent_id = @agent_id      
   GROUP BY ms.product_id      
    ,ms.product_label      
    ,ad.agent_id      
    ,cd.commission_value      
    ,cd.commission_type      
    ,company      
    ,product_type      
    ,product_category      
    ,product_logo      
    ,product_service_info      
    ,primary_gateway      
    ,secondary_gateway      
    ,ms.STATUS      
    ,ms.created_by      
    ,ms.updated_by      
    ,ms.created_local_date      
    ,ms.txn_type      
    ,sc.additional_value1      
    ,ms.min_denomination_amount      
    ,ms.max_denomination_amount  
	,ms.product_code, 
	ms.product_url
  END;      
      
  RETURN;      
 END;-- get list of services     
 
 IF @flag = 'cv'      
 BEGIN      
  IF @user_id IS NOT NULL      
  BEGIN      
   SELECT @agent_id = ad.agent_id      
   FROM tbl_user_detail  u   with (nolock)   
   JOIN tbl_agent_detail ad with (nolock) ON ad.agent_id = u.agent_id      
   WHERE user_id = @user_id      
  END      
--  print(@agent_id)      
  IF @agent_id IS NULL      
  BEGIN      
 --print('x')      
        
   SELECT isnull(txn_type, '') txn_type      
    ,      
     isnull(txn_type_id, 0) txn_type_id,             
    ms.product_code product_id      
    ,isnull(company, '') company      
    ,      
    -- isnull(company_id, 0) company_id,             
    isnull(product_type, '') product_type      
    ,isnull(product_label, '') product_label      
    ,isnull(product_category, '') product_category      
    ,isnull(product_logo, '') product_logo      
    ,isnull(product_service_info, '') product_service_info      
    ,isnull(primary_gateway, 0) primary_gateway      
    ,isnull(secondary_gateway, 0) secondary_gateway      
    ,isnull([status], '') AS [product_status]      
    ,sc.additional_value1 AS clientPmtUrl      
    ,isnull(ms.created_by, 'system') created_by      
    ,(ms.updated_by) AS updated_by      
    ,ms.created_local_date AS created_date   
	,ms.product_code, 
	ms.product_url
    ,isnull(CAST(min_denomination_amount AS VARCHAR), 0.00) min_denomination_amount      
    ,isnull(CAST(max_denomination_amount AS VARCHAR), 0.00) max_denomination_amount      
    ,isnull(CAST(min_denomination_amount AS VARCHAR), 0.00) + ' - ' + isnull(CAST(max_denomination_amount AS VARCHAR), 0.00) AS Denomination      
   FROM tbl_manage_services ms with (nolock)     
   LEFT JOIN tbl_static_data sc with (nolock) ON ms.product_type_id = sc.static_data_value      
    AND sdata_type_id = '18'  and isnull(ms.is_deleted,'y') = 'n'    
  END      
  ELSE      
  BEGIN      
  --print('y')      
       
      
   SELECT isnull(txn_type, '') txn_type      
    ,      
    -- isnull(txn_type_id, 0) txn_type_id,             
    ms.product_code product_id       
    ,isnull(company, '') company      
    ,      
    -- isnull(company_id, 0) company_id,             
    isnull(product_type, '') product_type      
    ,isnull(product_label, '') product_label      
    ,isnull(product_category, '') product_category      
    ,isnull(product_logo, '') product_logo      
    ,isnull(product_service_info, '') product_service_info     
    ,isnull(primary_gateway, 0) primary_gateway      
    ,isnull(secondary_gateway, 0) secondary_gateway      
    ,isnull(ms.[status], '') AS [product_status]      
    ,sc.additional_value1 AS clientPmtUrl      
    ,isnull(ms.created_by, 'system') created_by      
    ,(ms.updated_by) AS updated_by      
    ,ms.created_local_date AS created_date      
    ,cd.commission_value      
    ,cd.commission_type  
	,ms.product_code, 
	ms.product_url
    ,isnull(CAST(min_denomination_amount AS VARCHAR), 0.00) min_denomination_amount      
    ,isnull(CAST(max_denomination_amount AS VARCHAR), 0.00) max_denomination_amount      
    ,isnull(CAST(min_denomination_amount AS VARCHAR), 0.00) + ' - ' + isnull(CAST(max_denomination_amount AS VARCHAR), 0.00) AS Denomination      
   FROM tbl_manage_services ms with (nolock)      
   LEFT JOIN tbl_static_data sc with (nolock) ON ms.product_type_id = sc.static_data_value      
    AND sdata_type_id = '18'     and isnull(ms.is_deleted,'y') = 'n'   
   LEFT JOIN tbl_commission_category_detail cd with (nolock) ON cd.product_id = ms.product_id      
   LEFT JOIN tbl_agent_detail ad with (nolock) ON ad.agent_commission_id = cd.com_category_id      
   LEFT JOIN tbl_user_detail u with (nolock) ON u.agent_id = ad.agent_id      
   WHERE ad.agent_id = @agent_id      
   GROUP BY ms.product_id      
    ,ms.product_label      
    ,ad.agent_id      
    ,cd.commission_value      
    ,cd.commission_type      
    ,company      
    ,product_type      
    ,product_category      
    ,product_logo      
    ,product_service_info      
    ,primary_gateway      
    ,secondary_gateway      
    ,ms.STATUS      
    ,ms.created_by      
    ,ms.updated_by      
    ,ms.created_local_date      
    ,ms.txn_type      
    ,sc.additional_value1      
    ,ms.min_denomination_amount      
    ,ms.max_denomination_amount  
	,ms.product_code, 
	ms.product_url
  END;      
      
  RETURN;      
 END;-- get list of services           
      
 IF @flag = 'vid'      
 BEGIN      
  SELECT isnull(CONCAT (      
     txn_type_id      
     ,'|'      
     ,txn_type      
     ), '') txn_type      
   ,      
   --  isnull(txn_type_id, 0) txntypeid,             
   product_id      
   ,isnull(CONCAT (      
     company_id      
     ,'|'      
     ,company      
     ), '') company      
   ,      
   --  isnull(company_id, 0) companyid,             
   isnull(CONCAT (      
     product_type_id      
     ,'|'      
     ,product_type      
     ), '') product_type      
   ,isnull(product_label, '') product_label      
   ,isnull(product_category, '') product_category      
   ,isnull(product_logo, '') product_logo      
   ,isnull(product_service_info, '') product_service_info      
   ,isnull(primary_gateway, 0) primary_gateway      
   ,isnull(secondary_gateway, 0) secondary_gateway      
   ,isnull([status], '') product_status      
   ,isnull(created_by, 'system') created_by      
   ,(updated_by) AS updated_by      
   ,created_local_date AS created_date      
   ,isnull(CAST(min_denomination_amount AS VARCHAR), 0.00) min_denomination_amount      
   ,isnull(CAST(max_denomination_amount AS VARCHAR), 0.00) max_denomination_amount      
   ,isnull(CAST(min_denomination_amount AS VARCHAR), 0.00) + ' - ' + isnull(CAST(max_denomination_amount AS VARCHAR), 0.00) AS Denomination  
   ,product_code, 
	product_url
  FROM tbl_manage_services with (nolock)     
  WHERE product_id = @product_id  and isnull(is_deleted,'y') = 'n'    
      
  RETURN;      
 END;-- get detail of select product            
      
 IF @flag = 'del'      
 BEGIN      
  IF NOT EXISTS (      
    SELECT 'x'      
    FROM tbl_manage_services  with (nolock)    
    WHERE product_id = @product_id      
    )      
  BEGIN      
   SELECT '1' Code      
    ,'Selected product doesn''t exist. Please check!!' Message      
    ,NULL id   
      
   RETURN      
  END      
  ELSE      
  BEGIN      
   UPDATE tbl_manage_services      
   SET [status] = Isnull(@product_status, 'Y')      
   WHERE product_id = @product_id      
      
   SELECT '0' Code      
    ,'Product status updated. Please check.' Message      
    ,NULL id      
  END      
 END -- enable/disable product         
      
 IF @flag = 'gtc' -- get cashback per product/agentid        
 BEGIN      
  SELECT m.product_id      
   ,m.product_label      
   ,ad.agent_id      
   ,cd.commission_value      
   ,cd.commission_type      
  FROM tbl_manage_services m with (nolock)     
  RIGHT OUTER JOIN tbl_commission_category_detail cd with (nolock) ON cd.product_id = m.product_id      
  LEFT JOIN tbl_agent_detail ad with (nolock) ON ad.agent_commission_id = cd.com_category_id      
  LEFT JOIN tbl_user_detail u with (nolock) ON u.agent_id = ad.agent_id      
  WHERE ad.agent_id = @agent_id and isnull(m.is_deleted,'y') = 'n'       
  GROUP BY m.product_id      
   ,m.product_label      
   ,ad.agent_id      
   ,cd.commission_value      
   ,cd.commission_type      
 END      
END TRY      
      
BEGIN CATCH      
 IF @@trancount > 0      
  ROLLBACK TRANSACTION;      
      
 SELECT 1 code      
  ,error_message() message      
  ,NULL id;      
END CATCH;      
      
