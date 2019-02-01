CREATE TABLE [FedEx].[ThirdPartyRates_ZoneE]
(
[Weight] [int] NULL,
[InternationalFirst] [decimal] (10, 2) NULL,
[InternationalPriority] [decimal] (10, 2) NULL,
[InternationalEconomy] [decimal] (10, 2) NULL,
[Status] [int] NULL CONSTRAINT [DF__ThirdPart__Statu__595DFD3D] DEFAULT ((0)),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__ThirdPart__RowCr__5A522176] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ThirdPart__RowCr__5B4645AF] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__ThirdPart__RowMo__5C3A69E8] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ThirdPart__RowMo__5D2E8E21] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[ThirdPartyRates_ZoneE] ADD CONSTRAINT [PK_ZoneERowID] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[ThirdPartyRates_ZoneE] ADD CONSTRAINT [UQ__ThirdPar__CAD8CB4E5775B4CB] UNIQUE NONCLUSTERED  ([Weight]) ON [PRIMARY]
GO
