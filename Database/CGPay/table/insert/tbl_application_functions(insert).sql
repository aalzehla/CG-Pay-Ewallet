
-- View Merchant User(menu name) ,/Client/Merchant/ViewMerchantUser(menu url)
sproc_applicationFunc_mgmt @flag='i',@function_name='View Merchant User',@parent_menu_id='122',@function_url='/Client/Merchant/ViewMerchantUser'
go
sproc_applicationFunc_mgmt @flag='i',@function_name='Add/Edit Merchant User',@parent_menu_id='122',@function_url='/Client/Merchant/ManageMerchantUsers'
go
sproc_applicationFunc_mgmt @flag='i',@function_name='UnBlock Merchant User',@parent_menu_id='122',@function_url='/Client/Merchant/UnBlockUser'
go
sproc_applicationFunc_mgmt @flag='i',@function_name='Block Merchant User',@parent_menu_id='122',@function_url='/Client/Merchant/BlockUser'
go
sproc_applicationFunc_mgmt @flag='i',@function_name='View Merchant User Detail',@parent_menu_id='122',@function_url='/Client/Merchant/MerchantuserDetail'
go

sproc_applicationFunc_mgmt @flag='i',@function_name='View Profile',@parent_menu_id='122',@function_url='/Client/Merchant/Profile'
go

 --select * from tbl_menus where menu_url ='/Admin/CustomerManagement' ----For parent_menu_id   
insert into tbl_application_functions select '107','Add Balance','/Admin/CustomerManagement/AddBalance','2020-05-22 05:37:46.727','2020-05-22 11:22:46.727','2077-02-09','System','','','',''


--select * from tbl_menus where menu_url='/admin/AgentManagement'
insert into tbl_application_functions select '106', 'View Agent User', '/Admin/AgentManagement/ViewAgentUser' ,GetUTCDATE() , getdate(), dbo.func_get_nepali_date(DEFAULT),'System','','','',''

----select * from tbl_menus where menu_url='/admin/AgentManagement'
insert into tbl_application_functions select '106', 'Add/Edit Agent User', '/Admin/AgentManagement/ManageAgentUser' ,GetUTCDATE() , getdate(), dbo.func_get_nepali_date(DEFAULT),'System','','','',''
insert into tbl_application_functions select '106', 'Disable Agent User', '/Admin/AgentManagement/BlockUser' ,GetUTCDATE() , getdate(), dbo.func_get_nepali_date(DEFAULT),'System','','','',''
insert into tbl_application_functions select '106', 'Enable Agent User', '/Admin/AgentManagement/UnBlockUser' ,GetUTCDATE() , getdate(), dbo.func_get_nepali_date(DEFAULT),'System','','','',''
insert into tbl_application_functions select '106', 'Assign Role', '/Admin/AgentManagement/AssignRole' ,GetUTCDATE() , getdate(), dbo.func_get_nepali_date(DEFAULT),'System','','','',''

--select * from tbl_menus where menu_url='/Admin/MerchantManagement/Index'
insert into tbl_application_functions select '124', 'Change Password', '/Admin/MerchantManagement/ResetPassword' ,GetUTCDATE() , getdate(), dbo.func_get_nepali_date(DEFAULT),'System','','','',''

--select * from tbl_menus where menu_url='/admin/AgentManagement'
insert into tbl_application_functions select '106', 'Change Password', '/Admin/AgentManagement/ResetPassword' ,GetUTCDATE() , getdate(), dbo.func_get_nepali_date(DEFAULT),'System','','','',''


--select * from tbl_menus where menu_url= '/admin/user/searchuser'
insert into tbl_application_functions select '3', 'Search User Detail', '/Admin/User/ViewSearchUserDetail' ,GetUTCDATE() , getdate(), dbo.func_get_nepali_date(DEFAULT),'System','','','',''
insert into tbl_application_functions select '3', 'Edit Search User', '/Admin/User/EditSearchUser' ,GetUTCDATE() , getdate(), dbo.func_get_nepali_date(DEFAULT),'System','','','',''
insert into tbl_application_functions select '3', 'Block Search User', '/Admin/User/BlockSearchUser' ,GetUTCDATE() , getdate(), dbo.func_get_nepali_date(DEFAULT),'System','','','',''
insert into tbl_application_functions select '3', 'Unblock Search User', '/Admin/User/UnBlockSearchUser' ,GetUTCDATE() , getdate(), dbo.func_get_nepali_date(DEFAULT),'System','','','',''

--select * from tbl_menus where menu_url='/admin/AgentManagement'
insert into tbl_application_functions select '106', 'View Agent Detail', '/Admin/AgentManagement/ViewAgentDetail' ,GetUTCDATE() , getdate(), dbo.func_get_nepali_date(DEFAULT),'System','','','',''

