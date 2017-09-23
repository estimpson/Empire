CREATE TABLE [EDIPILOT].[StagingInvoice210Docs]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingIn__Statu__02B8ADAA] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingInv__Type__03ACD1E3] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[DocumentImportDT] [datetime] NULL,
[TradingPartner] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocType] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Version] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingIn__RowCr__04A0F61C] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingIn__RowCr__05951A55] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingIn__RowMo__06893E8E] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingIn__RowMo__077D62C7] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDIPILOT].[StagingInvoice210Docs] ADD CONSTRAINT [PK__StagingI__FFEE745000D06538] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
