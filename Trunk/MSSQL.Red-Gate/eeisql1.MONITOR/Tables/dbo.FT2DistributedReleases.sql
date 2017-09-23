CREATE TABLE [dbo].[FT2DistributedReleases]
(
[OrderNo] [int] NULL,
[OrderType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModelYear] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderUnit] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyRelease] [numeric] (20, 6) NULL,
[RelPost] [numeric] (20, 6) NULL,
[QtyCommitted] [numeric] (20, 6) NULL,
[ReleaseDT] [datetime] NULL,
[Line] [int] NULL
) ON [PRIMARY]
GO
