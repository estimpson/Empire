CREATE TABLE [FT].[POReceiptPeriods]
(
[PeriodID] [int] NOT NULL,
[PONumber] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StdQty] [numeric] (20, 6) NOT NULL,
[AccumAdjust] [numeric] (20, 6) NOT NULL,
[LastReceivedAmount] [numeric] (20, 6) NULL,
[LastReceivedDT] [datetime] NULL,
[ReceiptCount] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[POReceiptPeriods] ADD CONSTRAINT [PK__POReceiptPeriods__53C2623D] PRIMARY KEY CLUSTERED  ([PeriodID], [PONumber], [Part]) ON [PRIMARY]
GO
ALTER TABLE [FT].[POReceiptPeriods] ADD CONSTRAINT [FK__POReceipt__Perio__522F1F86] FOREIGN KEY ([PeriodID]) REFERENCES [FT].[ReceiptPeriods] ([ID])
GO
