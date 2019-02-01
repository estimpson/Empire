CREATE TABLE [dbo].[States]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Abbreviation] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[States] ADD CONSTRAINT [PK__States__3214EC270AAA74B7] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
