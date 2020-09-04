
-- Menu_name 'Bulk Upload', Menu url '/Client/BulkUpload/Index'
sproc_applicationFunc_mgmt @flag='i',@function_name='Bulk Upload Form',@parent_menu_id='140',@function_url='/Client/BulkUpload/Index'
go

sproc_applicationFunc_mgmt @flag='i',@function_name='Bulk Upload',@parent_menu_id='140',@function_url='/Client/BulkUpload/BulkUpload'
go

sproc_applicationFunc_mgmt @flag='i',@function_name='Bulk Data List',@parent_menu_id='140',@function_url='/Client/BulkUpload/GetErrorDataList'
go

sproc_applicationFunc_mgmt @flag='i',@function_name='Bulk Data Detail',@parent_menu_id='140',@function_url='/Client/BulkUpload/GetErrorDetail'
go

sproc_applicationFunc_mgmt @flag='i',@function_name='Bulk Top UP',@parent_menu_id='140',@function_url='/Client/BulkUpload/BulkTopUp'
go