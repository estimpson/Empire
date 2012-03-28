USE [MONITOR]
GO

/****** Object:  Table [EDI].[StagingNAL_830_Releases]    Script Date: 02/29/2012 23:11:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [EDI].[StagingNAL_830_Releases](
	[Status] [int] NOT NULL,
	[Type] [int] NOT NULL,
	[RawDocumentGUID] [uniqueidentifier] NULL,
	[ShipToCode] [varchar](15) NULL,
	[CustomerPart] [varchar](35) NULL,
	[CustomerPO] [varchar](35) NULL,
	[ShipFromCode] [varchar](15) NULL,
	[ICCode] [varchar](15) NULL,
	[ReleaseNo] [varchar](30) NULL,
	[ReleaseQty] [int] NULL,
	[ReleaseDT] [datetime] NULL,
	[AccumReceived] [int] NULL,
	[LastBOLReceived] [int] NULL,
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[RowCreateDT] [datetime] NULL,
	[RowCreateUser] [sysname] NOT NULL,
	[RowModifiedDT] [datetime] NULL,
	[RowModifiedUser] [sysname] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RowID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [EDI].[StagingNAL_830_Releases] ADD  DEFAULT ((0)) FOR [Status]
GO

ALTER TABLE [EDI].[StagingNAL_830_Releases] ADD  DEFAULT ((0)) FOR [Type]
GO

ALTER TABLE [EDI].[StagingNAL_830_Releases] ADD  DEFAULT (getdate()) FOR [RowCreateDT]
GO

ALTER TABLE [EDI].[StagingNAL_830_Releases] ADD  DEFAULT (user_name()) FOR [RowCreateUser]
GO

ALTER TABLE [EDI].[StagingNAL_830_Releases] ADD  DEFAULT (getdate()) FOR [RowModifiedDT]
GO

ALTER TABLE [EDI].[StagingNAL_830_Releases] ADD  DEFAULT (user_name()) FOR [RowModifiedUser]
GO


