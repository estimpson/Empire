CREATE TABLE [EEIUser].[acctg_csm_bulk_load_parts]
(
[base_part] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[include_in_forecast] [bit] NULL,
[part_family] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[parent_customer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[product_line] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[empire_market_segment] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[empire_market_subsegment] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[empire_application] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[empire_sop] [datetime] NULL,
[empire_eop] [datetime] NULL,
[qty_per] [int] NULL,
[take_rate] [decimal] (4, 2) NULL,
[family_allocation] [decimal] (4, 2) NULL,
[selling_price] [decimal] (18, 6) NULL,
[partusedformc] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[material_cost] [decimal] (18, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_bulk_load_parts] ADD CONSTRAINT [PK_acctg_csm_bulk_load_parts] PRIMARY KEY CLUSTERED  ([base_part]) ON [PRIMARY]
GO
