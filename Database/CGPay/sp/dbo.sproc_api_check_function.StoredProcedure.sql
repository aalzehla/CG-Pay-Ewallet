USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_api_check_function]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  <Developer>  
-- Create date: 2020-05-08  
-- Description: Check Api Function  
-- =============================================    
CREATE PROCEDURE [dbo].[sproc_api_check_function] @functionCode VARCHAR(30)  
 ,@user_login_id VARCHAR(50)=null
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;  
  
 if exists(select 'x' from tbl_Api_List where code=@functionCode and Status='y')  
 BEGIN  
  SELECT '0' code  
   ,'Success' message  
  
  RETURN  
 END  
  
 SELECT '1' code  
  ,'Api Function Not Found' message  
  
 RETURN  
END  


GO
