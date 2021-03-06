USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_application_functions_role]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_application_functions_role]
GO
/****** Object:  Table [dbo].[tbl_application_functions_role]    Script Date: 8/7/2020 9:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_application_functions_role](
	[function_role_id] [int] IDENTITY(1,2) NOT NULL,
	[function_id] [varchar](10) NULL,
	[role_id] [int] NULL,
	[created_UTC_date] [datetime] NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NOT NULL,
	[updated_by] [datetime] NULL,
	[updated_UTC_date] [varchar](50) NULL,
	[updated_local_date] [datetime] NULL,
	[updated_nepali_date] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[function_role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
