CREATE TABLE [dbo].[po_detail]
(
[po_number] [int] NOT NULL,
[vendor_code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[part_number] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[unit_of_measure] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[date_due] [datetime] NOT NULL,
[requisition_number] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last_recvd_date] [datetime] NULL,
[last_recvd_amount] [numeric] (20, 6) NULL,
[cross_reference_part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[account_code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[notes] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[quantity] [numeric] (20, 6) NULL,
[received] [numeric] (20, 6) NULL,
[balance] [numeric] (20, 6) NULL,
[active_release_cum] [numeric] (20, 6) NULL,
[received_cum] [numeric] (20, 6) NULL,
[price] [numeric] (20, 6) NULL,
[row_id] [numeric] (20, 6) NOT NULL,
[invoice_status] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[invoice_date] [datetime] NULL,
[invoice_qty] [numeric] (20, 6) NULL,
[invoice_unit_price] [numeric] (20, 6) NULL,
[RELEASE_NO] [int] NULL,
[ship_to_destination] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[terms] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[week_no] [int] NULL,
[plant] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[invoice_number] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[standard_qty] [numeric] (20, 6) NULL,
[sales_order] [int] NULL,
[dropship_oe_row_id] [int] NULL,
[ship_type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dropship_shipper] [int] NULL,
[price_unit] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[printed] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[selected_for_print] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[deleted] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ship_via] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[release_type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dimension_qty_string] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[taxable] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[scheduled_time] [datetime] NULL,
[truck_number] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[confirm_asn] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[job_cost_no] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[alternate_price] [numeric] (20, 6) NULL,
[requisition_id] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE trigger [dbo].[mtr_po_detail_i] on [dbo].[po_detail] for insert
as
/*
if we need currency conversions in the future, some form of this needs to be implemented...

	update 	po_detail set
		po_detail.price = inserted.alternate_price * IsNull (
		(	select	rate
			from	currency_conversion 
			where 	effective_date =
				(	select	max (effective_date)
					from	currency_conversion cc
					where	effective_date <= GetDate () and
						currency_code = po_header.currency_unit) and
				currency_code = po_header.currency_unit ), 1) / IsNull (
		(	select	rate
			from	currency_conversion 
			where 	effective_date =
				(	select	max (effective_date)
					from	currency_conversion cc
					where	effective_date <= GetDate () and
						currency_code = (select base_currency from parameters)) and
					currency_code = (select base_currency from parameters)),1)
	from	po_detail
		join po_header on po_detail.po_number = po_header.po_number
		join inserted on po_detail.po_number = inserted.po_number and
			po_detail.part_number = inserted.part_number and
			po_detail.date_due = inserted.date_due and
			po_detail.row_id = inserted.row_id
		join deleted on inserted.po_number = deleted.po_number and
			inserted.part_number = deleted.part_number and
			inserted.date_due = deleted.date_due and
			inserted.row_id = deleted.row_id
	where	IsNull (inserted.alternate_price, 0 ) != IsNull (deleted.alternate_price, 0)
*/
set nocount on

update	po_detail
set	price = Coalesce (inserted.price, inserted.alternate_price),
	alternate_price = Coalesce (inserted.alternate_price, inserted.price)
from	po_detail
	join inserted on  po_detail.po_number = inserted.po_number and
		po_detail.part_number = inserted.part_number and
		po_detail.date_due = inserted.date_due and
		po_detail.row_id = inserted.row_id
where	inserted.price is null or inserted.alternate_price is null
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE trigger [dbo].[mtr_po_detail_u] on [dbo].[po_detail] for update
as
/*
if we need currency conversions in the future, some form of this needs to be implemented...

	update 	po_detail set
		po_detail.price = inserted.alternate_price * IsNull (
		(	select	rate
			from	currency_conversion 
			where 	effective_date =
				(	select	max (effective_date)
					from	currency_conversion cc
					where	effective_date <= GetDate () and
						currency_code = po_header.currency_unit) and
				currency_code = po_header.currency_unit ), 1) / IsNull (
		(	select	rate
			from	currency_conversion 
			where 	effective_date =
				(	select	max (effective_date)
					from	currency_conversion cc
					where	effective_date <= GetDate () and
						currency_code = (select base_currency from parameters)) and
					currency_code = (select base_currency from parameters)),1)
	from	po_detail
		join po_header on po_detail.po_number = po_header.po_number
		join inserted on po_detail.po_number = inserted.po_number and
			po_detail.part_number = inserted.part_number and
			po_detail.date_due = inserted.date_due and
			po_detail.row_id = inserted.row_id
		join deleted on inserted.po_number = deleted.po_number and
			inserted.part_number = deleted.part_number and
			inserted.date_due = deleted.date_due and
			inserted.row_id = deleted.row_id
	where	IsNull (inserted.alternate_price, 0 ) != IsNull (deleted.alternate_price, 0)
*/
set nocount on

if	exists
(	select	1
	from	po_detail
		join inserted on  po_detail.po_number = inserted.po_number and
			po_detail.part_number = inserted.part_number and
			po_detail.date_due = inserted.date_due and
			po_detail.row_id = inserted.row_id
	where	isnull (po_detail.alternate_price, -1) != inserted.price) begin
	update	po_detail
	set	alternate_price = inserted.price
	from	po_detail
		join inserted on  po_detail.po_number = inserted.po_number and
			po_detail.part_number = inserted.part_number and
			po_detail.date_due = inserted.date_due and
			po_detail.row_id = inserted.row_id
	where	isnull (po_detail.alternate_price, -1) != inserted.price
end
else if	exists
(	select	1
	from	po_detail
		join inserted on  po_detail.po_number = inserted.po_number and
			po_detail.part_number = inserted.part_number and
			po_detail.date_due = inserted.date_due and
			po_detail.row_id = inserted.row_id
	where	isnull (po_detail.price, -1) != inserted.alternate_price) begin
	update	po_detail
	set	price = inserted.alternate_price
	from	po_detail
		join inserted on  po_detail.po_number = inserted.po_number and
			po_detail.part_number = inserted.part_number and
			po_detail.date_due = inserted.date_due and
			po_detail.row_id = inserted.row_id
	where	isnull (po_detail.price, -1) != inserted.alternate_price
end
GO
ALTER TABLE [dbo].[po_detail] ADD CONSTRAINT [PK__po_detail__475C8B58] PRIMARY KEY CLUSTERED  ([po_number], [part_number], [date_due], [row_id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_po_detail_FT_1] ON [dbo].[po_detail] ([po_number], [part_number], [date_due], [balance], [vendor_code]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_po_detail_FT_2] ON [dbo].[po_detail] ([vendor_code], [part_number], [date_due], [balance], [po_number]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[po_detail] ADD CONSTRAINT [fk_po_detail1] FOREIGN KEY ([po_number]) REFERENCES [dbo].[po_header] ([po_number])
GO
