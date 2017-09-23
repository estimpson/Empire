CREATE TABLE [dbo].[bill_of_material_ec_old_fxDelete]
(
[parent_part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[start_datetime] [datetime] NOT NULL,
[end_datetime] [datetime] NULL,
[type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[quantity] [numeric] (20, 6) NULL,
[unit_measure] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[reference_no] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[std_qty] [numeric] (20, 6) NULL,
[scrap_factor] [numeric] (20, 6) NULL,
[engineering_level] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[operator] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[substitute_part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[date_changed] [datetime] NOT NULL,
[note] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[bill_of_material_ec_old_fxDelete] ADD CONSTRAINT [PK__bill_of_material__5EBF139D] PRIMARY KEY CLUSTERED  ([parent_part], [part], [start_datetime]) ON [PRIMARY]
GO
