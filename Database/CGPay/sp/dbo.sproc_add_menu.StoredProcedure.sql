USE [Wepaynepal]
GO
/****** Object:  StoredProcedure [dbo].[sproc_add_menu]    Script Date: 8/8/2020 2:32:06 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[sproc_add_menu] @function_Id    VARCHAR(8), 
                                   @menu_name      VARCHAR(50), 
                                   @link_page      VARCHAR(255), 
                                   @menu_group     VARCHAR(50), 
                                   @position       INT, 
                                   @is_active      CHAR(1), 
                                   @group_position INT, 
                                   @parent_group   VARCHAR(50)  = NULL, 
                                   @class          VARCHAR(50)  = NULL
AS
     IF NOT EXISTS
     (
         SELECT 'X'
         FROM tbl_menus
         WHERE function_id = @function_Id
     )
         BEGIN
             INSERT INTO tbl_menus
             (function_id, 
              menu_name, 
              menu_url, 
              menu_group, 
              menu_order_position, 
              is_active, 
              group_order_postion, 
              parent_group, 
              css_class, 
              created_local_date, 
			  created_UTC_date,
			  created_nepali_date,
              created_by
             )
                    SELECT @function_Id, 
                           @menu_name, 
                           @link_page, 
                           @menu_group, 
                           @position, 
                           @is_active, 
                           @group_position, 
                           @parent_group, 
                           @class, 
						   GETDATE(),
                           GETUTCDATE(), 
						   null,
                           'system';
             PRINT @menu_name + ' menu added.';
     END;


GO
