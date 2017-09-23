CREATE TABLE [dbo].[partforprice]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[partforprice] ADD CONSTRAINT [pk_part1] PRIMARY KEY CLUSTERED  ([part]) ON [PRIMARY]
GO
