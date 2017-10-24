SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[eei_vw_projectedreceipts4weeks_MON]
AS
SELECT		'MON' as POtype,
					po_detail.vendor_code,
					po_header.terms as systemterms,
					venderterms.terms as kensterms,
					(CASE WHEN venderterms.terms like '%40%' then 40 when venderterms.terms like '%60%' then 60  when venderterms.terms like '%30%' then 30 when venderterms.terms like '%45%' then 45 when venderterms.terms like '%COD%' then 1 WHEN venderterms.terms like '%15%' then 15 WHEN venderterms.terms like '%1' then 1 else 30 end) as netdays,
					po_detail.part_number,
					po_detail.date_due as ActualDueDate,
					dateadd(dd, (datepart(dw, (case when po_detail.date_due< getdate() and po_detail.date_due> dateadd(wk,-2,getdate())  THEN getdate()  WHEN po_detail.date_due<= dateadd(wk,-2,getdate()) THEN dateadd(wk,-2,getdate()) ELSE po_detail.date_due end))-2)*(-1), (case when po_detail.date_due< getdate() and po_detail.date_due> dateadd(wk,-2,getdate())  THEN getdate()  WHEN po_detail.date_due<= dateadd(wk,-2,getdate()) THEN dateadd(wk,-2,getdate()) ELSE po_detail.date_due end)) as POMondayDuedate,
					(CASE WHEN venderterms.terms like '%30%' then 30 when venderterms.terms like '%45%' then 45 when venderterms.terms like '%COD%' then 0 WHEN venderterms.terms like '%15%' then 15 WHEN venderterms.terms like '%1' then 1 else 30 end)/7 as dueweeks,
					dateadd(wk,(CASE  WHEN venderterms.terms like '%40%' then 40 when venderterms.terms like '%60%' then 60 WHEN venderterms.terms like '%30%' then 30 when venderterms.terms like '%45%' then 45 when venderterms.terms like '%COD%' then 0 WHEN venderterms.terms like '%15%' then 15 WHEN venderterms.terms like '%1' then 1 else 30 end)/7, dateadd(dd, (datepart(dw, (case when po_detail.date_due< getdate() and po_detail.date_due> dateadd(wk,-2,getdate())  THEN getdate()  WHEN po_detail.date_due<= dateadd(wk,-2,getdate()) THEN dateadd(wk,-2,getdate()) ELSE po_detail.date_due end))-2)*(-1), (case when po_detail.date_due< getdate() and po_detail.date_due> dateadd(wk,-2,getdate())  THEN getdate()  WHEN po_detail.date_due<= dateadd(wk,-2,getdate()) THEN dateadd(wk,-2,getdate()) ELSE po_detail.date_due end))) as InvoiceMondayDuedate,
					po_detail.balance,
					po_detail.balance*alternate_price as extended,
					ceiling(isNULL((select max(FABAuthDays) from part_vendor where vendor=po_header.vendor_code and part = po_detail.part_number),28)/7) as FirmWeeks,
					convert(varchar(25), po_detail.po_number) as PONumber
					
					
					
				
					
FROM			po_detail
INNER JOIN	po_header ON po_detail.po_number = po_header.po_number
INNER JOIN	venderterms ON po_header.vendor_code = venderterms.vendor
WHERE			po_detail.balance>0 and
					po_detail.vendor_code <> 'EEI'


--UNION
--
--SELECT		'EMP' as POtype,
--					po_headers.buy_vendor,
--					po_headers.terms,
--					(CASE WHEN po_headers.terms like '%10%' then 10 when po_headers.terms like '%25%' then 25 when po_headers.terms like '%60%' then 60 when po_headers.terms like '%30%' then 30 when po_headers.terms like '%45%' then 45 when po_headers.terms like '%COD%' then 0 WHEN po_headers.terms like '%15%' then 15 WHEN po_headers.terms like '%1' then 1 else 30 end) as netdays,
--					po_items.item,
--					 po_items.required_date as ActualDueDate,
--					dateadd(dd, (datepart(dw, (case when po_items.required_date<getdate() and po_items.required_date > dateadd(wk,-2,getdate()) THEN getdate() WHEN po_items.required_date<= dateadd(wk,-2,getdate()) THEN dateadd(wk,-2,getdate())ELSE po_items.required_date END))-2)*(-1), (case when po_items.required_date<getdate() and po_items.required_date > dateadd(wk,-2,getdate()) THEN getdate() WHEN po_items.required_date<= dateadd(wk,-2,getdate()) THEN dateadd(wk,-2,getdate())ELSE po_items.required_date END)) as POMondayDuedate,
--					(CASE WHEN po_headers.terms like '%10%' then 10 when po_headers.terms like '%25%' then 25 when po_headers.terms like '%60%' then 60 when po_headers.terms like '%30%' then 30 when po_headers.terms like '%45%' then 45 when po_headers.terms like '%COD%' then 0 WHEN po_headers.terms like '%15%' then 15 WHEN po_headers.terms like '%1' then 1 else 30 end)/7 as dueweeks,
--					dateadd(wk,(CASE WHEN po_headers.terms like '%10%' then 10 when po_headers.terms like '%25%' then 25 when po_headers.terms like '%60%' then 60 when po_headers.terms like '%30%' then 30 when po_headers.terms like '%45%' then 45 when po_headers.terms like '%COD%' then 0 WHEN po_headers.terms like '%15%' then 15 WHEN po_headers.terms like '%1' then 1 else 30 end)/7,dateadd(dd, (datepart(dw, (case when po_items.required_date<getdate() and po_items.required_date > dateadd(wk,-2,getdate()) THEN getdate() WHEN po_items.required_date<= dateadd(wk,-2,getdate()) THEN dateadd(wk,-2,getdate())ELSE po_items.required_date END))-2)*(-1), (case when po_items.required_date<getdate() and po_items.required_date > dateadd(wk,-2,getdate()) THEN getdate() WHEN po_items.required_date<= dateadd(wk,-2,getdate()) THEN dateadd(wk,-2,getdate())ELSE po_items.required_date END))  ) as InvoiceMondayDuedate,
--					(quantity_ordered-quantity_cancelled)-quantity_received as balance,
--					((quantity_ordered-quantity_cancelled)-quantity_received)*price as extended,
--					4 as FirmWeeks
--
--					
--					
--					
--				
--					
--FROM			po_items
--INNER JOIN	po_headers ON po_items.purchase_order = po_headers.purchase_order
--WHERE			po_headers.po_type='EMPOWER' and
--					(isNULL(quantity_ordered,0)-isNULL(quantity_cancelled,0))-isNULL(quantity_received,0) > 0 and
--					po_headers.fiscal_year>2005 and isNULL(po_items.status,'X') <> 'C' and item <> 'ORDER CHANGE' and po_items.required_date is not null
GO
