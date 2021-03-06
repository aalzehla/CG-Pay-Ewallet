USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_email_request]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_email_request]
GO
/****** Object:  Table [dbo].[tbl_email_request]    Script Date: 8/7/2020 9:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_email_request](
	[email_req_id] [int] IDENTITY(1,2) NOT NULL,
	[email_subject] [nvarchar](250) NULL,
	[email_text] [nvarchar](max) NULL,
	[email_file_attached] [varchar](500) NULL,
	[email_notes_attached] [image] NULL,
	[email_send_by] [varchar](100) NULL,
	[email_send_to] [varchar](5000) NOT NULL,
	[email_send_to_cc] [varchar](5000) NULL,
	[email_send_to_bcc] [varchar](5000) NULL,
	[email_send_status] [char](3) NOT NULL,
	[is_active] [char](3) NOT NULL,
	[is_important] [char](3) NULL,
	[email_sensitivity] [varchar](20) NULL,
	[created_UTC_date] [datetime] NOT NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NOT NULL,
	[created_ip] [varchar](20) NULL,
	[updated_by] [varchar](50) NULL,
	[updated_UTC_date] [datetime] NULL,
	[updated_local_date] [datetime] NULL,
	[updated_nepali_date] [varchar](10) NULL,
	[updated_ip] [varchar](20) NULL,
	[txn_no] [int] NULL,
	[sys_mail_Id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[email_req_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
