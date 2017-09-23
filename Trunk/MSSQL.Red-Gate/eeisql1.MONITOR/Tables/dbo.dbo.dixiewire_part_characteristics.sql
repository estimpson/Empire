CREATE TABLE [dbo].[dbo.dixiewire_part_characteristics]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[vendor_part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[dixie_group] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[description] [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[color_combination] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dbo.dixiewire_part_characteristics] ADD CONSTRAINT [part_6] PRIMARY KEY CLUSTERED  ([part]) ON [PRIMARY]
GO
