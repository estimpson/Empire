SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- This view used by: execute	EEIUser.acctg_intercompany_reconcile
-- Returns gl_cost_transaction activity at a part level


CREATE VIEW [dbo].[vw_empower_transactions_by_posting_account_intercompany] AS

-- 1. Monitor shipouts
SELECT
	monitor_inventory_transactions.monitor_audit_trail_id,
	monitor_inventory_transactions.monitor_serial,
	monitor_inventory_transactions.monitor_part,
	monitor_inventory_transactions.monitor_transaction_type,
	monitor_inventory_transactions.monitor_transaction_date,
	monitor_inventory_transaction_allocations.posting_account,
	SUM(monitor_inventory_transactions.monitor_quantity) quantity,
	AVG(monitor_inventory_transactions.monitor_unit_cost) cost,
	SUM(monitor_inventory_transaction_allocations.monitor_amount) amount,
	monitor_inventory_documents.fiscal_year,
	monitor_inventory_documents.ledger,
	monitor_inventory_documents.period 
FROM
	EEH_Empower..monitor_inventory_transactions INNER JOIN
	EEH_Empower..monitor_inventory_transaction_allocations ON
		monitor_inventory_transactions.monitor_inventory_transaction_id = monitor_inventory_transaction_allocations.monitor_inventory_transaction_id INNER JOIN
	EEH_Empower..monitor_inventory_documents ON
		monitor_inventory_transaction_allocations.document_type = monitor_inventory_documents.document_type AND
		monitor_inventory_transaction_allocations.document_id1 = monitor_inventory_documents.document_id1 AND
		monitor_inventory_transaction_allocations.document_id2 = monitor_inventory_documents.document_id2 AND
		monitor_inventory_transaction_allocations.document_id3 = monitor_inventory_documents.document_id3
GROUP BY
	monitor_inventory_transactions.monitor_audit_trail_id,
	monitor_inventory_transactions.monitor_serial,
	monitor_inventory_transactions.monitor_part,
	monitor_inventory_transactions.monitor_transaction_type,
	monitor_inventory_transactions.monitor_transaction_date,
	monitor_inventory_transaction_allocations.posting_account,
	monitor_inventory_documents.fiscal_year,
	monitor_inventory_documents.ledger,
	monitor_inventory_documents.period 

UNION ALL

-- 2. Monitor receipts
SELECT
	monitor_po_receiver_transactions.monitor_audit_trail_id,
	audit_trail.serial monitor_serial,
	monitor_po_receiver_transactions.monitor_part,
	audit_trail.type monitor_transaction_type,
	monitor_po_receiver_transactions.monitor_transaction_date,
	po_receivers.posting_account, -- gl_cost_transactions.posting_account,
    monitor_po_receiver_transactions.monitor_quantity as quantity,
	po_receiver_items.unit_cost,
	CASE 
		WHEN ISNULL(po_receiver_items.quantity, 0) <> 0 THEN
			CONVERT(DECIMAL(18,6), -1* gl_cost_transactions.document_amount * (monitor_po_receiver_transactions.monitor_quantity / po_receiver_items.quantity)) 
		ELSE 
			0 
	END amount,
	po_receivers.fiscal_year,
	po_receivers.ledger,
	po_receivers.period
FROM
	EEH_Empower..monitor_po_receiver_transactions INNER JOIN
	EEH_Empower..po_receiver_items ON
		monitor_po_receiver_transactions.purchase_order = po_receiver_items.purchase_order AND
		monitor_po_receiver_transactions.purchase_order_release = po_receiver_items.purchase_order_release AND
		monitor_po_receiver_transactions.shipping_advice = po_receiver_items.shipping_advice AND
		monitor_po_receiver_transactions.document_type = po_receiver_items.document_type AND
		monitor_po_receiver_transactions.document_line = po_receiver_items.document_line INNER JOIN
	EEH_Empower..po_receivers ON
		monitor_po_receiver_transactions.purchase_order = po_receivers.purchase_order AND
		monitor_po_receiver_transactions.purchase_order_release = po_receivers.purchase_order_release AND
		monitor_po_receiver_transactions.shipping_advice = po_receivers.shipping_advice AND
		monitor_po_receiver_transactions.document_type = po_receivers.document_type 
		INNER JOIN
	EEH_Empower..gl_cost_transactions ON
		po_receiver_items.document_type = gl_cost_transactions.document_type AND
		po_receiver_items.document_id1 = gl_cost_transactions.document_id1 AND
		po_receiver_items.document_id2 = gl_cost_transactions.document_id2 AND
		po_receiver_items.document_id3 = gl_cost_transactions.document_id3 AND
		po_receiver_items.document_line = gl_cost_transactions.document_line 
LEFT OUTER JOIN
	audit_trail ON
		monitor_po_receiver_transactions.monitor_audit_trail_id = audit_trail.id
WHERE
	
	gl_cost_transactions.update_ledger_balances = 1 AND
	gl_cost_transactions.approved = 1
--	and gl_cost_transactions.fiscal_year = '2015' 
--	and gl_cost_transactions.period = 8
--	and po_receivers.posting_account = '215011'

-- select count(*) from audit_trail at join part p on at.part = p.part where at.type = 'R' and p.type = 'F' and at.date_stamp >= '2015-08-01' and at.date_stamp < '2015-09-01'

UNION ALL

-- 3. Journal Entries
SELECT
	NULL monitor_audit_trail_id,
	'' monitor_serial,
	gl_cost_transactions.document_id3 monitor_part,
	'JE' monitor_transaction_type,
	je_documents.gl_date monitor_transaction_date,
	gl_cost_transactions.posting_account
	,0 quantity
	,0 cost
	,gl_cost_transactions.document_amount amount
	,je_documents.fiscal_year
	,je_documents.ledger
	,je_documents.period 
FROM
	EEH_Empower..je_documents INNER JOIN
	EEH_Empower..gl_cost_transactions ON
		je_documents.document_type = gl_cost_transactions.document_type AND
		je_documents.document_id1 = gl_cost_transactions.document_id1 AND
		je_documents.document_id2 = gl_cost_transactions.document_id2 AND
		je_documents.document_id3 = gl_cost_transactions.document_id3
WHERE
	gl_cost_transactions.update_ledger_balances = 1 AND
	gl_cost_transactions.approved = 1


GO
