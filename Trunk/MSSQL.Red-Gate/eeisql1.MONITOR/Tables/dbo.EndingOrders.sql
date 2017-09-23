CREATE TABLE [dbo].[EndingOrders]
(
[ID] [int] NOT NULL,
[PartCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CustomerCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EndingQty] [decimal] (20, 6) NOT NULL
) ON [PRIMARY]
GO
