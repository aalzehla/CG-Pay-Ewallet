USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_funding_bank_account]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_funding_bank_account]
GO
/****** Object:  Table [dbo].[tbl_funding_bank_account]    Script Date: 8/7/2020 9:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_funding_bank_account](
	[funding_bank_id] [int] IDENTITY(1,2) NOT NULL,
	[funding_bank_name] [varchar](200) NULL,
	[funding_bank_branch] [varchar](75) NULL,
	[funding_account_number] [varchar](25) NULL,
	[bank_status] [char](1) NULL,
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
	[for_distributor] [char](5) NULL,
PRIMARY KEY CLUSTERED 
(
	[funding_bank_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
