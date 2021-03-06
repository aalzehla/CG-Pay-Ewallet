USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_transaction_detail_cards]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_transaction_detail_cards]
GO
/****** Object:  Table [dbo].[tbl_transaction_detail_cards]    Script Date: 8/7/2020 9:43:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_transaction_detail_cards](
	[card_txn_id] [int] IDENTITY(1,2) NOT NULL,
	[txn_id] [int] NULL,
	[Card_no] [varchar](16) NULL,
	[Card_Type_id] [int] NULL,
	[Card_type] [varchar](20) NULL,
	[Card_amount] [decimal](18, 2) NULL,
	[created_by] [varchar](512) NULL,
	[created_local_date] [datetime] NULL,
	[created_utc_date] [datetime] NULL,
	[created_nepali_date] [varchar](512) NULL,
PRIMARY KEY CLUSTERED 
(
	[card_txn_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
