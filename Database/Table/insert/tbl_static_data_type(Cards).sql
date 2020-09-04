

insert into tbl_static_data_type (static_data_name, static_data_description, created_by, created_Date, created_UTC_Date, created_Date_Nepali)
values('Card Type','Types of Agent Card','',GetDate(), GetUTCDATE(),dbo.func_get_nepali_date(default))

insert into tbl_static_data(sdata_type_id, static_data_value, static_data_label, static_data_description, created_local_date, created_UTC_date, created_by, created_nepali_date)
values(23,1,'Virtual Card','Type of Agent Card', GETDATE(), GETUTCDATE(), 'samir',dbo.func_get_nepali_date(default)),
(23,2,'Gift Card','Type of Agent Card', GETDATE(), GETUTCDATE(), 'samir',dbo.func_get_nepali_date(default)),
(23,3,'Discount Card','Type of Agent Card', GETDATE(), GETUTCDATE(), 'samir',dbo.func_get_nepali_date(default))

insert into tbl_static_data_type (static_data_name, static_data_description, created_by, created_Date, created_UTC_Date, created_Date_Nepali)
values('Card Transaction Type','Card Transaction Type','',GetDate(), GetUTCDATE(),dbo.func_get_nepali_date(default))

insert into tbl_static_data(sdata_type_id, static_data_value, static_data_label, static_data_description, created_local_date, created_UTC_date, created_by, created_nepali_date)
values(24,1,'Prepaid','Card Transaction Type', GETDATE(), GETUTCDATE(), 'samir',dbo.func_get_nepali_date(default)),
(24,2,'Wallet','Card Transaction Type', GETDATE(), GETUTCDATE(), 'samir',dbo.func_get_nepali_date(default))