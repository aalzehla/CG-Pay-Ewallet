USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_static_data]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_static_data]
GO
/****** Object:  Table [dbo].[tbl_static_data]    Script Date: 8/7/2020 9:43:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_static_data](
	[static_data_row_id] [int] IDENTITY(1,2) NOT NULL,
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
 CONSTRAINT [pk_tbl_static_data] PRIMARY KEY CLUSTERED 
(
	[static_data_row_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
