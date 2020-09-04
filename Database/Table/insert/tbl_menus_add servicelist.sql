
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
           ,[menu_access_category])
     VALUES
           ('Service List'
           ,'/admin/Service/List'
           ,'Services'
           ,'Setup'
           ,'0'
           ,'30'
           ,'icon-cog3'
           ,'Y'
           ,GETUTCDATE()
           ,getdate()
           ,''
           ,'System'
           ,'103070'
           ,null)



