USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_transaction_commission]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_transaction_commission]
GO
/****** Object:  Table [dbo].[tbl_transaction_commission]    Script Date: 8/7/2020 9:43:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_transaction_commission](
	[txn_comm_id] [int] IDENTITY(1,2) NOT NULL,
	[txn_id] [bigint] NOT NULL,
	[agent_id] [int] NOT NULL,
	[agent_commission] [decimal](18, 2) NULL,
	[parent_commission] [decimal](18, 2) NULL,
	[grand_parent_commission] [decimal](18, 2) NULL,
	[referal_id] [int] NULL,
	[referal_commission] [decimal](18, 2) NULL,
	[txn_reward_point] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[txn_comm_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
