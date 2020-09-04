IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_static_data_audit]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_static_data_audit]
GO

CREATE TABLE [dbo].[tbl_static_data_audit](
	[id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[static_data_row_id] [int] NULL,
	[sdata_type_id] [int] NOT NULL,
	[static_data_value] [nvarchar](255) NULL,
	[static_data_label] [varchar](125) NULL,
	[static_data_description] [nvarchar](1000) NULL,
	[additional_value1] [nvarchar](1000) NULL,
	[additional_value2] [nvarchar](1000) NULL,
	[additional_value3] [nvarchar](1000) NULL,
	[additional_value4] [nvarchar](1000) NULL,
	[is_deleted] [varchar](20) NULL,
	[created_UTC_date] [datetime] NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NULL,
	[updated_by] [varchar](50) NULL,
	[updated_UTC_date] [varchar](50) NULL,
	[updated_local_date] [datetime] NULL,
	[updated_nepali_date] [varchar](10) NULL,
	[Amount] [decimal](18, 2) NULL,
	[trigger_log_user] [varchar](512) NULL,
	[trigger_action] [varchar](512) NULL,
	[trigger_action_local_Date] [datetime] NULL,
	[trigger_action_UTC_Date] [datetime] NULL,
	[trigger_action_nepali_date] [varchar](512) NULL,
 CONSTRAINT [pk_tbl_static_data_audit] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO


