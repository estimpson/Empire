CREATE TABLE [EDI].[GMSPO_DELFOR_Headers]
(
[Status] [int] NOT NULL CONSTRAINT [DF__GMSPO_DEL__Statu__34D32D3C] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__GMSPO_DELF__Type__35C75175] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__GMSPO_DEL__RowCr__36BB75AE] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__GMSPO_DEL__RowCr__37AF99E7] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__GMSPO_DEL__RowMo__38A3BE20] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__GMSPO_DEL__RowMo__3997E259] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[GMSPO_DELFOR_Headers] ADD CONSTRAINT [PK__GMSPO_DE__FFEE745032EAE4CA] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_GMSPO_DELFOR_Headers_1] ON [EDI].[GMSPO_DELFOR_Headers] ([Status], [RawDocumentGUID]) INCLUDE ([ControlNumber], [DocNumber], [DocumentDT], [DocumentImportDT]) ON [PRIMARY]
GO
