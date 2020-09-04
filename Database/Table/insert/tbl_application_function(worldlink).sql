

update tbl_manage_services set product_url='/Client/WorldLinkBillPayment/WlinkBillInquiry' where product_id='29'

--select * from tbl_application_functions order by 1 desc
--select * from tbl_menus where menu_url='/Client/Home/Index'

[sproc_applicationFunc_mgmt] @flag='i',@function_name='WorldLink Bill Inquiry',@parent_menu_id='98',@function_url='/Client/WorldLinkBillPayment/WlinkBillInquiry'


[sproc_applicationFunc_mgmt] @flag='i',@function_name='WorldLink Bill Payment',@parent_menu_id='98',@function_url='/Client/WorldLinkBillPayment/WlinkBillPayment'

[sproc_applicationFunc_mgmt] @flag='i',@function_name='WorldLink Result Page',@parent_menu_id='98',@function_url='/Client/WorldLinkBillPayment/Resultpage'

