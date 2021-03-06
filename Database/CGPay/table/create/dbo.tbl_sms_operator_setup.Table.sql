USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_sms_operator_setup]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_sms_operator_setup]
GO
/****** Object:  Table [dbo].[tbl_sms_operator_setup]    Script Date: 8/7/2020 9:43:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_sms_operator_setup](
	[sms_operator_id] [int] IDENTITY(1,2) NOT NULL,
	[sms_country] [varchar](100) NOT NULL,
	[sms_country_code] [int] NOT NULL,
	[sms_operator_name] [varchar](100) NOT NULL,
	[sms_starting_number] [varchar](100) NOT NULL,
	[sms_primary_gateway] [int] NULL,
	[sms_secondary_gateway] [int] NULL,
	[sms_min_length] [int] NOT NULL,
	[sms_max_length] [int] NOT NULL,
	[sms_created_date] [datetime] NOT NULL,
	[sms_created_by] [varchar](50) NOT NULL,
	[sms_updated_date] [datetime] NULL,
	[sms_updated_by] [varchar](50) NULL,
 CONSTRAINT [pk_dtasmsoperatorsetup] PRIMARY KEY CLUSTERED 
(
	[sms_operator_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
