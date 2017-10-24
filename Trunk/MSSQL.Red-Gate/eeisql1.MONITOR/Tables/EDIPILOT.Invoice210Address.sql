CREATE TABLE [EDIPILOT].[Invoice210Address]
(
[Status] [int] NOT NULL CONSTRAINT [DF__Invoice21__Statu__49C02770] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__Invoice210__Type__4AB44BA9] DEFAULT ((0)),
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
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__Invoice21__RowCr__4BA86FE2] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Invoice21__RowCr__4C9C941B] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__Invoice21__RowMo__4D90B854] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Invoice21__RowMo__4E84DC8D] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [EDIPILOT].[Invoice210Address] ADD CONSTRAINT [PK__Invoice2__FFEE745047D7DEFE] PRIMARY KEY NONCLUSTERED  ([RowID]) ON [PRIMARY]
GO
