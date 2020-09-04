USE [WePayNepal]
GO

/****** Object:  Table [dbo].[tbl_agent_balance]    Script Date: 06/05/2020 18:46:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_agent_balance]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_agent_balance]
GO

/****** Object:  Table [dbo].[tbl_agent_balance]    Script Date: 06/05/2020 18:46:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_agent_balance](
	[balance_id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[agent_id] [varchar](20) NULL,
	[agent_parent_id] [int] NULL,
	[agent_name] [varchar](50) NULL,
	[amount] [decimal](18, 2) NULL,
	[currency_code] [char](3) NULL,
	[agent_remarks] [varchar](5000) NULL,
	[user_id] [varchar](50) NULL,
	[txn_type] [varchar](20) NULL,
	[txn_mode] [char](3) NULL,
	[bank_id] [int] NULL,
	[bank_name] [varchar](100) NULL,	
	[txn_id] [varchar](20) NULL,
	[txn_dt_ts] [datetime] NULL,
	[pmt_gateway_id] [int] NULL,
	[pmt_gateway_txn_id] [varchar](20) NULL,
	[remit_pay_id] [int] NULL,
	[remit_ref_no] [varchar](10) NULL,
	[fund_load_reward] [int] NULL,
	[created_UTC_date] [datetime] NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NOT NULL,
	[created_ip] [varchar](20) NULL,
	[created_platform] [varchar](20) NULL,
	[updated_by] [datetime] NULL,
	[updated_UTC_date] [datetime] NULL,
	[updated_local_date] [datetime] NULL,
	[updated_nepali_date] [varchar](10) NULL,
	[updated_ip] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[balance_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


