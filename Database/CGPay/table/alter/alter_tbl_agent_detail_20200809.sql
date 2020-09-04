

alter table tbl_agent_detail
add agent_qr_image_path varchar(1024) null

alter table tbl_agent_detail
alter column agent_qr_image nvarchar(max)


alter table tbl_agent_detail_audit
alter column agent_qr_image nvarchar(max)