CREATE TABLE [dbo].[ReleasePlanDetails]
(
[ReleasePlanID] [int] NOT NULL,
[VendorCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PONumber] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LeadDays] [numeric] (6, 2) NULL,
[AccumReceived] [numeric] (20, 6) NULL,
[WeekNo] [int] NOT NULL,
[DueDT] [datetime] NOT NULL,
[StdQty] [numeric] (20, 6) NULL,
[PriorAccum] [numeric] (20, 6) NULL,
[PostAccum] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
