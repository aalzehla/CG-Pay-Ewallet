USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_user_role]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_user_role]
GO
/****** Object:  Table [dbo].[tbl_user_role]    Script Date: 8/7/2020 9:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_user_role](
	[user_role_id] [int] IDENTITY(1,2) NOT NULL,
	[user_id] [varchar](30) NOT NULL,
	[role_id] [int] NOT NULL,
	[created_UTC_date] [datetime] NOT NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NOT NULL,
	[created_ip] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[user_role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
