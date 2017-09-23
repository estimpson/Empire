CREATE TABLE [dbo].[FlatFinishedPart]
(
[RawPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FinihedParts] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FlatFinishedPart] ADD CONSTRAINT [PK__FlatFinishedPart__21524BC1] PRIMARY KEY CLUSTERED  ([RawPart]) ON [PRIMARY]
GO
