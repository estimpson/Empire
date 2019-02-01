CREATE TABLE [EEIUser].[QL_QuoteTransfer_CustomerContacts]
(
[QuoteNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__QL_QuoteT__Statu__1691F406] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__QL_QuoteTr__Type__1786183F] DEFAULT ((0)),
[Title] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FaxNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress] [varchar] (320) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__QL_QuoteT__RowCr__187A3C78] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QL_QuoteT__RowCr__196E60B1] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__QL_QuoteT__RowMo__1A6284EA] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QL_QuoteT__RowMo__1B56A923] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QL_QuoteTransfer_CustomerContacts] ADD CONSTRAINT [PK__QL_Quote__FFEE745114A9AB94] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QL_QuoteTransfer_CustomerContacts] ADD CONSTRAINT [UQ__QL_Quote__488CF0277E6EECCE] UNIQUE NONCLUSTERED  ([QuoteNumber], [Title]) ON [PRIMARY]
GO
