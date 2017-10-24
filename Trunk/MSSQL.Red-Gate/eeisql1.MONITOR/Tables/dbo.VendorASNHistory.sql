CREATE TABLE [dbo].[VendorASNHistory]
(
[ASNID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ASNDate] [datetime] NOT NULL,
[ShipFrom] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BOL] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EEpart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EEPO] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QTYShipped] [numeric] (20, 6) NULL,
[CUMQtyShipped] [numeric] (20, 6) NULL,
[PackQty] [numeric] (20, 6) NULL,
[Serial] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
