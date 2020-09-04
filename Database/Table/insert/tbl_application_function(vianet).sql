
select * from tbl_menus
update tbl_manage_services set product_url='/Client/VianetBillPayment/VianetBillInquiry' where product_id='33'

--select * from tbl_application_functions order by 1 desc
--select * from tbl_menus where menu_url='/Client/Home/Index'
[sproc_applicationFunc_mgmt] @flag='i',@function_name='Vianet Bill Inquiry',@parent_menu_id='98',@function_url='/Client/VianetBillPayment/VianetBillInquiry'


[sproc_applicationFunc_mgmt] @flag='i',@function_name='Vianet Bill Payment',@parent_menu_id='98',@function_url='/Client/VianetBillPayment/VianetBillPayment'

[sproc_applicationFunc_mgmt] @flag='i',@function_name='Vianet Result Page',@parent_menu_id='98',@function_url='/Client/VianetBillPayment/Resultpage'