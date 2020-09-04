Create Table tbl_NRB_transaction_limit
(
	txnl_Id int primary Key Identity(1,1),
	KYC_Status varchar(50) null,
	txn_type varchar(512) null,
	transaction_limit_max decimal (18,2) null,
	transaction_daily_limit_max decimal(18,2) null,
	transaction_monthly_limit_max decimal(18,2) null,
	created_by varchar(512) null,
	created_local_date datetime null,
	created_UTC_date datetime null,
	updated_by varchar(512) null,
	updated_local_date datetime null,
	updated_UTC_date datetime null
)