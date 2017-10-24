CREATE TABLE [dbo].[PartActiveRevDuplicate]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[rev] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PartActiveRevDuplicate] ADD CONSTRAINT [partyyyyx] PRIMARY KEY CLUSTERED  ([part]) ON [PRIMARY]
GO
