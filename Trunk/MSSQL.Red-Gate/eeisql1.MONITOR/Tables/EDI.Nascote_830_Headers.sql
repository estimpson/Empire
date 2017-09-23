CREATE TABLE [EDI].[Nascote_830_Headers]
(
[Status] [int] NOT NULL CONSTRAINT [DF__Nascote_8__Statu__3A19674B] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__Nascote_83__Type__3B0D8B84] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__Nascote_8__RowCr__3C01AFBD] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Nascote_8__RowCr__3CF5D3F6] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__Nascote_8__RowMo__3DE9F82F] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Nascote_8__RowMo__3EDE1C68] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[Nascote_830_Headers] ADD CONSTRAINT [PK__Nascote___FFEE745038311ED9] PRIMARY KEY NONCLUSTERED  ([RowID]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
