SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[vw_eei_apitems_cccsurcharges] as
Select 	vw_eei_metaladjustments.inv_cm_date,
				vw_eei_metaladjustments.vendor, 
				vw_eei_metaladjustments.invoice_cm,
				vw_eei_metaladjustments.invoice_cm as surchargedInvoice,				
				(CASE WHEN vw_eei_metaladjustments.vendor in ('CCC') and RIGHT(vw_eei_metaladjustments.invoice_cm,1) like '%[A-Z]%' 
						THEN  SUBSTRING(vw_eei_metaladjustments.invoice_cm,1, LEN(vw_eei_metaladjustments.invoice_cm)-PATINDEX('%[A-Z]%',RIGHT(vw_eei_metaladjustments.invoice_cm,1))) 
						ELSE vw_eei_metaladjustments.invoice_cm END) as actual_invoice,
			vw_eei_metaladjustments.metaladjustments,
			isNULL((Select sum(quantity) from vw_eei_apitems_with_surcharge
				where		vw_eei_apitems_with_surcharge.actual_invoice = vw_eei_metaladjustments.actual_invoice and
								vw_eei_apitems_with_surcharge.vendor = vw_eei_metaladjustments.vendor),0) as totalQty
								
			

from		vw_eei_metaladjustments
where		vw_eei_metaladjustments.vendor='CCC' and
					isNULL((Select sum(quantity) from vw_eei_apitems_with_surcharge
				where		vw_eei_apitems_with_surcharge.actual_invoice = vw_eei_metaladjustments.actual_invoice and
								vw_eei_apitems_with_surcharge.vendor = vw_eei_metaladjustments.vendor),0)>0
GO
