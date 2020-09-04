update tbl_menus set menu_group = 'Funding Bank',menu_name = 'Funding Bank Management' where menu_id = 68
update tbl_menus set is_active = 'N' where menu_id = 71
update tbl_menus set menu_group = 'Message Template', menu_name = 'Notification Message Template' where menu_id = 87

insert into tbl_menus(menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class,is_active, parent_menu_id, created_by, created_local_date, created_UTC_date, created_nepali_date)
values('Manage Cards','/admin/Cards/agentCards','Agent Card Management','Setup','1','40','icon-cog3','Y','1','system',GETDATE(),GETUTCDATE(),dbo.func_get_nepali_date(default))