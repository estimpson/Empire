CREATE TABLE [EDIPILOT].[StagingInvoice210N9REF]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingIn__Statu__5BDED7AB] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingInv__Type__5CD2FBE4] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingIn__RowCr__5DC7201D] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingIn__RowCr__5EBB4456] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingIn__RowMo__5FAF688F] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingIn__RowMo__60A38CC8] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDIPILOT].[StagingInvoice210N9REF] ADD CONSTRAINT [PK__StagingI__FFEE745059F68F39] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
