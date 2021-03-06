USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_transaction_detail_movie]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_transaction_detail_movie]
GO
/****** Object:  Table [dbo].[tbl_transaction_detail_movie]    Script Date: 8/7/2020 9:43:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_transaction_detail_movie](
	[movie_txn_id] [int] IDENTITY(1,2) NOT NULL,
	[movie_id] [int] NULL,
	[show_id] [int] NULL,
	[process_id] [varchar](500) NULL,
	[theater_name] [varchar](500) NULL,
	[theater_address] [varchar](1000) NULL,
	[company_name] [varchar](500) NULL,
	[company_address] [varchar](100) NULL,
	[compant_vat_no] [varchar](50) NULL,
	[screen_name] [varchar](500) NULL,
	[show_date] [varchar](50) NULL,
	[show_time] [varchar](50) NULL,
	[movie_name] [varchar](50) NULL,
	[movie_nationality] [varchar](50) NULL,
	[movie_genre] [varchar](50) NULL,
	[ticket_url] [varchar](500) NULL,
	[no_of_seats] [int] NULL,
	[seat_id] [varchar](50) NULL,
	[seat_name] [varchar](50) NULL,
	[category] [varchar](50) NULL,
	[invoice_date] [datetime] NULL,
	[show_date_time] [datetime] NULL,
	[qr_bar_code] [varchar](50) NULL,
	[invoice_number] [varchar](50) NULL,
	[entrance_fee] [decimal](18, 2) NULL,
	[net_fee] [money] NULL,
	[fd_tax] [money] NULL,
	[vat] [money] NULL,
	[luxury] [money] NULL,
	[luxury_net] [money] NULL,
	[luxury_vat] [money] NULL,
	[charge_3d] [money] NULL,
	[charge_3d_net] [money] NULL,
	[charge_3d_vat] [money] NULL,
	[service_charge] [money] NULL,
	[local_charge] [money] NULL,
	[gross_amount] [money] NULL,
	[payment_mode] [varchar](100) NULL,
	[gateway_charge] [money] NULL,
	[user_id] [int] NULL,
	[created_UTC_date] [datetime] NOT NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NOT NULL,
	[created_ip] [varchar](20) NOT NULL,
	[created_platform] [varchar](20) NULL,
	[updated_by] [varchar](50) NULL,
	[updated_UTC_date] [datetime] NULL,
	[updated_local_date] [datetime] NULL,
	[updated_nepali_date] [varchar](10) NULL,
	[updated_ip] [varchar](20) NULL,
	[txn_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[movie_txn_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
