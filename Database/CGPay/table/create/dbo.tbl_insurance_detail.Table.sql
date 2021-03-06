USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_insurance_detail]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_insurance_detail]
GO
/****** Object:  Table [dbo].[tbl_insurance_detail]    Script Date: 8/7/2020 9:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_insurance_detail](
	[insurance_id_no] [int] IDENTITY(1,2) NOT NULL,
	[insurance_policy_number] [nvarchar](max) NULL,
	[insurance_document_number] [varchar](100) NULL,
	[policy_holder_name] [nvarchar](max) NULL,
	[date_of_birth] [varchar](max) NULL,
	[bill_amount] [decimal](18, 2) NULL,
	[insurance_amount] [decimal](18, 2) NULL,
	[extra_field1] [nvarchar](max) NULL,
	[extra_field2] [nvarchar](max) NULL,
	[extra_field3] [nvarchar](max) NULL,
	[extra_field4] [nvarchar](max) NULL,
	[extra_field5] [nvarchar](max) NULL,
	[extra_field6] [nvarchar](max) NULL,
	[extra_field7] [nvarchar](max) NULL,
	[process_id] [nvarchar](max) NULL,
	[created_UTC_date] [datetime] NOT NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NOT NULL,
	[created_ip] [varchar](20) NOT NULL,
	[created_platform] [varchar](100) NULL,
	[updated_by] [varchar](50) NULL,
	[updated_UTC_date] [datetime] NULL,
	[updated_local_date] [datetime] NULL,
	[updated_nepali_date] [varchar](10) NULL,
	[updated_ip] [varchar](20) NULL,
	[txnid] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[insurance_id_no] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
