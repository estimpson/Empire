CREATE TABLE [EDI].[StagingGMSPO_DELFOR_Headers]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingGM__Statu__69FBEDE9] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingGMS__Type__6AF01222] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[DocumentImportDT] [datetime] NULL,
[TradingPartner] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocType] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Version] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Release] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ControlNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingGM__RowCr__6BE4365B] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingGM__RowCr__6CD85A94] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingGM__RowMo__6DCC7ECD] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingGM__RowMo__6EC0A306] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[StagingGMSPO_DELFOR_Headers] ADD CONSTRAINT [PK__StagingG__FFEE74506813A577] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
