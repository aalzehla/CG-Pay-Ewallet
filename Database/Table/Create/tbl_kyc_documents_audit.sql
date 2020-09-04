USE [WePayNepal]
GO

/****** Object:  Table [dbo].[tbl_kyc_documents_audit]    Script Date: 5/31/2020 12:44:24 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_kyc_documents_audit]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_kyc_documents_audit]
GO

/****** Object:  Table [dbo].[tbl_kyc_documents]    Script Date: 30/05/2020 21:57:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_kyc_documents_audit](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[kycDoc_id] [bigint] NULL,
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
	[trigger_log_user] [varchar](512) NULL,
	[trigger_action] [varchar](512) NULL,
	[trigger_action_local_Date] [datetime] NULL,
	[trigger_action_UTC_Date] [datetime] NULL,
	[trigger_action_nepali_date] [varchar](512) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


