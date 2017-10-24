CREATE TABLE [FT].[HighRawAuthorizations]
(
[PONumber] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AuthorizedAccum] [numeric] (20, 6) NULL,
[WeekNo] [smallint] NOT NULL,
[ReleasePlanID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[HighRawAuthorizations] ADD CONSTRAINT [PK__HighRawAuthoriza__5F3414E9] PRIMARY KEY CLUSTERED  ([PONumber], [Part]) ON [PRIMARY]
GO
ALTER TABLE [FT].[HighRawAuthorizations] ADD CONSTRAINT [FK__HighRawAu__Relea__55FFB06A] FOREIGN KEY ([ReleasePlanID]) REFERENCES [FT].[ReleasePlans] ([ID])
GO
