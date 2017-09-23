CREATE TABLE [FT].[CSMAuditData]
(
[Basepart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Part] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ActivePart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Mnemonics] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rawparts] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [FT].[CSMAuditData] ADD CONSTRAINT [PK__CSMAudit__A15FB6940313E082] PRIMARY KEY CLUSTERED  ([Part]) ON [PRIMARY]
GO
