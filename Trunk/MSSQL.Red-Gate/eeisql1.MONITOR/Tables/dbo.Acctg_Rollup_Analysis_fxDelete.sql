CREATE TABLE [dbo].[Acctg_Rollup_Analysis_fxDelete]
(
[serial_pre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[part_pre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[quantity_pre] [decimal] (18, 6) NULL,
[type_pre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[product_line_pre] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[material_cum_pre] [decimal] (18, 6) NULL,
[ext_material_cum_pre] [decimal] (18, 6) NULL,
[labor_cum_pre] [decimal] (18, 6) NULL,
[ext_labor_cum_pre] [decimal] (18, 6) NULL,
[burden_cum_pre] [decimal] (18, 6) NULL,
[ext_burden_cum_pre] [decimal] (18, 6) NULL,
[serial_post] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[part_post] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[quantity_post] [decimal] (18, 6) NULL,
[type_post] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[product_line_post] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[material_cum_post] [decimal] (18, 6) NULL,
[ext_material_cum_post] [decimal] (18, 6) NULL,
[labor_cum_post] [decimal] (18, 6) NULL,
[ext_labor_cum_post] [decimal] (18, 6) NULL,
[burden_cum_post] [decimal] (18, 6) NULL,
[ext_burden_cum_post] [decimal] (18, 6) NULL,
[material_difference] [decimal] (18, 6) NULL,
[ext_material_difference] [decimal] (18, 6) NULL,
[labor_difference] [decimal] (18, 6) NULL,
[ext_labor_difference] [decimal] (18, 6) NULL,
[burden_difference] [decimal] (18, 6) NULL,
[ext_burden_difference] [decimal] (18, 6) NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Acctg_Rollup_Analysis] ON [dbo].[Acctg_Rollup_Analysis_fxDelete] ([part_pre]) ON [PRIMARY]
GO
