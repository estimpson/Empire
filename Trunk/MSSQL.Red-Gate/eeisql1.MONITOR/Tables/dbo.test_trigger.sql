CREATE TABLE [dbo].[test_trigger]
(
[id] [int] NOT NULL,
[price] [numeric] (20, 6) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[test_trigger] ADD CONSTRAINT [PK__test_trigger__1748F343] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
