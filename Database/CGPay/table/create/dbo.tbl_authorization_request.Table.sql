USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_authorization_request]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_authorization_request]
GO
/****** Object:  Table [dbo].[tbl_authorization_request]    Script Date: 8/7/2020 9:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_authorization_request](
	[id] [int] IDENTITY(1,2) NOT NULL,
	[request_user] [varchar](200) NULL,
	[request_ip] [varchar](200) NULL,
	[device_info] [varchar](2000) NULL,
	[authorization_scheme] [varchar](20) NULL,
	[authorization_token] [varchar](1000) NULL,
	[encryption_key] [varchar](1000) NULL,
	[expiry_ts] [datetime] NULL,
	[status] [char](1) NULL,
	[created_by] [varchar](100) NULL,
	[created_ts] [datetime] NULL,
	[updated_by] [varchar](100) NULL,
	[updated_ts] [datetime] NULL,
	[version_Id] [varchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
