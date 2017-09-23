CREATE TABLE [FT].[CurrentReleasePlan]
(
[PONumber] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WeekNo] [smallint] NOT NULL,
[StdQty] [numeric] (20, 6) NOT NULL,
[PriorAccum] [numeric] (20, 6) NOT NULL,
[PostAccum] [numeric] (20, 6) NULL,
[ReleasePlanID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[CurrentReleasePlan] ADD CONSTRAINT [PK__CurrentReleasePl__68BD7F23] PRIMARY KEY CLUSTERED  ([PONumber], [Part], [WeekNo]) ON [PRIMARY]
GO
ALTER TABLE [FT].[CurrentReleasePlan] ADD CONSTRAINT [FK__CurrentRe__Relea__5BB889C0] FOREIGN KEY ([ReleasePlanID]) REFERENCES [FT].[ReleasePlans] ([ID])
GO
