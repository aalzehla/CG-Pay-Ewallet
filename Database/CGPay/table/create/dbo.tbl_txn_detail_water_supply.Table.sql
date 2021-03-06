USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_txn_detail_water_supply]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_txn_detail_water_supply]
GO
/****** Object:  Table [dbo].[tbl_txn_detail_water_supply]    Script Date: 8/7/2020 9:43:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_txn_detail_water_supply](
	[txn_water_id] [int] IDENTITY(1,2) NOT NULL,
	[partner_txn_id] [varchar](100) NULL,
	[customer_id] [int] NULL,
	[customer_name] [varchar](100) NULL,
	[customer_mobile_no] [varchar](100) NULL,
	[customer_address] [varchar](100) NULL,
	[bill_area] [varchar](20) NULL,
	[lagat] [varchar](20) NULL,
	[office_code] [varchar](20) NULL,
	[office] [varchar](60) NULL,
	[bill_date_from] [varchar](60) NULL,
	[bill_to] [varchar](60) NULL,
	[bill_amt] [decimal](18, 2) NULL,
	[fine_amt] [decimal](18, 2) NULL,
	[meter_rent] [varchar](60) NULL,
	[discount_amt] [decimal](18, 2) NULL,
	[payable_amt] [decimal](18, 2) NULL,
	[service_charge] [decimal](18, 2) NULL,
	[total_advance_amount] [decimal](18, 2) NULL,
	[total_due_amt] [decimal](18, 2) NULL,
	[txn_id] [int] NULL,
	[paid_amt] [decimal](18, 2) NULL,
	[process_id] [varchar](200) NULL,
	[response_code] [int] NULL,
	[response_message] [varchar](200) NULL,
	[user_id] [int] NULL,
	[created_UTC_date] [datetime] NOT NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NOT NULL,
	[created_ip] [varchar](20) NOT NULL,
	[createdplatform] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[txn_water_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
