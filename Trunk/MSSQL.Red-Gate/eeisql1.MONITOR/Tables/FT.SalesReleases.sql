CREATE TABLE [FT].[SalesReleases]
(
[ReleaseHeaderID] [int] NOT NULL,
[PartECN] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DueDT] [datetime] NOT NULL,
[PostAccum] [numeric] (20, 6) NOT NULL,
[Quantity] [numeric] (20, 6) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[SalesReleases] ADD CONSTRAINT [FK__SalesRele__Relea__012A0591] FOREIGN KEY ([ReleaseHeaderID]) REFERENCES [FT].[SalesReleaseHeaders] ([ID])
GO
