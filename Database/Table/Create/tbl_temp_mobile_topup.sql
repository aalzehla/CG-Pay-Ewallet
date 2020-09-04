

CREATE TABLE [dbo].[tbl_temp_mobile_topup](
	[sno] [int] IDENTITY(1,1) NOT NULL,
	[SubscriberNo] [varchar](20) NOT NULL,
	[Amount] [money] NOT NULL,
	[created_local_date] [datetime] NULL,
	[UserId] [varchar](20) NOT NULL,
	[productId] [int] NOT NULL,
	[agentId] [varchar](20) NOT NULL,
	[CostAmount] [money] NULL,
	[FileName] [varchar](500) NOT NULL,
	[Remarks] [varchar](200) NULL
) ON [PRIMARY]
GO