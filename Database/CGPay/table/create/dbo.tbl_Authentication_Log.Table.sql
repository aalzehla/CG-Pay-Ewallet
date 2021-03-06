USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_Authentication_Log]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_Authentication_Log]
GO
/****** Object:  Table [dbo].[tbl_Authentication_Log]    Script Date: 8/7/2020 9:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_Authentication_Log](
	[sno] [int] IDENTITY(1,2) NOT NULL,
	[User_Id] [varchar](50) NULL,
	[Authentication_Log] [varchar](150) NULL,
	[Device_Id] [varchar](50) NULL,
	[Authentication_local_Date] [datetime] NULL,
	[Authentication_UTC_Date] [datetime] NULL,
	[Logout_local_Date] [datetime] NULL,
	[Logout_UTC_Date] [datetime] NULL,
	[Status] [varchar](10) NULL,
	[Txn_Id] [varchar](50) NULL,
 CONSTRAINT [PK_tbl_Authentication_Log] PRIMARY KEY CLUSTERED 
(
	[sno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
