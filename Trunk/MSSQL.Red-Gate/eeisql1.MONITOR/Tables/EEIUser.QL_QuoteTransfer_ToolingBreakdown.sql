CREATE TABLE [EEIUser].[QL_QuoteTransfer_ToolingBreakdown]
(
[QuoteNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__QL_QuoteT__Statu__2203A6B2] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__QL_QuoteTr__Type__22F7CAEB] DEFAULT ((0)),
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [int] NULL,
[Value] [decimal] (20, 2) NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__QL_QuoteT__RowCr__23EBEF24] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QL_QuoteT__RowCr__24E0135D] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__QL_QuoteT__RowMo__25D43796] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QL_QuoteT__RowMo__26C85BCF] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QL_QuoteTransfer_ToolingBreakdown] ADD CONSTRAINT [PK__QL_Quote__FFEE7451201B5E40] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QL_QuoteTransfer_ToolingBreakdown] ADD CONSTRAINT [UQ__QL_Quote__1EAC2DC6070432CF] UNIQUE NONCLUSTERED  ([QuoteNumber], [Description]) ON [PRIMARY]
GO
