CREATE TABLE [dbo].[sqlanypart_standard]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[price] [decimal] (20, 6) NULL,
[cost] [decimal] (20, 6) NULL,
[account_number] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[material] [decimal] (20, 6) NULL,
[labor] [decimal] (20, 6) NULL,
[burden] [decimal] (20, 6) NULL,
[other] [decimal] (20, 6) NULL,
[cost_cum] [decimal] (20, 6) NULL,
[material_cum] [decimal] (20, 6) NULL,
[burden_cum] [decimal] (20, 6) NULL,
[other_cum] [decimal] (20, 6) NULL,
[labor_cum] [decimal] (20, 6) NULL,
[flag] [int] NULL,
[premium] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qtd_cost] [decimal] (20, 6) NULL,
[qtd_material] [decimal] (20, 6) NULL,
[qtd_labor] [decimal] (20, 6) NULL,
[qtd_burden] [decimal] (20, 6) NULL,
[qtd_other] [decimal] (20, 6) NULL,
[qtd_cost_cum] [decimal] (20, 6) NULL,
[qtd_material_cum] [decimal] (20, 6) NULL,
[qtd_labor_cum] [decimal] (20, 6) NULL,
[qtd_burden_cum] [decimal] (20, 6) NULL,
[qtd_other_cum] [decimal] (20, 6) NULL,
[planned_cost] [decimal] (20, 6) NULL,
[planned_material] [decimal] (20, 6) NULL,
[planned_labor] [decimal] (20, 6) NULL,
[planned_burden] [decimal] (20, 6) NULL,
[planned_other] [decimal] (20, 6) NULL,
[planned_cost_cum] [decimal] (20, 6) NULL,
[planned_material_cum] [decimal] (20, 6) NULL,
[planned_labor_cum] [decimal] (20, 6) NULL,
[planned_burden_cum] [decimal] (20, 6) NULL,
[planned_other_cum] [decimal] (20, 6) NULL,
[frozen_cost] [decimal] (20, 6) NULL,
[frozen_material] [decimal] (20, 6) NULL,
[frozen_burden] [decimal] (20, 6) NULL,
[frozen_labor] [decimal] (20, 6) NULL,
[frozen_other] [decimal] (20, 6) NULL,
[frozen_cost_cum] [decimal] (20, 6) NULL,
[frozen_material_cum] [decimal] (20, 6) NULL,
[frozen_burden_cum] [decimal] (20, 6) NULL,
[frozen_labor_cum] [decimal] (20, 6) NULL,
[frozen_other_cum] [decimal] (20, 6) NULL,
[cost_changed_date] [datetime] NULL,
[qtd_changed_date] [datetime] NULL,
[planned_changed_date] [datetime] NULL,
[frozen_changed_date] [datetime] NULL
) ON [PRIMARY]
GO
