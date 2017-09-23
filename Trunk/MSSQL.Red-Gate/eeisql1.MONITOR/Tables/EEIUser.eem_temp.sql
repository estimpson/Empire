CREATE TABLE [EEIUser].[eem_temp]
(
[part] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[final_selling_price] [decimal] (18, 6) NULL,
[final_base_price] [decimal] (18, 6) NULL,
[final_surcharge_price] [decimal] (18, 6) NULL,
[correct_trf_price] [decimal] (18, 6) NULL,
[eem_po_cost] [decimal] (18, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[eem_temp] ADD CONSTRAINT [PK_eem_temp] PRIMARY KEY CLUSTERED  ([part]) ON [PRIMARY]
GO
