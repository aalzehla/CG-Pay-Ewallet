USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_state_local_nepal]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_state_local_nepal]
GO
/****** Object:  Table [dbo].[tbl_state_local_nepal]    Script Date: 8/7/2020 9:43:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_state_local_nepal](
	[local_data_id] [int] IDENTITY(1,2) NOT NULL,
	[province] [varchar](100) NULL,
	[district] [varchar](200) NULL,
	[local_level] [varchar](200) NULL,
	[province_Code] [varchar](10) NULL,
	[district_code] [varchar](10) NULL,
	[local_level_code] [varchar](10) NULL,
	[country_code] [varchar](5) NULL,
 CONSTRAINT [PK_DtaStateLocalNepal] PRIMARY KEY CLUSTERED 
(
	[local_data_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
