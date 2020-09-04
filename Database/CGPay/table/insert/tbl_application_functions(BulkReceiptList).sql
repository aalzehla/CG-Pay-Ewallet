select * from tbl_menus where menu_url='/Client/BulkUpload/Index' and menu_name='Bulk Upload'

insert into tbl_application_functions(parent_menu_id,function_name,function_Url,created_UTC_date,created_local_date,created_by)
values('140','View Receipt List','/Client/BulkUpload/BulkTopUpReceiptList',GETUTCDATE(),GETDATE(),'System')
