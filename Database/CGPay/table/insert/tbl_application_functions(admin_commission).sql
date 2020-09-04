-- Admin Commission Report(menu name) ,/Admin/Admincommission/Index(menu url)
sproc_applicationFunc_mgmt @flag='i',@function_name='Admin Commission Report',@parent_menu_id='150',@function_url='/Admin/AdminCommission/Index'
go

sproc_applicationFunc_mgmt @flag='i',@function_name='Report Detail List',@parent_menu_id='150',@function_url='/Admin/AdminCommission/ViewReportDetailList'
go

sproc_applicationFunc_mgmt @flag='i',@function_name='View Detail Report',@parent_menu_id='150',@function_url='/Admin/AdminCommission/ViewReportDetail'
go

--select * from tbl_menus where menu_name='Bulk Upload' and menu_url='/Client/BulkUpload/Index'

sproc_applicationFunc_mgmt @flag='i',@function_name='Clear Bulk List',@parent_menu_id='140',@function_url='/Client/BulkUpload/ClearBulkData'
go
