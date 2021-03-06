USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_capital_market_detail]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_capital_market_detail]
GO
/****** Object:  Table [dbo].[tbl_capital_market_detail]    Script Date: 8/7/2020 9:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_capital_market_detail](
	[capital_id_no] [int] IDENTITY(1,2) NOT NULL,
	[demat_account_number] [nvarchar](20) NULL,
	[service_type] [nvarchar](20) NULL,
	[account_name] [varchar](500) NULL,
	[mobile_number] [varchar](15) NULL,
	[duration] [varchar](5) NULL,
	[bill_amount] [decimal](18, 2) NULL,
	[service_charge] [decimal](18, 2) NULL,
	[amount] [decimal](18, 2) NULL,
	[process_id] [nvarchar](max) NULL,
	[created_UTC_dat] [datetime] NULL,
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
	[txn_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[capital_id_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
