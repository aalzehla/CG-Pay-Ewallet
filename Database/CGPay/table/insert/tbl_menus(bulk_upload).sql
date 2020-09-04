insert into tbl_menus(menu_name,menu_url,menu_group,parent_group,menu_order_position,group_order_postion,css_class,is_active,created_UTC_date,created_local_date,created_by,menu_access_category)
values('Bulk Upload','/Client/BulkUpload/Index','Client Dashboard','Client',3,100,'icon-file-upload2','Y',GETUTCDATE(),GETDATE(),'System','M')


insert into tbl_menus (menu_name,menu_url,menu_group,parent_group,menu_order_position,group_order_postion,css_class,is_active,created_UTC_date,created_local_date,created_by,menu_access_category)
values 
('Agent','/Client/walletbalance/balancetransfer','Agent','Load Balance',1,10,'icon-cash4','Y',GETUTCDATE(),GETDATE(),'system','M')
,('Customer','/Client/loadBalance','Customer','Load Balance',2,10,'icon-cash4','Y',GETUTCDATE(),GETDATE(),'system','M')