insert into tbl_API_Response_Code(Response_Code,Response_Message,Created_by,Created_ts)
select '189','Value must be alphabet', 'admin', GETDATE() from tbl_API_Response_Code where RCode_Id = 1
select '190','Value must be numberic', 'admin', GETDATE() from tbl_API_Response_Code where RCode_Id = 1


select * from tbl_API_Response_Code order by RESPONSE_CODE desc

select * from tbl_API_Response_Code where Response_Message like '%amount%'