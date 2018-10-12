SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [eeiuser].[acctg_rgni_daily]
			(
			@report_date datetime
			)

as


SELECT a.changed_date, CONVERT(varchar(25), po_header.po_number)po_no, po_header.vendor_code,
a.receiver, 
a.item, a.quantity_received, a.unit_cost,
a.total_cost,
a.bill_of_lading

FROM [HISTORICALDATA].dbo.po_receiver_items_historical_daily a,
vendor,
po_header

WHERE ft.fn_truncdate('dd',a.time_stamp) = @report_date
and (a.purchase_order = CONVERT(varchar(25),po_header.po_number))
and (vendor.code = po_header.vendor_code)
-- and ((vendor.outside_processor is null) or (vendor.outside_processor = '')) 
and (vendor.code <> 'EEH' and
a.invoice = '')



GO
