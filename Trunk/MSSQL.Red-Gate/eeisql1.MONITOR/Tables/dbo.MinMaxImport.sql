CREATE TABLE [dbo].[MinMaxImport]
(
[BasePart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MinQty] [numeric] (10, 6) NULL,
[MaxQty] [numeric] (10, 6) NULL,
[id] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MinMaxImport] ADD CONSTRAINT [PK__MinMaxIm__3213E83F5DDF6470] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
