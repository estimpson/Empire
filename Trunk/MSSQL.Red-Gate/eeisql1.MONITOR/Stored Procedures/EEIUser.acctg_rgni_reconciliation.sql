SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






-- exec eeiuser.acctg_rgni_reconciliation '212011', '2014-04-30', '2014-05-31' 

/* Author: Dan West
   Revision Date: 2012-06-06
   
   Dependancies:	Used for Crystal Report "EEH RGNI RECONCILIATION"
					Permanent Tables:	eeh.eeiuser.acctg_rgni_selected_gl_transactions
										eeh.eeiuser.acctg_rgni_comparison
*/

CREATE procedure [EEIUser].[acctg_rgni_reconciliation] 
					(@account_code varchar(6)
					,@prior_rgni_date datetime
					,@current_rgni_date datetime
					)

as
set transaction isolation level read uncommitted;

delete eeiuser.acctg_rgni_selected_gl_transactions
delete eeiuser.acctg_rgni_comparison

--declare @prior_rgni_date datetime; 
--declare @current_rgni_date datetime;
--declare @account_code varchar(6);
--select @prior_rgni_date = '2012-04-30';
--select @current_rgni_date = '2012-05-31';
--select @account_code = '212011'





if object_id('tempdb.dbo.#selected_gl') IS NOT NULL
drop table #selected_gl
else
create table #selected_gl (
	document_type varchar(25),
	document_id1 varchar(25),
	document_id2 varchar(25),
	document_id3 varchar(25),
	document_line smallint,
	ledger_account varchar(50),
	contract_id varchar(25),
	contract_account_id varchar(25),
	costrevenue_type_id varchar(25),
	fiscal_year varchar(5),
	period smallint,
	transaction_date datetime,
	amount decimal(18,6),
	document_reference1 varchar(50),
	document_reference2 varchar(50),
	document_remarks varchar(max),
	application varchar(25),
	quantity decimal(18,6),
	update_balances char(1),
	changed_date datetime,
	changed_user_id varchar(25)
	)

	
insert into #selected_gl
select document_type,
	document_id1,
	document_id2,
	document_id3,
	document_line,
	ledger_account,
	contract_id,
	contract_account_id,
	costrevenue_type_id,
	fiscal_year,
	period,
	transaction_date,
	amount,
	document_reference1,
	document_reference2,
	document_remarks,
	application,
	quantity,
	update_balances,
	changed_date,
	changed_user_id
from gl_cost_transactions with(index(glcosttrans_ledger_account)) 
where    ledger_account = @account_code
and transaction_date > @prior_rgni_date 
and transaction_date <= @current_rgni_date 
and update_balances = 'Y' 
and document_type <> 'Journal Entry'

insert into eeiuser.acctg_rgni_selected_gl_transactions
select ISNULL((case when document_type = 'MON INV' then left(CONVERT(varchar,audit_trail.po_number)+'_'+convert(varchar(max),audit_trail.shipper)+'_'+CONVERT(varchar,transaction_date,12)+'_'+convert(varchar(max),gct.document_reference1),50) else ap_items.purchase_order+'_'+bill_of_lading+'_'+ap_items.item end),'ORPHANEDRECORD') as id,
 	application,
	document_type, 
	document_id3,
	document_id2,
	(case when document_type = 'MON INV' then convert(datetime,left(right(document_remarks,(len(document_remarks)-PATINDEX('%/%',document_remarks)+3)),23)) else transaction_date end) as transaction_date,  
	ISNULL((case when document_type = 'MON INV' then po_headers.buy_vendor else document_id2 end),'ORPHANEDRECORD') as vendor,
	document_id1, 	
	ISNULL((case when document_type = 'MON INV' then audit_trail.po_number else ap_items.purchase_order end),'ORPHANEDRECORD') as purchase_order,
	--(case when document_type = 'AP INVOICE' then left(bill_of_lading,Len(bill_of_lading)-7) else ISNULL(shipper,bill_of_lading) end) as short_bill_of_lading,
	ISNULL((case when document_type = 'MON INV' then left(convert(varchar(max),audit_trail.shipper)+'_'+CONVERT(varchar,transaction_date,12),25) else bill_of_lading end),'ORPHANEDRECORD') as long_bill_of_lading,
	ISNULL(isnull(shipper,bill_of_lading),'ORPHANEDRECORD') as original_bill_of_lading,	
	ISNULL((case when document_type = 'AP INVOICE' then ap_items.item else document_reference1 end),'ORPHANEDRECORD') as part,	
	(case when document_type = 'AP INVOICE' then ap_items.quantity else gct.quantity end) as quantity, 	
	-gct.amount, 	
	gct.changed_date, 
	gct.changed_user_id,
	NULL
