CREATE TABLE [FT].[Inventory]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Location] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OnHand] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[Inventory] ADD CONSTRAINT [PK__Inventor__3214EC27360E347E] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
