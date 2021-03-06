USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_role]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[sproc_role] @flag          VARCHAR(20), 
                               @id            varchar(max)       = NULL, 
                               @user_name     VARCHAR(30)  = NULL, 
                               @user_id       VARCHAR(100)          = NULL, 
                               @role_name     VARCHAR(50)  = NULL, 
                               @role_id       INT          = NULL, 
                               @is_active     CHAR(1)      = NULL, 
                               @function_role XML          = NULL, 
                               @add_id        VARCHAR(500) = NULL, 
                               @delete_id     VARCHAR(500) = NULL, 
                               @user          VARCHAR(50)  = NULL, 
                               @search        VARCHAR(50)  = NULL, 
                               @page_size     VARCHAR(5)   = 10
AS
     SET NOCOUNT ON;
    BEGIN TRY
        IF @flag = 'i'
            BEGIN
                IF NOT EXISTS
                (
                    SELECT 'x'
                    FROM tbl_roles
                    WHERE role_name = @role_name
                )
                    BEGIN
                        INSERT INTO tbl_roles
                        (role_name, 
                         role_status, 
                         created_by, 
                         created_local_date, 
                         created_nepali_date, 
                         created_UTC_date
                        )
                               SELECT ltrim(@role_name), 
                                      @is_active, 
                                      @user, 
                                      GETDATE(), 
                                      dbo.func_get_nepali_date(DEFAULT), 
                                      GETUTCDATE();
                        SELECT '0' status_code, 
                               'Role added successfully' message, 
                               NULL id;
                        RETURN;
                END;
                    ELSE
                    BEGIN
                        EXEC sproc_error_handler 
                             @error_code = '1', 
                             @msg = 'Role already exists', 
                             @id = NULL;
                        RETURN;
                END;
        END;
        IF @flag = 'u'
            BEGIN
                IF EXISTS
                (
                    SELECT 'x'
                    FROM tbl_roles
                    WHERE role_id = @role_id
                )
                    BEGIN
                        UPDATE tbl_roles
                          SET 
                              role_name = ISNULL(@role_name, role_name), 
                              role_status = ISNULL(@is_active, role_status), 
                              created_by = ISNULL(@user, created_by), 
                              created_nepali_date = ISNULL(dbo.func_get_nepali_date(DEFAULT), created_nepali_date), 
                              created_local_date = ISNULL(GETDATE(), created_local_date), 
                              created_UTC_date = ISNULL(GETUTCDATE(), created_UTC_date)
                        WHERE role_id = @id;
                        EXEC sproc_error_handler 
                             @error_code = '0', 
                             @msg = 'Role updated successfully', 
                             @id = NULL;
                        RETURN;
                END;
                    ELSE
                    BEGIN
                        EXEC sproc_error_handler 
                             @error_code = '1', 
                             @msg = 'Role Id doesn''t successfully', 
                             @id = NULL;
                END;
        END;
        IF @flag = 'a'
            BEGIN
                DECLARE @sql VARCHAR(MAX);
                SET @sql = '      
 select top ' + @page_size + ' *      
 from tbl_roles r (nolock) where 1=1 ';
                IF @user not in ('superadmin' ,'admin')
                    BEGIN
                        SET @sql+=' and r.created_by=''' + @user + ''' ';
                END;
                IF @search IS NOT NULL
                    SET @sql+=' and name like ''' + @search + '%''';
					print (@sql)
                EXEC (@sql);
                RETURN;
        END;
        IF @flag = 's'
            BEGIN
                IF @role_id IS NOT NULL
                    BEGIN
                        SELECT *
                        FROM tbl_roles(NOLOCK)
                        WHERE role_id = @id;
                        RETURN;
                END;
                    ELSE
                    BEGIN
                        SELECT *
                        FROM tbl_roles(NOLOCK);
                        RETURN;
                END;
        END;
        IF @flag = 'd'
            BEGIN
                IF EXISTS
                (
                    SELECT 'x'
                    FROM tbl_user_detail
                    WHERE role_id = @role_id
                )
                    BEGIN
                        SELECT '1' status_code, 
                               'Can''t Delete Role, it is assigned to User.Please check' message;
                        RETURN;
                END;
                DELETE FROM tbl_roles
                WHERE role_id = @role_id;
                SELECT '0' status_code, 
                       'Success' message;
                RETURN;
        END;
        IF @flag = 'getassignlist'
            BEGIN
                SELECT sno = m.menu_id, 
                       m.menu_group, 
                       m.parent_group, 
                       m.menu_name menu_name, 
                       f.parent_menu_id, 
                       f.function_id, 
                       f.function_name function_name, 
                       @id role_id, 
                       haschecked = r.role_id, 
                       m.group_order_postion
                FROM tbl_menus m
                     INNER JOIN tbl_application_functions f ON m.function_id = f.parent_menu_id
                     LEFT JOIN
                (
                    SELECT role_id, 
                           function_id
                    FROM tbl_application_functions_role
                    WHERE role_id = @id
                ) r ON f.function_id = r.function_id
                WHERE ISNULL(m.is_active, 'y') = 'y'
                ORDER BY m.parent_group, 
                         m.group_order_postion;
        END;
        IF @flag = 'assignrole'
            BEGIN
                DELETE FROM tbl_application_functions_role
                WHERE role_id = @id;
                INSERT INTO tbl_application_functions_role
                (role_id, 
                 function_id, 
                 created_by
                )
                       SELECT @id, 
                              p.t.value('@id', 'varchar(10)') AS functionid, 
                              @user
                       FROM @function_role.nodes('/root/row') AS p(t);
                EXEC sproc_error_handler 
                     @error_code = '0', 
                     @msg = 'role assigned successfully', 
                     @id = NULL;
        END;
        IF @flag = 'getuserrole'
            BEGIN
                SELECT @user_name = user_name
                FROM tbl_user_detail WITH(NOLOCK)
                WHERE user_id = @id;
                SELECT @role_id = role_id
                FROM tbl_user_role WITH(NOLOCK)
                WHERE user_id = @user_name;
                SELECT username = @user_name, 
                       roleid = @role_id;
        END;
        IF @flag = 'assignuserrole'
            BEGIN
                IF @user_name IS NULL
                    BEGIN
                        EXEC sproc_error_handler 
                             @error_code = '1', 
                             @msg = 'user cannot be blank', 
                             @id = NULL;
                        RETURN;
                END;      
                --set @userid = @rolename      

                DELETE tbl_user_role
                WHERE user_id = @user_name;
                INSERT INTO tbl_user_role
                (user_id, 
                 role_id, 
                 created_by, 
                 created_UTC_date
                )
                       SELECT @user_name, 
                              @id, 
                              @user, 
                              GETUTCDATE();
                EXEC sproc_error_handler 
                     @error_code = '0', 
                     @msg = 'role assigned successfully', 
                     @id = NULL;
                RETURN;
        END;
    END TRY
    BEGIN CATCH
        IF @@trancount > 0
            ROLLBACK TRANSACTION;
        SELECT 1 code, 
               ERROR_MESSAGE() msg, 
               NULL id;
    END CATCH; 


GO
