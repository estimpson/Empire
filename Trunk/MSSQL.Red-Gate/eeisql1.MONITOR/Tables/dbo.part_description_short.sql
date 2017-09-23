CREATE TABLE [dbo].[part_description_short]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[id] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[part_description_short] ADD CONSTRAINT [PK_part_description_short] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
