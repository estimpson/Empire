SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[acctg_rgni_reconcile] @inputdate datetime
as

--1.  Create the working table for the gl_cost_transaction result set
--CREATE TABLE acctg_rgni_temp
--             (
--				document_type varchar(50),
--				document_id1 varchar(50),
--				document_id3 varchar(5),
--				document_line int,
--				transaction_date datetime,
--				bill_of_lading varchar(50),
--				quantity decimal(18,6),
--				amount decimal(18,6),
--				item varchar(50),
--				document_reference1 varchar(50),
--				document_reference2 varchar(50),
--				application varchar(25)
--			   )

--2.  Clear the working table
DELETE FROM		acctg_rgni_temp
 
--3.  Populate the working table with the gl_cost_transaction monitor inventory result set         
INSERT INTO		acctg_rgni_temp

SELECT			document_type, 
				Min(document_id1)+'...'+Max(document_id1) as document_id1, 
				document_id3, 
				document_line, 
				transaction_date, 
				shipper as bill_of_lading, 
				sum(gct.quantity) as quantity, 
				-sum(amount) as amount, 
				document_reference1 as item,
				document_reference1, 
				document_reference2,  
				application

FROM			gl_cost_transactions gct 
				left join audit_trail on convert(varchar(25),gct.document_id1) = convert(varchar(25),serial) and audit_trail.type = document_id3 and date_stamp >= @inputdate and date_stamp < dateadd(d,+1,@inputdate)

WHERE			(ledger_account = '212012' 
			and fiscal_year = datepart(yyyy,@inputdate) 
			and ledger = 'HONDURAS')
			and period = datepart(mm,@inputdate)
			and gct.transaction_date = @inputdate
			and update_balances = 'Y' 
			and document_type = 'MON INV'
	
group by		shipper
				,document_reference1 
				,transaction_date
				,document_type
				,document_id3 
				,document_line 
				,document_reference1 
				,document_reference2 
				,application

--4.  Populate the working table with the non-monitor inventory transaction result set         
INSERT INTO		acctg_rgni_temp

SELECT			document_type, 
				document_id1, 
				document_id3, 
				document_line, 
				transaction_date, 
				bill_of_lading as bill_of_lading, 
				-gct.quantity, 
				-amount, 
				isnull(ap_items.item,document_reference1) as item,
				document_reference1, 
				document_reference2,  
				gct.application

FROM			gl_cost_transactions gct 
			left join ap_items on inv_cm_flag = gct.document_id3 and vendor = gct.document_reference1 and invoice_cm = gct.document_id1 and inv_cm_line = document_line 

WHERE			(ledger_account = '212012' 
			and fiscal_year = datepart(yyyy,@inputdate) 
			and ledger = 'HONDURAS')
			and period = datepart(mm,@inputdate)
			and gct.transaction_date = @inputdate
			and update_balances = 'Y'
			and document_type <> 'MON INV'

--5.  Create the working table for the po_receiver_items result set
--CREATE TABLE acctg_rgni_temp2
--	 	       (
--				changed_date datetime,
--				po_no varchar(50),
--				vendor_code varchar(50),
--				bill_of_lading varchar(50),
--				inv_line int,
--				receiver varchar(50),		
--				item varchar(50),
--				quantity_received decimal(18,6),
--				unit_cost decimal(18,6),
--				total_cost decimal(18,6)
--		       )

--6.  Clear the working table
DELETE FROM		acctg_rgni_temp2

--7.  Populate the working table with the po_receiver_items result set
INSERT INTO		acctg_rgni_temp2

SELECT			ISNULL(b.changed_date, a.changed_date) as changed_date, 
				ISNULL(b.po_no,a.po_no) as po_no,
				ISNULL(b.vendor_code, a.vendor_code) as vendor_code,
				ISNULL(b.bill_of_lading, a.bill_of_lading) as bill_of_lading,
				ISNULL(b.inv_line, a.inv_line) as invoice_line, 
				ISNULL(b.receiver, a.receiver) as receiver, 
				ISNULL(b.item, a.item) as item, 
				(ISNULL(b.quantity_received,0)-ISNULL(a.quantity_received,0)) as quantity_received,
				ISNULL(b.unit_cost,a.unit_cost) as unit_cost,
				(ISNULL(b.total_cost,0)-ISNULL(a.total_cost,0)) as total_cost

FROM		(	SELECT	a.changed_date, 
						CONVERT(varchar(25), po_header.po_number) as po_no, 
						po_header.vendor_code,
						a.receiver,
						a.inv_line, 
						a.item, 
						a.quantity_received, 
						a.unit_cost,
						a.total_cost,
						a.bill_of_lading

				FROM	po_receiver_items_historical_daily a,
						vendor,
						po_header

				WHERE	(a.purchase_order = CONVERT(varchar(25),po_header.po_number))
					and (vendor.code = po_header.vendor_code)
				 -- and ((vendor.outside_processor is null) or (vendor.outside_processor = '')) 
					and (vendor.code <> 'EEH')
					and (a.fiscal_year = datepart(yyyy,dateadd(d,-1,@inputdate))
					and a.period = datepart(mm,dateadd(d,-1,@inputdate))
					and ft.fn_truncdate('dd',a.time_stamp) = dateadd(d,-1,@inputdate)
					and a.invoice = '')
			) a 

				FULL OUTER JOIN

			(	SELECT	a.changed_date, 
						CONVERT(varchar(25),po_header.po_number) as po_no, 
						po_header.vendor_code,
						a.receiver,
						a.inv_line, 
						a.item, 
						a.quantity_received, 
						a.unit_cost,
						a.total_cost,
						a.bill_of_lading

				FROM	po_receiver_items_historical_daily a,
						vendor,
						po_header

				WHERE	(a.purchase_order = CONVERT(varchar(25),po_header.po_number))
					and (vendor.code = po_header.vendor_code)
				 -- and ((vendor.outside_processor is null) or (vendor.outside_processor = '')) 
					and (vendor.code <> 'EEH')
					and (a.fiscal_year = datepart(yyyy,@inputdate)
					and a.period = datepart(mm,@inputdate)
					and ft.fn_truncdate('dd',a.time_stamp) = @inputdate
					and a.invoice = '')
			) b

				on a.bill_of_lading = b.bill_of_lading and a.item = b.item and a.po_no = b.po_no 

WHERE			(ISNULL(a.total_cost,0)-ISNULL(b.total_cost,0)) <> 0

-- Get results

select			*
				,ISNULL(b.amount,0)-ISNULL(a.total_cost,0) as variance 
				
FROM		(	SELECT	changed_date
						,po_no
						,vendor_code
						,(CASE when (total_cost > 0) then left(bill_of_lading,len(bill_of_lading)-7) else bill_of_lading end) as bill_of_lading
						,inv_line
						,receiver
						,item
						,quantity_received
						,unit_cost
						,total_cost 

				FROM	acctg_rgni_temp2
			) a
	 
				FULL OUTER JOIN
	 
			(	SELECT	* 
				
				FROM	acctg_rgni_temp
			) b 
	
				on a.bill_of_lading = b.bill_of_lading and a.item = b.item


GO
