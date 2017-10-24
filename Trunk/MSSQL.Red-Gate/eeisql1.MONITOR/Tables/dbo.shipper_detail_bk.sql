CREATE TABLE [dbo].[shipper_detail_bk]
(
[shipper] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[part] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[qty_required] [numeric] (20, 6) NULL,
[qty_packed] [numeric] (20, 6) NULL,
[qty_original] [numeric] (20, 6) NULL,
[accum_shipped] [numeric] (20, 6) NULL,
[order_no] [numeric] (8, 0) NULL,
[customer_po] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[release_no] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[release_date] [datetime] NULL,
[type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[price] [numeric] (20, 6) NULL,
[account_code] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[salesman] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tare_weight] [numeric] (20, 6) NULL,
[gross_weight] [numeric] (20, 6) NULL,
[net_weight] [numeric] (20, 6) NULL,
[date_shipped] [datetime] NULL,
[assigned] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[packaging_job] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[note] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[operator] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[boxes_staged] [int] NULL,
[pack_line_qty] [numeric] (20, 6) NULL,
[alternative_qty] [numeric] (20, 6) NULL,
[alternative_unit] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[week_no] [int] NULL,
[taxable] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[price_type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cross_reference] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer_part] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dropship_po] [int] NULL,
[dropship_po_row_id] [int] NULL,
[dropship_oe_row_id] [int] NULL,
[suffix] [int] NULL,
[part_name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[part_original] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[total_cost] [numeric] (20, 6) NULL,
[group_no] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dropship_po_serial] [int] NULL,
[dropship_invoice_serial] [int] NULL,
[stage_using_weight] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[alternate_price] [numeric] (20, 6) NULL,
[old_suffix] [int] NULL,
[old_shipper] [int] NULL
) ON [PRIMARY]
GO
