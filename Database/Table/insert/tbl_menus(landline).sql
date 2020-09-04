USE [CGPay]
GO


select * from tbl_menus where menu_url like '%landline%'

[sproc_applicationFunc_mgmt] @flag='i',@function_name='View Result Page',@parent_menu_id='136',@function_url='/client/LandLineBillPayment/ResultPage'

-----------------------------------------------------------------------------------------------------

--august 23 2020
update tbl_menus set menu_url='/client/LandLinebillPayment/LandLinePayment' where menu_id='136'

update tbl_application_functions set function_url='/Client/LandLinebillPayment/landlinepayment' where function_url='/Client/Payment/landlinepayment'

update tbl_application_functions set function_url='/Client/LandLinebillPayment/CheckLandLineNumber' where function_url='/Client/Payment/CheckLandLineNumber'

update tbl_application_functions set function_url='/Client/LandLinebillPayment/landlinenumbervalidation' where function_url='/Client/Payment/landlinenumbervalidation'

update tbl_application_functions set function_url='/Client/LandLinebillPayment/landlinenumberLengthValidate' where function_url='/Client/Payment/landlinenumberLengthValidate'




-----------------------------------------------------------------------------------------------------
INSERT INTO [dbo].[tbl_menus]
           ([menu_name]
           ,[menu_url]
           ,[menu_group]
           ,[parent_group]
           ,[menu_order_position]
           ,[group_order_postion]
           ,[css_class]
           ,[is_active]
           ,[created_UTC_date]
           ,[created_local_date]
           ,[created_nepali_date]
           ,[created_by]
           ,[function_id]
           ,[menu_access_category]
           ,[parent_menu_id])
     VALUES
           ('LandLine'
           ,'/client/payment/LandLinePayment'
           ,'Client Dashboard'
           ,'Client'
           ,'2'
           ,'100'
           ,'icon-phone'
           ,'Y'
           ,GETUTCDATE()
           ,getdate()
           ,null
           ,'system'
           ,null
           ,'M'
           ,null)
GO
select * from tbl_menus


select * from tbl_application_functions order by 1 desc

[sproc_applicationFunc_mgmt] @flag='i',@function_name='LandLine Payment',@parent_menu_id='136',@function_url='/Client/Payment/landlinepayment'

[sproc_applicationFunc_mgmt] @flag='i',@function_name='Check LandLine Number',@parent_menu_id='136',@function_url='/Client/Payment/CheckLandLineNumber'

[sproc_applicationFunc_mgmt] @flag='i',@function_name='landline number validation',@parent_menu_id='136',@function_url='/Client/Payment/landlinenumbervalidation'

[sproc_applicationFunc_mgmt] @flag='i',@function_name='landline number Length Validate',@parent_menu_id='136',@function_url='/Client/Payment/landlinenumberLengthValidate'



