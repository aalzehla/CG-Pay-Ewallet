-- *** SqlDbx Personal Edition ***
-- !!! Not licensed for commercial use beyound 90 days evaluation period !!!
-- For version limitations please check http://www.sqldbx.com/personal_edition.htm
-- Number of queries executed: 27, number of rows retrieved: 4140

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (1, 'View', '/admin/User/Index', '2020-05-15 09:24:45.877', '2020-05-15 15:09:45.877', '2077-02-02', NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (1, 'Add/Edit User', '/Admin/User/ManageUser', '2020-05-15 11:56:15.603', '2020-05-15 17:41:15.603', '2077-02-02', '1', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (1, 'Change Password User', '/Admin/User/changepassword', '2020-05-15 11:56:15.62', '2020-05-15 17:41:15.62', '2077-02-02', '1', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (1, 'Block User', '/Admin/User/BlockUser', '2020-05-15 11:56:15.637', '2020-05-15 17:41:15.637', '2077-02-02', '1', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (1, 'UnBlock User', '/Admin/User/UnBlockUser', '2020-05-15 11:56:15.65', '2020-05-15 17:41:15.65', '2077-02-02', '1', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (2, 'View Roles', '/Admin/Role/Index', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (2, 'Add/Edit Roles', '/Admin/Role/Manage', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (2, 'Assign Page Privilege', '/Admin/Role/Privilege', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (2, 'Assign Functions', '/Admin/Role/FunctionPrivilege', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (4, 'View Distributor', '/admin/Distributor/Index', '2020-05-15 14:29:25.86', '2020-05-15 20:14:25.86', '2077-02-02', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (8, 'Mobile TopUp', '/Client/Payment/MobileTopUp', '2020-05-15 16:43:55.767', '2020-05-15 22:28:55.767', '2077-02-02', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (8, 'Balance Transfer Request', '/Client/WalletBalance/balanceTransfer', '2020-05-15 18:13:39.137', '2020-05-15 23:58:39.137', '2077-02-02', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (4, 'View Sub-Distributor', '/admin/SubDistributor/Index', '2020-05-16 05:58:26.887', '2020-05-16 11:43:26.887', '2077-02-03', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (4, 'Add/Edit Sub-Distributor', '/admin/SubDistributor/manage', '2020-05-16 07:02:04.003', '2020-05-16 12:47:04.003', '2077-02-03', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (4, 'Add/Edit Distributor', '/admin/Distributor/Manage', '2020-05-16 11:05:42.653', '2020-05-16 16:50:42.653', '2077-02-03', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (4, 'View User', '/admin/Distributor/ViewUser', '2020-05-16 11:11:16.92', '2020-05-16 16:56:16.92', '2077-02-03', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (4, 'Add/Edit User', '/admin/Distributor/Users', '2020-05-16 11:12:35.973', '2020-05-16 16:57:35.973', '2077-02-03', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (4, 'Assign Role', '/admin/Distributor/AssignRole', '2020-05-16 11:29:41.797', '2020-05-16 17:14:41.797', '2077-02-03', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (4, 'View Sub-Distributor Users', '/admin/SubDistributor/ViewUser', '2020-05-16 12:12:51.423', '2020-05-16 17:57:51.423', '2077-02-03', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (4, 'Add/Edit Sub-Distributor Users', '/admin/SubDistributor/addUsers', '2020-05-16 14:54:37.497', '2020-05-16 20:39:37.497', '2077-02-03', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (4, 'Block Sub-Distributor Users', '/admin/SubDistributor/BlockUser', '2020-05-17 05:20:36.563', '2020-05-17 11:05:36.563', '2077-02-04', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (4, 'UnBlock Sub-Distributor Users', '/admin/SubDistributor/UnBlockUser', '2020-05-17 05:20:50.887', '2020-05-17 11:05:50.887', '2077-02-04', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (4, 'Cards', '/Admin/Card/Index', '2020-05-17 09:38:36.273', '2020-05-17 15:23:36.273', '2077-02-04', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (4, 'Add Cards', '/Admin/Card/AddCard', '2020-05-17 12:30:06.12', '2020-05-17 18:15:06.12', '2077-02-04', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (4, 'Block User', '/admin/Distributor/BlockUser', '2020-05-17 15:29:35.11', '2020-05-17 21:14:35.11', '2077-02-04', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (4, 'Unblock Distributor Users', '/Admin/Distributor/UnBlockUser', '2020-05-17 15:44:33.76', '2020-05-17 21:29:33.76', '2077-02-04', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (4, 'View Agent List', '/Admin/Distributor/Agent_Index', '2020-05-17 15:59:25.88', '2020-05-17 21:44:25.88', '2077-02-04', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (4, 'Add/Edit ', '/Admin/Distributor/Manage_Agent', '2020-05-17 16:00:46.79', '2020-05-17 21:45:46.79', '2077-02-04', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (4, 'View Agent User ', '/Admin/Distributor/View_Agent_User', '2020-05-17 18:25:34.5', '2020-05-18 00:10:34.5', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (4, 'add/Edit Agent User ', '/Admin/Distributor/AgentUser', '2020-05-17 19:36:52.457', '2020-05-18 01:21:52.457', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (4, ' Assign Agent Role ', '/Admin/Distributor/AssignAgentRole', '2020-05-17 20:16:32.967', '2020-05-18 02:01:32.967', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (8, 'View Commission Category', '/admin/Commission/Category', '2020-05-18 07:02:05.08', '2020-05-18 12:47:05.08', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (88, 'View Services List', '/admin/Services/servicesstatus', '2020-05-18 07:33:53.167', '2020-05-18 13:18:53.167', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (50, 'View Services Manage', '/admin/Services/Index', '2020-05-18 07:54:29.563', '2020-05-18 13:39:29.563', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (88, 'Enable/Disable Services List', '/admin/Services/ServicesStatus', '2020-05-18 08:44:38.25', '2020-05-18 14:29:38.25', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (50, 'Add/Edit Services', '/admin/Services/ManageServices', '2020-05-18 08:45:16.64', '2020-05-18 14:30:16.64', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (11, 'View Gateway', '/admin/Gateway/Detail', '2020-05-18 08:53:10.357', '2020-05-18 14:38:10.357', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (11, 'Add/Edit Gateway', '/admin/Gateway/ManageGateway', '2020-05-18 10:01:29.553', '2020-05-18 15:46:29.553', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (11, 'Add/Edit Gateway Balance', '/admin/Gateway/ManageGatewayBalance', '2020-05-18 10:06:38.717', '2020-05-18 15:51:38.717', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (11, 'View Gateway Product List', '/admin/Gateway/GatewayProductList', '2020-05-18 10:07:24', '2020-05-18 15:52:24', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (11, 'Add/Edit Gateway Commission', '/admin/Gateway/ManageGatewayCommission', '2020-05-18 10:09:13.13', '2020-05-18 15:54:13.13', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (8, 'Add/Edit Commission Category', '/admin/Commission/ManageCommissionCategory', '2020-05-18 10:14:13.68', '2020-05-18 15:59:13.68', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (8, 'View Commission Product List', '/admin/Commission/CommissionProductList', '2020-05-18 10:14:59.907', '2020-05-18 15:59:59.907', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (8, 'Disable Commission Category', '/admin/Commission/DisableCommissionCategory', '2020-05-18 10:16:16.63', '2020-05-18 16:01:16.63', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (8, 'Add/Edit Commission Category Product', '/admin/Commission/ManageCommissionCategoryProduct', '2020-05-18 10:18:03.46', '2020-05-18 16:03:03.46', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (9, 'View Assign category', '/admin/Commission/AssignCategory', '2020-05-18 10:19:13.44', '2020-05-18 16:04:13.44', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (9, 'Add/Edit Assign category', '/admin/Commission/ManageAssignCategory', '2020-05-18 10:20:21.93', '2020-05-18 16:05:21.93', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (5, 'Agent Balance Request/Transfer', '/Admin/Balance/AgentRT', '2020-05-18 12:05:04.523', '2020-05-18 17:50:04.523', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (6, 'Distributor Balance Request/Transfer', '/Admin/Balance/DistributorRT', '2020-05-18 12:06:34.063', '2020-05-18 17:51:34.063', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (7, 'Distributor Balance Report', '/Admin/Balance/Report', '2020-05-18 12:07:17.13', '2020-05-18 17:52:17.13', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (68, 'View Bank List', '/Admin/Bank/Detail', '2020-05-18 12:07:35.513', '2020-05-18 17:52:35.513', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (94, 'Agent Balance Report', '/Admin/Balance/AgentReport', '2020-05-18 12:07:39.503', '2020-05-18 17:52:39.503', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (68, 'Add/Edit Bank', '/Admin/Bank/AddBank', '2020-05-18 12:10:27.853', '2020-05-18 17:55:27.853', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (68, 'Enable Bank', '/Admin/Bank/EnableBank', '2020-05-18 12:12:03.82', '2020-05-18 17:57:03.82', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (68, 'Disable Bank', '/Admin/Bank/DisableBank', '2020-05-18 12:12:20.41', '2020-05-18 17:57:20.41', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (94, 'Agent Balance Report Detils', '/Admin/Balance/AgentReportDetail', '2020-05-18 12:57:23.857', '2020-05-18 18:42:23.857', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (7, 'Distributor Balance Report Detils', '/Admin/Balance/ReportDetail', '2020-05-18 12:57:50.94', '2020-05-18 18:42:50.94', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (90, 'KYC List', '/KYC', '2020-05-18 12:57:50.94', '2020-05-18 18:42:50.94', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (90, 'KYC Manage', '/KYC/Details', '2020-05-18 12:57:50.94', '2020-05-18 18:42:50.94', '2077-02-05', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (72, 'View Mobile Topup', '/Client/Payment/MobileTopUp', '2020-05-19 06:07:44.047', '2020-05-19 11:52:44.047', '2077-02-06', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (98, 'My Profile', '/Client/ClientUser/Profile', '2020-05-19 06:25:02.71', '2020-05-19 12:10:02.71', '2077-02-06', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (98, 'Change Password', '/Client/ClientUser/ChangePassword', '2020-05-19 06:25:36.28', '2020-05-19 12:10:36.28', '2077-02-06', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (98, 'Change Pin', '/Client/ClientUser/ChangePin', '2020-05-19 06:25:54.817', '2020-05-19 12:10:54.817', '2077-02-06', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (98, 'View/Update Kyc', '/Client/ClientUser/Kyc', '2020-05-19 06:26:32.333', '2020-05-19 12:11:32.333', '2077-02-06', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (98, 'View Dashboard', '/Client/Home/Index', '2020-05-19 06:29:07.45', '2020-05-19 12:14:07.45', '2077-02-06', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (36, 'Transaction Report', '/admin/DynamicReport/TransactionReport', '2020-05-19 06:41:21.69', '2020-05-19 12:26:21.69', '2077-02-06', 'System', NULL, NULL, NULL, NULL)
GO

INSERT INTO dbo.tbl_application_functions (parent_menu_id, function_name, function_Url, created_UTC_date, created_local_date, created_nepali_date, created_by, updated_by, updated_UTC_date, updated_local_date, updated_nepali_date)
VALUES (36, 'Transaction Report Details', '/admin/DynamicReport/TransactionReportDetail', '2020-05-19 06:43:12.553', '2020-05-19 12:28:12.553', '2077-02-06', 'System', NULL, NULL, NULL, NULL)
GO

--select * from tbl_menus where menu_url ='/admin/StaticData/Index' -- For parent_menu_id
insert into tbl_application_functions select '99','Static Data Detail','/admin/StaticData/StaticDataDetail','2020-05-22 05:37:46.727','2020-05-22 11:22:46.727','2077-02-09','System','','','',''
 
 --select * from tbl_menus where menu_url ='/Admin/KYC/Index' -- For parent_menu_id
insert into tbl_application_functions select '90','KYC Edit','/Admin/KYC/EditDetails','2020-05-22 05:37:46.727','2020-05-22 11:22:46.727','2077-02-09','System','','','',''

--select * from tbl_menus where menu_url ='/Admin/DynamicReport/MerchantTransactionReport' -- For parent_menu_id
insert into tbl_application_functions select '138','Merchant Transaction Report','/Admin/DynamicReport/MerchantTransactionReport','2020-08-13 05:37:46.727','2020-08-23 11:22:46.727','2077-02-09','System','','','','3'

--select * from tbl_menus where menu_url ='/Client/Payment/MobileTopUp' -- For parent_menu_id
insert into tbl_application_functions select '72','NT Prepaid Topup','/Client/Payment/NTPre','2020-08-13 05:37:46.727','2020-08-23 11:22:46.727','2077-02-09','System','','','',''
insert into tbl_application_functions select '72','NT Postpaid Topup','/Client/Payment/NTPost','2020-08-13 05:37:46.727','2020-08-23 11:22:46.727','2077-02-09','System','','','',''
insert into tbl_application_functions select '72','NT CDMA Prepaid Topup','/Client/Payment/NTCdmaPre','2020-08-13 05:37:46.727','2020-08-23 11:22:46.727','2077-02-09','System','','','',''
insert into tbl_application_functions select '72','NT CDMA Postpaid Topup','/Client/Payment/NTCdmaPost','2020-08-13 05:37:46.727','2020-08-23 11:22:46.727','2077-02-09','System','','','',''
insert into tbl_application_functions select '72','NCell','/Client/Payment/Ncell','2020-08-13 05:37:46.727','2020-08-23 11:22:46.727','2077-02-09','System','','','',''
insert into tbl_application_functions select '72','SmartCell','/Client/Payment/SmartCell','2020-08-13 05:37:46.727','2020-08-23 11:22:46.727','2077-02-09','System','','','',''
insert into tbl_application_functions select '72','UTL','/Client/Payment/UTL','2020-08-13 05:37:46.727','2020-08-23 11:22:46.727','2077-02-09','System','','','',''
insert into tbl_application_functions select '72','Product Topup','/Client/Payment/TopUpMobile','2020-08-13 05:37:46.727','2020-08-23 11:22:46.727','2077-02-09','System','','','',''

--select * from tbl_menus where menu_url ='/Admin/Services'
insert into tbl_application_functions select '50','Services Detail','/Admin/Services/ServicesDetail','2020-08-13 05:37:46.727','2020-08-23 11:22:46.727','2077-02-09','System','','','',''


--select * from tbl_menus where menu_url='/Admin/Gateway/Detail'
insert into tbl_application_functions select '11','Gateway Detail','/Admin/Gateway/GatewayDetail',GetUTCDATE(), getdate(), dbo.func_get_nepali_date(DEFAULT),'System','','','',''


--select * from tbl_menus where menu_url='/admin/customerManagement'
insert into tbl_application_functions select '107', 'Reset Password', '/Admin/CustomerManagement/ResetPassword' ,GetUTCDATE() , getdate(), dbo.func_get_nepali_date(DEFAULT),'System','','','',''

