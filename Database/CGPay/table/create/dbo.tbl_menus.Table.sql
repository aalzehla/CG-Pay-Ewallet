USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_menus]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_menus]
GO
/****** Object:  Table [dbo].[tbl_menus]    Script Date: 8/7/2020 9:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_menus](
	[menu_id] [int] IDENTITY(1,2) NOT NULL,
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
PRIMARY KEY CLUSTERED 
(
	[menu_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
