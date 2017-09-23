CREATE TABLE [FT].[SalesOrderReleases]
(
[ReleaseGUID] [uniqueidentifier] NULL,
[ReleaseID] [int] NOT NULL,
[DueDT] [datetime] NOT NULL,
[NetQty] [numeric] (20, 6) NOT NULL,
[PostAccum] [numeric] (20, 6) NOT NULL,
[RawAuthorized] [bit] NOT NULL CONSTRAINT [DF__SalesOrde__RawAu__7128A7F2] DEFAULT ((0)),
[FabAuthorized] [bit] NOT NULL CONSTRAINT [DF__SalesOrde__FabAu__721CCC2B] DEFAULT ((0)),
[ShipAuthorized] [bit] NOT NULL CONSTRAINT [DF__SalesOrde__ShipA__7310F064] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [FT].[SalesOrderReleases] ADD CONSTRAINT [FK__SalesOrde__Relea__703483B9] FOREIGN KEY ([ReleaseGUID]) REFERENCES [FT].[ReleaseHeaders] ([GUID])
GO
