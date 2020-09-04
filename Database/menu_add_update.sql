--rename part
select* from tbl_menus where menu_id = 5
--update tbl_menus set menu_name = 'Distributor Balance Transfer' where menu_id = 6 --Balance Retrieve

select * from tbl_menus where menu_name like '%Balance topup%' and menu_id = 5
--update tbl_menus set menu_name = 'Agent Balance Transfer' where menu_id = 5

--adding url admin/Balance/AgentRT
select * from tbl_menus where menu_id = 5
--update  tbl_menus set menu_url = '/admin/Balance/AgentRT' where menu_id = 5 --/admin/Customer/CustomerBalance

--adding menu 
EXECUTE [sproc_add_menu] @function_id = '704000'
	,@menu_name = 'Admin KYC'
	,@link_page = '/kyc'
	,@menu_group = 'Admin KYC'
	,@position = 4
	,@is_active = 'Y'
	,@group_position = 70
	,@parent_group = 4


--adding url /kyc
select * from tbl_menus where menu_id = 93
--update  tbl_menus set menu_url ='/kyc' where menu_id = 93

--for Balance Report Menu

select * from tbl_menus where menu_name like '%Balance Report%'
update tbl_menus set menu_name = 'Balance Transfer Report (Distributor)' where menu_id = 7

--for  Balance Transfer Report (Agent) 
select * from tbl_menus where menu_name like '%Balance Transfer Report%'

select  menu_id
	,menu_name
	,menu_group
	,parent_group
	,menu_order_position
	,group_order_postion
	,is_active
	,function_id
	,menu_access_category
	,parent_menu_id from tbl_menus where menu_group like '%user%'

--EXECUTE [sproc_add_menu] @function_id = '101080'
	,@menu_name = 'Balance Transfer Report (Agent)'
	,@link_page = '/admin/Balance/AgentReport'
	,@menu_group = 'User'
	,@position = 11
	,@is_active = 'Y'
	,@group_position = 10
	,@parent_group = Setup


	--update tbl_menus set parent_group = 'Setup' , parent_menu_id = 1 where menu_id = 94

--disabling Manage Merchant menu


select * from tbl_menus where menu_name like '%merchant%'
update tbl_menus set is_active = 'N' where menu_id = 45


--Disable SMS main menu 

select * from tbl_menus where menu_name like '%sms%'
update tbl_menus set is_active = 'N' where menu_id = 14

--Disable Utilities main menu 
select * from tbl_menus where parent_group like '%Utilities%'
update tbl_menus set is_active = 'N' where  parent_group like '%Utilities%'

--disable balance gateway submenu
select * from tbl_menus where menu_name = 'gateway balance'
update tbl_menus set is_active = 'N' where menu_id = 12
