CREATE TABLE [dbo].[dbo.dixiewire_group_characteristics]
(
[dixie_group] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[wire_type] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[wire_gauge] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[package_type] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[package_size_inches] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[uom] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[std_pack_in_uom] [decimal] (18, 6) NULL,
[std_pack_in_ft] [decimal] (18, 6) NULL,
[copper_pounds_per_uom] [decimal] (12, 12) NULL,
[copper_pounds_per_ft] [decimal] (12, 12) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dbo.dixiewire_group_characteristics] ADD CONSTRAINT [dixie_group2] PRIMARY KEY CLUSTERED  ([dixie_group]) ON [PRIMARY]
GO
