CREATE TABLE [FT].[FabAuthorizations]
(
[ReleasePlanID] [int] NOT NULL,
[PONumber] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WeekNo] [smallint] NOT NULL,
[AuthorizedAccum] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[FabAuthorizations] ADD CONSTRAINT [PK__FabAuthorization__64ECEE3F] PRIMARY KEY CLUSTERED  ([ReleasePlanID], [PONumber], [Part]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_FabAuthorizations_1] ON [FT].[FabAuthorizations] ([PONumber], [Part], [WeekNo], [ReleasePlanID]) ON [PRIMARY]
GO
ALTER TABLE [FT].[FabAuthorizations] ADD CONSTRAINT [FK__FabAuthor__Relea__59D0414E] FOREIGN KEY ([ReleasePlanID]) REFERENCES [FT].[ReleasePlans] ([ID])
GO
