CREATE TABLE [FT].[RawAuthorizations]
(
[ReleasePlanID] [int] NOT NULL,
[PONumber] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WeekNo] [smallint] NOT NULL,
[AuthorizedAccum] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[RawAuthorizations] ADD CONSTRAINT [PK__RawAuthorization__5D4BCC77] PRIMARY KEY CLUSTERED  ([ReleasePlanID], [PONumber], [Part]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_RawAuthorizations_1] ON [FT].[RawAuthorizations] ([PONumber], [Part], [WeekNo], [ReleasePlanID]) ON [PRIMARY]
GO
ALTER TABLE [FT].[RawAuthorizations] ADD CONSTRAINT [FK__RawAuthor__Relea__550B8C31] FOREIGN KEY ([ReleasePlanID]) REFERENCES [FT].[ReleasePlans] ([ID])
GO
