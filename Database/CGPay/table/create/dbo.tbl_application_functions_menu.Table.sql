USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_application_functions_menu]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_application_functions_menu]
GO
/****** Object:  Table [dbo].[tbl_application_functions_menu]    Script Date: 8/7/2020 9:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_application_functions_menu](
	[function_menu_id] [int] IDENTITY(1,2) NOT NULL,
	[role_id] [int] NULL,
	[menu_id] [int] NULL,
	[created_by] [varchar](100) NULL,
	[created_local_date] [datetime] NULL,
	[created_UTC_date] [datetime] NULL,
	[created_Nepali_date] [varchar](100) NULL,
	[created_ip] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[function_menu_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
