USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_kyc_documents]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_kyc_documents]
GO
/****** Object:  Table [dbo].[tbl_kyc_documents]    Script Date: 8/7/2020 9:43:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_kyc_documents](
	[kycDoc_id] [bigint] IDENTITY(1,1) NOT NULL,
	[agent_id] [varchar](100) NOT NULL,
	[user_name] [varchar](100) NULL,
	[Identification_type] [varchar](max) NULL,
	[Identification_NO] [varchar](max) NULL,
	[Identification_issued_date] [varchar](max) NULL,
	[Identification_issued_date_nepali] [varchar](100) NULL,
	[Identification_expiry_date] [varchar](max) NULL,
	[Identification_expiry_date_nepali] [varchar](100) NULL,
	[Identification_issued_place] [varchar](max) NULL,
	[Identification_photo_Logo] [nvarchar](max) NULL,
	[Id_document_front] [nvarchar](max) NULL,
	[Id_document_back] [nvarchar](max) NULL,
	[KYC_Verified] [varchar](20) NULL,
	[created_by] [varchar](50) NULL,
	[created_UTC_date] [datetime] NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[updated_by] [varchar](50) NULL,
	[updated_UTC_date] [datetime] NULL,
	[updated_local_date] [datetime] NULL,
	[updated_nepali_date] [varchar](10) NULL,
	[encrypted_identification_photo_log] [nvarchar](max) NULL,
	[encrypted_id_document_front] [nvarchar](max) NULL,
	[encrypted_id_document_back] [nvarchar](max) NULL,
	[encrypted_identification_photo_logs] [varbinary](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[kycDoc_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
