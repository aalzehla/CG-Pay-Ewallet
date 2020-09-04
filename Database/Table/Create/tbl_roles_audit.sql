USE [WePayNepal]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_roles_audit]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_roles_audit]
GO

/****** Object:  Table [dbo].[tbl_roles]    Script Date: 30/05/2020 22:08:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_roles_audit](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[role_id] [int] NULL,
	[role_name] [varchar](50) NULL,
	[role_type] [varchar](50) NULL,
	[created_UTC_date] [datetime]  NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NULL,
	[created_ip] [varchar](20) NULL,
	[role_status] [char](1) NULL,
	[trigger_log_user] [varchar](512) NULL,
	[trigger_action] [varchar](512) NULL,
	[trigger_action_local_Date] [datetime] NULL,
	[trigger_action_UTC_Date] [datetime] NULL,
	[trigger_action_nepali_date] [varchar](512) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
