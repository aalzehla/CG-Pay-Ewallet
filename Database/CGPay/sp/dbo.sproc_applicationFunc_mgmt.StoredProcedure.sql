USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_applicationFunc_mgmt]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE     PROCEDURE [dbo].[sproc_applicationFunc_mgmt] @flag CHAR(3) = NULL
	,@function_id VARCHAR(20) = NULL
	,@parent_menu_id INT = NULL
	,@function_url VARCHAR(520) = NULL
	,@function_name VARCHAR(100) = NULL
	,@action_user_id VARCHAR(20) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from  
	-- interfering with SELECT statements.  
	SET NOCOUNT ON;

	IF @flag = 'i'
	BEGIN
		--IF NOT EXISTS (
		--		SELECT 'x'
		--		FROM tbl_user_detail
		--		WHERE user_id = @action_user_id
		--			AND usr_type_id = 1
		--		)
		--BEGIN
		--	SELECT '1' code
		--		,'Un-Authorised User' message
		--		,NULL id

		--	RETURN
		--END
		--ELSE
		BEGIN
			INSERT INTO tbl_application_functions (
				--function_id
				function_name
				,parent_menu_id
				,function_Url
				,created_by
				,created_local_date
				,created_UTC_Date
				,created_nepali_date
				)
			VALUES (
				--@function_id
				@function_name
				,@parent_menu_id
				,@function_Url
				,'System'
				,getdate()
				,GetUTCDATE()
				,dbo.func_get_nepali_date(DEFAULT)
				)
					
		Select '0' code, 'Menu URL inserted succesfully' message, null id
		return
	
		END
	END
END


GO
