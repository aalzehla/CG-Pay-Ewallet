USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_products_gateway]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_products_gateway]
GO
/****** Object:  Table [dbo].[tbl_products_gateway]    Script Date: 8/7/2020 9:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_products_gateway](
	[p_gtw_id] [int] IDENTITY(1,2) NOT NULL,
	[product_id] [int] NULL,
	[gateway_id] [int] NULL,
	[created_by] [varchar](100) NULL,
	[created_local_date] [datetime] NULL,
	[created_UTC_date] [datetime] NULL,
	[created_nepali_date] [varchar](20) NULL,
	[created_ip] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[p_gtw_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
