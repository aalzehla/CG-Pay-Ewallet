USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_verification_sent]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_verification_sent]
GO
/****** Object:  Table [dbo].[tbl_verification_sent]    Script Date: 8/7/2020 9:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_verification_sent](
	[vid] [int] IDENTITY(1,2) NOT NULL,
	[UserId] [int] NULL,
	[username] [varchar](100) NULL,
	[Mobile_Number] [varchar](10) NULL,
	[Email_address] [varchar](100) NULL,
	[full_Name] [varchar](100) NULL,
	[verification_code] [varchar](100) NULL,
	[verification_Status] [char](100) NULL,
	[generate_date_time] [datetime] NULL,
	[send_date_time] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[vid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
