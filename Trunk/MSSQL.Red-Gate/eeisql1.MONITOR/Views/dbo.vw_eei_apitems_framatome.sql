SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[vw_eei_apitems_framatome] as
Select 	ap_headers.inv_cm_date,
				ap_headers.vendor, 
				ap_items.invoice_cm,
				ap_items.item,				
				ap_items.quantity,
				ap_items.price,
				ap_items.extended_amount,
				ap_items.purchase_order
			
from		ap_headers,
				ap_items
where		ap_headers.vendor='FRAMATOME' and
				ap_headers.invoice_cm = ap_items.invoice_cm and ap_headers.vendor = ap_items.vendor and ap_headers.inv_cm_flag = ap_items.inv_cm_flag and
				ap_items.item in (select part from part) and extended_amount > 0
GO
