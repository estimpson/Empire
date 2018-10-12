CREATE TABLE [FT].[FinalPOTDiscrepancies]
(
[Type] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartProduced] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartConsumed] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Serial] [int] NULL,
[TotalDisc] [numeric] (20, 6) NULL,
[UnitCost] [numeric] (20, 6) NULL,
[TotalCost] [numeric] (20, 6) NULL,
[BFDelta] [numeric] (20, 6) NULL,
[QtyManualIssued] [numeric] (18, 6) NULL,
[RemainingMaterialIssue] [numeric] (20, 6) NULL,
[QtyManuallyAdded] [numeric] (18, 6) NULL,
[ReturnToLine] [numeric] (20, 6) NULL,
[UnreconciledDifference] [numeric] (22, 6) NULL,
[FoundPRE] [numeric] (20, 6) NULL,
[UndoFound] [numeric] (20, 6) NULL,
[LostPOTLocation] [numeric] (38, 6) NULL
) ON [PRIMARY]
GO
