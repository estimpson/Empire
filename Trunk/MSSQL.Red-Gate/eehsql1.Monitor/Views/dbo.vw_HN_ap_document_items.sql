SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create VIEW [dbo].[vw_HN_ap_document_items]
AS
SELECT        dbo.ap_document_items.buy_vendor, dbo.ap_document_items.ap_document, dbo.ap_document_items.document_type, dbo.ap_document_items.document_line, dbo.ap_document_items.sort_line, 
                         dbo.ap_document_items.line_type, dbo.ap_document_items.purchase_order, dbo.ap_document_items.purchase_order_release, dbo.ap_document_items.purchase_order_document_line, 
                         dbo.ap_document_items.por_purchase_order, dbo.ap_document_items.por_purchase_order_release, dbo.ap_document_items.por_shipping_advice, dbo.ap_document_items.por_document_type, 
                         dbo.ap_document_items.por_document_line, dbo.ap_document_items.quantity, dbo.ap_document_items.quantity_uom, dbo.ap_document_items.unit_cost, dbo.ap_document_items.unit_cost_uom, 
                         dbo.ap_document_items.document_amount, dbo.ap_document_items.posting_account, dbo.ap_document_items.cost_account, dbo.ap_documents.buy_vendor_name, dbo.ap_documents.document_date, 
                         dbo.ap_documents.pay_vendor, dbo.ap_documents.pay_vendor_name, dbo.ap_documents.approved, dbo.ap_documents.received_date
FROM            dbo.ap_document_items INNER JOIN
                         dbo.ap_documents ON dbo.ap_document_items.buy_vendor = dbo.ap_documents.buy_vendor AND dbo.ap_document_items.ap_document = dbo.ap_documents.ap_document AND 
                         dbo.ap_document_items.document_type = dbo.ap_documents.document_type

GO
