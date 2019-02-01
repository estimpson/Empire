CREATE TABLE [FedEx].[ThirdPartyRates_ZoneK]
(
[Weight] [int] NULL,
[InternationalFirst] [decimal] (10, 2) NULL,
[InternationalPriority] [decimal] (10, 2) NULL,
[InternationalEconomy] [decimal] (10, 2) NULL,
[Status] [int] NULL CONSTRAINT [DF__ThirdPart__Statu__090D105F] DEFAULT ((0)),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__ThirdPart__RowCr__0A013498] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ThirdPart__RowCr__0AF558D1] DEFAULT (user_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__ThirdPart__RowMo__0BE97D0A] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ThirdPart__RowMo__0CDDA143] DEFAULT (user_name())
) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[ThirdPartyRates_ZoneK] ADD CONSTRAINT [PK_ZoneKRowID] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [FedEx].[ThirdPartyRates_ZoneK] ADD CONSTRAINT [UQ__ThirdPar__CAD8CB4E0724C7ED] UNIQUE NONCLUSTERED  ([Weight]) ON [PRIMARY]
GO
