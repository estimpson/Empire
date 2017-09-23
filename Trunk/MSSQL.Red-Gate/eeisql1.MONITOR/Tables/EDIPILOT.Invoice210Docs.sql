CREATE TABLE [EDIPILOT].[Invoice210Docs]
(
[Status] [int] NOT NULL CONSTRAINT [DF__Invoice21__Statu__24D8BB84] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__Invoice210__Type__25CCDFBD] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[DocumentImportDT] [datetime] NULL,
[TradingPartner] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocType] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Version] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__Invoice21__RowCr__26C103F6] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Invoice21__RowCr__27B5282F] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__Invoice21__RowMo__28A94C68] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Invoice21__RowMo__299D70A1] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDIPILOT].[Invoice210Docs] ADD CONSTRAINT [PK__Invoice2__FFEE7450159677F4] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
