select * from tbl_static_data_type
select * from tbl_static_data
--insert into tbl_static_data_type (static_data_name,static_data_description) values ('[Status]','Status Value')
--insert into tbl_static_data(sdata_type_id,static_data_value, static_data_label, static_data_description, created_by, created_local_date,created_UTC_date ,created_nepali_date)
--values(18,'Y','Active','status','admin',GETDATE(), GETUTCDATE(),dbo.func_get_nepali_date(default)),
--(18,'N','In-Active','status','admin',GETDATE(), GETUTCDATE(),dbo.func_get_nepali_date(default)),
--(18,'D','Deleted','status','admin',GETDATE(), GETUTCDATE(),dbo.func_get_nepali_date(default))

--insert into tbl_static_data_type (static_data_name,static_data_description) values ('[KYC Remarks]','Kyc Remarks Value')
insert into tbl_static_data(sdata_type_id,static_data_value, static_data_label, static_data_description, created_by, created_local_date,created_UTC_date ,created_nepali_date)
values	(19,'Your Passport is not valid at the moment you submitted your KYC application.','Your Passport is not valid at the moment you submitted your KYC application.','KYC Remarks','admin',GETDATE(), GETUTCDATE(),dbo.func_get_nepali_date(default)),
		(19,'Your Passport is not legible and/or it appeared to be modified by a photo editing software.','Your Passport is not legible and/or it appeared to be modified by a photo editing software.','KYC Remarks','admin',GETDATE(), GETUTCDATE(),dbo.func_get_nepali_date(default)),
		(19,'Your Note does not contain the correct information.','Your Note does not contain the correct information.','KYC Remarks','admin',GETDATE(), GETUTCDATE(),dbo.func_get_nepali_date(default)),
		(19,'Your Name does not match','Your Name does not match','KYC Remarks','admin',GETDATE(), GETUTCDATE(),dbo.func_get_nepali_date(default)),
		(19,'DOB incorrect','DOB incorrect','KYC Remarks','admin',GETDATE(), GETUTCDATE(),dbo.func_get_nepali_date(default)),
		(19,'Uploaded Photo not clear','Uploaded Photo not clear','KYC Remarks','admin',GETDATE(), GETUTCDATE(),dbo.func_get_nepali_date(default)),
		(19,'Uploaded Document not clear','Uploaded Document not clear','KYC Remarks','admin',GETDATE(), GETUTCDATE(),dbo.func_get_nepali_date(default)),
		(19,'Fill up detail and document detail doesn’t match','Fill up detail and document detail doesn’t match','KYC Remarks','admin',GETDATE(), GETUTCDATE(),dbo.func_get_nepali_date(default)),
		(19,'Citizenship number incorrect','Citizenship number incorrect','KYC Remarks','admin',GETDATE(), GETUTCDATE(),dbo.func_get_nepali_date(default)),
		(19,'"Others"','"Others"','KYC Remarks','admin',GETDATE(), GETUTCDATE(),dbo.func_get_nepali_date(default))
    
    
  
  

