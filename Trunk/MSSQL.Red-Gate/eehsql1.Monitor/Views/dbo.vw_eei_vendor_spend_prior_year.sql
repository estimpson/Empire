SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[vw_eei_vendor_spend_prior_year]
as
Select	ap_headers.Vendor,
		ap_items.item,
		isNull(part.name, ' ') as PartDesc,
		SUM(quantity)UNITS,
		SUM((CASE WHEN pay_unit = '12L' THEN extended_amount/18.9 else extended_amount END)) DOLLARS,
		AVG((CASE WHEN pay_unit = '12L' THEN price/18.9 else price END)) as AvgPrice
		
from	
ap_headers
join	ap_items on ap_headers.invoice_cm= ap_items.invoice_cm and ap_headers.vendor = ap_items.vendor and ap_headers.inv_cm_flag= ap_items.inv_cm_flag
left join	part on ap_items.item = part.part 
where	inv_cm_date>=DATEADD(dd,-365,getdate()) and inv_cm_date<= '2050-01-01'
and isNull(ap_headers.approved,'X') = 'Y' and ap_items.purchase_order is not NULL
group by	ap_headers.Vendor,
			ap_items.item,
			isNull(part.name, ' ')
			
GO
