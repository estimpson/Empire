CREATE TABLE [dbo].[LastEDIOrder]
(
[order_no] [numeric] (8, 0) NOT NULL,
[blanket_part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer_part] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer_po] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EDIShipToID] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[scheduler] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOfLastEDIOrder] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DaysSinceLastEDIOrder] [int] NOT NULL,
[TotalOrderQty] [decimal] (38, 6) NULL,
[FirstDueDate] [datetime] NULL,
[LastDueDate] [datetime] NULL
) ON [PRIMARY]
GO
