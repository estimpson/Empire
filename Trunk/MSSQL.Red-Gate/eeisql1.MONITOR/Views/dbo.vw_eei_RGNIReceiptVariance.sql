SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view  [dbo].[vw_eei_RGNIReceiptVariance]
as
Select	*	
from 
(Select	document_type as APInvoiceDocument_type,
		transaction_date as APInvoiceTransactionDate,
		document_id1 as APInvoice,
		document_id2 as APVendor,
		amount as GLAPInvoiceAmount 
			
from		gl_cost_transactions 
where		document_type = 'AP INVOICE' and  
		document_id3 = 'I' and ledger_account like '2120%' ) GLAPInvoice join

(select		sum(extended_amount) APItemExtendedAmount, 
		Vendor, 
		invoice_cm, 
		isNULL(purchase_order, 'PO is NULL') PONUmber,
		IsNULL( bill_of_lading , 'BOL is NULL') as APItemBOL
from		dbo.ap_items 
where		inv_cm_flag= 'I'
group by	Vendor, invoice_cm, purchase_order,IsNULL( bill_of_lading , 'BOL is NULL') )  APItems on GLAPInvoice.APVendor = APItems.Vendor  and GLAPInvoice.APInvoice = APItems.invoice_cm  join
(Select		IsNULL(document_id2, 'BOL is NULL') as ReceiptBOL,
		max(transaction_date) As ReceiptTransactionDate,
		max(document_type) as ReceiptDocType,
		sum(document_amount) as ReceiptGLDocAmount,
		document_reference1 as ReceiptVendor,
		document_id1 as ReceiptPO
from		gl_cost_transactions 
where		document_type = 'Bill of lading' and document_line = 0 and ledger_account like '2120%' 
group by	IsNULL(document_id2, 'BOL is NULL') ,
		document_reference1,
		document_id1) GLReceipt on APItems.APItemBOL = GLReceipt.ReceiptBOL and APItems.Vendor = GLReceipt.ReceiptVendor  and GLReceipt.ReceiptPO = PONumber

where		GLAPinvoiceAmount+ReceiptGLDocAmount<>0
GO
