Create Table tbl_application_functions_menu
(
	function_menu_id int Identity(1,1) Primary Key,
	role_id int null,
	menu_id int null,
	created_by varchar(100) null,
	created_local_date datetime  null,
	created_UTC_date datetime null,
	created_Nepali_date varchar(100) null,
	created_ip varchar(100)null

)