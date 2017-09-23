SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[web_ar_reconciliation]
as
declare	

    @BD datetime,
    @ED datetime,
    @FY varchar(5),
    @FP smallint


select

	@BD='2008-08-01',
	@ED='2008-09-01', 
	@FY='2008',
	@FP=8

delete from web_sales_rec_1


--populate gl_cost_transactions
insert into web_sales_rec_1 
(
gl_fiscal_year,
gl_period,
gl_transaction_date,
document_type,
document_id1,
document_reference1,
document_line,
part_original,
document_remarks,
gl_db_ledger_account,
gl_db_quantity,
gl_db_selling_price,
gl_db_amount,
gl_cr_ledger_account,
gl_cr_quantity,
gl_cr_selling_price,
gl_cr_amount,
gl_update_balances
)

(
select 
gl_cost_transactions.fiscal_year, 
gl_cost_transactions.period, 
gl_cost_transactions.transaction_date,
gl_cost_transactions.document_type, 
gl_cost_transactions.document_id1, 
gl_cost_transactions.document_reference1,
gl_cost_transactions.document_line,
ar_items.item,
gl_cost_transactions.document_remarks,
(case when (ISNULL(gl_cost_transactions.amount,0) >= 0) then gl_cost_transactions.ledger_account else '' end) as db_account,
(case when (ISNULL(gl_cost_transactions.amount,0) >= 0) then gl_cost_transactions.quantity else 0 end) as db_qty,
(case when (ISNULL(gl_cost_transactions.amount,0) >= 0) then ar_items.item_price else NULL end) as db_price,
(case when (ISNULL(gl_cost_transactions.amount,0) >= 0) then gl_cost_transactions.amount else 0 end) as db_amount,
(case when (gl_cost_transactions.amount < 0) then gl_cost_transactions.ledger_account else '' end) as cr_account,
(case when (gl_cost_transactions.amount < 0) then gl_cost_transactions.quantity else 0 end) as cr_qty,
(case when (gl_cost_transactions.amount < 0) then ar_items.item_price else NULL end) as cr_price,
(case when (gl_cost_transactions.amount < 0) then gl_cost_transactions.amount else 0 end) as cr_amount,
gl_cost_transactions.update_balances
from gl_cost_transactions 
left outer join ar_items on gl_cost_transactions.document_id2 = ar_items.document_type 
and gl_cost_transactions.document_id1 = ar_items.document
and gl_cost_transactions.document_line = ar_items.document_line
where gl_cost_transactions.fiscal_year = @FY
and gl_cost_transactions.period = @FP
and gl_cost_transactions.document_type in ('AR CHECK','AR INVOICE','AR CREDIT MEMO')
and gl_cost_transactions.update_balances = 'Y')

--populate with shipper_detail where gl_cost_transactions exist

update web_sales_rec_1
set 
sd_date_shipped = shipper.date_shipped,
sd_customer = shipper.customer,
sd_customer_part = shipper_detail.customer_part,
sd_account_code = shipper_detail.account_code,
sd_qty_packed = shipper_detail.qty_packed,
sd_alternate_price = shipper_detail.alternate_price,
sd_total_amount = (shipper_detail.qty_packed*shipper_detail.alternate_price),
sd_plant = shipper.plant,
sd_type = shipper.type
from 
web_sales_rec_1
left outer join shipper on convert(varchar(50),shipper.id) = web_sales_rec_1.document_id1
and shipper.customer = web_sales_rec_1.document_reference1
and (case ISNULL(shipper.type,0) when 0 then 'AR INVOICE' when 'R' then 'AR CREDIT MEMO' else '' end) = web_sales_rec_1.document_type
left outer join shipper_detail on convert(varchar(50),shipper) = web_sales_rec_1.document_id1
and (case ISNULL(shipper_detail.type,'0') when '0' then 'AR INVOICE' when 'R' then 'AR CREDIT MEMO' else '' end) = web_sales_rec_1.document_type
where 
shipper_detail.part_original=web_sales_rec_1.part_original 
and shipper.destination <> 'EMPHOND' 
and ISNULL(shipper.type,0)<>'T' 
and shipper.date_shipped >= '2007-05-01' 
and shipper.date_shipped < '2007-06-01'


--insert with shipper_detail where no gl_cost_transactions 


--select results

select * from web_sales_rec_1
GO
