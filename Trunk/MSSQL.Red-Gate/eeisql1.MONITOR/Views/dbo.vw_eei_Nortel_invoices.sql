SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[vw_eei_Nortel_invoices]
as
select	ap_headers.vendor, ap_headers.invoice_cm , ap_items.extended_amount, item_description, ap_headers.gl_date, pay_unit
from		ap_items, 
		ap_headers 
where	ap_headers.vendor = 'SUNTEL' and ap_items.invoice_cm = ap_headers.invoice_cm and ap_headers.gl_date>='2006-01-01' and Item_description not like '%State of Michigan%'
GO
