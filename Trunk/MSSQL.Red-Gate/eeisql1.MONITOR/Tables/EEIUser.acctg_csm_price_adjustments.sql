CREATE TABLE [EEIUser].[acctg_csm_price_adjustments]
(
[BasePart] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Part] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QuoteNumber] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AdjustmentType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SellingPrice] [decimal] (18, 6) NULL,
[PriceAdjustment] [decimal] (18, 6) NULL,
[EffectiveDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_price_adjustments] ADD CONSTRAINT [PK__acctg_cs__FFEE745155A07190] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
