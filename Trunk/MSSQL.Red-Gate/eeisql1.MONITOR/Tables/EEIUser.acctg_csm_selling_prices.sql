CREATE TABLE [EEIUser].[acctg_csm_selling_prices]
(
[FORECAST_ID] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[VERSION] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BASE_PART] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[YEAR] [int] NOT NULL,
[PERIOD] [int] NOT NULL,
[BEG_EFFECTIVE_DATE] [datetime] NULL,
[END_EFFECTIVE_DATE] [datetime] NULL,
[SELLING_PRICE] [decimal] (18, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_selling_prices] ADD CONSTRAINT [PK_acctg_csm_selling_prices] PRIMARY KEY CLUSTERED  ([FORECAST_ID], [VERSION], [BASE_PART], [YEAR], [PERIOD]) ON [PRIMARY]
GO
