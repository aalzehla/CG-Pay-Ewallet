INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Manage User', '/admin/User', 'User', 'Setup', 1, 10, 'icon-cog3', 'Y', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '101000', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Role Setup', '/admin/Role', 'User', 'Setup', 2, 10, 'icon-cog3', 'Y', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '101010', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Search User', '/admin/User/Search', 'User', 'Setup', 3, 10, 'icon-cog3', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '101020', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Manage Distributor', '/admin/Distributor', 'User', 'Setup', 4, 10, 'icon-cog3', 'Y', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '101030', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Agent Balance Transfer', '/admin/Balance/AgentRT', 'User', 'Setup', 5, 10, 'icon-cog3', 'Y', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '101040', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Distributor Balance Transfer', '/admin/Balance/DistributorRT', 'User', 'Setup', 6, 10, 'icon-cog3', 'Y', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '101050', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Balance Transfer Report (Distributor)', '/admin/Balance/Report', 'User', 'Setup', 7, 10, 'icon-mobile2', 'Y', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '101060', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Create Category', '/admin/Commission/Category', 'Commission', 'Setup', 1, 20, 'icon-cog3', 'Y', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '102000', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Assign Category', '/admin/Commission/AssignCategory', 'Commission', 'Setup', 2, 20, 'icon-cog3', 'Y', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '102010', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Service Configuration', '/admin/Service/Configuration', 'Services', 'Setup', 1, 30, 'icon-cog3', 'Y', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '103000', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Gateway Detail', '/admin/Gateway/Detail', 'Services', 'Setup', 3, 30, 'icon-cog3', 'Y', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '103010', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Gateway Balance', '/admin/Gateway/GatewayBalanceDetail', 'Services', 'Setup', 4, 30, 'icon-cog3', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '103020', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Gateway Balance Report', '/admin/Gateway/BalanceReport', 'Services', 'Setup', 5, 30, 'icon-cog3', 'Y', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '103030', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('SMS Gateway Detail', '/admin/CommonSetup/SMSGatewayList', 'SMS', 'Setup', 1, 40, 'icon-cog3', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '104000', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Operator', '/admin/CommonSetup/Operator', 'SMS', 'Setup', 2, 40, 'icon-cog3', 'n', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '104010', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Sender Config', '/admin/CommonSetup/SenderConfig', 'SMS', 'Setup', 3, 40, 'icon-cog3', 'n', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '104020', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Upload E-Pin', '/admin/epin/upload ', 'E-Pin', 'Utilities', 1, 30, 'icon-wrench2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '301000', NULL, 2)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Block/Unblock', '/admin/epin/manage', 'E-Pin', 'Utilities', 2, 30, 'icon-wrench2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '301010', NULL, 2)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('E-Pin Stock Report', '/admin/epin/index', 'E-Pin', 'Utilities', 3, 30, 'icon-wrench2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '301020', NULL, 2)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Account Setup', '/admin/Finance/AccountSetup', 'Account Setup', 'Finance', 1, 40, 'icon-file-text2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '401000', NULL, 5)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Voucher Type Setup', '/admin/Finance/VoucherSetup', 'Account Setup', 'Finance', 2, 40, 'icon-file-text2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '401010', NULL, 5)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Journal Voucher', '/admin/Finance/JournalVoucher', 'Transaction', 'Finance', 1, 40, 'icon-file-text2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '402000', NULL, 5)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Approve Voucher', '/admin/Finance/ApproveVoucher', 'Transaction', 'Finance', 2, 40, 'icon-file-text2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '402010', NULL, 5)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Contra Voucher', '/admin/Finance/ContraVoucher', 'Transaction', 'Finance', 3, 40, 'icon-file-text2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '402020', NULL, 5)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Payment Voucher', '/admin/Finance/PaymentVoucher', 'Transaction', 'Finance', 4, 40, 'icon-file-text2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '402030', NULL, 5)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Edit Voucher', '/admin/Finance/EditVoucher', 'Transaction', 'Finance', 5, 40, 'icon-file-text2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '402040', NULL, 5)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Receipt Voucher', '/admin/Finance/ReceiptVoucher', 'Transaction', 'Finance', 5, 40, 'icon-file-text2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '402050', NULL, 5)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Day Book', '/admin/Finance/DayBook', 'Report', 'Finance', 1, 40, 'icon-file-text2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '403000', NULL, 5)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('PL Account', '/admin/Finance/PLAccount', 'Report', 'Finance', 2, 40, 'icon-file-text2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '403010', NULL, 5)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Balance Sheet', '/admin/Finance/BalanceSheet', 'Report', 'Finance', 4, 40, 'icon-file-text2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '403030', NULL, 5)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Voucher Report', '/admin/Finance/LedgerReport', 'Report', 'Finance', 5, 40, 'icon-file-text2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '403040', NULL, 5)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('GL Report', '/admin/Finance/GLReport', 'Report', 'Finance', 6, 40, 'icon-file-text2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '403050', NULL, 5)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Cash Flow', '/admin/Finance/CashFlow', 'Report', 'Finance', 7, 40, 'icon-file-text2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '403060', NULL, 5)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('GL Report', '/admin/Finance/Statement', 'Report', 'Finance', 8, 40, 'icon-file-text2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '403070', NULL, 5)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Search Transaction', '/admin/DynamicReport/ViewTransactionReport', 'Transaction', 'Report', 1, 50, 'icon-file-text2', 'Y', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '501000', NULL, 3)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Transaction Report', '/admin/DynamicReport/TransactionReport', 'Transaction', 'Report', 2, 50, 'icon-file-text2', 'Y', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '501010', NULL, 3)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Gateway Statement', '/admin/Report/GatewayStatement', 'Settlement', 'Report', 1, 50, 'icon-file-text2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '502000', NULL, 3)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Agent Statement', '/admin/Report/DistributorStatement', 'Settlement', 'Report', 2, 50, 'icon-file-text2', 'Y', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '502010', NULL, 3)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Commission Report', '/admin/Report/CommissionReport', 'Commission', 'Report', 1, 50, 'icon-file-text2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '503000', NULL, 3)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Pending Transaction', '/admin/DynamicReport/PendingTransaction', 'Reconcilation', 'Report', 1, 50, 'icon-file-text2', 'Y', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '504000', NULL, 3)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Money Transfer', '/admin/Report/MoneyTransfer', 'Reconcilation', 'Report', 2, 50, 'icon-file-text2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '504010', NULL, 3)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Remit Pay', '/admin/Report/Remit Pay', 'Reconcilation', 'Report', 3, 50, 'icon-file-text2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '504020', NULL, 3)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Gateway Txn', '/admin/Report/GatewayTransaction', 'Reconcilation', 'Report', 3, 50, 'icon-file-text2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '504030', NULL, 3)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Payment Gateway', '/admin/PaymentGateway', 'Services', 'Setup', 6, 30, 'icon-cog3', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '103040', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Manage Merchant', '/admin/Merchant', 'User', 'Setup', 10, 10, 'icon-cog3', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '101070', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Add Balance', '/admin/MerchantBalance', 'Services', 'Setup', 7, 30, 'icon-cog3', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '103050', 'D', 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Topup Merchant', '/admin/Balance/TopUpMerchant', 'Balance', 'Utilities', 1, 40, 'icon-wrench2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '302000', NULL, 2)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Retrieve Merchant', '/admin/Balance/RetrieveMerchant', 'Balance', 'Utilities', 2, 40, 'icon-wrench2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '302010', NULL, 2)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Report Merchant', '/admin/Balance/ReportMerchant', 'Balance', 'Utilities', 3, 40, 'icon-wrench2', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '302020', NULL, 2)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Manage Services', '/admin/Services', 'Services', 'Setup', 2, 30, 'icon-cog3', 'Y', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '103060', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Manage Customer', '/admin/Customer/ManageCustomer', 'Manage Customer', 'Customer', 1, 60, 'icon-users4', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '601000', NULL, 6)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('KYC', '/admin/Customer/KYC', 'KYC', 'Customer', 1, 60, 'icon-users4', 'N', '2019-10-20 10:58:18.467', '2019-10-20 16:43:18.467', '', 'System', '602000', NULL, 6)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Topup SubDistributor', '/admin/Balance/TopUpSubDistributor', 'Balance', 'Utilities', 1, 50, 'icon-wrench2', 'N', '2019-11-05 10:03:35.62', '2019-11-05 15:48:35.62', NULL, 'system', '303000', 'D', 2)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Retrieve SubDistributor', '/admin/Balance/RetrieveSubDistributor', 'Balance', 'Utilities', 2, 50, 'icon-wrench2', 'N', '2019-11-05 10:03:35.663', '2019-11-05 15:48:35.663', NULL, 'system', '303010', 'D', 2)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Report SubDistributor', '/admin/Balance/ReportSubDistributor', 'Balance', 'Utilities', 3, 50, 'icon-wrench2', 'N', '2019-11-05 10:03:35.67', '2019-11-05 15:48:35.67', NULL, 'system', '303020', 'D', 2)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Create Event', '/admin/Events/EventSetup', 'Setup', 'Events', 1, 7010, 'mdi mdi-sigma', 'N', '2019-11-06 05:49:37.663', NULL, NULL, 'system', '701000', NULL, 7)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Manage Users', '/admin/Events/UserSetup', 'Setup', 'Events', 2, 7010, 'mdi mdi-sigma', 'N', '2019-11-06 05:49:37.677', NULL, NULL, 'system', '701010', NULL, 7)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Event Type', '/admin/Events/EventType', 'Setup', 'Events', 3, 7010, 'mdi mdi-sigma', 'N', '2019-11-06 05:49:37.68', NULL, NULL, 'system', '701020', NULL, 7)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Event Category', '/admin/Events/EventCategory', 'Setup', 'Events', 4, 7010, 'mdi mdi-sigma', 'N', '2019-11-06 05:49:37.687', NULL, NULL, 'system', '701030', NULL, 7)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Ticket Category', '/admin/Events/TicketCategory', 'Setup', 'Events', 5, 7010, 'mdi mdi-sigma', 'N', '2019-11-06 05:49:37.69', NULL, NULL, 'system', '701040', NULL, 7)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Ticket Type', '/admin/Events/TicketType', 'Setup', 'Events', 6, 7010, 'mdi mdi-sigma', 'N', '2019-11-06 05:49:37.69', NULL, NULL, 'system', '701050', NULL, 7)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Offer/Discount', '/admin/Events/Offer', 'Setup', 'Events', 7, 7010, 'mdi mdi-sigma', 'N', '2019-11-06 05:49:37.697', NULL, NULL, 'system', '701060', NULL, 7)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Manage Tickets', '/admin/Events/Ticketing', 'Ticketing', 'Events', 2, 7020, 'mdi mdi-sigma', 'N', '2019-11-06 05:49:37.7', NULL, NULL, 'system', '702000', NULL, 7)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Search Ticket', '/admin/Events/SearchTicket', 'Report', 'Events', 1, 7030, 'mdi mdi-sigma', 'N', '2019-11-06 05:49:37.703', NULL, NULL, 'system', '703000', NULL, 7)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Txn Report', '/admin/Events/TransactionReport', 'Report', 'Events', 2, 7030, 'mdi mdi-sigma', 'N', '2019-11-06 05:49:37.703', NULL, NULL, 'system', '703010', NULL, 7)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Customer Balance', '/admin/Customer/CustomerBalance', 'CustomerBalance', 'Customer', 3, 60, 'icon-users4', 'N', '2019-11-06 09:39:25.413', NULL, NULL, 'system', '603000', NULL, 6)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Customer Statement', '/admin/Customer/CustomerStatement', 'CustomerStatement', 'Customer', 4, 60, 'icon-users4', 'N', '2019-11-08 08:18:56.117', NULL, NULL, 'system', '606000', NULL, 6)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Funding Bank Management', '/Admin/Bank/Detail', 'Funding Bank', 'Setup', 5, 7010, 'icon-users4', 'Y', '2019-11-11 08:47:12.4', NULL, NULL, 'system', '604000', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Support Kyc', '/admin/Customer/SupportKyc', 'SupportKyc', 'Customer', 5, 60, 'icon-users4', 'N', '2019-11-13 09:09:04.053', NULL, NULL, 'system', '605000', NULL, 6)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Used E-Pin Report', '/admin/Epin/EpinReport', 'E-Pin', 'Utilities', 4, 30, 'icon-wrench2', 'N', '2019-11-18 04:42:03.53', NULL, NULL, 'system', '301040', NULL, 2)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Client', '/admin/KYC', 'Client Dashboard', 'Client', 1, 100, 'icon-users4', 'N', '2019-12-17 09:25:02.303', NULL, NULL, 'system', '801000', NULL, 8)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Mobile TopUp', '/Client/Payment/MobileTopUp', 'Client Dashboard', 'Client', 1, 100, 'icon-mobile2', 'Y', '2019-12-17 09:25:02.303', NULL, NULL, 'system', '801001', 'M', NULL)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('LandLine', '/Client/Payment/LandLine', 'Client Dashboard', 'Client', 1, 100, 'icon-phone2', 'Y', '2019-12-17 09:25:02.303', NULL, NULL, 'system', '801002', 'M', NULL)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Television', '/Client/Payment/Television', 'Client Dashboard', 'Client', 1, 100, '/UI/client/images/style/sidebar/television.png', 'Y', '2019-12-17 09:25:02.303', NULL, NULL, 'system', '801003', 'M', NULL)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Internet', '/Client/Payment/Internet', 'Client Dashboard', 'Client', 1, 100, '/UI/client/images/style/sidebar/internet.png', 'Y', '2019-12-17 09:25:02.32', NULL, NULL, 'system', '801004', 'M', NULL)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Electricity', '/Client/Payment/Electricity', 'Client Dashboard', 'Client', 1, 100, '/UI/client/images/style/sidebar/electricity.png', 'Y', '2019-12-17 09:25:02.32', NULL, NULL, 'system', '801005', 'M', NULL)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Water', '/Client/Payment/Water', 'Client Dashboard', 'Client', 1, 100, '/UI/client/images/style/sidebar/water.png', 'Y', '2019-12-17 09:25:02.32', NULL, NULL, 'system', '801006', 'M', NULL)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Insurance', '/Client/Payment/Insurance', 'Client Dashboard', 'Client', 1, 100, '/UI/client/images/style/sidebar/insurance.png', 'Y', '2019-12-17 09:25:02.32', NULL, NULL, 'system', '801007', 'M', NULL)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('RCPIN', '/Client/Payment/RCPIN', 'Client Dashboard', 'Client', 1, 100, '/UI/client/images/style/sidebar/rcpins.png', 'Y', '2019-12-17 09:25:02.32', NULL, NULL, 'system', '801008', 'M', NULL)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Flight Tickets', '/Client/Payment/Flight', 'Client Dashboard', 'Client', 1, 100, '/UI/client/images/style/airplane.png', 'Y', '2019-12-17 09:25:02.32', NULL, NULL, 'system', '801009', 'M', NULL)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Movie Ticket', '/Client/Payment/MovieTicket', 'Client Dashboard', 'Client', 1, 100, '/UI/client/images/style/movie.png', 'Y', '2019-12-17 09:25:02.32', NULL, NULL, 'system', '801010', 'M', NULL)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Capital Market', '/Client/Payment/CapitalMarket', 'Client Dashboard', 'Client', 1, 100, '/UI/client/images/style/CapitalMarket.png', 'Y', '2019-12-17 09:25:02.32', NULL, NULL, 'system', '801011', 'M', NULL)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Bank Transfer', '/Client/Withdraw/BankDeposit', 'Client Dashboard', 'Client', 1, 100, '/UI/client/images/style/bank.png', 'Y', '2019-12-17 09:25:02.32', NULL, NULL, 'system', '801012', 'M', NULL)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Wallet Registration', '/Client/Payment/wallet', 'Client Dashboard', 'Client', 1, 100, 'fa fa-google-wallet', 'Y', '2019-12-17 09:27:41.48', NULL, NULL, 'system', '801013', 'M', NULL)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Statements', '/Client/Reports', 'Client Dashboard', 'Client', 1, 100, 'fa fa-tasks', 'Y', '2019-12-17 09:27:41.48', NULL, NULL, 'system', '801014', 'M', NULL)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Hospital', '/Client/Payment/Hospital', 'Client Dashboard', 'Client', 1, 100, 'fa fa-hospital-o', 'Y', '2019-12-24 09:38:55.71', NULL, NULL, 'system', '801015', 'M', NULL)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Message Template', '/admin/CommonSetup/MessageTemplateIndex', 'MessageTemplate', 'Setup', 5, 1030, 'icon-wrench2', 'N', '2020-01-09 05:03:37.11', NULL, NULL, 'system', '606000', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Service List', '/admin/Services/servicesstatus', 'Services', 'Setup', 0, 30, 'icon-cog3', 'Y', '2020-04-15 08:21:41.783', '2020-04-15 14:06:41.783', '', 'System', '103070', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('KYC Management', '/kyc', 'KYC Management', 'KYC', 1, 70, 'icon-users4', 'Y', '2020-04-19 07:51:45.75', '2020-04-19 13:36:45.75', '2077-01-07', 'System', '701000', NULL, 4)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Support KYC', '/admin/KYC/supportKYC', 'Support Kyc', 'KYC', 2, 70, 'icon-users4', 'N', '2020-04-19 07:51:45.75', '2020-04-19 13:36:45.75', '2077-01-07', 'System', '702000', NULL, 4)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('KYC Report', '/admin/KYC/KYC Report', 'KYC Report', 'KYC', 3, 70, 'icon-users4', 'Y', '2020-04-19 07:51:45.75', '2020-04-19 13:36:45.75', '2077-01-07', 'System', '703000', NULL, 4)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Admin KYC', '/kyc', 'Admin KYC', 'KYC', 4, 70, 'icon-users4', 'N', '2020-05-08 10:59:15.32', '2020-05-08 16:44:15.32', NULL, 'system', '704000', NULL, 4)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Balance Transfer Report (Agent)', '/admin/Balance/AgentReport', 'User', 'Setup', 11, 10, NULL, 'Y', '2020-05-08 11:05:58.413', '2020-05-08 16:50:58.413', NULL, 'system', '101080', NULL, 1)
GO

