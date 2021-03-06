USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_transaction]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_transaction]
GO
/****** Object:  Table [dbo].[tbl_transaction]    Script Date: 8/7/2020 9:43:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_transaction](
	[txn_id] [bigint] IDENTITY(1,2) NOT NULL,
	[product_id] [int] NULL,
	[product_label] [varchar](120) NULL,
	[txn_type_id] [int] NULL,
	[company_id] [int] NULL,
	[partner_txn_id] [varchar](50) NULL,
	[grand_parent_id] [int] NULL,
	[parent_id] [int] NULL,
	[agent_id] [int] NULL,
	[subscriber_no] [varchar](50) NULL,
	[amount] [decimal](18, 2) NOT NULL,
	[service_charge] [decimal](18, 2) NULL,
	[bonus_amt] [decimal](18, 2) NULL,
	[status] [varchar](20) NOT NULL,
	[user_id] [varchar](100) NULL,
	[created_UTC_date] [datetime] NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NULL,
	[created_ip] [varchar](20) NULL,
	[created_platform] [varchar](20) NULL,
	[updated_by] [varchar](50) NULL,
	[updated_UTC_date] [datetime] NULL,
	[updated_local_date] [datetime] NULL,
	[updated_nepali_date] [varchar](10) NULL,
	[updated_ip] [varchar](20) NULL,
	[gateway_id] [int] NULL,
	[gateway_txn_id] [varchar](100) NULL,
	[gateway_bill_id] [varchar](100) NULL,
	[is_auto_commission_agent] [char](1) NULL,
	[is_auto_commission_parent] [char](1) NULL,
	[is_auto_commission_gparent] [char](1) NULL,
	[admin_commission] [int] NULL,
	[manual_reprocessed] [char](1) NULL,
	[is_reconciled] [char](1) NULL,
	[reconcile_count] [int] NULL,
	[batch_id] [int] NULL,
	[batch_txn_id] [int] NULL,
	[process_id] [varchar](200) NULL,
	[admin_remarks] [varchar](1000) NULL,
	[agent_remarks] [varchar](500) NULL,
	[last_agent_balance] [decimal](18, 2) NULL,
	[admin_cost_amount] [decimal](18, 2) NULL,
	[status_code] [int] NULL,
	[json_data] [nvarchar](max) NULL,
	[otp_code] [varchar](30) NULL,
 CONSTRAINT [pk_tbl_transaction] PRIMARY KEY CLUSTERED 
(
	[txn_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
