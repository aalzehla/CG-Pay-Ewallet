USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_gateway_products]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_gateway_products]
GO
/****** Object:  Table [dbo].[tbl_gateway_products]    Script Date: 8/7/2020 9:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_gateway_products](
	[gtw_pid] [int] IDENTITY(1,2) NOT NULL PRIMARY KEY,
	[gateway_id] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[commission_value] [float] NULL,
	[commission_type] [varchar](3) NULL,
	[commission_earned] [float] NULL,
	[created_UTC_date] [datetime] NOT NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NOT NULL,
	[created_ip] [varchar](20) NOT NULL,
	[updated_by] [varchar](50) NULL,
	[updated_UTC_date] [datetime] NULL,
	[updated_local_date] [datetime] NULL,
	[updated_nepali_date] [varchar](10) NULL,
	[updated_ip] [varchar](20) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
