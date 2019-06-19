
/*
Create View.EEH.SupplierEDI.PurchaseOrders.sql
*/

use EEH
go

--drop table SupplierEDI.PurchaseOrders
if	objectproperty(object_id('SupplierEDI.PurchaseOrders'), 'IsView') = 1 begin
	drop view SupplierEDI.PurchaseOrders
end
go

create view SupplierEDI.PurchaseOrders
with encryption
as
select
	PurchaseOrderNumber = ph.po_number
,	EmpireVendorCode = ph.vendor_code
,	EmpireBlanketPart = ph.blanket_part
,	ReleaseCount =
		(	select
				count(*)
			from
				dbo.po_detail pd
			where
				pd.po_number = ph.po_number
				and pd.balance > 0
		)
,	TradingPartnerCode = ev.trading_partner_code
,	tpog.OverlayGroup
,	xrpdrf.FunctionName
,	TodaySendFlag =
		case when ev.send_days like '%' + td.TodaySendDay + '%' then 1 else 0 end
,	AutoSendFlag =
		case when ev.auto_create_po = 'Y' then 1 else 0 end
,	RowID =
		row_number() over (order by ev.trading_partner_code, ph.vendor_code, ph.po_number)
from
	dbo.po_header ph
	join dbo.edi_vendor ev
		join SupplierEDI.TradingPartnerOverlayGroups tpog
			left join SupplierEDI.XML_ReleasePlanDataRootFunctions xrpdrf
				on xrpdrf.OverlayGroup = tpog.OverlayGroup
			on tpog.TradingPartnerCode = ev.trading_partner_code
		on ev.vendor = ph.vendor_code
	join dbo.EDI_PO ep
		on ep.po_number = ph.po_number
	cross apply
		(	select
				TodaySendDay = substring('NMTWHFS', datepart(weekday, getdate()), 1)
		) td
where
	ph.release_control in
			(	'L'
			,	'A'
			)
	and ph.status != 'C'
	and ph.type = 'B'
go

select
	po.PurchaseOrderNumber
,	po.EmpireVendorCode
,	po.EmpireBlanketPart
,	po.ReleaseCount
,	po.TradingPartnerCode
,	po.OverlayGroup
,	po.FunctionName
,	po.TodaySendFlag
,	po.AutoSendFlag
,	po.RowID
from
	SupplierEDI.PurchaseOrders po
order by
	po.RowID