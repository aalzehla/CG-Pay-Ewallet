USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_login_log]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_login_log]
GO
/****** Object:  Table [dbo].[tbl_login_log]    Script Date: 8/7/2020 9:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_login_log](
	[login_log_id] [bigint] IDENTITY(1,2) NOT NULL,
	[page_name] [varchar](100) NULL,
	[log_type] [varchar](30) NULL,
	[from_ip_address] [varchar](20) NULL,
	[browser_info] [varchar](1000) NULL,
	[remarks] [varchar](500) NULL,
	[is_active] [char](1) NULL,
	[created_by] [varchar](30) NULL,
	[created_UTC_date] [datetime] NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[login_log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
