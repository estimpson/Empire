CREATE TABLE [FedEx].[ThirdPartyRates_ZoneH]
(
[Weight] [int] NULL,
[InternationalFirst] [decimal] (10, 2) NULL,
[InternationalPriority] [decimal] (10, 2) NULL,
[InternationalEconomy] [decimal] (10, 2) NULL,
[Status] [int] NULL CONSTRAINT [DF__ThirdPart__Statu__6C70D1B1] DEFAULT ((0)),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__ThirdPart__RowCr__6D64F5EA] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ThirdPart__RowCr__6E591A23] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__ThirdPart__RowMo__6F4D3E5C] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ThirdPart__RowMo__70416295] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[ThirdPartyRates_ZoneH] ADD CONSTRAINT [PK_ZoneHRowID] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[ThirdPartyRates_ZoneH] ADD CONSTRAINT [UQ__ThirdPar__CAD8CB4E6A88893F] UNIQUE NONCLUSTERED  ([Weight]) ON [PRIMARY]
GO
