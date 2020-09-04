USE [WePayNepal]
GO

/****** Object:  Table [dbo].[tbl_gateway_detail]    Script Date: 06/05/2020 18:53:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_gateway_detail]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_gateway_detail]
GO

/****** Object:  Table [dbo].[tbl_gateway_detail]    Script Date: 06/05/2020 18:53:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_gateway_detail](
	[gateway_id] [int] IDENTITY(1,1) NOT NULL,
	[gateway_name] [nvarchar](100) NULL,
	[gateway_balance] [varchar](10) NULL,
	[gateway_country] [varchar](50) NULL,
	[gateway_currency] [varchar](5) NULL,
	[gateway_username] [varchar](500) NULL,
	[gateway_password] [varchar](500) NULL,
	[gateway_access_code] [varchar](550) NULL,
	[gateway_security_code] [varchar](550) NULL,
	[gateway_api_token] [varchar](550) NULL,
	[gateway_url] [varchar](500) NULL,
	[gateway_status] [char](1) NULL,
	[is_direct_gateway] [char](1) NULL,
	[gateway_type] [char](1) NULL,
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
 CONSTRAINT [PK__tbl_gate__0AF5B00B3562DEA3] PRIMARY KEY CLUSTERED 
(
	[gateway_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


