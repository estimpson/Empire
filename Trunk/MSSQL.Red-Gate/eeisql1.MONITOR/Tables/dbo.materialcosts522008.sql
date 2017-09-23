CREATE TABLE [dbo].[materialcosts522008]
(
[id] [int] NOT NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[cost] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[materialcosts522008] ADD CONSTRAINT [idkey1] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
