CREATE TABLE [FT].[HistoricalSalesData]
(
[BasePart] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EntryDay] [datetime] NOT NULL,
[RevLevel] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PriceSales] [numeric] (20, 6) NULL,
[QtyShipped] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[HistoricalSalesData] ADD CONSTRAINT [PK__HistoricalSalesD__6EE530D7] PRIMARY KEY CLUSTERED  ([BasePart], [EntryDay], [RevLevel]) ON [PRIMARY]
GO
