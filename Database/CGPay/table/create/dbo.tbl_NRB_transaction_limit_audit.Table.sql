USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_NRB_transaction_limit_audit]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_NRB_transaction_limit_audit]
GO
/****** Object:  Table [dbo].[tbl_NRB_transaction_limit_audit]    Script Date: 8/7/2020 9:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_NRB_transaction_limit_audit](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[txnl_Id] [int] NULL,
	[KYC_Status] [varchar](50) NULL,
	[txn_type] [varchar](512) NULL,
	[transaction_limit_max] [decimal](18, 2) NULL,
	[transaction_daily_limit_max] [decimal](18, 2) NULL,
	[transaction_monthly_limit_max] [decimal](18, 2) NULL,
	[created_by] [varchar](512) NULL,
	[created_local_date] [datetime] NULL,
	[created_UTC_date] [datetime] NULL,
	[updated_by] [varchar](512) NULL,
	[updated_local_date] [datetime] NULL,
	[updated_UTC_date] [datetime] NULL,
	[trigger_log_user] [varchar](512) NULL,
	[trigger_action] [varchar](512) NULL,
	[trigger_action_local_Date] [datetime] NULL,
	[trigger_action_UTC_Date] [datetime] NULL,
	[trigger_action_nepali_date] [varchar](512) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
