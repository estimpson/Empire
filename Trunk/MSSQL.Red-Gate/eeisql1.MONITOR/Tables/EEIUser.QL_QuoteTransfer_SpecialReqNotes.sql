CREATE TABLE [EEIUser].[QL_QuoteTransfer_SpecialReqNotes]
(
[QuoteNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__QL_QuoteT__Statu__2F5DA1D0] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__QL_QuoteTr__Type__3051C609] DEFAULT ((0)),
[Description] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Answer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__QL_QuoteT__RowCr__3145EA42] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QL_QuoteT__RowCr__323A0E7B] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__QL_QuoteT__RowMo__332E32B4] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QL_QuoteT__RowMo__342256ED] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QL_QuoteTransfer_SpecialReqNotes] ADD CONSTRAINT [PK__QL_Quote__FFEE74512D75595E] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QL_QuoteTransfer_SpecialReqNotes] ADD CONSTRAINT [UQ__QL_Quote__1EAC2DC60427C624] UNIQUE NONCLUSTERED  ([QuoteNumber], [Description]) ON [PRIMARY]
GO
