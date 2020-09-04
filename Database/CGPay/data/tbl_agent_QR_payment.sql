USE [CGPay]
GO

/****** Object:  Table [dbo].[tbl_agent_QR_payment]    Script Date: 11/08/2020 16:51:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_agent_QR_payment]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_agent_QR_payment]
GO

/****** Object:  Table [dbo].[tbl_agent_QR_payment]    Script Date: 11/08/2020 16:51:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_agent_QR_transaction](
	[pid] [int] IDENTITY(1,2) NOT NULL,
	[agent_id] [int] NOT NULL,
	[agent_parent_id] [int] NULL,
	[agent_name] [varchar](200) NULL,
	[agent_code] [varchar](20) NOT NULL,
	[amount] [decimal](18, 2) NOT NULL,
	[service_charge] [decimal](18, 2) NULL,
	[commission_amt] [decimal](18, 2) NULL,
	[pmt_description] [varchar](500) NULL,
	[created_by] [varchar](200) NOT NULL,
	[created_local_date] [datetime] NULL,
	[created_UTC_date] [datetime] NULL,
	[created_nepali_date] [datetime] NULL,
	[created_ip] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[pid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


