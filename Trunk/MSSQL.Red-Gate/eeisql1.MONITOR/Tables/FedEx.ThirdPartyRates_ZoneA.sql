CREATE TABLE [FedEx].[ThirdPartyRates_ZoneA]
(
[Weight] [int] NULL,
[InternationalFirst] [decimal] (10, 2) NULL,
[InternationalPriority] [decimal] (10, 2) NULL,
[InternationalEconomy] [decimal] (10, 2) NULL,
[Status] [int] NULL CONSTRAINT [DF__ThirdPart__Statu__31500BE3] DEFAULT ((0)),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__ThirdPart__RowCr__3244301C] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ThirdPart__RowCr__33385455] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__ThirdPart__RowMo__342C788E] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ThirdPart__RowMo__35209CC7] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[ThirdPartyRates_ZoneA] ADD CONSTRAINT [PK_ZoneARowID] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[ThirdPartyRates_ZoneA] ADD CONSTRAINT [UQ__ThirdPar__CAD8CB4E2F67C371] UNIQUE NONCLUSTERED  ([Weight]) ON [PRIMARY]
GO
