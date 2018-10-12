SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create	view [dbo].[vw_eei_AP_OutstandingAP]
as
Select	Vendor,
		inv_cm_flag,
		invoice_cm,
		inv_cm_date,
		received_date,
		exchanged_amount - exchanged_applied_amount as openAmount,
		ap_headers.terms,
		net_days,
		due_date as DueDate,
		Due_date
 from	ap_headers
join		terms on ap_headers.terms = terms.terms 
where	exchanged_amount - exchanged_applied_amount != 0  and
		fiscal_year >= 2008 and net_days>1 and
		pay_unit = '12'
GO
