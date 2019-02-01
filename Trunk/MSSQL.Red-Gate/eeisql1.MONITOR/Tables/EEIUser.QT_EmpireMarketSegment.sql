CREATE TABLE [EEIUser].[QT_EmpireMarketSegment]
(
[EmpireMarketSegment] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__QT_Empire__Statu__579E3B4F] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__QT_EmpireM__Type__58925F88] DEFAULT ((0)),
[RequestorNote] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResponseNote] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__QT_Empire__RowCr__598683C1] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QT_Empire__RowCr__5A7AA7FA] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__QT_Empire__RowMo__5B6ECC33] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QT_Empire__RowMo__5C62F06C] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_EmpireMarketSegment] ADD CONSTRAINT [PK__QT_Empir__FFEE745155B5F2DD] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
