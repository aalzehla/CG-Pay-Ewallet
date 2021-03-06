USE [WePayNepal]
GO
ALTER TABLE [dbo].[tbl_invalid_attempt_limit] DROP CONSTRAINT DF__tbl_inval__creat__625A9A57
GO
ALTER TABLE [dbo].[tbl_invalid_attempt_limit] DROP CONSTRAINT DF__tbl_inval__creat__634EBE90
GO
/****** Object:  Table [dbo].[tbl_invalid_attempt_limit]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_invalid_attempt_limit]
GO
/****** Object:  Table [dbo].[tbl_invalid_attempt_limit]    Script Date: 8/7/2020 9:43:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_invalid_attempt_limit](
	[limit_log_id] [bigint] IDENTITY(1,2) NOT NULL,
	[login_fails] [int] NULL,
	[invalid_password_changed] [int] NULL,
	[unauthorization] [int] NULL,
	[apperror] [int] NULL,
	[invalid_otp] [int] NULL,
	[is_active] [bit] NULL,
	[created_by] [varchar](30) NULL,
	[created_UTC_date] [datetime] NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[limit_log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tbl_invalid_attempt_limit] ADD  DEFAULT (getutcdate()) FOR [created_UTC_date]
GO
ALTER TABLE [dbo].[tbl_invalid_attempt_limit] ADD  DEFAULT (getdate()) FOR [created_local_date]
GO
