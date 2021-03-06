USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_agent_notification]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_agent_notification]
GO
/****** Object:  Table [dbo].[tbl_agent_notification]    Script Date: 8/7/2020 9:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_agent_notification](
	[notification_id] [int] IDENTITY(1,2) NOT NULL,
	[notification_subject] [varchar](100) NULL,
	[notification_subtitle] [varchar](100) NULL,
	[notification_body] [varchar](max) NULL,
	[notification_image_url] [varchar](200) NULL,
	[action_id] [varchar](200) NULL,
	[notification_type] [varchar](200) NULL,
	[notification_importance_level] [int] NULL,
	[notification_status] [varchar](10) NULL,
	[is_background] [char](1) NULL,
	[notification_to] [varchar](50) NULL,
	[agent_id] [int] NULL,
	[user_id] [int] NULL,
	[created_UTC_date] [datetime] NOT NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](512) NULL,
	[updated_by] [datetime] NULL,
	[updated_UTC_date] [datetime] NULL,
	[updated_local_date] [datetime] NULL,
	[updated_nepali_date] [varchar](10) NULL,
	[txn_id] [int] NULL,
	[read_status] [char](1) NULL,
	[txn_status_id] [int] NULL,
	[txn_status] [varchar](20) NULL,
	[Remaining_Balance] [decimal](18, 2) NULL,
	[data_payload] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[notification_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
