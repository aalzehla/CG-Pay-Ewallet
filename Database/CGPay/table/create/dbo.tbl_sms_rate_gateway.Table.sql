USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_sms_rate_gateway]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_sms_rate_gateway]
GO
/****** Object:  Table [dbo].[tbl_sms_rate_gateway]    Script Date: 8/7/2020 9:43:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_sms_rate_gateway](
	[sms_gtw_rate_id] [int] IDENTITY(1,2) NOT NULL,
	[sms_gateway_id] [int] NOT NULL,
	[sms_country] [varchar](100) NOT NULL,
	[sms_operator_id] [int] NULL,
	[sms_rate] [float] NOT NULL,
	[sms_created_by] [varchar](20) NOT NULL,
	[sms_created_date] [datetime] NOT NULL,
	[sms_updated_by] [varchar](50) NULL,
	[sms_updated_date] [datetime] NULL,
 CONSTRAINT [pk_dtssmsrategateway] PRIMARY KEY CLUSTERED 
(
	[sms_gtw_rate_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
