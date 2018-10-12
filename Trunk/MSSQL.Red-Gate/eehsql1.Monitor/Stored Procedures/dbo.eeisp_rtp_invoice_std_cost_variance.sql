SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[eeisp_rtp_invoice_std_cost_variance] (@BeginDate datetime, @ThroughDate datetime, @Account varchar(25))
as
Begin
--eeisp_rtp_invoice_std_cost_variance '2016-3-1', '2016-3-15', '502012'
Declare	@AdjBeginDT datetime,
		@AdjEndDT datetime

Select	@AdjBeginDT = [FT].[fn_TruncDate] (  'dd', @BeginDate)
Select	@AdjEndDT = dateadd(dd,1,[FT].[fn_TruncDate] ( 'dd', @ThroughDate))

SELECT	transaction_date=gl_cost_documents.document_date, 
		gl_cost_transactions.document_id1, 
		gl_cost_transactions.document_id2, 
		ledger_account=gl_cost_transactions.posting_account, 
		ap_items.item, 
		ap_items.quantity, 
		unit_of_measure=ap_items.unit_cost_uom, 
		ap_items.unit_cost apPrice, 
		extended_amount = ap_items.document_amount, 
		po_items.unit_cost poPrice, 
		gl_cost_transactions.document_id3,
		gl_cost_transactions.document_amount, 
		(CASE WHEN ap_items.quantity = 0 THEN 0 ELSE (ap_items.document_amount-gl_cost_transactions.document_amount)/ap_items.quantity END) as Cost,
		po_items.purchase_order, 
		gl_cost_transactions.
		update_ledger_balances, 
		ap_items.item_description
 FROM	Monitor.dbo.gl_cost_transactions gl_cost_transactions 
		inner join  Monitor.dbo.gl_cost_documents gl_cost_documents on
				gl_cost_transactions.document_type = gl_cost_documents.document_type AND 
				gl_cost_transactions.document_id1 = gl_cost_documents.document_id1 AND 
				gl_cost_transactions.document_id2 = gl_cost_documents.document_id2 
                      AND  gl_cost_transactions.document_id3 = gl_cost_documents.document_id3
		LEFT JOIN Monitor.dbo.ap_document_items ap_items ON gl_cost_transactions.document_id1=ap_items.buy_vendor AND 
					gl_cost_transactions.document_id2=ap_items.ap_document   AND 
				gl_cost_transactions.document_line=ap_items.document_line AND 
				gl_cost_transactions.gl_line_type = 'I'	
--		gl_cost_transactions.document_id3=ap_items.inv_cm_flag 
LEFT JOIN Monitor.dbo.purchase_order_items po_items ON ap_items.purchase_order=po_items.purchase_order AND 
		ap_items.purchase_order_document_line=po_items.document_line
 WHERE	gl_cost_documents.document_date>=@AdjBeginDT AND gl_cost_documents.document_date<@AdjEndDT AND 
		gl_cost_transactions.posting_account=@Account AND 
		gl_cost_transactions.update_ledger_balances='1' AND 
		gl_cost_transactions.document_id2<>'wzqrsqvwrqs'
 ORDER BY gl_cost_documents.document_date, gl_cost_transactions.document_id2, ap_items.item

/*SELECT	gl_cost_transactions.transaction_date, 
		gl_cost_transactions.document_id1, 
		gl_cost_transactions.document_id2, 
		gl_cost_transactions.ledger_account, 
		ap_items.item, 
		ap_items.quantity, 
		ap_items.unit_of_measure, 
		ap_items.price apPrice, 
		ap_items.extended_amount, 
		po_items.price poPrice, 
		gl_cost_transactions.document_amount, 
		(CASE WHEN ap_items.quantity = 0 THEN 0 ELSE (ap_items.extended_amount-gl_cost_transactions.document_amount)/ap_items.quantity END) as Cost,
		po_items.purchase_order, 
		gl_cost_transactions.
		update_balances, 
		ap_items.item_description
 FROM	Monitor.dbo.gl_cost_transactions gl_cost_transactions 
		LEFT JOIN Monitor.dbo.ap_document_items ap_items ON gl_cost_transactions.document_id1=ap_items.ap_document AND 
		gl_cost_transactions.document_id2=ap_items.buy_vendor AND 
		gl_cost_transactions.document_line=ap_items.document_line AND 
		gl_cost_transactions.gl_line_type = 'I'
--		gl_cost_transactions.document_id3=ap_items.inv_cm_flag 
LEFT JOIN Monitor.dbo.po_items po_items ON ap_items.purchase_order=po_items.purchase_order AND 
		ap_items.purchase_order_line=po_items.po_line
 WHERE	gl_cost_transactions.transaction_date>=@AdjBeginDT AND gl_cost_transactions.transaction_date<@AdjEndDT AND 
		gl_cost_transactions.ledger_account=@Account AND 
		gl_cost_transactions.update_balances='Y' AND 
		gl_cost_transactions.document_id2<>'wzqrsqvwrqs'
 ORDER BY gl_cost_transactions.transaction_date, gl_cost_transactions.document_id2, ap_items.item*/
End

GO
