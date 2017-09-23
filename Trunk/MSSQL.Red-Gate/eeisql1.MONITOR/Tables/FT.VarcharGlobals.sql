CREATE TABLE [FT].[VarcharGlobals]
(
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[VarcharGlobals] ADD CONSTRAINT [PK__VarcharGlobals__135DC465] PRIMARY KEY CLUSTERED  ([Name]) ON [PRIMARY]
GO
