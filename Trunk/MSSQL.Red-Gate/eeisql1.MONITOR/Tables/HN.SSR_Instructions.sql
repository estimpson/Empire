CREATE TABLE [HN].[SSR_Instructions]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[SSR_ID] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Instruction] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [HN].[SSR_Instructions] ADD CONSTRAINT [PK_SSR_Instructions] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
GRANT SELECT ON  [HN].[SSR_Instructions] TO [APPUser]
GO
GRANT INSERT ON  [HN].[SSR_Instructions] TO [APPUser]
GO
GRANT DELETE ON  [HN].[SSR_Instructions] TO [APPUser]
GO
GRANT UPDATE ON  [HN].[SSR_Instructions] TO [APPUser]
GO