from #selected_gl gct
left join ap_items with(index(pk_ap_items)) on ap_items.vendor = gct.document_id2 and ap_items.inv_cm_flag = gct.document_id3 and ap_items.invoice_cm = gct.document_id1 and ap_items.inv_cm_line = gct.document_line  
left join audit_trail on convert(varchar(20),serial) = convert(varchar(20),gct.document_id1) and audit_trail.type = document_id3 and audit_trail.date_stamp = (case when document_type = 'MON INV' then convert(datetime,left(right(document_remarks,(len(document_remarks)-PATINDEX('%/%',document_remarks)+3)),23)) else transaction_date end)
left join po_headers on audit_trail.po_number = po_headers.purchase_order

declare @categorization table (id varchar(50), distinct_types int, ext_amount decimal(18,6))

insert  @categorization
select id, COUNT(distinct(document_type)) as distinct_types, sum(amount) as ext_amount from eeiuser.acctg_rgni_selected_gl_transactions group by id


update eeiuser.acctg_rgni_selected_gl_transactions 
set Category = 'Investigate' where id in (select id from @categorization where ext_amount <> 0 and distinct_types > 1)


update eeiuser.acctg_rgni_selected_gl_transactions
set Category = 'New Receipts' where id in (select id from @categorization where ext_amount < 0 and distinct_types = 1)


update eeiuser.acctg_rgni_selected_gl_transactions
set Category = 'Invoice Old Receipts' where id in (select id from @categorization where ext_amount > 0 and distinct_types = 1)


declare @prior_rgni_report table
( changed_date datetime,
	purchase_order varchar(25),
	vendor_code varchar(25),
	receiver varchar(25),
	item varchar(25),
	quantity_received decimal(18,6),
	unit_cost decimal(18,6),
	total_cost decimal(18,6),
	bill_of_lading varchar(25),
	id varchar(50)
)

insert @prior_rgni_report
SELECT a.changed_date, 
CONVERT(varchar(25), po_headers.purchase_order) as po_no, 
po_headers.buy_vendor as vendor_code,
a.receiver, 
a.item, 
a.quantity_received, 
a.unit_cost,
a.total_cost,
a.bill_of_lading,
convert(varchar(25),po_headers.purchase_order)+'_'+convert(varchar(25),a.bill_of_lading)+'_'+CONVERT(varchar(25),a.item) as id

FROM HistoricalData.dbo.po_receiver_items_historical a
 join po_headers on a.purchase_order = CONVERT(varchar(25),po_headers.purchase_order)
join part on a.item = part.part

WHERE (ft.fn_truncdate('dd',a.time_stamp) = @prior_rgni_date)
and (a.invoice = '')
and   (
		(@account_code = '212011' and part.product_line not in ('BULBED ES3 COMPONENTS', 'ES3 COMPONENTS', 'OUTSOURCED ES3 COMPONENTS'))       
       or
        (@account_code = '212060' and part.product_line in ('BULBED ES3 COMPONENTS', 'ES3 COMPONENTS', 'OUTSOURCED ES3 COMPONENTS'))       
      )
and (po_headers.buy_vendor <> 'EEH')
and (po_headers.po_type = 'MONITOR')


declare @current_rgni_report table
( changed_date datetime,
	purchase_order varchar(25),
	vendor_code varchar(25),
	receiver varchar(25),
	item varchar(25),
	quantity_received decimal(18,6),
	unit_cost decimal(18,6),
	total_cost decimal(18,6),
	bill_of_lading varchar(25),
	id varchar(50)
)

insert @current_rgni_report
SELECT a.changed_date, 
CONVERT(varchar(25), po_headers.purchase_order) as po_no, 
po_headers.buy_vendor as vendor_code,
a.receiver, 
a.item, 
a.quantity_received, 
a.unit_cost,
a.total_cost,
a.bill_of_lading,
convert(varchar(25),po_headers.purchase_order)+'_'+convert(varchar(25),a.bill_of_lading)+'_'+CONVERT(varchar(25),a.item) as id

