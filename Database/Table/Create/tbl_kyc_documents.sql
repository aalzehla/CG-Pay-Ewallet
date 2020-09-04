

CREATE TABLE [dbo].[tbl_kyc_documents](
	[kycDoc_id] [bigint] IDENTITY(1,1) NOT NULL,
	[agent_id] [varchar](100) NOT NULL,
	[Identification_type] [varchar](max)NOT NULL,
	[Identification_NO] [varchar](max)NOT NULL,
	[Identification_issued_date] [varchar](max) NULL,
	[Identification_expiry_date] [varchar](max) NULL,
	[Identification_issued_place] [varchar](max) NULL,
	[Identification_photo_Logo] [nvarchar](max) NULL,
	[Id_document_front] [nvarchar](max)NOT NULL,
	[Id_document_back] [nvarchar](max)NOT NULL,
	[KYC_Verified][char](3)NULL,
	[created_by] [varchar](50) NULL,
	[created_UTC_date] [datetime] NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL
	
PRIMARY KEY CLUSTERED 
(
	[kycDoc_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


