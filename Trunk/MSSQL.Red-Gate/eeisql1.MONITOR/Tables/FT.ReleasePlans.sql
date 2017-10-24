CREATE TABLE [FT].[ReleasePlans]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[GeneratedDT] [datetime] NOT NULL CONSTRAINT [DF__ReleasePl__Gener__5832119F] DEFAULT (getdate()),
[GeneratedWeekNo] [int] NOT NULL,
[GeneratedWeekDay] [tinyint] NOT NULL CONSTRAINT [DF__ReleasePl__Gener__592635D8] DEFAULT (datepart(weekday,getdate())),
[BaseDT] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[ReleasePlans] ADD CONSTRAINT [CK__ReleasePl__Gener__4C764630] CHECK (([GeneratedWeekDay]>=(1) AND [GeneratedWeekDay]<=(7)))
GO
ALTER TABLE [FT].[ReleasePlans] ADD CONSTRAINT [CK__ReleasePl__Gener__4B8221F7] CHECK (([GeneratedWeekNo]>(0)))
GO
ALTER TABLE [FT].[ReleasePlans] ADD CONSTRAINT [PK__ReleasePlans__573DED66] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