FROM HistoricalData.dbo.po_receiver_items_historical a
 join po_headers on a.purchase_order = CONVERT(varchar(25),po_headers.purchase_order)
join part on a.item = part.part

WHERE (ft.fn_truncdate('dd',a.time_stamp) = @current_rgni_date)
and (a.invoice = '')
and   (
		(@account_code = '212011' and part.product_line not in ('BULBED ES3 COMPONENTS', 'ES3 COMPONENTS', 'OUTSOURCED ES3 COMPONENTS'))       
       or
        (@account_code = '212060' and part.product_line in ('BULBED ES3 COMPONENTS', 'ES3 COMPONENTS', 'OUTSOURCED ES3 COMPONENTS'))       
      )
and (po_headers.buy_vendor <> 'EEH')
and (po_headers.po_type = 'MONITOR')


insert into eeiuser.acctg_rgni_comparison
select	isnull(a.id,b.id),
		ISNULL(a.vendor_code,''),
		a.changed_date,
		a.purchase_order, 
		a.bill_of_lading,
		ISNULL(a.item,''), 
		ISNULL(a.quantity_received,0),
		ISNULL(a.unit_cost,0),
		ISNULL(a.total_cost,0),
		b.vendor_code,
		b.changed_date,
		b.purchase_order,
		b.bill_of_lading,
		b.item,
		ISNULL(b.quantity_received,0),
		ISNULL(b.unit_cost,0),
		ISNULL(b.total_cost,0),
		0
from	@prior_rgni_report a
 left outer join @current_rgni_report b on a.id = b.id
 
--select * from eeiuser.acctg_rgni_comparison

-- Update table with current month inventory where no prior month inventory
insert into eeiuser.acctg_rgni_comparison
select	a.id,
		a.vendor_code,
		a.changed_date,
		a.purchase_order, 
		a.bill_of_lading,
		a.item,
		0,
		0,
		0,
		a.vendor_code,
		a.changed_date,
		a.purchase_order,
		a.bill_of_lading,
		a.item,
		ISNULL(a.quantity_received,0),
		ISNULL(a.unit_cost,0),
		ISNULL(a.total_cost,0),
		0
from	@current_rgni_report a
 where a.id not in (select id from eeiuser.acctg_rgni_comparison)
 
-- select * from eeiuser.acctg_rgni_comparison
 
--Update table for instances of current month activity but no current month or prior month ending inventory
insert into eeiuser.acctg_rgni_comparison
select  distinct(id),
		vendor,
		NULL,	
		purchase_order,		
		long_bill_of_lading,		
		part,		
		0,		
		NULL,		
		0,		
		NULL,		
		NULL,
		purchase_order,
		NULL,
		part,
		0,
		NULL,
		0,
		0
from	eeiuser.acctg_rgni_selected_gl_transactions c
where	c.id not in (select id from eeiuser.acctg_rgni_comparison)

-- select * from eeiuser.acctg_rgni_comparison

update eeiuser.acctg_rgni_comparison
set periodchange = current_total_cost - prior_total_cost

select 
	A.PeriodChange-ISNULL(C.activity_ext_amount,0) as variance,
	a.id,
	a.Prior_Vendor_Code,
	a.Prior_Changed_Date,
	A.Prior_Purchase_Order,
	A.Prior_Bill_of_Lading,
	A.Prior_Item,
	A.Prior_Quantity_Received,
	A.Prior_Unit_Cost,
	A.Prior_Total_Cost,
	A.Current_Vendor_Code,
	A.Current_Changed_Date,
	A.Current_Purchase_Order,
	A.Current_Bill_of_Lading,
	A.Current_Item,
	A.Current_Quantity_Received,
	A.Current_Unit_Cost,
	A.Current_Total_Cost,
	A.PeriodChange,
	C.id,
	ISNULL(C.activity_ext_amount,0)	as activity_ext_amount
from eeiuser.acctg_rgni_comparison a
--left join (select * from eeiuser.acctg_rgni_selected_gl_transactions) b on a.id = b.id
left join (select id, SUM(amount) as activity_ext_amount from eeiuser.acctg_rgni_selected_gl_transactions group by id) c on a.id = c.id







GO
