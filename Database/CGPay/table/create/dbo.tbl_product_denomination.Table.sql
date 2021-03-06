USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_product_denomination]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_product_denomination]
GO
/****** Object:  Table [dbo].[tbl_product_denomination]    Script Date: 8/7/2020 9:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_product_denomination](
	[denomination_id] [int] IDENTITY(1,2) NOT NULL,
	[product_id] [int] NULL,
	[amount] [money] NULL,
	[topup_value] [money] NULL,
	[bonus_amount] [money] NULL,
	[denomination_label] [varchar](500) NULL,
	[denomination_status] [varchar](3) NULL,
	[created_UTC_date] [datetime] NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NULL,
	[created_ip] [varchar](20) NULL,
	[updated_by] [varchar](50) NULL,
	[updated_UTC_date] [datetime] NULL,
	[updated_local_date] [datetime] NULL,
	[updated_nepali_date] [varchar](10) NULL,
	[updated_ip] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[denomination_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
