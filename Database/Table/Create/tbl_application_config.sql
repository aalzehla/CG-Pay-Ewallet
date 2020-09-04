
Create table tbl_application_config
(
	id int primary key identity(1,1),
	config_label varchar(20) null,
	config_value varchar(50) null,
	config_value1 nvarchar(max) null,
	config_value2 nvarchar(max) null,
	config_value3 nvarchar(max) null,
	config_value4 nvarchar(max) null,
	config_value5 nvarchar(max) null,
	created_by varchar(50) null,
	created_ts datetime null,
	updated_by varchar(50) null,
	updated_ts datetime null

)