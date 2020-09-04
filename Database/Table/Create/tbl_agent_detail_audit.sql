USE [WePayNepal]
GO

/****** Object:  Table [dbo].[tbl_agent_detail_audit]    Script Date: 06/05/2020 18:45:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_agent_detail_audit]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_agent_detail_audit]
GO

/****** Object:  Table [dbo].[tbl_agent_detail_audit]    Script Date: 06/05/2020 18:45:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_agent_detail_audit](
	[id] [int] IDENTITY(1000,1) NOT NULL,
	[agent_id] [int] NULL,
	[parent_id] [int] NULL,
	[agent_code] [varchar](20) NULL,
	[agent_type] [varchar](50) NULL,
	[agent_operation_type] [varchar](20) NULL,
	[agent_name] [varchar](500) NULL,
	[kyc_status] [varchar](20) NULL,
	[first_name] [varchar](100) NULL,
	[middle_name] [varchar](100) NULL,
	[last_name] [varchar](100) NULL,
	[available_balance] [decimal](18, 2) NULL,
	[date_of_birth_eng] [datetime] NULL,
	[date_of_birth_nep] [varchar](20) NULL,
	[gender] [varchar](10) NULL,
	[agent_phone_no] [varchar](15) NULL,
	[agent_mobile_no] [varchar](15) NULL,
	[agent_email_address] [varchar](255) NULL,
	[occupation] [varchar](20) NULL,
	[marital_status] [varchar](20) NULL,
	[spouse_name] [varchar](500) NULL,
	[father_name] [varchar](500) NULL,
	[mother_name] [varchar](500) NULL,
	[grand_father_name] [varchar](500) NULL,
	[agent_nationality] [varchar](20) NULL,
	[agent_country] [varchar](200) NULL,
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
	[latitude] [varchar](100) NULL,
	[longitude] [varchar](100) NULL,
	[web_url] [varchar](150) NULL,
	[agent_registration_no] [varchar](20) NULL,
	[agent_pan_no] [varchar](20) NULL,
	[agent_credit_limit] [varchar](100) NULL,
	[agent_support_staff] [varchar](20) NULL,
	[agent_contract_local_date] [datetime] NULL,
	[agent_contract_nepali_date] [varchar](10) NULL,
	[agent_logo_img] [varchar](max) NULL,
	[agent_document_img_front] [varchar](max) NULL,
	[agent_document_img_back] [varchar](max) NULL,
	[contact_person_name] [varchar](50) NULL,
	[agent_country_code] [varchar](4) NULL,
	[contact_person_mobile_no] [varchar](15) NULL,
	[contact_person_id_type] [varchar](20) NULL,
	[contact_person_id_no] [varchar](20) NULL,
	[contact_id_issue_local_date] [datetime] NULL,
	[contact_id_issued_bs_date] [varchar](20) NULL,
	[contact_id_issued_district] [varchar](50) NULL,
	[agent_commission_id] [int] NULL,
	[agent_status] [varchar](20) NULL,
	[is_auto_commission] [bit] NULL,
	[agent_qr_image] [varchar](500) NULL,
	[fund_load_reward] [int] NULL,
	[txn_reward_point] [int] NULL,
	[admin_remarks] [varchar](max) NULL,
	[full_name] [varchar](100) NULL,
	[is_sameAs_per_add] [bit] NULL,
	[individual_image] [varchar](50) NULL,
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
	[trigger_log_user] [varchar](100) NULL,
	[trigger_action] [varchar](100) NULL,
	[trigger_action_local_Date] [datetime] NULL,
	[trigger_action_UTC_Date] [datetime] NULL,
	[trigger_action_nepali_date] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


