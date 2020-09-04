create table tbl_agent_card_management
(
	card_id int identity(1,1) primary key not null,
	agent_id int null,
	user_id int null,
	user_name varchar(50) null,
	card_no varchar(100) UNIQUE null,
	card_uid varchar(50)null,
	card_type varchar(50) null,
	card_txn_type varchar(50) null,
	card_issued_date datetime null,
	card_expiry_date datetime null,
	is_active char(3)null,
	created_by varchar(50) null,
	created_local_date datetime null,
	created_utc_date datetime null,
	created_nepali_date varchar(50) null,
	updated_by varchar(50) null,
	updated_local_date datetime null,
	updated_utc_date datetime null,
	updated_nepali_date varchar(50) null
)