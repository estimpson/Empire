CREATE TABLE [EEIUser].[QT_CustomersNew]
(
[CustomerCode] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__QT_Custom__Statu__0D31DBA7] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__QT_Custome__Type__0E25FFE0] DEFAULT ((0)),
[CustomerName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address3] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PostalCode] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Terms] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LtaType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResponseNote] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__QT_Custom__RowCr__0F1A2419] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QT_Custom__RowCr__100E4852] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__QT_Custom__RowMo__11026C8B] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QT_Custom__RowMo__11F690C4] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_CustomersNew] ADD CONSTRAINT [PK__QT_Custo__FFEE74510B499335] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_CustomersNew] ADD CONSTRAINT [UQ__QT_Custo__066785213357848F] UNIQUE NONCLUSTERED  ([CustomerCode]) ON [PRIMARY]
GO
