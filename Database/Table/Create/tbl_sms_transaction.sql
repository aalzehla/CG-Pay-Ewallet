USE [CGPay]
GO

/****** Object:  Table [dbo].[tbl_sms_transaction]    Script Date: 20/08/2020 11:35:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_sms_transaction]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_sms_transaction]
GO

/****** Object:  Table [dbo].[tbl_sms_transaction]    Script Date: 20/08/2020 11:35:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_sms_transaction](
	[sms_txn_id] [int] IDENTITY(1,1) NOT NULL,
	[country] [varchar](100) NULL,
	[agent_id] [int] NULL,
	[sms_operator_id] [int] NULL,
	[sms_operator] [varchar](200) NULL,
	[sms_destination_no] [varchar](20) NOT NULL,
	[sms_sender_id] [varchar](20) NULL,
	[sms_message_type] [int] NULL,
	[message] [nvarchar](max) NOT NULL,
	[status] [varchar](20) NOT NULL,
	[sms_gateway_message_id] [varchar](512) NULL,
	[sms_gateway_id] [varchar](512) NULL,
	[sms_gateway_response] [nvarchar](max) NULL,
	[created_by] [varchar](120) NULL,
	[created_date] [datetime] NULL,
	[process_id] [varchar](100) NULL,
	[ip_address] [varchar](50) NULL,
	[updated_by] [varchar](120) NULL,
	[updated_date] [datetime] NULL,
 CONSTRAINT [pk_tbl_sms_transaction] PRIMARY KEY CLUSTERED 
(
	[sms_txn_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


