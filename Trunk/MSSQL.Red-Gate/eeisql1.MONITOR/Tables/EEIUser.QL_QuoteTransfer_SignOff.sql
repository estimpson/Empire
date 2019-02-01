CREATE TABLE [EEIUser].[QL_QuoteTransfer_SignOff]
(
[QuoteNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__QL_QuoteT__Statu__47352B61] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__QL_QuoteTr__Type__48294F9A] DEFAULT ((0)),
[Title] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Initials] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SignOffDate] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__QL_QuoteT__RowCr__491D73D3] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QL_QuoteT__RowCr__4A11980C] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__QL_QuoteT__RowMo__4B05BC45] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QL_QuoteT__RowMo__4BF9E07E] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QL_QuoteTransfer_SignOff] ADD CONSTRAINT [PK__QL_Quote__FFEE7451454CE2EF] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QL_QuoteTransfer_SignOff] ADD CONSTRAINT [UQ__QL_Quote__488CF027014B5979] UNIQUE NONCLUSTERED  ([QuoteNumber], [Title]) ON [PRIMARY]
GO
