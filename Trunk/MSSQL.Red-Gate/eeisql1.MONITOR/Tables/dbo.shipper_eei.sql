CREATE TABLE [dbo].[shipper_eei]
(
[id] [int] NOT NULL,
[destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[shipping_dock] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ship_via] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[date_shipped] [datetime] NULL,
[aetc_number] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[freight_type] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[printed] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bill_of_lading_number] [int] NULL,
[model_year_desc] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[model_year] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[location] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[staged_objs] [int] NULL,
[plant] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[type] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[invoiced] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[invoice_number] [int] NULL,
[freight] [numeric] (15, 6) NULL,
[tax_percentage] [numeric] (6, 3) NULL,
[total_amount] [numeric] (15, 6) NULL,
[gross_weight] [numeric] (20, 6) NULL,
[net_weight] [numeric] (20, 6) NULL,
[tare_weight] [numeric] (20, 6) NULL,
[responsibility_code] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[trans_mode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pro_number] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[notes] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[time_shipped] [datetime] NULL,
[truck_number] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[invoice_printed] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[seal_number] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[terms] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tax_rate] [numeric] (20, 6) NULL,
[staged_pallets] [int] NULL,
[container_message] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[picklist_printed] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dropship_reconciled] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[date_stamp] [datetime] NULL,
[platinum_trx_ctrl_num] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[posted] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[scheduled_ship_time] [datetime] NULL,
[currency_unit] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[show_euro_amount] [smallint] NULL,
[cs_status] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bol_ship_to] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bol_carrier] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[operator] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[shipper_eei] ADD CONSTRAINT [shipper_x] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
