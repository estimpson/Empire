CREATE TABLE [EDI].[StagingTRW_DELJIT_Headers]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingTR__Statu__1E3849F9] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingTRW__Type__1F2C6E32] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingTR__RowCr__2020926B] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingTR__RowCr__2114B6A4] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingTR__RowMo__2208DADD] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingTR__RowMo__22FCFF16] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[StagingTRW_DELJIT_Headers] ADD CONSTRAINT [PK__StagingT__FFEE74501C500187] PRIMARY KEY NONCLUSTERED  ([RowID]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
