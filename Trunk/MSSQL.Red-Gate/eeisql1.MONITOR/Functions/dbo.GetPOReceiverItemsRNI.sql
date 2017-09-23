SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- select * from GetPOReceiverItemsRNI ('2015-09-30') order by gl_date

CREATE FUNCTION [dbo].[GetPOReceiverItemsRNI]
(      
       @as_of_date DATETIME
)
RETURNS TABLE 
AS
RETURN 
(select   po_receiver_items.item_transaction_type             
              ,po_receivers.purchase_order+po_receivers.purchase_order_release+po_receivers.shipping_advice+po_receivers.document_type as po_receiver
			  ,po_receiver_items.document_type
              ,po_receiver_items.document_line
              ,purchase_orders.po_type          
              ,purchase_orders.blanket          
              ,po_receiver_items.purchase_order
              ,po_receiver_items.purchase_order_release       

              ,po_receiver_items.shipping_advice       
              ,po_receivers.gl_date

              ,purchase_orders.buy_vendor
              ,purchase_orders.buy_vendor_name
              ,po_receiver_items.item    
              ,po_receiver_items.item_description

              ,po_receiver_items.location
              ,po_receiver_items.quantity
              ,po_receiver_items.quantity_uom
              ,po_receiver_items.unit_cost
              ,po_receiver_items.unit_cost_uom
              ,po_receiver_items.quantity*po_receiver_items.unit_cost as po_receiver_items_ext_cost
              ,po_receiver_items.receiver_comments

              ,po_receiver_items.unit
              ,po_receiver_items.receipt_issue
              ,po_receiver_items.completed
              ,po_receiver_items.posting_account as DB_Acct
              ,gl_cost_transactions.posting_account as CR_Acct
              ,chart_of_account_items.account_description as CR_Description
              ,gl_cost_transactions.document_amount *-1 document_amount
              ,applied_amounts.applied_document_amount        
              
              ,po_receiver_items.changed_date
              ,po_receiver_items.changed_user_id 
from Empower..po_receiver_items
       INNER JOIN Empower..po_receivers ON
                     po_receiver_items.purchase_order = po_receivers.purchase_order
              AND po_receiver_items.purchase_order_release = po_receivers.purchase_order_release
              AND po_receiver_items.shipping_advice = po_receivers.shipping_advice
              AND po_receiver_items.document_type = po_receivers.document_type
       
       INNER JOIN Empower..gl_cost_transactions ON
                     po_receivers.document_type=gl_cost_transactions.document_type  
              AND po_receivers.document_id1=gl_cost_transactions.document_id1  
              AND po_receivers.document_id2=gl_cost_transactions.document_id2 
              AND po_receivers.document_id3=gl_cost_transactions.document_id3 
       
       INNER JOIN Empower..posting_accounts posting_accounts ON 
                     gl_cost_transactions.fiscal_year=posting_accounts.fiscal_year  
              AND gl_cost_transactions.ledger=posting_accounts.ledger 
              AND gl_cost_transactions.posting_account=posting_accounts.posting_account 
       
       INNER JOIN Empower..chart_of_account_items chart_of_account_items ON 
                     posting_accounts.fiscal_year=chart_of_account_items.fiscal_year 
              AND posting_accounts.coa=chart_of_account_items.coa 
              AND posting_accounts.account=chart_of_account_items.account 

       INNER JOIN Empower..purchase_orders ON 
                     po_receivers.purchase_order=purchase_orders.purchase_order  
              AND po_receivers.purchase_order_release=purchase_orders.purchase_order_release
       
       OUTER APPLY   Empower..GetPOReceiverAppliedAmountsFromGL(     po_receivers.purchase_order, 
                                                                                         po_receivers.purchase_order_release, 
                                                                                         po_receivers.shipping_advice,
                                                                                         po_receivers.document_type,
                                                                                         gl_cost_transactions.posting_account,
                                                                                         @as_of_date) applied_amounts
       LEFT JOIN monitor..vendor v ON
                     purchase_orders.buy_vendor = v.code
WHERE
       po_receivers.gl_date <= @as_of_date
       AND gl_cost_transactions.approved = 1 
       AND gl_cost_transactions.update_ledger_balances = 1 
       AND gl_cost_transactions.gl_line_type = 'H' 
       AND gl_cost_transactions.document_amount * -1 <> applied_amounts.applied_document_amount
       AND purchase_orders.po_type = 'MONITOR'
       AND purchase_orders.buy_vendor not in ('EEH','EEM')
	   AND po_receiver_items.completed <> 1 -- These vendors are never paid due because they are intercompany (maybe we can attribute the PO as intercompany?)
       -- AND ISNULL(v.outside_processor,'') = '' -- Not sure why the exclusion other than we didn't pay the vendor off of receipt (we don't use any outside_processors in Troy)

)

GO
