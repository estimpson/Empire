CREATE TABLE [EEIUser].[acctg_csm_base_prices]
(
[RowID] [int] NOT NULL,
[BasePart] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QuoteNumber] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Price] [decimal] (18, 6) NULL,
[EffectiveDT] [datetime] NULL
) ON [PRIMARY]
GO
