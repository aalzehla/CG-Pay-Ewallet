USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_sms_rate]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_sms_rate]
GO
/****** Object:  Table [dbo].[tbl_sms_rate]    Script Date: 8/7/2020 9:43:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_sms_rate](
	[sms_rate_id] [int] IDENTITY(1,2) NOT NULL,
	[sms_com_id] [int] NOT NULL,
	[sms_country] [varchar](100) NOT NULL,
	[sms_operator_id] [int] NULL,
	[sms_rate] [float] NOT NULL,
	[sms_created_by] [varchar](20) NOT NULL,
	[sms_created_date] [datetime] NOT NULL,
	[sms_updated_by] [varchar](50) NULL,
	[sms_updated_date] [datetime] NULL,
	[is_deleted] [char](3) NULL,
 CONSTRAINT [pk_dtasmsrate] PRIMARY KEY CLUSTERED 
(
	[sms_rate_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
