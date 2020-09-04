select *  from tbl_application_config
insert into tbl_application_config(config_label,config_value,config_value1, config_value2)
values('Authorisation','wePayApiUser','wePayAp1us3r@20',replace(newid(), '-', '') + '-' + replace(NEWID(), '-', '') + '==')