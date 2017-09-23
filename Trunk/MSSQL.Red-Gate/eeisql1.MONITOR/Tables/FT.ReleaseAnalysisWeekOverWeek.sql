CREATE TABLE [FT].[ReleaseAnalysisWeekOverWeek]
(
[AnalysisDT] [datetime] NULL,
[PWSSDT] [datetime] NULL,
[CWSSDT] [datetime] NULL,
[Customer] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipTo] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BasePart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShippedBtwSS] [numeric] (38, 6) NULL,
[PW4WkDmd] [numeric] (38, 6) NULL,
[CW4WkDmd] [numeric] (38, 6) NULL,
[Wk4Variance] [numeric] (38, 6) NULL,
[PW8WkDmd] [numeric] (38, 6) NULL,
[CW8WkDmd] [numeric] (38, 6) NULL,
[Wk8Variance] [numeric] (38, 6) NULL,
[PW12WkDmd] [numeric] (38, 6) NULL,
[CW12WkDmd] [numeric] (38, 6) NULL,
[Wk12Variance] [numeric] (38, 6) NULL,
[PWFutureDmd] [numeric] (38, 6) NULL,
[CWFutureDmd] [numeric] (38, 6) NULL,
[FutureVariance] [numeric] (38, 6) NULL
) ON [PRIMARY]
GO
