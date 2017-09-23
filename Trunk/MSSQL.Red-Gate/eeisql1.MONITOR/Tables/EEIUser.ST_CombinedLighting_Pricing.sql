CREATE TABLE [EEIUser].[ST_CombinedLighting_Pricing]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AveragePrice] [numeric] (20, 2) NULL,
[HarnessPcbPrice] [numeric] (20, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[ST_CombinedLighting_Pricing] ADD CONSTRAINT [PK__ST_Combi__3214EC27162F09F0] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
