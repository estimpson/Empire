CREATE TABLE [dbo].[terminals]
(
[terminal] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[price] [numeric] (20, 6) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[terminals] ADD CONSTRAINT [keyterminal] PRIMARY KEY CLUSTERED  ([terminal]) ON [PRIMARY]
GO
