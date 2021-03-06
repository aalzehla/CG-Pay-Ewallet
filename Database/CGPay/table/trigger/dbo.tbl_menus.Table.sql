USE [WePayNepal]
GO
/****** Object:  Trigger [TRG_UPDATE_tbl_menus]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_UPDATE_tbl_menus]
GO
/****** Object:  Trigger [TRG_INSERT_tbl_menus]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_INSERT_tbl_menus]
GO
/****** Object:  Trigger [TRG_DELETE_tbl_menus]    Script Date: 8/8/2020 2:54:42 AM ******/
DROP TRIGGER [dbo].[TRG_DELETE_tbl_menus]
GO

/****** Object:  Trigger [dbo].[TRG_DELETE_tbl_menus]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRG_DELETE_tbl_menus] ON [dbo].[tbl_menus]
FOR DELETE
AS
     BEGIN
         INSERT INTO tbl_menus_audit
         (menu_id, 
          menu_name, 
          menu_url, 
          menu_group, 
          parent_group, 
          menu_order_position, 
          group_order_postion, 
          css_class, 
          is_active, 
          created_UTC_date, 
          created_local_date, 
          created_nepali_date, 
          created_by, 
          function_id, 
          menu_access_category, 
          parent_menu_id, 
          trigger_log_user, 
          trigger_action, 
          trigger_action_local_Date, 
          trigger_action_UTC_Date, 
          trigger_action_nepali_date
         )
                SELECT 
					   menu_id, 
                       menu_name,
					   menu_url, 
                       menu_group, 
                       parent_group, 
                       menu_order_position, 
                       group_order_postion, 
                       css_class, 
                       is_active, 
                       created_UTC_date, 
                       created_local_date, 
                       created_nepali_date, 
                       created_by, 
                       function_id, 
                       menu_access_category, 
                       parent_menu_id, 
                       system_user, 
                       'Delete', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Deleted;
     END;
GO
/****** Object:  Trigger [dbo].[TRG_INSERT_tbl_menus]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRG_INSERT_tbl_menus] ON [dbo].[tbl_menus]
FOR INSERT
AS
     BEGIN
         INSERT INTO tbl_menus_audit
         (menu_id, 
          menu_name, 
          menu_url, 
          menu_group, 
          parent_group, 
          menu_order_position, 
          group_order_postion, 
          css_class, 
          is_active, 
          created_UTC_date, 
          created_local_date, 
          created_nepali_date, 
          created_by, 
          function_id, 
          menu_access_category, 
          parent_menu_id, 
          trigger_log_user, 
          trigger_action, 
          trigger_action_local_Date, 
          trigger_action_UTC_Date, 
          trigger_action_nepali_date
         )
                SELECT 
					   menu_id, 
                       menu_name,
					   menu_url, 
                       menu_group, 
                       parent_group, 
                       menu_order_position, 
                       group_order_postion, 
                       css_class, 
                       is_active, 
                       created_UTC_date, 
                       created_local_date, 
                       created_nepali_date, 
                       created_by, 
                       function_id, 
                       menu_access_category, 
                       parent_menu_id, 
                       system_user, 
                       'Insert', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Inserted;
     END;
GO
/****** Object:  Trigger [dbo].[TRG_UPDATE_tbl_menus]    Script Date: 8/8/2020 2:54:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRG_UPDATE_tbl_menus] ON [dbo].[tbl_menus]
FOR UPDATE
AS
     BEGIN
         INSERT INTO tbl_menus_audit
         (menu_id, 
          menu_name, 
          menu_url, 
          menu_group, 
          parent_group, 
          menu_order_position, 
          group_order_postion, 
          css_class, 
          is_active, 
          created_UTC_date, 
          created_local_date, 
          created_nepali_date, 
          created_by, 
          function_id, 
          menu_access_category, 
          parent_menu_id, 
          trigger_log_user, 
          trigger_action, 
          trigger_action_local_Date, 
          trigger_action_UTC_Date, 
          trigger_action_nepali_date
         )
                SELECT 
					   menu_id, 
                       menu_name,
					   menu_url, 
                       menu_group, 
                       parent_group, 
                       menu_order_position, 
                       group_order_postion, 
                       css_class, 
                       is_active, 
                       created_UTC_date, 
                       created_local_date, 
                       created_nepali_date, 
                       created_by, 
                       function_id, 
                       menu_access_category, 
                       parent_menu_id, 
                       system_user, 
                       'Update', 
                       GETDATE(), 
                       GETUTCDATE(), 
                       dbo.func_get_nepali_date(DEFAULT)
                FROM Inserted;
     END;
GO
