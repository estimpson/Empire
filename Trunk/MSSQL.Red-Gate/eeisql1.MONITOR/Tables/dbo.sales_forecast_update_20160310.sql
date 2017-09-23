CREATE TABLE [dbo].[sales_forecast_update_20160310]
(
[base_part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rev_level] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EEI_price] [decimal] (18, 6) NULL,
[EEI_frozen_material_cost] [decimal] (18, 6) NULL,
[EEH_material_cost] [decimal] (18, 6) NULL,
[MSF_price] [decimal] (18, 6) NULL,
[MSF_material_cost] [decimal] (18, 6) NULL
) ON [PRIMARY]
GO
