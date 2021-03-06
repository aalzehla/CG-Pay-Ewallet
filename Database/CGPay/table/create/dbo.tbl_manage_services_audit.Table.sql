USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_manage_services_audit]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_manage_services_audit]
GO
/****** Object:  Table [dbo].[tbl_manage_services_audit]    Script Date: 8/7/2020 9:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_manage_services_audit](
	[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[product_id] [int] NULL,
	[txn_type_id] [int] NULL,
	[txn_type] [varchar](50) NULL,
	[company_id] [int] NULL,
	[company] [varchar](50) NULL,
	[product_type_id] [int] NULL,
	[product_type] [varchar](50) NULL,
	[product_label] [varchar](100) NULL,
	[product_logo] [varchar](100) NULL,
	[product_service_info] [nvarchar](max) NULL,
	[product_category] [varchar](200) NULL,
	[subscriber_regex] [varchar](100) NULL,
	[min_denomination_amount] [decimal](18, 2) NULL,
	[max_denomination_amount] [decimal](18, 2) NULL,
	[primary_gateway] [int] NULL,
	[secondary_gateway] [int] NULL,
	[status] [varchar](20) NULL,
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
	[trigger_log_user] [varchar](100) NULL,
	[trigger_action] [varchar](100) NULL,
	[trigger_action_local_Date] [datetime] NULL,
	[trigger_action_UTC_Date] [datetime] NULL,
	[trigger_action_nepali_Date] [varchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
