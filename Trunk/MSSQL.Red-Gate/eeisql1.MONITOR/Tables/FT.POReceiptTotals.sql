CREATE TABLE [FT].[POReceiptTotals]
(
[PONumber] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StdQty] [numeric] (20, 6) NOT NULL,
[AccumAdjust] [numeric] (20, 6) NOT NULL,
[LastReceivedAmount] [numeric] (20, 6) NULL,
[LastReceivedDT] [datetime] NULL,
[ReceiptCount] [int] NOT NULL,
[LastUpdated] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[POReceiptTotals] ADD CONSTRAINT [PK__POReceip__33AC53294EA4D81E] PRIMARY KEY CLUSTERED  ([PONumber], [Part]) ON [PRIMARY]
GO
