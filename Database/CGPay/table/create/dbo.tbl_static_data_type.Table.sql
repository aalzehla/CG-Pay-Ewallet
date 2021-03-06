USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_static_data_type]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_static_data_type]
GO
/****** Object:  Table [dbo].[tbl_static_data_type]    Script Date: 8/7/2020 9:43:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_static_data_type](
	[sdata_type_id] [int] IDENTITY(1,2) NOT NULL,
	[static_data_name] [varchar](200) NOT NULL,
	[static_data_description] [varchar](200) NULL,
	[static_data_type] [char](1) NULL,
	[static_data_Label] [varchar](50) NULL,
	[created_by] [varchar](50) NULL,
	[created_Date] [datetime] NULL,
	[created_UTC_Date] [datetime] NULL,
	[created_Date_Nepali] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[sdata_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
