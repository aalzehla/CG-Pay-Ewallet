USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_payment_gateway_detail_audit]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_payment_gateway_detail_audit]
GO
/****** Object:  Table [dbo].[tbl_payment_gateway_detail_audit]    Script Date: 8/7/2020 9:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_payment_gateway_detail_audit](
	[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[pmt_gateway_id] [int] NULL,
	[pmt_gateway_name] [varchar](200) NOT NULL,
	[currency] [char](3) NOT NULL,
	[balance] [money] NOT NULL,
	[user_name] [varchar](50) NOT NULL,
	[password] [nvarchar](100) NOT NULL,
	[access_code] [varchar](50) NULL,
	[security_code] [nvarchar](100) NULL,
	[call_api_url] [varchar](500) NULL,
	[status_api_url] [varchar](500) NULL,
	[logo_file_name] [varchar](500) NULL,
	[display_order] [int] NULL,
	[status] [varchar](50) NOT NULL,
	[type] [varchar](50) NULL,
	[funding_bank_id] [int] NULL,
	[trigger_log_user] [varchar](100) NULL,
	[trigger_action] [varchar](100) NULL,
	[trigger_action_local_date] [datetime] NULL,
	[trigger_action_UTC_date] [datetime] NULL,
	[trigger_action_nepali_date] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
