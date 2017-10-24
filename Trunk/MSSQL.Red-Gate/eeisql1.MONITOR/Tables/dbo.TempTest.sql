CREATE TABLE [dbo].[TempTest]
(
[PostId] [int] NOT NULL,
[PostContent] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ParentPostId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TempTest] ADD CONSTRAINT [PK__TempTest__AA1260185445757F] PRIMARY KEY CLUSTERED  ([PostId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TempTest] ADD CONSTRAINT [FK__TempTest__Parent__562DBDF1] FOREIGN KEY ([ParentPostId]) REFERENCES [dbo].[TempTest] ([PostId])
GO
