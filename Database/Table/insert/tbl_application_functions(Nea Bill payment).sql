[sproc_applicationFunc_mgmt] @flag='i',@function_name='Nea Bill Inquiry',@parent_menu_id='98',@function_url='/client/payment/NeaBillInquiry'


[sproc_applicationFunc_mgmt] @flag='i',@function_name='Nea Bill Payment',@parent_menu_id='98',@function_url='/client/payment/NeaBillPayment'


go


update tbl_manage_services set min_denomination_amount=0.00 , max_denomination_amount=5000 where product_id=26


insert into tbl_menus select 'NEA Bill Payment','/Client/Payment/NeaBillInquiry' , 'Client Dashboard' , 'Client', '1', '100', 'icon-sun3', 'y',GetUTCDATE(), getdate(), dbo.func_get_nepali_date(DEFAULT), 'system','','M',''

