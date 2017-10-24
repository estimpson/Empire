SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_eei_apitems_with_surcharge] as
Select		ap_headers.inv_cm_date,
				apinv.vendor, 
				apinv.invoice_cm,
				apinv.invoice_cm as surchargedInvoice,				
			(CASE WHEN apinv.vendor in ('CCC') and RIGHT(apinv.invoice_cm,1) like '%[A-Z]%' 
						THEN  SUBSTRING(apinv.invoice_cm,1, LEN(apinv.invoice_cm)-PATINDEX('%[A-Z]%',RIGHT(apinv.invoice_cm,1))) 
						ELSE apinv.invoice_cm END) as actual_invoice,
			apinv.purchase_order,
			(select sum(quantity) from ap_items where ap_items.invoice_cm = apinv.invoice_cm and ap_items.item = apinv.item and ap_items.purchase_order = apinv.purchase_order) as quantity,
			apinv.price,
			apinv.extended_amount as extendedcost,
			item,
			item_description
			

from		ap_items apinv,
				ap_headers
where		apinv.invoice_cm = ap_headers.invoice_cm and apinv.vendor = ap_headers.vendor and apinv.inv_cm_flag = ap_headers.inv_cm_flag and
				(apinv.item not like '%Adjust%' or apinv.item_description not like '%Copper%' or apinv.item not like '%surcharge%' )and		
				apinv.extended_amount > 0 and apinv.purchase_order is not NULL   and 
				isNULL(apinv.purchase_order,'XXXXXX')<> '' and 
				isNULL(apinv.purchase_order,'XXXXXX') not like 'EEH%'  and
				(CASE WHEN apinv.vendor in ('CCC') and RIGHT(apinv.invoice_cm,1) like '%[A-Z]%' 
						THEN  SUBSTRING(apinv.invoice_cm,1, LEN(apinv.invoice_cm)-PATINDEX('%[A-Z]%',RIGHT(apinv.invoice_cm,1))) 
						ELSE apinv.invoice_cm END) in (Select actual_invoice from vw_eei_metaladjustments) and item<> 'UPAC' 
GO
