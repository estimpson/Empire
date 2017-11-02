CREATE TABLE [HN].[Picklist_RF_DataExcel]
(
[Operator] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipperID] [int] NULL,
[CrossRef] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyRequired] [int] NULL,
[StandardPack] [int] NULL,
[BoxesAvailable] [int] NULL,
[BoxesRequired] [int] NULL,
[BoxesPicked] [int] NULL,
[Status] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comments] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyPicked] [int] NULL,
[TAB] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Pending] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LOT] [int] NULL,
[LocQty] [int] NULL,
[LotReq] [int] NULL,
[BestOption] [int] NULL,
[boxtype] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[location] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreateDT] [datetime] NULL CONSTRAINT [DF__Picklist___Creat__602469DB] DEFAULT (getdate())
) ON [PRIMARY]
GO