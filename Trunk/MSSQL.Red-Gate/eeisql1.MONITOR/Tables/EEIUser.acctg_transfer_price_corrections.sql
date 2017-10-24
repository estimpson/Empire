CREATE TABLE [EEIUser].[acctg_transfer_price_corrections]
(
[fiscal_year] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[period] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[part] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EEH_xfr_price_shipped] [decimal] (18, 6) NULL,
[EEH_qty_shipped] [decimal] (18, 6) NULL,
[EEH_ext_shipped] [decimal] (18, 6) NULL,
[EEI_xfr_price_received] [decimal] (18, 6) NULL,
[EEI_qty_received] [decimal] (18, 6) NULL,
[EEI_ext_received] [decimal] (18, 6) NULL,
[EEH_xfr_price_rma] [decimal] (18, 6) NULL,
[EEH_qty_rma] [decimal] (18, 6) NULL,
[EEH_ext_rma] [decimal] (18, 6) NULL,
[EEI_xfr_price_rtv] [decimal] (18, 6) NULL,
[EEI_qty_rtv] [decimal] (18, 6) NULL,
[EEI_ext_rtv] [decimal] (18, 6) NULL,
[customer_production_selling_price] [decimal] (18, 6) NULL,
[transfer_price] [decimal] (18, 6) NULL,
[updated] [nchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_transfer_price_corrections] ADD CONSTRAINT [PK_acctg_transfer_price_corrections] PRIMARY KEY CLUSTERED  ([fiscal_year], [period], [part]) ON [PRIMARY]
GO
