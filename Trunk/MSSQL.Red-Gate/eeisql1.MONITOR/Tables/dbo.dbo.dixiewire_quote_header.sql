CREATE TABLE [dbo].[dbo.dixiewire_quote_header]
(
[quote_number] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[quote_date] [datetime] NOT NULL,
[beg_eff_date] [datetime] NOT NULL,
[end_eff_date] [datetime] NOT NULL,
[comex_copper_avg_price] [decimal] (18, 6) NOT NULL,
[dixie_adder_price] [decimal] (18, 6) NOT NULL,
[dixie_copper_base_price] [decimal] (18, 6) NOT NULL,
[payment_terms] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[freight_terms] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dbo.dixiewire_quote_header] ADD CONSTRAINT [quote_number] PRIMARY KEY CLUSTERED  ([quote_number]) ON [PRIMARY]
GO
