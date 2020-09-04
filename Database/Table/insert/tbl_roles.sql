
INSERT INTO dbo.tbl_roles (role_name, role_type, created_UTC_date, created_local_date, created_nepali_date, created_by, created_ip, role_status)
VALUES ('Admin', 'Admin', GetUTCDATE(), GETDate(),dbo.func_get_nepali_date(default),'System', '10.10.10.10', 'Y')
GO

INSERT INTO dbo.tbl_roles (role_name, role_type, created_UTC_date, created_local_date, created_nepali_date, created_by, created_ip, role_status)
VALUES ('Manager', 'Manager', GetUTCDATE(), GETDate(),dbo.func_get_nepali_date(default),'System', '10.10.10.10', 'Y')
GO

INSERT INTO dbo.tbl_roles (role_name, role_type, created_UTC_date, created_local_date, created_nepali_date, created_by, created_ip, role_status)
VALUES ('User', 'User', GetUTCDATE(), GETDATE(), dbo.func_get_nepali_date(default), 'System', '10.10.10.10', 'Y')
GO

