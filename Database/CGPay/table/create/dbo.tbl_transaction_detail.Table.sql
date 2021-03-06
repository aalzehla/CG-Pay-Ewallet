USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_transaction_detail]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_transaction_detail]
GO
/****** Object:  Table [dbo].[tbl_transaction_detail]    Script Date: 8/7/2020 9:43:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_transaction_detail](
	[txn_detail_id] [int] IDENTITY(1,2) NOT NULL,
	[txn_id] [bigint] NULL,
	[gateway_amount] [decimal](18, 2) NOT NULL,
	[mobile] [varchar](100) NULL,
	[customer_name] [nvarchar](1000) NULL,
	[customer_id] [nvarchar](100) NULL,
	[session_id] [nvarchar](100) NULL,
	[gateway_token] [nvarchar](100) NULL,
	[plan_id] [nvarchar](100) NULL,
	[plan_name] [nvarchar](100) NULL,
	[invoice_id] [nvarchar](100) NULL,
	[extra_field1] [nvarchar](max) NULL,
	[extra_field2] [varchar](200) NULL,
	[extra_field3] [varchar](200) NULL,
	[extra_field4] [varchar](200) NULL,
	[detail_remarks] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[txn_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[txn_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
