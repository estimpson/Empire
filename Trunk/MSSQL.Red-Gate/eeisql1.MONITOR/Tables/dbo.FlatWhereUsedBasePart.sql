CREATE TABLE [dbo].[FlatWhereUsedBasePart]
(
[RawPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BaseParts] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FlatWhereUsedBasePart] ADD CONSTRAINT [PK__FlatWhereUsedBas__2F207CD4] PRIMARY KEY CLUSTERED  ([RawPart]) ON [PRIMARY]
GO
