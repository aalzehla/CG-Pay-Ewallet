USE [WePayNepal]
GO
/****** Object:  Table [dbo].[tbl_transaction_detail_nea]    Script Date: 8/7/2020 9:43:04 PM ******/
DROP TABLE [dbo].[tbl_transaction_detail_nea]
GO
/****** Object:  Table [dbo].[tbl_transaction_detail_nea]    Script Date: 8/7/2020 9:43:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_transaction_detail_nea](
	[nea_txn_det_id] [int] IDENTITY(1,2) NOT NULL,
	[partner_txn_id] [varchar](50) NULL,
	[sc_no] [varchar](50) NULL,
	[consumer_id] [varchar](50) NULL,
	[customer_name] [varchar](50) NULL,
	[office_code] [varchar](50) NULL,
	[office] [varchar](50) NULL,
	[bill_date] [datetime] NULL,
	[due_bill_of] [varchar](50) NULL,
	[no_of_days] [int] NULL,
	[bill_amt] [money] NULL,
	[consumed_units] [varchar](20) NULL,
	[payable_amt] [money] NULL,
	[fine_rate] [varchar](50) NULL,
	[rebate] [varchar](50) NULL,
	[service_charge] [float] NULL,
	[total_due_amt] [money] NULL,
	[txn_id] [varchar](50) NULL,
	[paid_amt] [varchar](50) NULL,
	[amount_due_left] [varchar](50) NULL,
	[process_id] [varchar](50) NULL,
	[nea_response_code] [int] NULL,
	[nea_message] [varchar](500) NULL,
	[user_id] [int] NULL,
	[created_UTC_date] [datetime] NOT NULL,
	[created_local_date] [datetime] NULL,
	[created_nepali_date] [varchar](10) NULL,
	[created_by] [varchar](100) NOT NULL,
	[created_ip] [varchar](20) NOT NULL,
	[created_platform] [varchar](20) NULL,
	[nea_txn_id] [varchar](100) NULL,
 CONSTRAINT [pk_dtatransactiondetailnea] PRIMARY KEY CLUSTERED 
(
	[nea_txn_det_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
