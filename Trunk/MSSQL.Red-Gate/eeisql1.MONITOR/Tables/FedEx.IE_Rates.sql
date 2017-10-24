CREATE TABLE [FedEx].[IE_Rates]
(
[Weight] [int] NULL,
[ZoneA] [decimal] (10, 2) NULL,
[ZoneB] [decimal] (10, 2) NULL,
[ZoneC] [decimal] (10, 2) NULL,
[ZoneD] [decimal] (10, 2) NULL,
[ZoneE] [decimal] (10, 2) NULL,
[ZoneF] [decimal] (10, 2) NULL,
[ZoneG] [decimal] (10, 2) NULL,
[ZoneH] [decimal] (10, 2) NULL,
[ZoneI] [decimal] (10, 2) NULL,
[ZoneJ] [decimal] (10, 2) NULL,
[ZoneK] [decimal] (10, 2) NULL,
[ZoneL] [decimal] (10, 2) NULL,
[ZoneM] [decimal] (10, 2) NULL,
[ZoneN] [decimal] (10, 2) NULL,
[ZoneO] [decimal] (10, 2) NULL,
[Status] [int] NULL CONSTRAINT [DF_IE_Rates_Status] DEFAULT ((0)),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__IERates__RowCreateDT] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__IERates__RowCreateUser] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__IERates__RowModifiedDT] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__IERates__RowModifiedUser] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[IE_Rates] ADD CONSTRAINT [PK_IERatesRowID] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[IE_Rates] ADD CONSTRAINT [UQ__IE_Rates__CAD8CB4E1CBF6B14] UNIQUE NONCLUSTERED  ([Weight]) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[IE_Rates] ADD CONSTRAINT [UQ__IE_Rates__CAD8CB4E3521048A] UNIQUE NONCLUSTERED  ([Weight]) ON [PRIMARY]
GO
