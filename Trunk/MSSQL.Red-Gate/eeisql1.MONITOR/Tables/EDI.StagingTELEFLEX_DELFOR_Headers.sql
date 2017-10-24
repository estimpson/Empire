CREATE TABLE [EDI].[StagingTELEFLEX_DELFOR_Headers]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingTE__Statu__6582E83D] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingTEL__Type__66770C76] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingTE__RowCr__676B30AF] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingTE__RowCr__685F54E8] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingTE__RowMo__69537921] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingTE__RowMo__6A479D5A] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[StagingTELEFLEX_DELFOR_Headers] ADD CONSTRAINT [PK__StagingT__FFEE7450639A9FCB] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
