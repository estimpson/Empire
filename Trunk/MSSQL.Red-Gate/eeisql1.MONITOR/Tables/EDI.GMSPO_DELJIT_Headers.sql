CREATE TABLE [EDI].[GMSPO_DELJIT_Headers]
(
[Status] [int] NOT NULL CONSTRAINT [DF__GMSPO_DEL__Statu__1FD81056] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__GMSPO_DELJ__Type__20CC348F] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__GMSPO_DEL__RowCr__21C058C8] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__GMSPO_DEL__RowCr__22B47D01] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__GMSPO_DEL__RowMo__23A8A13A] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__GMSPO_DEL__RowMo__249CC573] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[GMSPO_DELJIT_Headers] ADD CONSTRAINT [PK__GMSPO_DE__FFEE74501DEFC7E4] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_GMSPO_DELJIT_Headers_1] ON [EDI].[GMSPO_DELJIT_Headers] ([Status], [RawDocumentGUID], [DocumentDT], [DocNumber], [ControlNumber], [Release]) ON [PRIMARY]
GO
