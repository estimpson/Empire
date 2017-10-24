CREATE TABLE [EDI].[TRW_DELFOR_Headers]
(
[Status] [int] NOT NULL CONSTRAINT [DF__TRW_DELFO__Statu__019C0B4B] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__TRW_DELFOR__Type__02902F84] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__TRW_DELFO__RowCr__038453BD] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__TRW_DELFO__RowCr__047877F6] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__TRW_DELFO__RowMo__056C9C2F] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__TRW_DELFO__RowMo__0660C068] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[TRW_DELFOR_Headers] ADD CONSTRAINT [PK__TRW_DELF__FFEE74507FB3C2D9] PRIMARY KEY NONCLUSTERED  ([RowID]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
