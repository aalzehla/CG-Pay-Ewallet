
IF EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'tbl_user_detail'
                 AND COLUMN_NAME = 'failed_login_attempt') 
Begin
    alter table tbl_user_detail alter column failed_login_attempt int;
end
ELSE
Begin
    alter table tbl_user_detail add  failed_login_attempt int;
end

