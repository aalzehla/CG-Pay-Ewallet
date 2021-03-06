USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_gateway_detail_audit]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_gateway_detail_audit]
GO
/****** Object:  Table [dbo].[tbl_gateway_detail_audit]    Script Date: 8/7/2020 9:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_gateway_detail_audit](
	[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[gateway_id] [int] NULL,
	[gateway_name] [nvarchar](100) NULL,
	[gateway_balance] [decimal](18, 2) NULL,
	[gateway_country] [varchar](50) NULL,
	[gateway_currency] [varchar](5) NULL,
	[gateway_username] [varchar](100) NULL,
	[gateway_password] [varchar](100) NULL,
	[gateway_access_code] [varchar](550) NULL,
	[gateway_security_code] [varchar](550) NULL,
	[gateway_api_token] [varchar](550) NULL,
	[gateway_url] [varchar](500) NULL,
	[gateway_status] [varchar](10) NULL,
	[created_UTC_date] [datetime] NOT NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NOT NULL,
	[created_ip] [varchar](20) NOT NULL,
	[updated_by] [varchar](50) NULL,
	[updated_UTC_date] [datetime] NULL,
	[updated_local_date] [datetime] NULL,
	[updated_nepali_date] [varchar](10) NULL,
	[updated_ip] [varchar](20) NULL,
	[is_direct_gateway] [char](1) NULL,
	[gateway_type] [varchar](20) NULL,
	[trigger_log_user] [varchar](100) NULL,
	[trigger_action] [varchar](100) NULL,
	[trigger_action_local_Date] [datetime] NULL,
	[trigger_action_UTC_Date] [datetime] NULL,
	[trigger_action_nepali_Date] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
