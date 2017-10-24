CREATE TABLE [EDIPILOT].[StagingInvoice210Address]
(
[Status] [int] NOT NULL CONSTRAINT [DF__StagingIn__Statu__3C662C52] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__StagingInv__Type__3D5A508B] DEFAULT ((0)),
[RawDocumentGUID] [uniqueidentifier] NULL,
[InvoiceNumber] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[N1Qualifier] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[N1Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[N1IDQualifier] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[N1IDCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[N201Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[N202Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[N301Address] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[N401City] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[N402State] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[N403Zip] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[n404Country] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__StagingIn__RowCr__3E4E74C4] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingIn__RowCr__3F4298FD] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__StagingIn__RowMo__4036BD36] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__StagingIn__RowMo__412AE16F] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDIPILOT].[StagingInvoice210Address] ADD CONSTRAINT [PK__StagingI__FFEE74503A7DE3E0] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
