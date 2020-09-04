USE [WePayNepal]
GO

/****** Object:  Table [dbo].[tbl_agent_detail]    Script Date: 05/25/2020 3:06:16 PM ******/
DROP TABLE [dbo].[tbl_agent_detail]
GO

/****** Object:  Table [dbo].[tbl_agent_detail]    Script Date: 05/25/2020 3:06:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_agent_detail](
	[agent_id] [int] IDENTITY(1000,1) NOT NULL,
	[parent_id] [int] NULL,
	[agent_code] [varchar](20) NULL,
	[agent_type] [varchar](50) NULL,
	[agent_operation_type] [varchar](20) NULL,
	[agent_name] [varchar](500) NULL,
	[available_balance] [decimal](18, 2) NULL,
	[agent_phone_no] [varchar](15) NULL,
	[agent_mobile_no] [varchar](15) NULL,
	[agent_email_address] [varchar](255) NULL,
	[agent_nationality] [varchar](20) NULL,
	[agent_country] [varchar](200) NULL,
	[agent_country_code] [varchar](4) NULL,
	[agent_province] [varchar](50) NULL,
	[agent_district] [varchar](50) NULL,
	[agent_localbody] [varchar](50) NULL,
	[agent_wardno] [int] NULL,
	[agent_address] [varchar](500) NULL,
	[agent_web_url] [varchar](150) NULL,
	[agent_registration_no] [varchar](20) NULL,
	[agent_pan_no] [varchar](20) NULL,
	[agent_credit_limit] [varchar](100) NULL,
	[agent_contract_local_date] [datetime] NULL,
	[agent_contract_nepali_date] [varchar](10) NULL,
	[agent_logo_img] [varchar](max) NULL,
	[agent_pan_cert_image] [varchar](max) NULL,
	[agent_registeration_cert_image] [varchar](max) NULL,
	[contact_person_name] [varchar](50) NULL,
	[contact_person_mobile_no] [varchar](15) NULL,
	[contact_Person_address] [varchar](512) NULL,
	[contact_person_id_type] [varchar](20) NULL,
	[contact_person_id_no] [varchar](20) NULL,
	[contact_id_issue_local_date] [datetime] NULL,
	[contact_id_issued_bs_date] [varchar](20) NULL,
	[contact_id_expiry_local_date] [datetime] NULL,
	[contact_id_expiry_bs_date] [varchar](10) NULL,
	[contact_id_issued_district] [varchar](50) NULL,
	[agent_commission_id] [int] NULL,
	[agent_status] [varchar](20) NULL,
	[is_auto_commission] [bit] NULL,
	[agent_qr_image] [varchar](500) NULL,
	[fund_load_reward] [int] NULL,
	[txn_reward_point] [int] NULL,
	[referal_id] [int] NULL,
	[agent_referal_id] [int] NULL,
	[lock_status] [char](1) NULL,
	[locked_reason] [varchar](500) NULL,
	[locked_UTC_date] [datetime] NULL,
	[locked_by] [varchar](50) NULL,
	[created_UTC_date] [datetime] NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	
	[created_by] [varchar](100) NULL,
	[created_ip] [varchar](20) NULL,
	[created_platform] [varchar](20) NULL,
	[updated_by] [varchar](200) NULL,
	[updated_UTC_date] [varchar](50) NULL,
	[updated_local_date] [datetime] NULL,
	[updated_nepali_date] [varchar](10) NULL,
	[updated_ip] [varchar](20) NULL,
	
 CONSTRAINT [PK__tbl_agen__2C05379E5B6D867A] PRIMARY KEY CLUSTERED 
(
	[agent_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


