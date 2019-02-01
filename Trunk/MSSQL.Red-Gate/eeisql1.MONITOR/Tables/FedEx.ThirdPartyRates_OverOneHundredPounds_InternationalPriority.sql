CREATE TABLE [FedEx].[ThirdPartyRates_OverOneHundredPounds_InternationalPriority]
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
[Status] [int] NULL CONSTRAINT [DF__ThirdPart__Statu__7392D08C] DEFAULT ((0)),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__ThirdPart__RowCr__7486F4C5] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ThirdPart__RowCr__757B18FE] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__ThirdPart__RowMo__766F3D37] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ThirdPart__RowMo__77636170] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[ThirdPartyRates_OverOneHundredPounds_InternationalPriority] ADD CONSTRAINT [PK_IntPriorityRowID] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[ThirdPartyRates_OverOneHundredPounds_InternationalPriority] ADD CONSTRAINT [UQ__ThirdPar__D51458FC71AA881A] UNIQUE NONCLUSTERED  ([WeightRange]) ON [PRIMARY]
GO
