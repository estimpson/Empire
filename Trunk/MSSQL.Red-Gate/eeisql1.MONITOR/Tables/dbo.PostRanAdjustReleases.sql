CREATE TABLE [dbo].[PostRanAdjustReleases]
(
[RowID] [int] NOT NULL IDENTITY(1, 1),
[Type] [tinyint] NULL,
[OrderNo] [int] NULL,
[BlanketPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipToID] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPO] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModelYear] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderUnit] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyShipper] [numeric] (20, 6) NULL,
[Line] [int] NULL,
[ReleaseNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyRelease] [numeric] (20, 6) NULL,
[StdQtyRelease] [numeric] (20, 6) NULL,
[ReferenceAccum] [numeric] (20, 6) NULL,
[RelPrior] [numeric] (20, 6) NULL,
[RelPost] [numeric] (20, 6) NULL,
[ReleaseDT] [datetime] NULL,
[LastRANDT] [datetime] NULL,
[NewDocument] [int] NULL
) ON [PRIMARY]
GO
