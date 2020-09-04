-- =============================================                
-- Author:  <Author,,Name>                
-- Create date: <Create Date,,>                
-- Description: <Description,,>    
-- sproc_role_management.sql
-- =============================================                
CREATE
	OR
ALTER PROCEDURE [dbo].[sproc_role_management] @flag CHAR(33)
	,@role_id INT = NULL
	,@name VARCHAR(50) = NULL
	,@role_type VARCHAR(255) = NULL
	,@user VARCHAR(50) = NULL
	,@action_ip_address VARCHAR(20) = NULL
	,@roles VARCHAR(max) = NULL
	,@menuid VARCHAR(255) = NULL
	,@function_role XML = NULL
	,@user_name VARCHAR(255) = NULL
	,@id INT = NULL
	,@functions VARCHAR(max) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from                
	-- interfering with SELECT statements.                
	SET NOCOUNT ON;

	DECLARE @str_sql VARCHAR(1000)

	IF @flag = 's'
	BEGIN
		IF @role_id IS NOT NULL
		BEGIN
			SELECT *
			FROM tbl_roles
			WHERE role_id = @role_id

			RETURN
		END

		SELECT *
		FROM tbl_roles
		ORDER BY role_name ASC

		RETURN
	END --select roles from roles table                

	IF @flag = 'i'
	BEGIN
		IF NOT EXISTS (
				SELECT 'x'
				FROM tbl_roles
				WHERE role_name = @name
				)
		BEGIN
			INSERT INTO [dbo].[tbl_roles] (
				role_name
				,role_type
				,created_by
				,created_local_date
				,created_UTC_date
				,created_nepali_date
				,created_ip
				)
			VALUES (
				@name
				,@role_type
				,@user
				,GETDATE()
				,GETUTCDATE()
				,dbo.func_get_nepali_date(DEFAULT)
				,@action_ip_address
				)

			SELECT '0' status_code
				,'Successfully created new role' message

			RETURN
		END
		ELSE
		BEGIN
			SELECT '1' status_code
				,'Role Already Exist' message

			RETURN
		END
	END -- insert new roles                

	IF @flag = 'getMenuList'
	BEGIN
		IF EXISTS (
				SELECT 'x'
				FROM tbl_roles
				WHERE role_id = @role_id
					AND role_type IN (
						'WalletUser'
						,'Agent'
						,'Sub-Agent'
						)
				)
		BEGIN
			SELECT AM.menu_name AS MenuName
				,AM.menu_id Value
				,AM.parent_group Parent
				,CASE 
					WHEN AUM.function_menu_id IS NULL
						THEN 'n'
					ELSE 'y'
					END STATUS
				,am.menu_url linkurl
			FROM tbl_menus AM
			LEFT JOIN tbl_application_functions_menu AUM ON AUM.menu_id = AM.menu_id
				AND AUM.role_id = @role_id
			WHERE isnull(AM.is_active, 'N') = 'Y'
				AND am.menu_access_category = 'm'
		END
		ELSE IF EXISTS (
				SELECT 'x'
				FROM tbl_roles
				WHERE role_id = @role_id
					AND role_type IN ('Merchant')
				)
		BEGIN
			SELECT AM.menu_name AS MenuName
				,AM.menu_id Value
				,AM.parent_group Parent
				,CASE 
					WHEN AUM.function_menu_id IS NULL
						THEN 'n'
					ELSE 'y'
					END STATUS
				,am.menu_url linkurl
			FROM tbl_menus AM
			LEFT JOIN tbl_application_functions_menu AUM ON AUM.menu_id = AM.menu_id
				AND AUM.role_id = @role_id
			WHERE isnull(AM.is_active, 'N') = 'Y'
				AND am.menu_access_category = 'p'
		END
		ELSE
		BEGIN
			SELECT AM.menu_name AS MenuName
				,AM.menu_id Value
				,AM.parent_group Parent
				,CASE 
					WHEN AUM.function_menu_id IS NULL
						THEN 'n'
					ELSE 'y'
					END STATUS
				,AM.menu_url linkurl
			FROM tbl_menus AM
			LEFT JOIN tbl_application_functions_menu AUM ON AUM.menu_id = AM.menu_id
				AND AUM.role_id = @role_id
			WHERE isnull(AM.is_active, 'N') = 'Y'
				AND ISNULL(am.menu_access_category, '') not in ('p','m')
		END
				--SELECT sno = m.menu_id,                 
				--                    m.menu_group,                 
				--                    m.parent_group,                 
				--                    m.menu_name menu_name,                 
				--                f.parent_function_id,                 
				--                    f.function_id,                 
				--                    f.function_name function_name,                 
				--                    @role_id  role_id,                 
				--                    haschecked = r.role_id,                 
				--                    m.group_order_postion,                
				--     m.is_active as Status                
				--     --case when r.role_id is null then 'n' else 'y' end Status                
				--             FROM tbl_menus m                
				--                  INNER JOIN tbl_application_functions f ON m.function_id = f.parent_function_id                
				--                  LEFT JOIN                
				--             (                
				--                 SELECT role_id,                 
				--                        function_id                
				--                 FROM tbl_application_functions_role                
				--                 WHERE role_id = @role_id                
				--             ) r ON f.function_id = r.function_id                
				--             WHERE ISNULL(m.is_active, 'y') = 'y'                
				--             ORDER BY m.parent_group,                 
				--                      m.group_order_postion;                
	END

	IF @flag = 'getFunctionListLogIn'
	BEGIN
		SELECT DISTINCT AM.menu_name AS MenuName
			,AM.menu_id Value
			,AM.parent_group Parent
			,'y' STATUS
			,af.function_Url linkurl
		FROM tbl_menus AM
		JOIN tbl_application_functions af ON af.parent_menu_id = am.menu_id
		JOIN tbl_application_functions_role afr ON afr.function_id = af.function_id
			AND afr.role_id = @role_id
		WHERE isNull(AM.is_active, 'N') = 'Y'
			--SELECT sno = m.menu_id,                 
			--                    m.menu_group,                 
			--        m.parent_group,                 
			--                    m.menu_name menu_name,                 
			--                    f.parent_function_id,                 
			--                    f.function_id,                 
			--                    f.function_name function_name,                 
			--                    @role_id  role_id,                 
			--                    haschecked = r.role_id,                 
			--                    m.group_order_postion,                
			--     m.is_active as Status                
			--     --case when r.role_id is null then 'n' else 'y' end Status                
			--             FROM tbl_menus m                
			--                  INNER JOIN tbl_application_functions f ON m.function_id = f.parent_function_id                
			--                  LEFT JOIN                
			--             (                
			--                 SELECT role_id,                 
			--                        function_id                
			--                 FROM tbl_application_functions_role                
			--                 WHERE role_id = @role_id                
			--             ) r ON f.function_id = r.function_id                
			--             WHERE ISNULL(m.is_active, 'y') = 'y'                
			--             ORDER BY m.parent_group,                 
			--                      m.group_order_postion;                
	END

	IF @flag = 'assignMenu'
	BEGIN
		DELETE
		FROM tbl_application_functions_menu
		WHERE Role_id = @role_id

		SET @str_sql = 'insert into tbl_application_functions_menu(Role_id,menu_id,Created_by,Created_local_Date, created_UTC_date, created_Nepali_Date)                 
  Select ' + cast(@role_id AS VARCHAR) + ',menu_id,''' + @user + ''',GETDATE(),GETUTCDATE(),dbo.func_get_nepali_date(default) from tbl_menus where menu_id in (' + @roles + ')'

		PRINT @str_sql

		EXEC (@str_sql)

		DELETE
		FROM tbl_application_functions_role
		WHERE role_id = @role_id
			AND function_id NOT IN (
				SELECT af.function_id
				FROM tbl_application_functions_menu afm
				JOIN tbl_application_functions af ON af.parent_menu_id = afm.menu_id
				WHERE role_id = @role_id
				)

		SELECT '0' code
			,'Success' message
	END

	IF @flag = 'getfunctions'
	BEGIN
		--SELECT @user = user_name                
		--FROM tbl_user_detail WITH(NOLOCK)                
		--WHERE user_id = @id;                
		--SELECT @role_id = role_id                
		--FROM tbl_user_role WITH(NOLOCK)                
		--WHERE user_id = @user;                
		--SELECT username = @user_name,                 
		--       roleid = @role_id;                
		SELECT AF.Function_Name AS FunctionName
			,AF.function_id Value
			,AM.Menu_Name Parent
			,am.menu_group
			,CASE 
				WHEN AFU.function_role_id IS NULL
					THEN 'n'
				ELSE 'y'
				END STATUS
		FROM tbl_application_functions AF
		JOIN tbl_menus AM ON AM.menu_id = AF.parent_menu_id
		JOIN tbl_application_functions_menu afm ON am.menu_id = afm.menu_id
		LEFT JOIN tbl_application_functions_role AFU ON AFU.Function_ID = AF.function_id
			AND AFU.role_id = afm.role_id
		WHERE afm.role_id = @role_id
		ORDER BY menu_group
	END;

	IF @flag = 'assignfunctions'
	BEGIN
		IF @user IS NULL
		BEGIN
			EXEC sproc_error_handler @error_code = '1'
				,@msg = 'user cannot be blank'
				,@id = NULL;

			RETURN;
		END;

		--set @userid = @rolename                      
		--first delte the previous roles                
		DELETE
		FROM tbl_application_functions_role
		WHERE role_id = @role_id

		--insert the new role                
		SET @str_sql = 'INSERT INTO tbl_application_functions_role                
       (function_id,                 
                 role_id,                 
                 created_by,                 
     created_local_date,                
                 created_UTC_date,                
     created_nepali_date                
                )                
                Select function_id, ' + cast(@role_id AS VARCHAR) + ',''' + @user + ''',GETDATE(),GETUTCDATE(),dbo.func_get_nepali_date(default) from tbl_application_functions where function_id in (' + @functions + ')'

		PRINT (@str_sql)

		EXEC (@str_sql)

		EXEC sproc_error_handler @error_code = '0'
			,@msg = 'role assigned successfully'
			,@id = NULL;

		RETURN;
	END;
END
