CREATE TABLE [dbo].[dbo.dixiewire_quote_detail]
(
[quote_number] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[buy_unit] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[dixie_group] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[uom] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[price_per_uom] [decimal] (18, 6) NULL,
[price_per_ft] [decimal] (18, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dbo.dixiewire_quote_detail] ADD CONSTRAINT [quote_detail_2] PRIMARY KEY CLUSTERED  ([quote_number], [buy_unit], [dixie_group]) ON [PRIMARY]
GO
