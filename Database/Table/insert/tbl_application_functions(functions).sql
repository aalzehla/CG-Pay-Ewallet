-- *** SqlDbx Personal Edition ***
-- !!! Not licensed for commercial use beyound 90 days evaluation period !!!
-- For version limitations please check http://www.sqldbx.com/personal_edition.htm
-- Number of queries executed: 26, number of rows retrieved: 4131


INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (1, 'View', '/admin/User/Index', '2020-05-15 09:24:45.877', '2020-05-15 15:09:45.877', '2077-02-02', NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES ( 1, 'Add/Edit User', '/Admin/User/ManageUser', '2020-05-15 11:56:15.603', '2020-05-15 17:41:15.603', '2077-02-02', '1', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES ( 1, 'Change Password User', '/Admin/User/changepassword', '2020-05-15 11:56:15.62', '2020-05-15 17:41:15.62', '2077-02-02', '1', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES ( 1, 'Block User', '/Admin/User/BlockUser', '2020-05-15 11:56:15.637', '2020-05-15 17:41:15.637', '2077-02-02', '1', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES ( 1, 'UnBlock User', '/Admin/User/UnBlockUser', '2020-05-15 11:56:15.65', '2020-05-15 17:41:15.65', '2077-02-02', '1', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES ( 2, 'View Roles', '/Admin/Role/Index', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (2, 'Add/Edit Roles', '/Admin/Role/Manage', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (2, 'Assign Page Privilege', '/Admin/Role/Privilege', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES ( 2, 'Assign Functions', '/Admin/Role/FunctionPrivilege', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

