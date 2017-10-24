SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[USP_Rpt_Empower_ProofReport]( 
		@ProofReportID varchar(25) )
as
SELECT
	ap_check_selection_items.group_number, 
	ap_check_selection_items.stub_number, 
	ap_check_selection_items.sort_order, 
	ap_check_selections.ap_check_selection, 
	ap_documents.pay_unit,
	ap_documents.bank_account,
	ap_documents.currency,
	ap_documents.direct_deposit,
	ap_documents.buy_vendor,
	ap_documents.document_type,
	ap_documents.ap_document,
	ap_documents.purchase_order,
	purchase_orders.po_type,
	ap_documents.document_date,
	ap_documents.payment_term,
	ap_documents.due_date,
	ap_documents.document_amount * ap_documents.multiplier document_amount,
	ap_documents.ledger_amount * ap_documents.multiplier ledger_amount,
	(SELECT open_amount
		FROM GetDocumentOpenAmount(ap_documents.document_type,
                                     ap_documents.document_id1,
                                     ap_documents.document_id2,
                                     ap_documents.document_id3)) * ap_documents.multiplier open_amount,
	ap_check_selection_items.discount_amount * ap_documents.multiplier discount_amount, 
	ap_check_selection_items.pay_amount, 
	ap_document_items.document_line inv_cm_line, 
	ap_document_items.sort_line inv_cm_sort_line,
	ap_document_items.item,
	ap_document_items.item_description,
	ap_document_items.posting_account,
	ap_document_items.quantity,
	ap_document_items.quantity_uom,
	ap_document_items.unit_cost,
	ap_document_items.unit_cost_uom,
	ap_document_items.document_amount * ap_documents.multiplier item_document_amount,
	chart_of_account_items.account_description,
	gl_cost_transactions.posting_account gl_posting_account,
    gl_cost_transactions.ledger_amount gl_amount,
	purchase_order_items.unit_cost po_unit_cost,
	po_receiver_items.shipping_advice,
	po_receiver_items.quantity quantity_received, 
    po_receiver_items.unit_cost po_receiver_items_unit_cost,
    po_receiver_items.document_amount po_receiver_items_total_cost, 
	po_receiver_items.posting_account po_receiver_items_posting_account,
    po_receiver_items.item po_receiver_items_item
 FROM   
	ap_check_selections INNER JOIN 
	ap_check_selection_items ON 
		ap_check_selection_items.ap_check_selection = ap_check_selections.ap_check_selection INNER JOIN  
	ap_documents ON
		ap_documents.buy_vendor = ap_check_selection_items.buy_vendor AND 
		ap_documents.ap_document = ap_check_selection_items.ap_document AND
		ap_documents.document_type = ap_check_selection_items.document_type INNER JOIN
	ap_document_items ON
		ap_document_items.buy_vendor = ap_documents.buy_vendor AND 
		ap_document_items.ap_document = ap_documents.ap_document AND
		ap_document_items.document_type = ap_documents.document_type INNER JOIN
	gl_cost_transactions ON
		gl_cost_transactions.document_type = ap_document_items.document_type AND
		gl_cost_transactions.document_id1 = ap_document_items.document_id1 AND
		gl_cost_transactions.document_id2 = ap_document_items.document_id2 AND
		gl_cost_transactions.document_id3 = ap_document_items.document_id3 AND
		gl_cost_transactions.document_line = ap_document_items.document_line INNER JOIN
	posting_accounts ON
		posting_accounts.fiscal_year = gl_cost_transactions.fiscal_year AND
		posting_accounts.ledger = gl_cost_transactions.ledger AND
		posting_accounts.posting_account = gl_cost_transactions.posting_account INNER JOIN
	chart_of_account_items ON
		chart_of_account_items.fiscal_year = posting_accounts.fiscal_year AND
		chart_of_account_items.coa = posting_accounts.coa AND
		chart_of_account_items.account = posting_accounts.account LEFT OUTER JOIN
	purchase_orders ON
		purchase_orders.purchase_order = ap_documents.purchase_order AND
		purchase_orders.purchase_order_release = ap_documents.purchase_order_release LEFT OUTER JOIN
	purchase_order_items ON
		purchase_order_items.purchase_order = ap_document_items.purchase_order AND
		purchase_order_items.purchase_order_release = ap_document_items.purchase_order_release AND
		purchase_order_items.document_line = ap_document_items.purchase_order_document_line LEFT OUTER JOIN
	po_receiver_application_items ON
		po_receiver_application_items.source_document_type = ap_document_items.document_type AND
		po_receiver_application_items.source_document_id1 = ap_document_items.document_id1 AND
		po_receiver_application_items.source_document_id2 = ap_document_items.document_id2 AND
		po_receiver_application_items.source_document_id3 = ap_document_items.document_id3 AND
		po_receiver_application_items.source_document_line = ap_document_items.document_line LEFT OUTER JOIN
	po_receiver_items ON
		po_receiver_items.purchase_order = po_receiver_application_items.por_purchase_order AND
		po_receiver_items.purchase_order_release = po_receiver_application_items.por_purchase_order_release AND
		po_receiver_items.shipping_advice = po_receiver_application_items.por_shipping_advice AND
		po_receiver_items.document_type = po_receiver_application_items.por_document_type AND
		po_receiver_items.document_line = po_receiver_application_items.por_document_line
WHERE
	ap_check_selections.ap_check_selection = @ProofReportID
ORDER BY           
	ap_documents.posting_account,
	ap_documents.pay_vendor,
	ap_documents.due_date
  

GO
