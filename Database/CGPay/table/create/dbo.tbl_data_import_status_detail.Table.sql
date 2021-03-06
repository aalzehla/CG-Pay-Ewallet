USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_data_import_status_detail]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_data_import_status_detail]
GO
/****** Object:  Table [dbo].[tbl_data_import_status_detail]    Script Date: 8/7/2020 9:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_data_import_status_detail](
	[import_status_id] [int] IDENTITY(1,2) NOT NULL,
	[process_id] [varchar](100) NULL,
	[data_import_source] [varchar](50) NULL,
	[type] [varchar](100) NULL,
	[data_import_description] [varchar](500) NULL,
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
	[ms_repl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [pk_source_system_data_import_status_detail] PRIMARY KEY CLUSTERED 
(
	[import_status_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
