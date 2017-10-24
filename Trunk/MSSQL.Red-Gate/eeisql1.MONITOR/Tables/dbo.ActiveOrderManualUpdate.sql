CREATE TABLE [dbo].[ActiveOrderManualUpdate]
(
[OrderNo] [int] NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Destination] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CurrentDemand] [numeric] (20, 6) NULL,
[CurrentInventory] [numeric] (20, 6) NULL,
[ActiveFlag] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RevCount] [int] NULL
) ON [PRIMARY]
GO
