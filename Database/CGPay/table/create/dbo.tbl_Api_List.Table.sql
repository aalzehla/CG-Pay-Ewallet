USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_Api_List]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_Api_List]
GO
/****** Object:  Table [dbo].[tbl_Api_List]    Script Date: 8/7/2020 9:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_Api_List](
	[ApiId] [int] IDENTITY(1,100) NOT NULL,
	[function_Name] [varchar](200) NULL,
	[code] [varchar](20) NULL,
	[function_description] [varchar](50) NULL,
	[Status] [char](3) NULL,
	[Created_by] [varchar](20) NULL,
	[created_local_Date] [datetime] NULL,
	[created_UTC_date] [datetime] NULL,
	[created_nepali_date] [varchar](50) NULL,
	[updated_by] [varchar](100) NULL,
	[updated_local_Date] [datetime] NULL,
	[updated_UTC_Date] [datetime] NULL,
	[updated_nepali_date] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ApiId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
