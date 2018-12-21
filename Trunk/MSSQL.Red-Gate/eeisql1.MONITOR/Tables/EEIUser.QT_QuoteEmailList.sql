CREATE TABLE [EEIUser].[QT_QuoteEmailList]
(
[OperatorCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__QT_QuoteE__Statu__5C18D7A9] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__QT_QuoteEm__Type__5D0CFBE2] DEFAULT ((0)),
[EmailAddress] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__QT_QuoteE__RowCr__5E01201B] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QT_QuoteE__RowCr__5EF54454] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__QT_QuoteE__RowMo__5FE9688D] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QT_QuoteE__RowMo__60DD8CC6] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_QuoteEmailList] ADD CONSTRAINT [PK__QT_Quote__FFEE74515A308F37] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_QuoteEmailList] ADD CONSTRAINT [UQ__QT_Quote__49A1474065A241E3] UNIQUE NONCLUSTERED  ([EmailAddress]) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_QuoteEmailList] ADD CONSTRAINT [UQ__QT_Quote__8C70C42762C5D538] UNIQUE NONCLUSTERED  ([OperatorCode]) ON [PRIMARY]
GO
