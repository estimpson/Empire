CREATE TABLE [dbo].[dbo.description_short_fxDelete]
(
[description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dbo.description_short_fxDelete] ADD CONSTRAINT [PK_description_short] PRIMARY KEY CLUSTERED  ([description]) ON [PRIMARY]
GO
