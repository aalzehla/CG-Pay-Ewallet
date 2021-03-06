USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_application_function_log]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_application_function_log]
GO
/****** Object:  Table [dbo].[tbl_application_function_log]    Script Date: 8/7/2020 9:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_application_function_log](
	[fnlog_id] [int] IDENTITY(1,2) NOT NULL,
	[request_user] [int] NULL,
	[function_url] [varchar](500) NULL,
	[request_ip] [varchar](20) NULL,
	[request_dt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[fnlog_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
