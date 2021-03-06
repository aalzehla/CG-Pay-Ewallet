USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_API_Response_Code]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_API_Response_Code]
GO
/****** Object:  Table [dbo].[tbl_API_Response_Code]    Script Date: 8/7/2020 9:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_API_Response_Code](
	[RCode_Id] [int] IDENTITY(1,1) NOT NULL,
	[Response_Code] [int] NULL,
	[Response_Message] [varchar](max) NULL,
	[Created_by] [varchar](50) NULL,
	[Created_ts] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[updated_ts] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[RCode_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
