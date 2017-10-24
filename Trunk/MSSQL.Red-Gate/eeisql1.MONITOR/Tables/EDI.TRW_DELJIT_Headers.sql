CREATE TABLE [EDI].[TRW_DELJIT_Headers]
(
[Status] [int] NOT NULL CONSTRAINT [DF__TRW_DELJI__Statu__6E8936D7] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__TRW_DELJIT__Type__6F7D5B10] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__TRW_DELJI__RowCr__70717F49] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__TRW_DELJI__RowCr__7165A382] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__TRW_DELJI__RowMo__7259C7BB] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__TRW_DELJI__RowMo__734DEBF4] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[TRW_DELJIT_Headers] ADD CONSTRAINT [PK__TRW_DELJ__FFEE74506CA0EE65] PRIMARY KEY NONCLUSTERED  ([RowID]) WITH (FILLFACTOR=95) ON [PRIMARY]
GO
