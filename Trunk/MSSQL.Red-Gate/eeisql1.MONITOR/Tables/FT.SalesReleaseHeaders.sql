CREATE TABLE [FT].[SalesReleaseHeaders]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ReleaseDT] [datetime] NOT NULL,
[TypeID] [tinyint] NOT NULL,
[Operator] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BasePart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ShippedAccum] [numeric] (20, 6) NOT NULL,
[FabAccum] [numeric] (20, 6) NULL,
[RawAccum] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[SalesReleaseHeaders] ADD CONSTRAINT [PK__SalesReleaseHead__7E4D98E6] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [FT].[SalesReleaseHeaders] ADD CONSTRAINT [FK__SalesRele__TypeI__7F41BD1F] FOREIGN KEY ([TypeID]) REFERENCES [FT].[SalesReleaseTypes] ([ID])
GO
