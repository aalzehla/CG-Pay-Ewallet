USE [WePayNepal]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_application_functions_audit]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_application_functions_audit]
GO

/****** Object:  Table [dbo].[tbl_application_functions_audit]    Script Date: 5/31/2020 12:30:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_application_functions_audit](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[function_id] [int] NULL,
	[parent_menu_id] [int] NULL,
	[function_name] [varchar](50) NULL,
	[function_Url] [varchar](max) NULL,
	[created_UTC_date] [datetime] NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NULL,
	[updated_by] [datetime] NULL,
	[updated_UTC_date] [varchar](50) NULL,
	[updated_local_date] [datetime] NULL,
	[updated_nepali_date] [varchar](10) NULL,
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


