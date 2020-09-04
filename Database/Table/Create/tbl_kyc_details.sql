USE [WePayNepal]
GO

/****** Object:  Table [dbo].[tbl_kyc_documents]    Script Date: 25/05/2020 09:28:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_kyc_documents]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_kyc_documents]
GO

/****** Object:  Table [dbo].[tbl_kyc_documents]    Script Date: 25/05/2020 09:28:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_kyc_details](
	[kyc_id] [bigint] IDENTITY(1,1) NOT NULL,
	[agent_id] [varchar](100) NOT NULL,
	[user_name] [varchar](100) NULL,
	[first_name] [varchar](100) NULL,
	[middle_name] [varchar](100) NULL,
	[last_name] [varchar](100) NULL,
	[date_of_birth_eng] [datetime] NULL,
	[date_of_birth_nep] [varchar](20) NULL,
	[gender] [varchar](10) NULL,
	[occupation] [varchar](20) NULL,
	[marital_status] [varchar](20) NULL,
	[spouse_name] [varchar](500) NULL,
	[father_name] [varchar](500) NULL,
	[mother_name] [varchar](500) NULL,
	[grand_father_name] [varchar](500) NULL,
	[permanent_province] [varchar](50) NULL,
	[permanent_district] [varchar](50) NULL,
	[permanent_localbody] [varchar](50) NULL,
	[permanent_wardno] [int] NULL,
	[permanent_address] [varchar](100) NULL,
	[temporary_province] [varchar](50) NULL,
	[temporary_district] [varchar](50) NULL,
	[temporary_localbody] [varchar](50) NULL,
	[temporary_wardno] [int] NULL,
	[temporary_address] [varchar](100) NULL,
	[admin_remarks] [varchar](max) NULL,
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
PRIMARY KEY CLUSTERED 
(
	[kyc_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


