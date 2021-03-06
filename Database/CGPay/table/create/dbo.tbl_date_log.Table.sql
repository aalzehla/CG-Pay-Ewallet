USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_date_log]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_date_log]
GO
/****** Object:  Table [dbo].[tbl_date_log]    Script Date: 8/7/2020 9:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_date_log](
	[dt_sno] [int] IDENTITY(1,2) NOT NULL,
	[nepali_year] [int] NULL,
	[nepali_month] [tinyint] NULL,
	[english_date] [date] NULL,
	[created_by] [date] NULL,
	[created_UTC_date] [date] NULL,
	[created_local_date] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[dt_sno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
