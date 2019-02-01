CREATE TABLE [FedEx].[ThirdPartyRates_OverOneHundredPounds_InternationalEconomy]
(
[WeightRange] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
[ZoneP] [decimal] (10, 2) NULL,
[Status] [int] NULL CONSTRAINT [DF__ThirdPart__Statu__7D1C3AC6] DEFAULT ((0)),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__ThirdPart__RowCr__7E105EFF] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ThirdPart__RowCr__7F048338] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__ThirdPart__RowMo__7FF8A771] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ThirdPart__RowMo__00ECCBAA] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[ThirdPartyRates_OverOneHundredPounds_InternationalEconomy] ADD CONSTRAINT [PK_IntEconomyRowID] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[ThirdPartyRates_OverOneHundredPounds_InternationalEconomy] ADD CONSTRAINT [UQ__ThirdPar__D51458FC7B33F254] UNIQUE NONCLUSTERED  ([WeightRange]) ON [PRIMARY]
GO
