USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_activity_log]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_activity_log]
GO
/****** Object:  Table [dbo].[tbl_activity_log]    Script Date: 8/7/2020 9:43:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_activity_log](
	[log_id] [bigint] IDENTITY(1,2) NOT NULL,
	[page_name] [varchar](100) NULL,
	[page_Url] [varchar](max) NULL,
	[log_type] [varchar](30) NULL,
	[from_ip_address] [varchar](20) NULL,
	[from_browser] [varchar](100) NULL,
	[attempt_details] [varchar](500) NULL,
	[is_active] [bit] NULL,
	[created_by] [varchar](30) NULL,
	[created_UTC_date] [datetime] NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
