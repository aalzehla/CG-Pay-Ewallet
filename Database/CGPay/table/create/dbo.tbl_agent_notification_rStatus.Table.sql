USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_agent_notification_rStatus]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_agent_notification_rStatus]
GO
/****** Object:  Table [dbo].[tbl_agent_notification_rStatus]    Script Date: 8/7/2020 9:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_agent_notification_rStatus](
	[r_notification_id] [int] IDENTITY(1,2) NOT NULL,
	[notification_id] [int] NOT NULL,
	[agent_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
	[created_by] [varchar](200) NULL,
	[created_UTC_date] [datetime] NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[r_notification_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
