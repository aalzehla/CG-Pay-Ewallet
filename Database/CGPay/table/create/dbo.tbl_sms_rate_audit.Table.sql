USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_sms_rate_audit]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_sms_rate_audit]
GO
/****** Object:  Table [dbo].[tbl_sms_rate_audit]    Script Date: 8/7/2020 9:43:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_sms_rate_audit](
	[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[sms_rate_id] [int] NULL,
	[sms_com_id] [int] NOT NULL,
	[sms_country] [varchar](100) NOT NULL,
	[sms_operator_id] [int] NULL,
	[sms_rate] [float] NOT NULL,
	[sms_created_by] [varchar](20) NOT NULL,
	[sms_created_date] [datetime] NOT NULL,
	[sms_updated_by] [varchar](50) NULL,
	[sms_updated_date] [datetime] NULL,
	[is_deleted] [char](3) NULL,
	[trigger_log_user] [varchar](100) NULL,
	[trigger_action] [varchar](100) NULL,
	[trigger_action_local_date] [datetime] NULL,
	[trigger_action_UTC_date] [datetime] NULL,
	[trigger_action_nepali_date] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
