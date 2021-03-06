USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_error_log]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_error_log]
GO
/****** Object:  Table [dbo].[tbl_error_log]    Script Date: 8/7/2020 9:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_error_log](
	[error_id] [bigint] IDENTITY(1,2) NOT NULL,
	[error_page] [varchar](100) NULL,
	[error_msg] [varchar](max) NULL,
	[error_detail] [varchar](max) NULL,
	[created_by] [varchar](50) NULL,
	[error_UTC_date] [datetime] NULL,
	[error_local_date] [datetime] NULL,
	[error_nepali_date] [varchar](10) NULL,
	[is_active] [char](1) NULL,
	[ip_address] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[error_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
