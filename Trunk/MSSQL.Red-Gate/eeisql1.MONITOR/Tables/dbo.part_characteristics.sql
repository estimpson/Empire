CREATE TABLE [dbo].[part_characteristics]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[unit_weight] [numeric] (20, 6) NULL,
[length_x] [numeric] (20, 6) NULL,
[height_y] [numeric] (20, 6) NULL,
[width_z] [numeric] (20, 6) NULL,
[color] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[hazardous] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[part_size] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[user_defined_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[package_type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[returnable] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lbs_total_metal_content] [numeric] (14, 10) NULL,
[lbs_metal_content] [numeric] (14, 10) NULL,
[lbs_metal_waste] [numeric] (14, 10) NULL,
[lbs_total_plastics_content] [numeric] (14, 10) NULL,
[lbs_plastics_content] [numeric] (14, 10) NULL,
[lbs_plastics_waste] [numeric] (14, 10) NULL,
[plastics_recycling_rate] [numeric] (14, 10) NULL,
[lbs_recycling_rate] [numeric] (20, 6) NULL CONSTRAINT [DF__part_char__lbs_r__0B129727] DEFAULT ((0)),
[InfoRecord] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[part_characteristics] ADD CONSTRAINT [PK__part_characteris__3F7B726E] PRIMARY KEY CLUSTERED  ([part]) ON [PRIMARY]
GO
