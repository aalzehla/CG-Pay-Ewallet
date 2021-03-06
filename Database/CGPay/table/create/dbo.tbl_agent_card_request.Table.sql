USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_agent_card_request]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_agent_card_request]
GO
/****** Object:  Table [dbo].[tbl_agent_card_request]    Script Date: 8/7/2020 9:43:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_agent_card_request](
	[req_id] [int] IDENTITY(1,2) NOT NULL,
	[user_name] [varchar](50) NOT NULL,
	[user_mobile_no] [varchar](10) NULL,
	[user_email] [varchar](50) NULL,
	[request_status] [varchar](10) NULL,
	[created_local_date] [datetime] NULL,
	[created_UTC_Date] [datetime] NULL,
	[created_by] [varchar](50) NULL,
	[created_ip] [varchar](50) NULL,
	[updated_local_date] [datetime] NULL,
	[updated_UTC_Date] [datetime] NULL,
	[updated_by] [varchar](50) NULL,
	[updated_ip] [varchar](50) NULL,
	[card_type] [varchar](50) NULL,
	[requested_amount] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[req_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
