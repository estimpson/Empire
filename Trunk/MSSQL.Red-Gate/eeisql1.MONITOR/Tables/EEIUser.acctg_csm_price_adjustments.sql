CREATE TABLE [EEIUser].[acctg_csm_price_adjustments]
(
[RowID] [int] NOT NULL,
[BasePart] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Part] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QuoteNumber] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AdjustmentType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SellingPrice] [decimal] (18, 6) NULL,
[PriceAdjustment] [decimal] (18, 6) NULL,
[EffectiveDT] [datetime] NULL
) ON [PRIMARY]
GO
