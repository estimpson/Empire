CREATE TABLE [dbo].[Pies]
(
[PieId] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShortDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LongDescription] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AllergyInformation] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Price] [decimal] (18, 2) NOT NULL,
[ImageUrl] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ImageThumbnailUrl] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsPieOfTheWeek] [bit] NOT NULL,
[InStock] [bit] NOT NULL,
[CategoryId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Pies] ADD CONSTRAINT [PK_Pies] PRIMARY KEY CLUSTERED  ([PieId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Pies_CategoryId] ON [dbo].[Pies] ([CategoryId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Pies] ADD CONSTRAINT [FK_Pies_Categories_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[Categories] ([CategoryId]) ON DELETE CASCADE
GO
