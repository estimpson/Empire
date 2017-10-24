CREATE TABLE [dbo].[inventory_parameters]
(
[record_number] [real] NOT NULL,
[machine_number] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[jc_machine] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[jc_part] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[jc_packaging] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[jc_location_to] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[jc_operator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[jc_number_of] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[jc_qty] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[jc_unit] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mi_machine] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mi_operator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mi_serial] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mi_qty] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mi_unit] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bo_operator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bo_serial] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bo_number_of] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bo_qty] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bo_unit] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[jc_allow_zero_qty] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[jc_parts_mode] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[limit_locations] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[jc_material_lot] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[limit_locations_jc] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[limit_locations_mi] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[limit_locations_tr] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[inventory_parameters] ADD CONSTRAINT [PK__inventory_parame__25518C17] PRIMARY KEY CLUSTERED  ([record_number]) ON [PRIMARY]
GO
