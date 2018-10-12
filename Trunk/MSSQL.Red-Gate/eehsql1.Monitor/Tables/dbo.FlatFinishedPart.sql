CREATE TABLE [dbo].[FlatFinishedPart]
(
[RawPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FinihedParts] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FlatFinishedPart] ADD CONSTRAINT [PK__FlatFini__EAF8D7343649A1BE] PRIMARY KEY CLUSTERED  ([RawPart]) ON [PRIMARY]
GO
