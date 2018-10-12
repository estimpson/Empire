CREATE TABLE [FT].[CSMAuditData]
(
[Basepart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Part] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ActivePart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mnemonics] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rawparts] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[CSMAuditData] ADD CONSTRAINT [PK__CSMAudit__BCE6EB6181DAA4EF] PRIMARY KEY CLUSTERED  ([Basepart], [Part]) ON [PRIMARY]
GO
