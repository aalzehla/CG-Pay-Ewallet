USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_User_registration]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_User_registration]
GO
/****** Object:  Table [dbo].[tbl_User_registration]    Script Date: 8/7/2020 9:43:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_User_registration](
	[UserId] [int] IDENTITY(1,2) NOT NULL PRIMARY KEY,
	[Agent_Mobile_Number] [varchar](20) NULL,
	[Agent_Email_address] [varchar](40) NULL,
	[Agent_full_Name] [varchar](50) NULL,
	[Agent_verification_code] [varchar](30) NULL,
	[Agent_verification_Status] [char](10) NULL,
	[generate_date_time] [datetime] NULL,
	[send_date_time] [datetime] NULL,
	[username] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
