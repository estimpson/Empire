CREATE TABLE [dbo].[POReceiptTotalsTemp]
(
[PONumber] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StdQty] [numeric] (20, 6) NULL,
[AccumAdjust] [numeric] (20, 6) NULL,
[LastReceivedAmount] [numeric] (20, 6) NULL,
[LastReceivedDT] [datetime] NULL,
[ReceiptCount] [int] NOT NULL,
[LastUpdated] [datetime] NOT NULL
) ON [PRIMARY]
GO
