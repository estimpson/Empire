CREATE TABLE [dbo].[salesOrderAudit]
(
[order_no] [numeric] (8, 0) NOT NULL,
[ohAccum] [decimal] (20, 6) NULL,
[odAccum] [decimal] (20, 6) NULL,
[YOrder] [numeric] (8, 0) NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastDateShipped] [datetime] NULL,
[LastQtyShipped] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
