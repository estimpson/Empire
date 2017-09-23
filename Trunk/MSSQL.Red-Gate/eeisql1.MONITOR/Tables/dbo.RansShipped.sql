CREATE TABLE [dbo].[RansShipped]
(
[RANNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OrderNo] [int] NULL,
[RanQty] [numeric] (20, 6) NULL,
[CustomerPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Destination] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
