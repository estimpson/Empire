CREATE TABLE [dbo].[suspectOrdersDeltaConsideringShipping]
(
[YOrder] [numeric] (8, 0) NULL,
[TodaysQuantity] [decimal] (38, 6) NULL,
[YesterdaysQuantity] [decimal] (38, 6) NULL,
[QtyShipped] [numeric] (38, 6) NULL
) ON [PRIMARY]
GO
