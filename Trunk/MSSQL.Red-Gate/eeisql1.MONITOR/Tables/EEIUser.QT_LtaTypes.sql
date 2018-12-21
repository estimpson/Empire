CREATE TABLE [EEIUser].[QT_LtaTypes]
(
[LtaType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__QT_LtaTyp__Statu__03A8716D] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__QT_LtaType__Type__049C95A6] DEFAULT ((0)),
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartDate] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__QT_LtaTyp__RowCr__0590B9DF] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QT_LtaTyp__RowCr__0684DE18] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__QT_LtaTyp__RowMo__07790251] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QT_LtaTyp__RowMo__086D268A] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_LtaTypes] ADD CONSTRAINT [PK__QT_LtaTy__FFEE745101C028FB] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_LtaTypes] ADD CONSTRAINT [UQ__QT_LtaTy__49C2AAD6307B17E4] UNIQUE NONCLUSTERED  ([LtaType]) ON [PRIMARY]
GO
