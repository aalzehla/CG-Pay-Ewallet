/****** Object:  Table [dbo].[tbl_agent_card_management_audit]    Script Date: 5/31/2020 11:37:58 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_agent_card_management_audit]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_agent_card_management_audit]
GO

/****** Object:  Table [dbo].[tbl_agent_card_management_audit]    Script Date: 5/31/2020 11:37:58 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_agent_card_management_audit](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[card_id] [int],
	[agent_id] [int] NULL,
	[user_id] [int] NULL,
	[user_name] [varchar](50) NULL,
	[card_no] [varchar](100) NULL,
	[card_uid] [varchar](50) NULL,
	[card_type] [varchar](50) NULL,
	[card_txn_type] [varchar](50) NULL,
	[card_issued_date] [datetime] NULL,
	[card_expiry_date] [datetime] NULL,
	[is_active] [char](1) NULL,
	[created_by] [varchar](50) NULL,
	[created_local_date] [datetime] NULL,
	[created_utc_date] [datetime] NULL,
	[created_nepali_date] [varchar](50) NULL,
	[updated_by] [varchar](50) NULL,
	[updated_local_date] [datetime] NULL,
	[updated_utc_date] [datetime] NULL,
	[updated_nepali_date] [varchar](50) NULL,
	[Amount] [decimal](18, 2) NULL,
	[trigger_log_user] [varchar](512) NULL,
	[trigger_action] [varchar](512) NULL,
	[trigger_action_local_Date] [datetime] NULL,
	[trigger_action_UTC_Date] [datetime] NULL,
	[trigger_action_nepali_date] [varchar](512) NULL,
PRIMARY KEY CLUSTERED 
(
	[card_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


