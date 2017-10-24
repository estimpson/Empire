CREATE TABLE [dbo].[acctg_inventory_pricing_update]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[customer_selling_price] [decimal] (18, 6) NULL,
[production_selling_price] [decimal] (18, 6) NULL,
[transfer_price] [decimal] (18, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[acctg_inventory_pricing_update] ADD CONSTRAINT [aipu] PRIMARY KEY CLUSTERED  ([part]) ON [PRIMARY]
GO
