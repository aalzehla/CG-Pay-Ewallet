[sproc_applicationFunc_mgmt] @flag='i',@function_name='Check Denomination',@parent_menu_id='72',@function_url='/Client/Payment/CheckDenomination'

update tbl_manage_services set min_denomination_amount=100,max_denomination_amount=5000 where product_id='15'