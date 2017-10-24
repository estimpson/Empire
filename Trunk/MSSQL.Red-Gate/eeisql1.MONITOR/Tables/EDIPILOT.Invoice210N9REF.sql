CREATE TABLE [EDIPILOT].[Invoice210N9REF]
(
[Status] [int] NOT NULL CONSTRAINT [DF__Invoice21__Statu__656841E5] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__Invoice210__Type__665C661E] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[b3InvoiceNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[N9IDQualifier] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[N9ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined6] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined7] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined8] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined9] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserDefined10] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__Invoice21__RowCr__67508A57] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Invoice21__RowCr__6844AE90] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__Invoice21__RowMo__6938D2C9] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Invoice21__RowMo__6A2CF702] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDIPILOT].[Invoice210N9REF] ADD CONSTRAINT [PK__Invoice2__FFEE7450637FF973] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
