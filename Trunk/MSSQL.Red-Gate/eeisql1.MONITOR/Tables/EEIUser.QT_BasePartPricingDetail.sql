CREATE TABLE [EEIUser].[QT_BasePartPricingDetail]
(
[PartNumber] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__QT_BasePa__Statu__336C9328] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__QT_BasePar__Type__3460B761] DEFAULT ((0)),
[QuoteNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveDate] [datetime] NULL,
[Price] [decimal] (20, 4) NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__QT_BasePa__RowCr__3554DB9A] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QT_BasePa__RowCr__3648FFD3] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__QT_BasePa__RowMo__373D240C] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QT_BasePa__RowMo__38314845] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_BasePartPricingDetail] ADD CONSTRAINT [PK__QT_BaseP__FFEE745131844AB6] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
