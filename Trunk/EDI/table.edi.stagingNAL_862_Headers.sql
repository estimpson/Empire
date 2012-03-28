USE [MONITOR]
GO

/****** Object:  Table [EDI].[StagingNAL_862_Headers]    Script Date: 02/29/2012 23:04:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [EDI].[StagingNAL_862_Headers](
	[Status] [int] NOT NULL,
	[Type] [int] NOT NULL,
	[RawDocumentGUID] [uniqueidentifier] NULL,
	[DocumentImportDT] [datetime] NULL,
	[TradingPartner] [varchar](50) NULL,
	[DocType] [varchar](6) NULL,
	[Version] [varchar](20) NULL,
	[Release] [varchar](30) NULL,
	[DocNumber] [varchar](50) NULL,
	[ControlNumber] [varchar](10) NULL,
	[DocumentDT] [datetime] NULL,
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[RowCreateDT] [datetime] NULL,
	[RowCreateUser] [sysname] NOT NULL,
	[RowModifiedDT] [datetime] NULL,
	[RowModifiedUser] [sysname] NOT NULL,
PRIMARY KEY NONCLUSTERED 
(
	[RowID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [EDI].[StagingNAL_862_Headers] ADD  DEFAULT ((0)) FOR [Status]
GO

ALTER TABLE [EDI].[StagingNAL_862_Headers] ADD  DEFAULT ((0)) FOR [Type]
GO

ALTER TABLE [EDI].[StagingNAL_862_Headers] ADD  DEFAULT (getdate()) FOR [RowCreateDT]
GO

ALTER TABLE [EDI].[StagingNAL_862_Headers] ADD  DEFAULT (user_name()) FOR [RowCreateUser]
GO

ALTER TABLE [EDI].[StagingNAL_862_Headers] ADD  DEFAULT (getdate()) FOR [RowModifiedDT]
GO

ALTER TABLE [EDI].[StagingNAL_862_Headers] ADD  DEFAULT (user_name()) FOR [RowModifiedUser]
GO


