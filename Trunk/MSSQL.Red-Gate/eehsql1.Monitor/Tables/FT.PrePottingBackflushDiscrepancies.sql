CREATE TABLE [FT].[PrePottingBackflushDiscrepancies]
(
[Type] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartProduced] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartConsumed] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Serial] [int] NULL,
[TotalDisc] [numeric] (20, 6) NULL,
[UnitCost] [numeric] (20, 6) NULL,
[TotalCost] [numeric] (20, 6) NULL,
[BFDelta] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
