USE [WePayNepal]
GO

/****** Object:  StoredProcedure [dbo].[sproc_commission_detail]    Script Date: 06/05/2020 12:12:59 PM ******/
DROP PROCEDURE [dbo].[sproc_commission_detail]
GO

/****** Object:  StoredProcedure [dbo].[sproc_commission_detail]    Script Date: 06/05/2020 12:12:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[sproc_commission_detail] @flag CHAR(10)  
 ,@comm_category_id INT = NULL  
 ,@comm_category_detail_id INT = NULL  
 ,@comm_category_name VARCHAR(200) = NULL  
 ,@product_id INT = NULL  
 ,@commission_type CHAR(3) = NULL  
 ,@commission_value varchar(20) = NULL  
 ,@commission_percent_type CHAR(3) = NULL  
 ,@created_by VARCHAR(100) = NULL  
 ,@created_ip VARCHAR(100) = NULL  
 ,@updated_by VARCHAR(100) = NULL  
 ,@updated_ip VARCHAR(20) = NULL  
 ,@is_active CHAR(10) = NULL  
 ,@category_for VARCHAR(100) = NULL  
 ,@distributor_id VARCHAR(100) = NULL  
 ,@agent_id INT = NULL  
 ,@agent_type VARCHAR(20) = NULL  
 ,@action_user VARCHAR(50) = NULL  
AS  
SET NOCOUNT ON;  
  
DECLARE @agent_name VARCHAR(100)  
 ,@product_name VARCHAR(50);  
  
BEGIN TRY  
 IF @flag = 'i'  
 BEGIN  
  DECLARE @id_category AS INT  
   ,@total_products INT  
   ,@scommission_type VARCHAR(3)  
   ,@scomm_percent_type CHAR(3);  
  
  SET @id_category = SCOPE_IDENTITY();  
  
  SELECT @scommission_type = static_data_value  
  FROM tbl_static_data  
  WHERE sdata_type_id = 6  
   AND static_data_label = 'percentage'  
  
  SELECT @scomm_percent_type = static_data_value  
  FROM tbl_static_data  
  WHERE sdata_type_id = 6  
   AND static_data_label = 'service charge'  
  
  IF EXISTS (  
    SELECT 'x'  
    FROM tbl_commission_category  
    WHERE category_id = @comm_category_id  
    )  
  BEGIN  
   SELECT '1' code  
    ,'Category already exists' message  
    ,NULL id  
  
   RETURN  
  END  
  ELSE  
  BEGIN  
   IF EXISTS (  
     SELECT 'x'  
     FROM tbl_user_detail  
     WHERE user_id = @agent_id  
      AND @agent_type = usr_type  
      AND usr_type = 'admin'  
     )  
    SET @agent_id = NULL  
  
   INSERT INTO dbo.tbl_commission_category (  
    category_name  
    ,created_by  
    ,created_UTC_date  
    ,created_local_date  
    ,created_nepali_date  
    ,created_ip  
    ,is_active  
    )  
   VALUES (  
    @comm_category_name  
    ,@created_by  
    ,getutcdate()  
    ,getdate()  
    ,[dbo].func_get_nepali_date(DEFAULT)  
    ,@created_ip  
    ,'y'  
    )  
  
   SET @comm_category_id = ident_current('tbl_commission_category')  
  
   DECLARE @counter INT = 0  
  
   SELECT product_id  
    ,product_label  
    ,@@rowcount rows  
   INTO #temp  
   FROM tbl_manage_services  
  
   INSERT INTO tbl_commission_category_detail (  
    com_category_id  
    ,product_id  
    ,commission_type  
    ,commission_value  
    ,commission_percent_type  
    ,created_UTC_date  
    ,created_local_date  
    ,created_nepali_date  
    ,created_by  
    ,created_ip  
    )  
   SELECT @comm_category_id  
    ,product_id  
    ,@scommission_type  
    ,0  
    ,@scomm_percent_type  
    ,getutcdate()  
    ,getdate()  
    ,[dbo].func_get_nepali_date(DEFAULT)  
    ,@created_by  
    ,@created_ip  
   FROM #temp  
  
   SELECT '0' code  
    ,'category successfully inserted' message  
    ,NULL id  
    ,@comm_category_id categoryid  
    ,@comm_category_name categoryname  
  
   RETURN  
  END  
 END;  
  
 IF @flag = 'u'  
 BEGIN  
  IF @comm_category_id IS NULL  
  BEGIN  
   SELECT '1' code  
    ,'category id is null' message  
    ,NULL id  
  
   RETURN  
  END  
  
  IF @comm_category_detail_id IS NULL  
  BEGIN  
   SELECT '1' code  
    ,'category detail id is null' message  
    ,NULL id  
  
   RETURN  
  END  
  
  IF NOT EXISTS (  
    SELECT 'x'  
    FROM tbl_commission_category_detail  
    WHERE com_detail_id = @comm_category_detail_id  
     AND product_id = @product_id  
    )  
  BEGIN  
   SELECT '1' code  
    ,'Selected product Doesnot exist' message  
    ,NULL id  
  
   RETURN  
  END  
  
  IF @product_id IS NULL  
  BEGIN  
   SELECT '1' code  
    ,'product id is null' message  
    ,NULL id  
  
   RETURN  
  END  
  ELSE  
  BEGIN  
   UPDATE [dbo].tbl_commission_category_detail  
   SET commission_type = isnull(@commission_type, commission_type)  
    ,commission_value = isnull(@commission_value, commission_value)  
    ,commission_percent_type = isnull(@commission_percent_type, commission_percent_type)  
    ,updated_by = isnull(@updated_by, updated_by)  
    ,updated_UTC_date = isnull(getutcdate(), updated_UTC_date)  
    ,updated_local_date = isnull(getdate(), updated_local_date)  
    ,updated_nepali_date = isnull([dbo].func_get_nepali_date(DEFAULT), updated_nepali_date)  
    ,updated_ip = isnull(@updated_ip, updated_ip)  
   WHERE product_id = @product_id  
    AND com_detail_id = @comm_category_detail_id  
  END  
  
  SELECT '0' code  
   ,'commission detail updated successfully ' message  
   ,NULL id  
  
  RETURN  
 END  
  
 IF @flag = 'd'  
 BEGIN  
  IF @comm_category_id IS NULL  
  BEGIN  
   SELECT '1' code  
    ,'category is null' message  
    ,NULL id  
  
   RETURN  
  END  
  ELSE  
   UPDATE tbl_commission_category  
   SET is_active = @is_active
    ,updated_by = @updated_by  
    ,updated_local_date = getdate()  
    ,updated_UTC_date = getutcdate()  
    ,updated_nepali_date = [dbo].func_get_nepali_date(DEFAULT)  
   WHERE category_id = @comm_category_id  
  
  SELECT '0' code  
   ,'' message  
   ,NULL id  
 END  
  
 --update the commission of the product for same catagory  
 IF @flag = 'uc'  
 BEGIN  
  UPDATE tbl_commission_category_detail  
  SET commission_type = @commission_type  
   ,commission_value = @commission_value  
   ,updated_UTC_date = cast(getutcdate() AS VARCHAR)  
   ,updated_by = @updated_by  
  WHERE com_detail_id = @comm_category_detail_id  
  
  SELECT @product_name = dm.product_label  
   ,@comm_category_name = dc.category_name  
  FROM tbl_commission_category_detail cd  
  JOIN tbl_manage_services dm ON cd.product_id = dm.product_id  
  JOIN tbl_commission_category dc ON dc.category_id = cd.com_category_id  
  WHERE com_detail_id = @comm_category_detail_id  
  
  SELECT '0' code  
   --,'commission updated successfully for ' + cast(@cdetailid as varchar) message      
   ,'commission value updated successfully for ' + @product_name + ' on ' + @comm_category_name + ' category' message  
   ,NULL id  
  
  RETURN  
 END  
  
 -- select from tbl_commission_category with agent type  
 IF @flag = 'list'  
 BEGIN  
  DECLARE @agent_id_name VARCHAR(50)  
  
  SET @agent_id_name = (  
    SELECT TOP 1 ud.usr_type  
    FROM tbl_user_detail ud  
    LEFT JOIN tbl_agent_detail ad ON ad.agent_id = ud.agent_id  
    WHERE CASE   
      WHEN isnull(ud.usr_type, 'admin') = 'admin'  
       THEN user_id  
      ELSE ud.agent_id  
      END = @agent_id  
     AND @agent_type = ud.usr_type  
    )  
  
  DECLARE @sql VARCHAR(max) = '';  
  
  --SELECT *  
  --FROM tbl_commission_category  
  SET @sql += ' select category_id, '  
  SET @sql += ' category_name, '  
  SET @sql += ' created_by, '  
  SET @sql += ' created_UTC_date, '  
  SET @sql += ' created_local_date, '  
  SET @sql += ' is_active '  
  SET @sql += ' from tbl_commission_category(nolock) '  
  
  IF (@agent_id_name != 'admin')  
   SET @sql += ' where created_by in (''' + cast(@agent_id AS VARCHAR) + ''') '  
  
  --ELSE  
  -- SET @sql += ' where created_by is null '  
  PRINT (@sql)  
  
  EXEC (@sql)  
  
  RETURN;  
 END  
  
 -- select from tbl_commission_category by catagory id  
 IF @flag = 'lsbyid'  
 BEGIN  
  SELECT dc.category_id  
   ,category_name  
   ,created_by  
   ,dc.created_UTC_date  
   ,dc.created_local_date  
   ,dc.created_ip  
   ,is_active  
  --dcd.cdetailid,dcd.productid        
  FROM tbl_commission_category dc  
  --inner join dtacommissioncategorydetail dcd on dc.categoryid= dcd.categoryid        
  WHERE dc.category_id = @comm_category_id  
 END  
  
 --select the product list mapping with category and category details  
 IF @flag = 'cid'  
 BEGIN  
  SELECT com_category_id  
   ,ms.product_id  
   ,ccd.com_detail_id  
   ,ms.product_label  
   ,commission_type  
   ,commission_value  
   ,sd.static_data_label commission_percent_type  
   ,ccd.created_local_date  
   ,ccd.created_by  
  FROM tbl_commission_category_detail ccd  
  RIGHT JOIN tbl_manage_services ms ON ms.product_id = ccd.product_id  
  left join tbl_static_data sd on sdata_type_id='6' and commission_percent_type=sd.static_data_value  
  WHERE ccd.com_category_id = @comm_category_id  
  
  RETURN  
 END  
  
 -- tbl_commission_category  
 IF @flag = 'ddl'  
 BEGIN  
  SET @agent_id_name = (  
    SELECT TOP 1 ud.usr_type  
    FROM tbl_user_detail ud  
    LEFT JOIN tbl_agent_detail ad ON ad.agent_id = ud.agent_id  
    WHERE CASE   
      WHEN isnull(ud.usr_type, 'admin') = 'admin'  
       THEN user_id  
      ELSE ud.agent_id  
      END = @agent_id  
     AND @agent_type = ud.usr_type  
    )  
  
  IF (@agent_id_name = 'admin')  
  BEGIN  
   SELECT category_id  
    ,category_name  
   FROM tbl_commission_category  
   WHERE isnull(is_active, 'n') = 'y'  
    AND created_by IS NULL  
  
   RETURN;  
  END  
  ELSE  
  BEGIN  
   SELECT category_id  
    ,category_name  
   FROM tbl_commission_category  
   WHERE created_by = @agent_id  
    AND isnull(is_active, 'n') = 'y'  
  
   RETURN;  
  END  
 END  
  
 -- tbl_agent_detail,tbl_commission_category  
 IF @flag = 's'  
 BEGIN  
  SET @agent_id_name = (  
    SELECT TOP 1 usr_type  
    FROM tbl_user_detail  
    WHERE CASE   
      WHEN isnull(usr_type, 'admin') = 'admin'  
       THEN user_id  
      ELSE agent_id  
      END = @agent_id  
     AND @agent_type = usr_type  
    )  
  SET @sql = ''  
  SET @sql += 'select agent_commission_id as categoryid, cc.category_name as name,agent_type ,agent_id as distributorid, ad.agent_name as distributorname '  
  SET @sql += 'from tbl_agent_detail ad '  
  SET @sql += 'left join tbl_commission_category cc on ad.agent_commission_id= cc.category_id where 1=1'  
  
  IF (@agent_id_name != 'admin')  
   SET @sql += ' and ad.parent_id=''' + cast(@agent_id AS VARCHAR) + ''''  
  
  IF @agent_type = 'admin'  
   SET @sql += ' and  ad.agent_type in(''distributor'',''Agent'',''merchant'') and ad.parent_id is null'  

  ELSE IF @agent_type = 'distributor'  
   SET @sql += ' and ad.agent_type in(''sub-distributor'',''merchant'',''Agent'')'  
  ELSE IF @agent_type = 'subdistributor'  
   SET @sql += ' and ad.agent_type in (''merchant'',''Agent'')'  
    ELSE IF @agent_type = 'Agent'  
   SET @sql += ' and ad.agent_type in (''merchant'',''sub-Agent'')'  
       ELSE IF @agent_type = 'sub-Agent'  
   SET @sql += ' and ad.agent_type=''merchant'''  
  PRINT (@sql)  
  
  EXEC (@sql)  
  
  RETURN;  
 END  
  
 if @flag='sid'  
 BEGIN  
  select agent_id,Agent_Name,agent_commission_id from tbl_agent_detail where agent_id=@distributor_id  
  
  RETURN;  
 END  
  
  
 --tbl_commission_category_detail  
 IF @flag = 'scp'  
 BEGIN  
  SELECT com_detail_id  
   ,com_category_id  
   ,product_id  
   ,commission_type  
   ,commission_value  
   ,commission_percent_type  
  FROM tbl_commission_category_detail  
  WHERE com_detail_id = @comm_category_detail_id  
 END  
  
 --tbl_agent_detail  
 IF @flag = 'com_u'  
 BEGIN  
  UPDATE tbl_agent_detail  
  SET agent_commission_id = @comm_category_id  
   ,updated_UTC_date = getutcdate()  
   ,updated_by = @updated_by  
  WHERE agent_id = @distributor_id  
  
  SELECT @agent_name = first_name  
  FROM tbl_agent_detail  
  WHERE agent_id = @distributor_id  
  
  SELECT '0' code  
   ,' commision updated succesfully for agent: ' + @agent_name message  
   ,NULL id  
  
  RETURN  
 END  
   -- update agent detail table  
END TRY  
  
BEGIN CATCH  
 IF @@trancount > 0  
  ROLLBACK TRANSACTION  
  
 SELECT 1 code  
  ,error_message() message  
  ,NULL id  
END CATCH  
GO


