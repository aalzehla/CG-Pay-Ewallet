USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_agent_card_management]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_agent_card_management]
GO
/****** Object:  Table [dbo].[tbl_agent_card_management]    Script Date: 8/7/2020 9:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_agent_card_management](
	[card_id] [int] IDENTITY(1,2) NOT NULL,
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
	[is_transfer] [char](1) NULL,
	[transfer_to] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[card_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[card_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
