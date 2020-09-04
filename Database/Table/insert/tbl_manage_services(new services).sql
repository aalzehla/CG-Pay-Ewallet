insert into tbl_manage_services 
(txn_type_id, txn_type, company_id, company, product_type_id, product_type, product_label, product_logo, product_service_info, product_category, primary_gateway, secondary_gateway, status, created_by, created_local_date, created_UTC_date, created_nepali_date)
values
(9, 'Payment', 45, 'NPS', 8, 'Ride', 'YO! Ride', 'icon-ride-inverse.png','Ride with us','NPS',1, 1, 'y', 'admin',GETDATE(), GETUTCDATE(), dbo.func_get_nepali_date(default)),
(9, 'Payment', 45, 'NPS', 9, 'Agro', 'YO! Agriculture', 'icon-agriculture-inverse.png','Go Green','NPS',1, 1, 'y', 'admin',GETDATE(), GETUTCDATE(), dbo.func_get_nepali_date(default)),
(9, 'Payment', 45, 'NPS', 10, 'Medical', 'YO! Health', 'icon-agriculture-inverse.png','Health is Wealth','NPS',1, 1, 'y', 'admin',GETDATE(), GETUTCDATE(), dbo.func_get_nepali_date(default)),
(9, 'Payment', 45, 'NPS', 11, 'Antivirus', 'Antivirus', 'icon-agriculture-inverse.png','Protect and Save','NPS',1, 1, 'y', 'admin',GETDATE(), GETUTCDATE(), dbo.func_get_nepali_date(default)),
(9, 'Payment', 45, 'NPS', 13, 'Share', 'NEPSE', 'icon-agriculture-inverse.png','Get share','NPS',1, 1, 'y', 'admin',GETDATE(), GETUTCDATE(), dbo.func_get_nepali_date(default)),
(9, 'Payment', 45, 'NPS', 14, 'Credit Card', 'YO! Cards', 'icon-agriculture-inverse.png','Pay as You go','NPS',1, 1, 'y', 'admin',GETDATE(), GETUTCDATE(), dbo.func_get_nepali_date(default)),
(9, 'Payment', 45, 'NPS', 15, 'School', 'School', 'icon-agriculture-inverse.png','Schooling','NPS',1, 1, 'y', 'admin',GETDATE(), GETUTCDATE(), dbo.func_get_nepali_date(default)),
(9, 'Payment', 45, 'NPS', 16, 'Voting', 'Voting', 'icon-agriculture-inverse.png','Vote Now','NPS',1, 1, 'y', 'admin',GETDATE(), GETUTCDATE(), dbo.func_get_nepali_date(default)),
(9, 'Payment', 45, 'NPS', 17, 'Delivery', 'YO! Delivery', 'icon-agriculture-inverse.png','Deliveroooooo','NPS',1, 1, 'y', 'admin',GETDATE(), GETUTCDATE(), dbo.func_get_nepali_date(default)),
(9, 'Payment', 45, 'NPS', 18, 'Event', 'YO! Event Management', 'icon-agriculture-inverse.png','EVENT','NPS',1, 1, 'y', 'admin',GETDATE(), GETUTCDATE(), dbo.func_get_nepali_date(default)),
(9, 'Payment', 45, 'NPS', 19, 'EMI', 'EMI', 'icon-agriculture-inverse.png','Get EMI','NPS',1, 1, 'y', 'admin',GETDATE(), GETUTCDATE(), dbo.func_get_nepali_date(default)),
(9, 'Payment', 45, 'NPS', 20, 'Subscription', 'Subscription', 'icon-agriculture-inverse.png','Subscribe !!!!','NPS',1, 1, 'y', 'admin',GETDATE(), GETUTCDATE(), dbo.func_get_nepali_date(default))