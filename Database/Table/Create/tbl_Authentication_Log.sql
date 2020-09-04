

CREATE TABLE [dbo].[tbl_Authentication_Log](
	[sno] [int] IDENTITY(1,1)  NOT NULL,
	[User_Id] [varchar](50) NULL,
	[Authentication_Log] [varchar](150) NULL,
	[Device_Id] [varchar](50) NULL,
	[Authentication_local_Date] [datetime] NULL,
	[Authentication_UTC_Date] [datetime] NULL,
	[Logout_local_Date] [datetime] NULL,
	[Logout_UTC_Date] [datetime] NULL,
	[Status] [varchar](10) NULL,
	[Txn_Id] [varchar](50) NULL,
 CONSTRAINT [PK_tbl_Authentication_Log] PRIMARY KEY CLUSTERED 
(
	[sno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


