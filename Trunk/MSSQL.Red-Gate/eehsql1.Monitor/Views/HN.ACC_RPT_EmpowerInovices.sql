SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [HN].[ACC_RPT_EmpowerInovices] AS
SELECT	ap_headers.vendor, ap_headers.invoice_cm, ap_headers.inv_cm_date, 
		ap_headers.inv_cm_amount, ap_headers.fiscal_year, ap_headers.period, 
		ap_headers.pay_vendor_name, ap_headers.buy_unit, SubTotal
FROM	ap_headers
		left join (	select	vendor, inv_cm_flag, invoice_cm, SubTotal = sum( extended_amount)
					from	ap_items
					where	bill_of_lading is not null
					group by vendor, inv_cm_flag, invoice_cm ) CalculateSubTotals on 
			CalculateSubTotals.inv_cm_flag = ap_headers.inv_cm_flag and 
			CalculateSubTotals.invoice_cm = ap_headers.invoice_cm and 
			CalculateSubTotals.vendor = ap_headers.vendor
GO
