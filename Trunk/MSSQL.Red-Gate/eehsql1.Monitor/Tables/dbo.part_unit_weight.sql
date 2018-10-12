CREATE TABLE [dbo].[part_unit_weight]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[unit_weight] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[part_unit_weight] ADD CONSTRAINT [PK__part_unit_weight__25692E7F] PRIMARY KEY CLUSTERED  ([part]) ON [PRIMARY]
GO
