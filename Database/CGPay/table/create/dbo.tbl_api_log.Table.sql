USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_api_log]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_api_log]
GO
/****** Object:  Table [dbo].[tbl_api_log]    Script Date: 8/7/2020 9:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_api_log](
	[api_log_id] [int] IDENTITY(1,2) NOT NULL,
	[api_gateway_id] [int] NULL,
	[txn_id] [int] NULL,
	[user_id] [nvarchar](max) NULL,
	[function_ame] [varchar](100) NULL,
	[api_request] [nvarchar](max) NULL,
	[api_response] [nvarchar](max) NULL,
	[partner_txn_id] [varchar](20) NULL,
	[partner_id] [int] NULL,
	[created_UTC_date] [datetime] NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NULL,
	[created_ip] [varchar](20) NULL,
	[created_platform] [varchar](20) NULL,
	[updated_by] [datetime] NULL,
	[updated_UTC_date] [datetime] NULL,
	[updated_local_date] [datetime] NULL,
	[updated_nepali_date] [varchar](10) NULL,
	[updated_ip] [varchar](20) NULL,
 CONSTRAINT [pk_tbl_api_log] PRIMARY KEY CLUSTERED 
(
	[api_log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
