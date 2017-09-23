CREATE TABLE [dbo].[ADACRanNumbersShipped]
(
[OrderNo] [int] NULL,
[ShipDate] [datetime] NULL,
[Qty] [numeric] (20, 6) NULL,
[RanNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Shipper] [int] NULL
) ON [PRIMARY]
GO
