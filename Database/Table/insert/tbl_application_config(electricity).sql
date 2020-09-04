--electricity
update tbl_static_data set additional_value1='/Client/NeaBillPayment/NeaBillInquiry' where additional_value1='/Client/Payment/NeaBillInquiry' and sdata_type_id='18'

update tbl_application_functions set function_url='/client/NeaBillPayment/NeaBillInquiry' where function_url='/client/payment/NeaBillInquiry'
update tbl_application_functions set function_url='/client/NeaBillPayment/NeaBillPayment' where function_url='/client/payment/NeaBillPayment'


--client dashboard
[sproc_applicationFunc_mgmt] @flag='i',@function_name='NEA GetCharges',@parent_menu_id='98',@function_url='/client/NeaBillPayment/GetCharges'
