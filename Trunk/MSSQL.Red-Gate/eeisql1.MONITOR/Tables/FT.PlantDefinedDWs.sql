CREATE TABLE [FT].[PlantDefinedDWs]
(
[Code] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DWSyntax] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [FT].[PlantDefinedDWs] ADD CONSTRAINT [PK__PlantDefinedDWs__6C2EE8AB] PRIMARY KEY CLUSTERED  ([Code]) ON [PRIMARY]
GO
