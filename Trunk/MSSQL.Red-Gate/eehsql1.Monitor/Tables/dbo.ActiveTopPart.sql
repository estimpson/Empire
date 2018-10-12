CREATE TABLE [dbo].[ActiveTopPart]
(
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ActiveTopPart] ADD CONSTRAINT [PK__ActiveTopPart__45C0EF78] PRIMARY KEY CLUSTERED  ([Part]) ON [PRIMARY]
GO
