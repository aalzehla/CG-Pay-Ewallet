USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_get_menu]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE
	

 PROC [dbo].[sproc_get_menu] @flag VARCHAR(10) = NULL
	,@user_name VARCHAR(50) = NULL
AS
IF @flag = 'menu'
BEGIN
	CREATE TABLE #temp (
		MenuName VARCHAR(200)
		,linkPage VARCHAR(500)
		,MenuGroup VARCHAR(200)
		,ParentGroup VARCHAR(200)
		,Class VARCHAR(200)
		,group_order_postion VARCHAR(200)
		,menu_order_position VARCHAR(200)
		)

	CREATE TABLE #temp2 (function_id INT)

	IF LOWER(@user_name) IN (
			'admin'
			,'superadmin'
			)
	BEGIN
		INSERT INTO #temp
		SELECT m.menu_name MenuName
			,linkPage = m.menu_url
			,m.menu_group MenuGroup
			,m.parent_group ParentGroup
			,m.css_Class Class
			,m.group_order_postion
			,m.menu_order_position
		FROM tbl_menus m(NOLOCK)
		WHERE ISNULL(m.is_active, 'y') = 'y'
			AND ISNULL(menu_access_category, '') NOT IN (
				'd'
				,'m'
				,'p'
				)

		INSERT INTO #temp2
		SELECT function_id
		FROM tbl_application_functions(NOLOCK)
		WHERE parent_menu_id NOT IN (
				SELECT function_id
				FROM tbl_menus m(NOLOCK)
				WHERE ISNULL(m.is_active, 'y') = 'y'
					AND ISNULL(menu_access_category, '') IN (
						'd'
						,'m'
						,'p'
						)
				);
	END;
	ELSE IF EXISTS (
			SELECT *
			FROM tbl_user_detail
			WHERE (
					user_name = @user_name
					OR user_mobile_no = @user_name
					OR user_email = @user_name
					)
				AND usr_type IN (
					'gateway'
					,'walletUser'
					,'agent'
					,'sub-agent'
					,'merchant'
					)
			)
	BEGIN
		INSERT INTO #temp
		SELECT m.menu_name MenuName
			,linkPage = m.menu_url
			,m.menu_group MenuGroup
			,m.parent_group ParentGroup
			,m.css_Class Class
			,m.group_order_postion
			,m.menu_order_position
		FROM tbl_menus m(NOLOCK)
		JOIN (
			SELECT afm.menu_id
			FROM tbl_user_detail ud
			JOIN tbl_application_functions_menu afm ON afm.role_id = ud.role_id
			LEFT JOIN tbl_application_functions_role f ON f.role_id = ud.role_id
			LEFT JOIN tbl_application_functions a ON a.function_id = f.function_id
			WHERE (
					ud.user_name = @user_name
					OR ud.user_mobile_no = @user_name
					OR ud.user_email = @user_name
					)
			GROUP BY afm.menu_id
			) x ON x.menu_id = m.menu_id
		WHERE ISNULL(m.is_active, 'y') = 'y'
			AND ISNULL(menu_access_category, '') IN (
				'm'
				,'p'
				)

		INSERT INTO #temp2
		SELECT f.function_id
		FROM tbl_application_functions f(NOLOCK)
		LEFT JOIN tbl_application_functions_role ar(NOLOCK) ON ar.function_id = f.function_id
		LEFT JOIN tbl_user_role r(NOLOCK) ON r.role_id = ar.role_id
		WHERE r.user_id = @user_name
			AND parent_menu_id IN (
				SELECT function_id
				FROM tbl_menus m(NOLOCK)
				WHERE ISNULL(m.is_active, 'y') = 'y'
					AND ISNULL(menu_access_category, '') IN (
						'm'
						,'p'
						)
				);
	END;
	ELSE
	BEGIN
		INSERT INTO #temp
		SELECT  m.menu_name MenuName
			,linkPage = m.menu_url
			,m.menu_group MenuGroup
			,m.parent_group ParentGroup
			,m.css_Class Class
			,m.group_order_postion
			,m.menu_order_position
		FROM tbl_menus m(NOLOCK)
		JOIN (
			SELECT afm.menu_id
			FROM tbl_user_detail ud
			JOIN tbl_application_functions_menu afm ON afm.role_id = ud.role_id
			LEFT JOIN tbl_application_functions_role f ON f.role_id = ud.role_id
			LEFT JOIN tbl_application_functions a ON a.function_id = f.function_id
			WHERE (
					ud.user_name = @user_name
					OR ud.user_mobile_no = @user_name
					OR ud.user_email = @user_name
					)
			) x ON x.menu_id = m.menu_id
		WHERE ISNULL(m.is_active, 'y') = 'y'
			AND ISNULL(menu_access_category, '') NOT IN (
				'm'
				,'p'
				)

		INSERT INTO #temp2
		SELECT f.function_id
		FROM tbl_application_functions f(NOLOCK)
		LEFT JOIN tbl_application_functions_role ar(NOLOCK) ON ar.function_id = f.function_id
		LEFT JOIN tbl_user_role r(NOLOCK) ON r.role_id = ar.role_id
		WHERE r.user_id = @user_name
			AND parent_menu_id IN (
				SELECT function_id
				FROM tbl_menus m(NOLOCK)
				WHERE ISNULL(m.is_active, 'y') = 'y'
					AND ISNULL(menu_access_category, '') NOT IN (
						'm'
						,'p'
						)
				);
	END;

	SELECT distinct *
	FROM #temp m with(nolock)
	ORDER BY m.group_order_postion
		,m.menu_order_position
		,m.ParentGroup;

	SELECT m.*
	FROM #temp2 m;

	DROP TABLE #temp;

	DROP TABLE #temp2;
END;


GO