INSERT INTO dbo.tbl_menus (menu_name, menu_url, menu_group, parent_group, menu_order_position, group_order_postion, css_class, is_active, created_UTC_date, created_local_date, created_nepali_date, created_by, function_id, menu_access_category, parent_menu_id)
VALUES ('Dashboard', '/Client/Home/Index', 'Client Dashboard', 'Client', 0, 0, 'icon-home2', 'y', '2020-05-19 06:23:50.047', '2020-05-19 12:08:50.047', NULL, 'system', '801000', 'm', NULL)
GO

INSERT INTO [dbo].[tbl_menus] ([menu_name],[menu_url],[menu_group],[parent_group],[menu_order_position],[group_order_postion],[css_class],[is_active],[created_UTC_date],[created_local_date],[created_by],[function_id],[menu_access_category],[parent_menu_id])
VALUES('Payment Gateway Transaction Report','/Admin/DynamicReport/PaymentGatewayTransactionReport','Payment Gateway','Report','4','100','icon-file-text2','Y','2019-11-06 05:49:37.703','2019-11-06 05:49:37.703','system')
GO

INSERT INTO [dbo].[tbl_menus] ([menu_name],[menu_url],[menu_group],[parent_group],[menu_order_position],[group_order_postion],[css_class],[is_active],[created_UTC_date],[created_local_date],[created_by],[function_id],[menu_access_category],[parent_menu_id])
VALUES('Merchant Transaction Report','/Admin/DynamicReport/MerchantTransactionReport','Merchant','Report','5','100','icon-file-text2','Y','2019-11-06 05:49:37.703','2019-11-06 05:49:37.703','system')
GO

insert into tbl_menus select 'Load Fund','/Client/LoadBalance/LoadBalanceIndex' , 'Client Dashboard' , 'Client', '1', '100', 'icon-cash2', 'y',GetUTCDATE(), getdate(), dbo.func_get_nepali_date(DEFAULT), 'system','','M',''


