CREATE TABLE [FT].[HighFabAuthorizations]
(
[PONumber] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AuthorizedAccum] [numeric] (20, 6) NULL,
[WeekNo] [smallint] NOT NULL,
[ReleasePlanID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[HighFabAuthorizations] ADD CONSTRAINT [PK__HighFabAuthoriza__6304A5CD] PRIMARY KEY CLUSTERED  ([PONumber], [Part]) ON [PRIMARY]
GO
ALTER TABLE [FT].[HighFabAuthorizations] ADD CONSTRAINT [FK__HighFabAu__Relea__58DC1D15] FOREIGN KEY ([ReleasePlanID]) REFERENCES [FT].[ReleasePlans] ([ID])
GO
