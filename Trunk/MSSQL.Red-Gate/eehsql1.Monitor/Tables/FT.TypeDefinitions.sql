CREATE TABLE [FT].[TypeDefinitions]
(
[ClassName] [sys].[sysname] NOT NULL,
[Mask] [int] NOT NULL,
[Value] [int] NOT NULL,
[TypeName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[TypeDefinitions] ADD CONSTRAINT [PK__TypeDefi__B8CACF60121BF886] PRIMARY KEY CLUSTERED  ([ClassName], [Mask], [Value]) ON [PRIMARY]
GO
