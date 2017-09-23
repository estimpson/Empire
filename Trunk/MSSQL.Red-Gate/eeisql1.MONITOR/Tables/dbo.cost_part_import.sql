CREATE TABLE [dbo].[cost_part_import]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[cost] [numeric] (20, 6) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cost_part_import] ADD CONSTRAINT [pk_partcost] PRIMARY KEY CLUSTERED  ([part]) ON [PRIMARY]
GO
