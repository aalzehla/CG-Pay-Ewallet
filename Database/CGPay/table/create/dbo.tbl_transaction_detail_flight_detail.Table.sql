USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_transaction_detail_flight_detail]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_transaction_detail_flight_detail]
GO
/****** Object:  Table [dbo].[tbl_transaction_detail_flight_detail]    Script Date: 8/7/2020 9:43:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_transaction_detail_flight_detail](
	[ticket_txn_id] [int] IDENTITY(1,2) NOT NULL,
	[txn_id] [int] NULL,
	[outbound_flight_id] [varchar](50) NULL,
	[airline] [varchar](20) NULL,
	[inbound_flight_id] [varchar](50) NULL,
	[adult_passenger] [int] NULL,
	[child_passenger] [int] NULL,
	[infant_passenger] [int] NULL,
	[contact_name] [varchar](50) NULL,
	[contact_email] [varchar](50) NULL,
	[contact_phone] [varchar](50) NULL,
	[pnr_no] [varchar](20) NULL,
	[title] [varchar](20) NULL,
	[gender] [varchar](10) NULL,
	[first_name] [varchar](30) NULL,
	[last_name] [varchar](30) NULL,
	[pax_no] [varchar](20) NULL,
	[pax_type] [varchar](20) NULL,
	[nationality] [varchar](5) NULL,
	[pax_id] [varchar](20) NULL,
	[api_log_id] [varchar](50) NULL,
	[ticket_status] [varchar](50) NULL,
	[child_rate] [money] NULL,
	[adult_rate] [money] NULL,
	[infant_rate] [money] NULL,
	[cost_amount] [money] NULL,
	[flight_date] [datetime] NULL,
	[return_flight_date] [datetime] NULL,
	[dt_date] [datetime] NULL,
	[total_amount] [money] NULL,
	[ticket_commission] [money] NULL,
	[reprocess_yes_no] [char](1) NULL,
	[partner_txn_id] [varchar](50) NULL,
	[process_id] [varchar](100) NULL,
	[issued_date] [datetime] NULL,
	[issue_by] [varchar](20) NULL,
	[flight_no] [varchar](20) NULL,
	[departure_from] [varchar](10) NULL,
	[flight_time] [varchar](10) NULL,
	[ticket_no] [varchar](50) NULL,
	[arrival_to] [varchar](10) NULL,
	[arrival_time] [varchar](10) NULL,
	[ticket_class] [varchar](5) NULL,
	[ticket_fare] [money] NULL,
	[scharge] [money] NULL,
	[tax_currency] [varchar](10) NULL,
	[tax] [money] NULL,
	[admin_commission_amount] [float] NULL,
	[gparent_commission_amount] [float] NULL,
	[parentcommission_amount] [float] NULL,
	[agentcommission_amount] [float] NULL,
	[refundable] [varchar](50) NULL,
	[reporting_time] [varchar](200) NULL,
	[free_baggage] [varchar](20) NULL,
	[bar_code_value] [varchar](50) NULL,
	[bar_code_image] [varchar](50) NULL,
	[user_id] [varchar](200) NULL,
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
 CONSTRAINT [pk_tbl_transaction_detail_flight_detail] PRIMARY KEY CLUSTERED 
(
	[ticket_txn_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
