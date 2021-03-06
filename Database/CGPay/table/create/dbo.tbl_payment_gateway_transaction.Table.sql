USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_payment_gateway_transaction]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_payment_gateway_transaction]
GO
/****** Object:  Table [dbo].[tbl_payment_gateway_transaction]    Script Date: 8/7/2020 9:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_payment_gateway_transaction](
	[pmt_txn_id] [int] IDENTITY(10000,2) NOT NULL,
	[amount] [decimal](18, 2) NULL,
	[service_charge] [decimal](18, 2) NULL,
	[total_amount] [decimal](18, 2) NULL,
	[status] [varchar](20) NULL,
	[pmt_gateway_id] [int] NULL,
	[pmt_gateway_name] [varchar](100) NULL,
	[pmt_gateway_txn_id] [varchar](20) NULL,
	[gateway_timestamp] [varchar](20) NULL,
	[card_no] [varchar](20) NULL,
	[card_expiry_date] [date] NULL,
	[card_issuer] [varchar](100) NULL,
	[name_on_card] [varchar](100) NULL,
	[gateway_status] [varchar](50) NULL,
	[remarks] [varchar](100) NULL,
	[email] [varchar](100) NULL,
	[mobile] [varchar](50) NULL,
	[agent_id] [int] NULL,
	[user_id] [int] NULL,
	[user_name] [varchar](100) NULL,
	[process_id] [varchar](max) NULL,
	[gateway_process_id] [varchar](max) NULL,
	[type] [varchar](50) NULL,
	[created_UTC_date] [datetime] NOT NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NOT NULL,
	[createdplatform] [nvarchar](max) NULL,
	[updated_by] [varchar](50) NULL,
	[updated_UTC_date] [datetime] NULL,
	[updated_local_date] [datetime] NULL,
	[updated_nepali_date] [varchar](10) NULL,
	[updated_ip] [varchar](20) NULL,
	[error_code] [varchar](10) NULL,
	[created_ip] [varchar](20) NULL,
 CONSTRAINT [pk_tbl_payment_gateway_transaction] PRIMARY KEY CLUSTERED 
(
	[pmt_txn_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
