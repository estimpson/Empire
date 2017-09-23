CREATE TABLE [dbo].[CurrentCustomerReleasePlan]
(
[ReleasePlanID] [int] NOT NULL,
[OrderNumber] [int] NOT NULL,
[currentWeek] [smallint] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WeekNo] [smallint] NOT NULL,
[DueDT] [datetime] NOT NULL,
[LineID] [int] NOT NULL,
[StdQty] [numeric] (20, 6) NULL,
[PriorAccum] [numeric] (20, 6) NULL,
[PostAccum] [numeric] (20, 6) NULL,
[AccumShipped] [numeric] (20, 6) NULL,
[LastShippedDT] [datetime] NULL,
[LastShippedAmount] [numeric] (20, 6) NULL,
[LastShippedShipper] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirmWeeks] [int] NULL,
[FABWeeks] [int] NULL,
[MATWeeks] [int] NULL,
[FABAuthorized] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MATAuthorized] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PosAllowedVariancem] [numeric] (20, 6) NULL,
[NegAllowedVariance] [numeric] (20, 6) NULL,
[EEIEntry] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CurrentCustomerReleasePlan] ADD CONSTRAINT [PK__CurrentCustomerR__4E3E9311] PRIMARY KEY CLUSTERED  ([ReleasePlanID], [OrderNumber], [Part], [DueDT], [LineID]) ON [PRIMARY]
GO
