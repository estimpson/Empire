SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create	view [dbo].[vw_eei_AP_ProjectedPayablesBaseonOpenEmpowerPOs]
as
Select po_header.buy_vendor,
		'I' as InvorCM,
		'Projected' as InvoiceCM,
		po_detail.required_date as ExpectedReceiptDate,
		po_detail.required_date as ExpectedInvoiceDate,
		extended_amount-invoiced_amount as openAmount,
		po_header.terms as POTerms,
(CASE	WHEN net_days is NULL and po_header.terms like '%30%' then 30 
				WHEN net_days is NULL and po_header.terms like '%45%' then 45 
				WHEN net_days is NULL and po_header.terms like '%60%' then 60
				WHEN net_days is NULL and po_header.terms like '%COD%' then 0
				WHEN net_days is not NULL then net_days ELSE 60 END) as netDays,
		dateadd(dd,(CASE	WHEN net_days is NULL and po_header.terms like '%30%' then 30 
				WHEN net_days is NULL and po_header.terms like '%45%' then 45 
				WHEN net_days is NULL and po_header.terms like '%60%' then 60
				WHEN net_days is NULL and po_header.terms like '%COD%' then 0
				WHEN net_days is not NULL then net_days ELSE 60 END) , po_detail.required_date) as DueDate 
		from po_headers po_header
			left join		terms on po_header.terms = terms.terms 
			join po_items po_detail on po_header.purchase_order = po_detail.purchase_order where  po_date > dateadd(dd, -120, getdate()) and po_header.status = 'O'  and extended_amount > 0 and (invoiced_amount - extended_amount ) < 0 and pay_unit = '12'
GO
