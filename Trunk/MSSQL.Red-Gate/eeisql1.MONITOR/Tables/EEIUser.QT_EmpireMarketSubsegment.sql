CREATE TABLE [EEIUser].[QT_EmpireMarketSubsegment]
(
[EmpireMarketSubsegment] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__QT_Empire__Statu__6127A589] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__QT_EmpireM__Type__621BC9C2] DEFAULT ((0)),
[RequestorNote] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResponseNote] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__QT_Empire__RowCr__630FEDFB] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QT_Empire__RowCr__64041234] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__QT_Empire__RowMo__64F8366D] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QT_Empire__RowMo__65EC5AA6] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_EmpireMarketSubsegment] ADD CONSTRAINT [PK__QT_Empir__FFEE74515F3F5D17] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
