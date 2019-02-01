CREATE TABLE [FedEx].[ThirdPartyRates_ZoneP]
(
[Weight] [int] NULL,
[InternationalFirst] [decimal] (10, 2) NULL,
[InternationalPriority] [decimal] (10, 2) NULL,
[InternationalEconomy] [decimal] (10, 2) NULL,
[Status] [int] NULL CONSTRAINT [DF__ThirdPart__Statu__38BC2381] DEFAULT ((0)),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__ThirdPart__RowCr__39B047BA] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ThirdPart__RowCr__3AA46BF3] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__ThirdPart__RowMo__3B98902C] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ThirdPart__RowMo__3C8CB465] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[ThirdPartyRates_ZoneP] ADD CONSTRAINT [PK_ZonePRowID] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[ThirdPartyRates_ZoneP] ADD CONSTRAINT [UQ__ThirdPar__CAD8CB4E36D3DB0F] UNIQUE NONCLUSTERED  ([Weight]) ON [PRIMARY]
GO
