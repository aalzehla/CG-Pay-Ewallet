IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_application_config_audit]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_application_config_audit]
GO

CREATE TABLE [dbo].[tbl_application_config_audit](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[config_id] [int] NULL,
	[config_label] [varchar](20) NULL,
	[config_value] [varchar](50) NULL,
	[config_value1] [nvarchar](max) NULL,
	[config_value2] [nvarchar](max) NULL,
	[config_value3] [nvarchar](max) NULL,
	[config_value4] [nvarchar](max) NULL,
	[config_value5] [nvarchar](max) NULL,
	[created_by] [varchar](50) NULL,
	[created_ts] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[updated_ts] [datetime] NULL,
	[trigger_log_user] [varchar](512) NULL,
	[trigger_action] [varchar](512) NULL,
	[trigger_action_local_Date] [datetime] NULL,
	[trigger_action_UTC_Date] [datetime] NULL,
	[trigger_action_nepali_date] [varchar](512) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


