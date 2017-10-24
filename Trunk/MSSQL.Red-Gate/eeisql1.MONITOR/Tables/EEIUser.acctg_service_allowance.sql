CREATE TABLE [EEIUser].[acctg_service_allowance]
(
[document_type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[document_id] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[gl_date] [date] NOT NULL,
[part_original] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[quantity_shipped] [decimal] (18, 2) NOT NULL,
[amount] [decimal] (18, 2) NULL,
[base_part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original_production_part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[production_price] [decimal] (18, 4) NULL,
[service_price] [decimal] (18, 4) NULL,
[service_po] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sos] [date] NULL,
[eos] [date] NULL,
[ledger_account] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_service_allowance] ADD CONSTRAINT [PK_acctg_service_allowance] PRIMARY KEY CLUSTERED  ([document_type], [document_id], [gl_date], [part_original], [quantity_shipped]) ON [PRIMARY]
GO
