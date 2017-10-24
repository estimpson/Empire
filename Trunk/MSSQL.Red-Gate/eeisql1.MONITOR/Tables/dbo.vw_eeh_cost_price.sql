CREATE TABLE [dbo].[vw_eeh_cost_price]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[order_header_price] [decimal] (20, 6) NULL,
[order_detail_price] [decimal] (20, 6) NULL,
[pcpm_price] [decimal] (20, 6) NULL,
[pc_price] [numeric] (20, 6) NULL,
[standard_price] [numeric] (20, 6) NOT NULL,
[standard_material_cum] [numeric] (20, 6) NOT NULL
) ON [PRIMARY]
GO
