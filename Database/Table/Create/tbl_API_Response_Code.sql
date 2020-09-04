Create table tbl_API_Response_Code
(
	RCode_Id int primary key identity(1,1),
	Response_Code int null,
	Response_Message varchar(max) null,
	Created_by varchar(50) null,
	Created_ts datetime  null,
	updated_by varchar(50)null,
	updated_ts datetime null
)

