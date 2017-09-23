CREATE TABLE [FT].[ReleasePlanRaw]
(
[ReleasePlanID] [int] NOT NULL,
[ReceiptPeriodID] [int] NOT NULL,
[PONumber] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WeekNo] [smallint] NOT NULL,
[DueDT] [datetime] NOT NULL,
[LineID] [int] NOT NULL,
[StdQty] [numeric] (20, 6) NOT NULL,
[PriorAccum] [numeric] (20, 6) NOT NULL,
[PostAccum] [numeric] (20, 6) NOT NULL,
[AccumReceived] [numeric] (20, 6) NOT NULL,
[LastReceivedDT] [datetime] NULL,
[LastReceivedAmount] [numeric] (20, 6) NULL,
[FabWeekNo] [smallint] NOT NULL,
[RawWeekNo] [smallint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[ReleasePlanRaw] ADD CONSTRAINT [PK__ReleasePlanRaw__66D536B1] PRIMARY KEY CLUSTERED  ([ReleasePlanID], [PONumber], [Part], [DueDT], [LineID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_ReleasePlanRaw_1] ON [FT].[ReleasePlanRaw] ([PONumber], [Part], [WeekNo], [ReleasePlanID]) ON [PRIMARY]
GO
ALTER TABLE [FT].[ReleasePlanRaw] ADD CONSTRAINT [FK__ReleasePl__Relea__5AC46587] FOREIGN KEY ([ReleasePlanID]) REFERENCES [FT].[ReleasePlans] ([ID])
GO
