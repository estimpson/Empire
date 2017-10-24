CREATE TABLE [EDI].[TELEFLEX_DELFOR_Headers]
(
[Status] [int] NOT NULL CONSTRAINT [DF__TELEFLEX___Statu__021F26EB] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__TELEFLEX_D__Type__03134B24] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__TELEFLEX___RowCr__04076F5D] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__TELEFLEX___RowCr__04FB9396] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__TELEFLEX___RowMo__05EFB7CF] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__TELEFLEX___RowMo__06E3DC08] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[TELEFLEX_DELFOR_Headers] ADD CONSTRAINT [PK__TELEFLEX__FFEE74500036DE79] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
