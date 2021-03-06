USE [WePayNepal]
GO
ALTER TABLE [dbo].[tbl_roles] DROP CONSTRAINT DF__tbl_roles__creat__6319B466
GO
ALTER TABLE [dbo].[tbl_roles] DROP CONSTRAINT DF__tbl_roles__creat__640DD89F
GO
/****** Object:  Table [dbo].[tbl_roles]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_roles]
GO
/****** Object:  Table [dbo].[tbl_roles]    Script Date: 8/7/2020 9:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_roles](
	[role_id] [int] IDENTITY(1,2) NOT NULL,
	[role_name] [varchar](50) NULL,
	[role_type] [varchar](50) NULL,
	[created_UTC_date] [datetime] NOT NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NOT NULL,
	[created_ip] [varchar](20) NULL,
	[role_status] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tbl_roles] ADD  DEFAULT (getutcdate()) FOR [created_UTC_date]
GO
ALTER TABLE [dbo].[tbl_roles] ADD  DEFAULT (getdate()) FOR [created_local_date]
GO
