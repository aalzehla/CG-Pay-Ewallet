USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_commission_category_audit]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_commission_category_audit]
GO
/****** Object:  Table [dbo].[tbl_commission_category_audit]    Script Date: 8/7/2020 9:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_commission_category_audit](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[category_id] [int] NULL,
	[category_name] [varchar](200) NULL,
	[is_active] [char](3) NULL,
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
	[agent_id] [varchar](50) NULL,
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
SET ANSI_PADDING OFF
GO
