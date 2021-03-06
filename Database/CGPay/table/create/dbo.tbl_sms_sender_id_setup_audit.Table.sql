USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_sms_sender_id_setup_audit]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_sms_sender_id_setup_audit]
GO
/****** Object:  Table [dbo].[tbl_sms_sender_id_setup_audit]    Script Date: 8/7/2020 9:43:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_sms_sender_id_setup_audit](
	[sender_id_sno] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[agent_id] [int] NOT NULL,
	[sender_id] [varchar](50) NOT NULL,
	[created_UTC_date] [datetime] NOT NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NOT NULL,
	[created_ip] [varchar](20) NOT NULL,
	[updated_by] [varchar](50) NULL,
	[updated_UTC_date] [datetime] NULL,
	[updated_local_date] [datetime] NULL,
	[updated_nepali_date] [varchar](10) NULL,
	[updated_ip] [varchar](20) NULL,
	[trigger_loguser] [varchar](100) NULL,
	[trigger_action] [varchar](100) NULL,
	[trigger_action_local_datel] [datetime] NULL,
	[trigger_action_UTC_date] [datetime] NULL,
	[trigger_action_nepali_date] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
