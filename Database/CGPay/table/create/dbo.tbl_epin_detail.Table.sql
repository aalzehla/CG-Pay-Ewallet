USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_epin_detail]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_epin_detail]
GO
/****** Object:  Table [dbo].[tbl_epin_detail]    Script Date: 8/7/2020 9:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_epin_detail](
	[epin_id] [int] IDENTITY(1,2) NOT NULL,
	[txn_id] [int] NULL,
	[product_id] [int] NOT NULL,
	[epin_amount] [decimal](18, 2) NOT NULL,
	[serial_no] [varchar](50) NOT NULL,
	[pin_no] [nvarchar](100) NOT NULL,
	[expiry_date] [datetime] NULL,
	[expiry_nepali_date] [varchar](30) NULL,
	[status] [varchar](20) NULL,
	[gateway_txn_id] [varchar](100) NULL,
	[batch_id] [varchar](250) NULL,
	[process_id] [varchar](100) NULL,
	[created_UTC_date] [datetime] NOT NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NOT NULL,
	[created_ip] [varchar](20) NOT NULL,
	[updated_by] [varchar](50) NULL,
	[updated_UTC_date] [datetime] NULL,
	[updated_local_date] [datetime] NULL,
	[updated_nepali_date] [varchar](10) NULL,
	[updated_ip] [varchar](20) NULL,
 CONSTRAINT [pk_tbl_epin_detail] PRIMARY KEY CLUSTERED 
(
	[epin_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
