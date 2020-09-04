	Create table agent_card_request
	(
		req_id int primary key identity(1,1),
		user_name varchar(50) not null,
		user_mobile_no varchar(10)null,
		user_email varchar(50)null,
		create_local_date datetime null,
		create_UTC_Date datetime null,
		created_by varchar(50) null,
		created_ip varchar(50)null
	)