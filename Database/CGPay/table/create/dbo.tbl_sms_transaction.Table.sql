USE [WePayNepal]
GO
ALTER TABLE [dbo].[tbl_sms_transaction] DROP CONSTRAINT [df_tbl_sms_transaction_sms_reseller_rate]
GO
ALTER TABLE [dbo].[tbl_sms_transaction] DROP CONSTRAINT [df_tbl_sms_transaction_sms_message_type]
GO
/****** Object:  Table [dbo].[tbl_sms_transaction]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_sms_transaction]
GO
/****** Object:  Table [dbo].[tbl_sms_transaction]    Script Date: 8/7/2020 9:43:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_sms_transaction](
	[sms_txn_id] [int] IDENTITY(1,2) NOT NULL,
	[country] [varchar](100) NULL,
	[sms_operator_id] [int] NULL,
	[sms_destination] [varchar](20) NOT NULL,
	[sms_sender_id] [varchar](20) NULL,
	[sms_message_type] [int] NULL,
	[message] [nvarchar](max) NOT NULL,
	[sms_gateway_message_id] [varchar](100) NULL,
	[sms_cost_rate] [float] NULL,
	[sms_currency] [varchar](5) NULL,
	[sms_reseller_rate] [float] NULL,
	[client_rate] [float] NULL,
	[status] [varchar](20) NOT NULL,
	[partner_id] [varchar](50) NULL,
	[agent_id] [int] NOT NULL,
	[created_by] [varchar](20) NOT NULL,
	[created_date] [datetime] NOT NULL,
	[sms_gateway_id] [int] NULL,
	[process_id] [varchar](100) NULL,
	[ip_address] [varchar](50) NULL,
	[msg_admin] [varchar](200) NULL,
	[msg_reseller] [varchar](200) NULL,
	[msg_client] [varchar](200) NULL,
	[code] [varchar](50) NULL,
	[batch_id] [int] NULL,
	[reconcile_status] [char](1) NULL,
	[updated_date] [datetime] NULL,
 CONSTRAINT [pk_dtasmstransaction] PRIMARY KEY CLUSTERED 
(
	[sms_txn_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tbl_sms_transaction] ADD  CONSTRAINT [df_tbl_sms_transaction_sms_message_type]  DEFAULT ((0)) FOR [sms_message_type]
GO
ALTER TABLE [dbo].[tbl_sms_transaction] ADD  CONSTRAINT [df_tbl_sms_transaction_sms_reseller_rate]  DEFAULT ((0.0)) FOR [sms_reseller_rate]
GO
