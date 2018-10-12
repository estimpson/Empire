SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- [USE MONITOR]

CREATE PROCEDURE [eeiuser].[GetRGNI]

-- exec eeiuser.getrgni

as

select  

a.posting_account, 
b.posting_account, 
c.buy_unit, 
c.pay_unit,
c.po_type, 
a.purchase_order,
a.purchase_order_release,

c.buy_vendor, 
c.buy_vendor_name, 

b.document_date,
(case when datediff(d,b.document_date,getdate()) > 10 then 'Over 10' else 'Under 10' end) as age,
b.gl_date,
a.shipping_advice,
a.sort_line,  
a.item, 
replace(replace(replace(replace(cast(a.item_description as nvarchar(max)),char(9),''),char(13),''),',',''),char(10),'') as item_description, 

a.quantity, 
a.quantity_uom,
a.standards_per_quantity,

a.unit_cost, 
a.unit_cost_uom, 
a.standards_per_unit_cost, 

(a.quantity/a.standards_per_quantity)*(a.unit_cost/a.standards_per_unit_cost) as ext_cost,
a.document_amount ,

a.inventoried, 
a.inventory_uom, 
a.receiver_comments, 
c.buyer, 
b.clerk, 
b.location,   

a.activity_location, 
a.location

from eeh_empower..po_receiver_items a
join eeh_empower..po_receivers b on a.purchase_order = b.purchase_order and a.purchase_order_release = b.purchase_order_release and a.shipping_advice = b.shipping_advice and a.document_type = b.document_type
join eeh_empower..purchase_orders c on a.purchase_order = c.purchase_order and a.purchase_order_release = c.purchase_order_release
left join eeh_empower..ap_document_items d with (index(ix_ap_document_items_fk_ap_document_items_po_receiver_items)) on a.purchase_order = d.purchase_order and a.purchase_order_release = d.purchase_order_release and a.shipping_advice = d.por_shipping_advice and a.document_type = d.por_document_type and a.document_line = d.por_document_line 
left join eeh.eeiuser.po_receiver_items_invoiced f on a.purchase_order = f.purchase_order and a.purchase_order_release = f.purchase_order_release and a.shipping_advice = f.shipping_advice and a.document_type = f.document_type and a.document_line = f.document_line

where	isnull(d.por_shipping_advice,'') = '' 
	and isnull(f.invoice,'') = ''
	--DEM. Added Oct 19TH-2016. Req. by Chris D. (Troy). Bridget M.
	and isnull(a.quantity, 0) > 0
	and isnull(a.document_amount, 0) > 0 







GO
