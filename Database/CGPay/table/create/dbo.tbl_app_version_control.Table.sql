USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_app_version_control]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_app_version_control]
GO
/****** Object:  Table [dbo].[tbl_app_version_control]    Script Date: 8/7/2020 9:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_app_version_control](
	[vid] [int] IDENTITY(1,2) NOT NULL,
	[app_platform] [varchar](20) NULL,
	[app_version] [varchar](20) NULL,
	[is_major_update] [char](3) NULL,
	[is_minor_update] [char](3) NULL,
	[created_by] [varchar](50) NULL,
	[created_local_date] [datetime] NULL,
	[created_utc_date] [datetime] NULL,
	[created_nepali_date] [varchar](512) NULL,
	[created_ip] [varchar](10) NULL,
	[app_update_info] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[vid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
