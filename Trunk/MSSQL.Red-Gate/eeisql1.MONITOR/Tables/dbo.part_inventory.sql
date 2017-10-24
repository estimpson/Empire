CREATE TABLE [dbo].[part_inventory]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[standard_pack] [numeric] (20, 6) NULL,
[unit_weight] [numeric] (20, 6) NULL,
[standard_unit] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cycle] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[abc] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[saftey_stock_qty] [numeric] (20, 6) NULL,
[primary_location] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[location_group] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ipa] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[label_format] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[shelf_life_days] [numeric] (3, 0) NULL,
[material_issue_type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[safety_part] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[upc_code] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dim_code] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[configurable] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[next_suffix] [int] NULL,
[drop_ship_part] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[eau] [int] NULL,
[imds] [int] NULL,
[longest_lt] [int] NULL,
[min_prod_run] [numeric] (20, 6) NULL,
[critical_part] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[criticalpartnotes] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[eehlabel] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[part_inventory] ADD CONSTRAINT [PK__part_inventory__3C9F05C3] PRIMARY KEY CLUSTERED  ([part]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_part_inventory_1] ON [dbo].[part_inventory] ([part], [standard_pack]) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[part_inventory] TO [APPUser]
GO
