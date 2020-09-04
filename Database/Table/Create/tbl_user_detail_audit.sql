USE [WePayNepal]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_user_detail_audit]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_user_detail_audit]
GO

/****** Object:  Table [dbo].[tbl_user_detail]    Script Date: 30/05/2020 22:12:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_user_detail_audit](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NULL,
	[user_name] [varchar](200) NULL,
	[password] [varbinary](500) NULL,
	[full_name] [varchar](200) NULL,
	[agent_id] [int] NULL,
	[user_email] [varchar](300) NULL,
	[user_mobile_no] [varchar](20) NULL,
	[last_login_UTC_date] [datetime] NULL,
	[last_login_local_date] [datetime] NULL,
	[last_password_changed_UTC_date] [datetime] NULL,
	[last_password_changed_local_date] [datetime] NULL,
	[session] [varchar](200) NULL,
	[forced_password_changed] [char](3) NULL,
	[created_UTC_date] [datetime] NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](55) NULL,
	[created_ip] [varchar](15) NULL,
	[created_platform] [varchar](800) NULL,
	[updated_by] [varchar](50) NULL,
	[updated_UTC_date] [datetime] NULL,
	[updated_local_date] [datetime] NULL,
	[updated_nepali_date] [varchar](10) NULL,
	[updated_ip] [varchar](20) NULL,
	[allow_multiple_login] [char](2) NULL,
	[is_currently_logged_in] [char](2) NULL,
	[device_id] [varchar](400) NULL,
	[status] [varchar](20) NULL,
	[usr_type_id] [int] NULL,
	[usr_type] [varchar](50) NULL,
	[is_login_enabled] [char](3) NULL,
	[is_primary] [char](3) NULL,
	[browser_info] [varchar](1000) NULL,
	[access_code] [varchar](100) NULL,
	[user_qrimage] [nvarchar](max) NULL,
	[pay_load] [varchar](500) NULL,
	[m_pin] [varbinary](1000) NULL,
	[role_id] [int] NULL,
	[device_token] [nvarchar](max) NULL,
	[trigger_log_user] [varchar](512) NULL,
	[trigger_action] [varchar](512) NULL,
	[trigger_action_local_Date] [datetime] NULL,
	[trigger_action_UTC_Date] [datetime] NULL,
	[trigger_action_nepali_date] [varchar](512) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


