USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_gateway_balance]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_gateway_balance]
GO
/****** Object:  Table [dbo].[tbl_gateway_balance]    Script Date: 8/7/2020 9:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_gateway_balance](
	[gtw_balance_id] [int] IDENTITY(1,2) NOT NULL,
	[gateway_id] [int] NULL,
	[balance_type] [char](5) NULL,
	[amount] [decimal](18, 2) NULL,
	[currency_code] [char](3) NULL,
	[bank_id] [int] NULL,
	[bank_name] [varchar](100) NULL,
	[admin_remarks] [varchar](5000) NULL,
	[created_UTC_date] [datetime] NOT NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NOT NULL,
	[created_ip] [varchar](20) NOT NULL,
	[transaction_date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[gtw_balance_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
