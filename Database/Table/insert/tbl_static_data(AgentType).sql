insert into tbl_static_data (sdata_type_id, static_data_value, static_data_label, static_data_description, created_UTC_date, created_local_date, created_nepali_date, created_by)
values	(21,'1','Distributor','Distributor', GETUTCDATE(), GETDATE(), dbo.func_get_nepali_date(default), 'admin'),
		(21,'2','Sub-Distributor','Distributor', GETUTCDATE(), GETDATE(), dbo.func_get_nepali_date(default), 'admin'),
		(21,'3','Agent','Agent', GETUTCDATE(), GETDATE(), dbo.func_get_nepali_date(default), 'admin'),
		(21,'4','Sub-Agent','Agent', GETUTCDATE(), GETDATE(), dbo.func_get_nepali_date(default), 'admin'),
		(21,'5','Merchant','Merchant', GETUTCDATE(), GETDATE(), dbo.func_get_nepali_date(default), 'admin'),
		(21,'6','WalletUser','WalletUser', GETUTCDATE(), GETDATE(), dbo.func_get_nepali_date(default), 'admin')