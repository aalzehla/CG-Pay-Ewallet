USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_error_log_sql]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_error_log_sql]
GO
/****** Object:  Table [dbo].[tbl_error_log_sql]    Script Date: 8/7/2020 9:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_error_log_sql](
	[sql_error_id] [bigint] IDENTITY(1,2) NOT NULL,
	[sql_error_desc] [varchar](500) NULL,
	[sql_error_script] [varchar](500) NULL,
	[sql_query_string] [varchar](500) NULL,
	[sql_error_category] [varchar](500) NULL,
	[sql_error_source] [varchar](500) NULL,
	[sql_error_UTC_date] [datetime] NULL,
	[sql_error_local_date] [datetime] NULL,
	[sql_error_nepali_date] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[sql_error_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
