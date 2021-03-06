USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_file_upload_log]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_file_upload_log]
GO
/****** Object:  Table [dbo].[tbl_file_upload_log]    Script Date: 8/7/2020 9:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_file_upload_log](
	[file_upload_id] [int] IDENTITY(1,2) NOT NULL PRIMARY KEY,
	[file_name] [varchar](200) NULL,
	[total_data] [int] NULL,
	[file_upload_status] [varchar](50) NULL,
	[process_id] [varchar](100) NULL,
	[upload_local_date] [datetime] NULL,
	[upload_UTC_date] [datetime] NULL,
	[upload_nepali_date] [varchar](50) NULL,
	[upload_by] [varchar](50) NULL,
	[upload_from_ip] [varchar](50) NULL,
	[file_path] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
