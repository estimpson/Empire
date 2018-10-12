SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create	view [dbo].[vw_eei_AP_ProjectedPayablesBaseonOpenMonitorPOs]
as
Select	po_header.Vendor_code,
		'I' as InvorCM,
		'Projected' as InvoiceCM,
		po_detail.date_due as ExpectedReceiptDate,
		po_detail.date_due as ExpectedInvoiceDate,
		po_detail.Balance*material_cum as openAmount,
		terms.terms as Empowerterms,
		po_header.terms as POTerms,
		vendor.terms as VendorTerms,
		(CASE	WHEN net_days is NULL and po_header.terms like '%30%' then 30 
				WHEN net_days is NULL and po_header.terms like '%45%' then 45 
				WHEN net_days is NULL and po_header.terms like '%60%' then 60
				WHEN net_days is NULL and po_header.terms like '%COD%' then 0
				WHEN net_days is not NULL then net_days ELSE 60 END) as netDays,
		dateadd(dd,(CASE	WHEN net_days is NULL and po_header.terms like '%30%' then 30 
				WHEN net_days is NULL and po_header.terms like '%45%' then 45 
				WHEN net_days is NULL and po_header.terms like '%60%' then 60
				WHEN net_days is NULL and po_header.terms like '%COD%' then 0
				WHEN net_days is not NULL then net_days ELSE 60 END) , po_detail.date_due) as DueDate
 from	po_detail
join		part_standard on po_detail.part_number = part_standard.part
join		po_header on po_detail.po_number = po_header.po_number
join		vendor on po_header.vendor_code = vendor.code
left join		terms on po_header.terms = terms.terms 
where	po_detail.balance> 0  and
		po_detail.date_due > dateadd(dd,-30, getdate())



GO
