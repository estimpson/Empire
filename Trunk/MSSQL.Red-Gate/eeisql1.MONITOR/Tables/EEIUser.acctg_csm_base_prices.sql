CREATE TABLE [EEIUser].[acctg_csm_base_prices]
(
[BasePart] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QuoteNumber] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Price] [decimal] (18, 6) NULL,
[EffectiveDT] [datetime] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_base_prices] ADD CONSTRAINT [PK_BasePrices_BasePart] PRIMARY KEY CLUSTERED  ([BasePart]) ON [PRIMARY]
GO
