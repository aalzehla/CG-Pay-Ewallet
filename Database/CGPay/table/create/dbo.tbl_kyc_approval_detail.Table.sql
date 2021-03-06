USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_kyc_approval_detail]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_kyc_approval_detail]
GO
/****** Object:  Table [dbo].[tbl_kyc_approval_detail]    Script Date: 8/7/2020 9:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_kyc_approval_detail](
	[kyc_approval_id] [int] IDENTITY(1,2) NOT NULL,
	[agent_id] [varchar](100) NULL,
	[action_status_id] [int] NULL,
	[action_status] [varchar](20) NULL,
	[created_UTC_date] [datetime] NOT NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NOT NULL,
	[created_ip] [varchar](20) NULL,
	[remarks] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[kyc_approval_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
