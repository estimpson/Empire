CREATE TABLE [dbo].[SupplierReleasePlanRaw]
(
[ReleasePlanID] [int] NOT NULL,
[OrderNumber] [int] NOT NULL,
[CurrentWeek] [smallint] NOT NULL,
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
[ReleaseNo] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BasePart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Destination] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SupplierReleasePlanRaw] ADD CONSTRAINT [PK__Supplier__7A9081246F01F6AE] PRIMARY KEY CLUSTERED  ([ReleasePlanID], [OrderNumber], [Part], [DueDT], [LineID]) ON [PRIMARY]
GO
