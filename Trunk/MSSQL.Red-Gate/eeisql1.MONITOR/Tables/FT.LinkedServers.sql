CREATE TABLE [FT].[LinkedServers]
(
[Name] [sys].[sysname] NOT NULL,
[LinkedServer] [sys].[sysname] NOT NULL,
[TranLocationName] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[LinkedServers] ADD CONSTRAINT [PK__LinkedServers__65D6F0D7] PRIMARY KEY CLUSTERED  ([Name]) ON [PRIMARY]
GO
