USE [WePayNepal]
GO

/****** Object:  Table [dbo].[tbl_user_detail]    Script Date: 25/05/2020 09:01:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_user_detail]') AND type in (N'U'))
DROP TABLE [dbo].[tbl_user_detail]
GO

/****** Object:  Table [dbo].[tbl_user_detail]    Script Date: 25/05/2020 09:01:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbl_user_detail](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[agent_id] [int] NULL,
	[role_id] [int] NULL,
	[usr_type_id] [int] NULL,
	[usr_type] [varchar](50) NULL,
	[user_name] [varchar](200) NULL,
	[kyc_status] [varchar](20) NULL,
	[first_name] [varchar](100) NULL,
	[middle_name] [varchar](100) NULL,
	[last_name] [varchar](100) NULL,
	[full_name] [varchar](200) NULL,
	[password] [varbinary](500) NULL,
	[user_email] [varchar](300) NULL,
	[user_mobile_no] [varchar](20) NULL,
	[user_status] [varchar](20) NULL,
	[m_pin] [varbinary](1000) NULL,
	[last_login_UTC_date] [datetime] NULL,
	[last_login_local_date] [datetime] NULL,
	[last_password_changed_UTC_date] [datetime] NULL,
	[last_password_changed_local_date] [datetime] NULL,
	[session] [varchar](200) NULL,
	[forced_password_changed] [char](3) NULL,
	[created_UTC_date] [datetime] NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](55) NULL,
	[created_ip] [varchar](15) NULL,
	[created_platform] [varchar](800) NULL,
	[updated_by] [varchar](50) NULL,
	[updated_UTC_date] [datetime] NULL,
	[updated_local_date] [datetime] NULL,
	[updated_nepali_date] [varchar](10) NULL,
	[updated_ip] [varchar](20) NULL,
	[allow_multiple_login] [char](2) NULL,
	[is_currently_logged_in] [char](2) NULL,
	[device_id] [varchar](400) NULL,
	[is_login_enabled] [char](3) NULL,
	[is_primary] [char](3) NULL,
	[browser_info] [varchar](1000) NULL,
	[access_code] [varchar](100) NULL,
	[user_qrimage] [nvarchar](max) NULL,
	[pay_load] [varchar](500) NULL,


PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[user_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


