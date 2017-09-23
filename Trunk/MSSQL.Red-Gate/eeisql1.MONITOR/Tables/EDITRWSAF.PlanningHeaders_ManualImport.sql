CREATE TABLE [EDITRWSAF].[PlanningHeaders_ManualImport]
(
[Status] [int] NOT NULL CONSTRAINT [DF__PlanTRWSAF__Statu__5E6F3151] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__PlanTRWSAF__Type__5F63558A] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[DocumentImportDT] [datetime] NULL,
[TradingPartner] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocType] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Version] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Release] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ControlNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocumentDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__PlanTRWSAF__RowCr__605779C3] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PlanTRWSAF__RowCr__614B9DFC] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__PlanTRWSAF__RowMo__623FC235] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PlanTRWSAF__RowMo__6333E66E] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDITRWSAF].[PlanningHeaders_ManualImport] ADD CONSTRAINT [PK__PlanTRWSAF__FFEE74504697A7C0] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
