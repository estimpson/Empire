CREATE TABLE [EEIUser].[QT_ProductEngineerInitials]
(
[Initials] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__QT_Produc__Statu__5A47FFD5] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__QT_Product__Type__5B3C240E] DEFAULT ((0)),
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__QT_Produc__RowCr__5C304847] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QT_Produc__RowCr__5D246C80] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__QT_Produc__RowMo__5E1890B9] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QT_Produc__RowMo__5F0CB4F2] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_ProductEngineerInitials] ADD CONSTRAINT [PK__QT_Produ__FFEE7451585FB763] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
