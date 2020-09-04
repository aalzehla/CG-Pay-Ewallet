USE [WePayNepal]
GO

/****** Object:  StoredProcedure [dbo].[sproc_app_version_control]    Script Date: 06/08/2020 3:54:31 PM ******/
DROP PROCEDURE [dbo].[sproc_app_version_control]
GO

/****** Object:  StoredProcedure [dbo].[sproc_app_version_control]    Script Date: 06/08/2020 3:54:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sproc_app_version_control]
	@flag char(1),
	@app_platform varchar(15)=null,
	@app_version varchar(15)=null,
	@is_major_update char(1)=null,
	@is_minor_update char(1)=null,
	@Action_user varchar(50)=null,
	@ipAddress varchar(10)=null,
	@app_update_info varchar(max)=null


AS
BEGIN
	if @flag='s'
	begin
		SELECT [vid]
      ,[app_platform]
      ,[app_version]
      ,[is_major_update]
      ,[is_minor_update]
      ,[created_by]
      ,[created_local_date]
      ,[created_utc_date]
      ,[created_nepali_date]
      ,[created_ip]
      ,[app_update_info]
  FROM [dbo].[tbl_app_version_control]
	end
	if @flag='i'
	begin
	INSERT INTO [dbo].[tbl_app_version_control]
           ([app_platform]
           ,[app_version]
           ,[is_major_update]
           ,[is_minor_update]
           ,[created_by]
           ,[created_local_date]
           ,[created_utc_date]
           ,[created_nepali_date]
           ,[created_ip]
           ,[app_update_info])
     VALUES
           (@app_platform
           ,@app_version
           ,@is_major_update
           ,@is_minor_update
           ,@Action_user
           ,GETDATE()
           ,GETUTCDATE()
           ,dbo.func_get_nepali_date(null)
           ,@ipAddress
           ,@app_update_info)
	end
END
GO


