CREATE TABLE [FxPVQ].[PartVendorQuotes]
(
[VendorCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PartCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Oem] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__PartVendo__Statu__7C4843E8] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__PartVendor__Type__7D3C6821] DEFAULT ((0)),
[EffectiveDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[Price] [decimal] (10, 6) NULL,
[QuoteFileName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__PartVendo__RowCr__7E308C5A] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PartVendo__RowCr__7F24B093] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__PartVendo__RowMo__0018D4CC] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PartVendo__RowMo__010CF905] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [FxPVQ].[PartVendorQuotes] ADD CONSTRAINT [PK__PartVend__FFEE745177838ECB] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [FxPVQ].[PartVendorQuotes] ADD CONSTRAINT [UQ__PartVend__7058ECCB7A5FFB76] UNIQUE NONCLUSTERED  ([VendorCode], [PartCode]) ON [PRIMARY]
GO
ALTER TABLE [FxPVQ].[PartVendorQuotes] ADD CONSTRAINT [FK_PartVendorQuotes_Oems] FOREIGN KEY ([Oem]) REFERENCES [FxPVQ].[Oems] ([Oem]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [FxPVQ].[PartVendorQuotes] ADD CONSTRAINT [FK_PartVendorQuotes_part] FOREIGN KEY ([PartCode]) REFERENCES [dbo].[part] ([part]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [FxPVQ].[PartVendorQuotes] ADD CONSTRAINT [FK_PartVendorQuotes_vendor] FOREIGN KEY ([VendorCode]) REFERENCES [dbo].[vendor] ([code]) ON DELETE CASCADE ON UPDATE CASCADE
GO
