CREATE TABLE [FT].[SupplierDemandAnalysisWeekOverWeekBasePart]
(
[AnalysisDT] [datetime] NULL,
[PriorWeekSnapShotDate] [datetime] NULL,
[AnalysisWeekSnapShotDate] [datetime] NULL,
[Customer] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Destination] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BasePart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QtyShippedBetweenSnapShots] [int] NULL,
[PriorWeekSnapShotDay] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AnalysisWeekSnapShotDay] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Week4QtyPriorWeek] [numeric] (20, 6) NULL,
[Week4QtyAnalysisWeek] [numeric] (20, 6) NULL,
[Week4Variance] [numeric] (20, 6) NULL,
[Week8QtyPriorWeek] [numeric] (20, 6) NULL,
[Week8QtyAnalysisWeek] [numeric] (20, 6) NULL,
[Week8Variance] [numeric] (20, 6) NULL,
[Week12QtyPriorWeek] [numeric] (20, 6) NULL,
[Week12QtyAnalysisWeek] [numeric] (20, 6) NULL,
[Week12Variance] [numeric] (20, 6) NULL,
[TotalQtyPriorWeek] [numeric] (20, 6) NULL,
[TotalQtyAnalysisWeek] [numeric] (20, 6) NULL,
[FutureVariance] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
