
update tbl_menus set menu_url='/Client/LoadBalance/BankList' where menu_url='/Client/LoadBalance/LoadBalanceIndex'

--To off duplicate menu catageory in nav bar
update tbl_menus set is_active ='N' where menu_url='/admin/AgentCommission/Category'
update tbl_menus set is_active ='N' where menu_url='/admin/AgentCommission/AssignCategory'


