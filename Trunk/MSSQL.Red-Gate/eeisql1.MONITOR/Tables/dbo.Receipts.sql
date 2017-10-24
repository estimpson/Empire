CREATE TABLE [dbo].[Receipts]
(
[PONumber] [int] NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QTYReceived] [numeric] (20, 6) NULL,
[CUMQtyReceived] [numeric] (20, 6) NULL,
[CUMQtyAdjust] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
