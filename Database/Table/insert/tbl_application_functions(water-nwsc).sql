select * from tbl_manage_services where product_type='water'



select * from tbl_static_data where sdata_type_id='18'  and static_data_label='water'

--change the product type id as from tbl_static_data(static_data_value)

update tbl_manage_services set product_type_id='7' where product_type='water'

update tbl_static_data set static_data_description='WATER PRODUCTS',additional_value1='/client/Nwscbillpayment/NwscBillInquiry' where sdata_type_id='18' and static_Data_label='water' 


--menu_url='/Client/Home/Index'
[sproc_applicationFunc_mgmt] @flag='i',@function_name='Nwsc Bill Inquery',@parent_menu_id='98' ,@function_url='/client/Nwscbillpayment/NwscBillInquiry'

[sproc_applicationFunc_mgmt] @flag='i',@function_name='Nwsc Bill Payment',@parent_menu_id='98' ,@function_url='/client/Nwscbillpayment/NwscBillpayment'

[sproc_applicationFunc_mgmt] @flag='i',@function_name='Nwsc ResultPage',@parent_menu_id='98' ,@function_url='/client/Nwscbillpayment/ResultPage'


--NEA RESULT page

[sproc_applicationFunc_mgmt] @flag='i',@function_name='NEA ResultPage',@parent_menu_id='98' ,@function_url='/client/NEAbillpayment/ResultPage'

