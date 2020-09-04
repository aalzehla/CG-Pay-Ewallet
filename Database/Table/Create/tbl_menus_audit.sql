USE [WePayNepal]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_menus_audit]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_menus_audit]
GO

/****** Object:  Table [dbo].[tbl_menus]    Script Date: 30/05/2020 22:01:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_menus_audit](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[menu_id] [int] NULL,
	[menu_name] [varchar](100) NOT NULL,
	[menu_url] [varchar](100) NOT NULL,
	[menu_group] [varchar](40) NOT NULL,
	[parent_group] [varchar](30) NULL,
	[menu_order_position] [int] NOT NULL,
	[group_order_postion] [int] NULL,
	[css_class] [varchar](300) NULL,
	[is_active] [char](1) NULL,
	[created_UTC_date] [datetime] NOT NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NOT NULL,
	[function_id] [varchar](20) NULL,
	[menu_access_category] [varchar](25) NULL,
	[parent_menu_id] [int] NULL,
	[trigger_log_user] [varchar](512) NULL,
	[trigger_action] [varchar](512) NULL,
	[trigger_action_local_Date] [datetime] NULL,
	[trigger_action_UTC_Date] [datetime] NULL,
	[trigger_action_nepali_date] [varchar](512) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


