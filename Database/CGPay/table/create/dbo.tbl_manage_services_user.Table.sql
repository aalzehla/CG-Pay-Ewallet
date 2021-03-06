USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_manage_services_user]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_manage_services_user]
GO
/****** Object:  Table [dbo].[tbl_manage_services_user]    Script Date: 8/7/2020 9:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_manage_services_user](
	[row_Id] [int] IDENTITY(1,2) NOT NULL,
	[agent_Id] [int] NULL,
	[product_Id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[row_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
