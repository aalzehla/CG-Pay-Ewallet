USE [WePayNepal]
GO
ALTER TABLE [dbo].[tbl_message_templates] DROP CONSTRAINT [DF_tbl_Message_Templates_Is_Deleted]
GO
/****** Object:  Table [dbo].[tbl_message_templates]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_message_templates]
GO
/****** Object:  Table [dbo].[tbl_message_templates]    Script Date: 8/7/2020 9:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_message_templates](
	[msg_template_Id] [int] IDENTITY(1,2) NOT NULL,
	[msg_slug] [nvarchar](200) NOT NULL,
	[msg_title] [nvarchar](500) NULL,
	[message] [nvarchar](max) NOT NULL,
	[contains] [nvarchar](500) NULL,
	[Remarks] [nvarchar](1000) NULL,
	[created_UTC_date] [datetime] NOT NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NULL,
	[created_ip] [varchar](20) NULL,
	[updated_by] [varchar](50) NULL,
	[updated_UTC_date] [datetime] NULL,
	[updated_local_date] [datetime] NULL,
	[updated_nepali_date] [varchar](10) NULL,
	[updated_ip] [varchar](20) NULL,
	[Is_Deleted] [nvarchar](5) NULL,
PRIMARY KEY CLUSTERED 
(
	[msg_template_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tbl_message_templates] ADD  CONSTRAINT [DF_tbl_Message_Templates_Is_Deleted]  DEFAULT (N'N') FOR [Is_Deleted]
GO
