
/*
Create View.EEH.EDI_XML.PurchaseOrderInfo.sql
*/

use EEH
go

--drop table EDI_XML.PurchaseOrderInfo
if	objectproperty(object_id('EDI_XML.PurchaseOrderInfo'), 'IsView') = 1 begin
	drop view EDI_XML.PurchaseOrderInfo
end
go

create view EDI_XML.PurchaseOrderInfo
with encryption
as
select
	po.TradingPartnerCode
,	po.EmpireVendorCode
,	po.PurchaseOrderNumber
,	ReleaseNumber = po.EmpireVendorCode + '-' + convert(varchar(6), getdate(), 12)
,	po.EmpireBlanketPart
,	VendorPart = coalesce(pv.vendor_part, po.EmpireBlanketPart)
,	PartDescription = left(SupplierEDI.udf_CleanString(p.name), 78)
,	Unit = pInv.standard_unit
,	Price =
		case
			when ew.Price < 0 then '('
			else ''
		end
		+ convert (varchar(4), floor(abs(ew.Price)))
		+ substring(convert(varchar(10), round(convert(numeric(20,7), abs(ew.Price) - floor(abs(ew.Price))), 4) + 0.0000001), 2, 5)
		+ case
			when ew.Price < 0 then ')'
			else ''
		end
,	AccumReceived = coalesce(prt.StdQty + prt.AccumAdjust, 0)
,	AccumStartDT = dg.Value
,	AccumEndDT = getdate()
,	RawAccum =
		case
			when coalesce(vhpe.HighRawQty, 0) < vhpe.HighFabQty and vhpe.HighFabQty < 0 then 0
			when coalesce(vhpe.HighRawQty, 0) < vhpe.HighFabQty then vhpe.HighFabQty
			else coalesce(vhpe.HighRawQty, 0)
		end
,	RawEndDT = vphe.RawDate
,	FabAccum = coalesce(vhpe.HighFabQty, 0)
,	FabEndDT = vphe.FabDate
,	lr.LastReceivedQty
,	lr.LastReceivedDT
,	lr.LastShipperID
from
	SupplierEDI.PurchaseOrders po
	join dbo.edi_vendor ev
		on ev.vendor = po.EmpireVendorCode
	left join dbo.edi_setups es
		on es.destination = po.EmpireVendorCode
	join dbo.part p
		on p.part = po.EmpireBlanketPart
	join dbo.part_inventory pInv
		on pInv.part = po.EmpireBlanketPart
	left join dbo.part_vendor pv
		on pv.vendor = po.EmpireVendorCode
		and pv.part = po.EmpireBlanketPart
	left join FT.POReceiptTotals prt
		on prt.PONumber = po.PurchaseOrderNumber
		and prt.Part = po.EmpireBlanketPart
	left join FT.vwPOHeaderEDI vphe
		on vphe.PONumber = po.PurchaseOrderNumber
		and vphe.Part = po.EmpireBlanketPart
	cross apply
		(	select
				Price = coalesce
					(	(	select top (1)
					 			pd.alternate_price
					 		from
					 			dbo.po_detail pd
							where
								pd.po_number = po.PurchaseOrderNumber
							order by
								pd.date_due
					 	)
					,	(	select top (1)
					 			pvpm.alternate_price
					 		from
					 			dbo.part_vendor_price_matrix pvpm
							where
								pvpm.vendor = po.EmpireVendorCode
								and pvpm.part = po.EmpireBlanketPart
							order by
								pvpm.break_qty
					 	)
					)
		) ew
	outer apply
		(	select top (1)
				vphe.HighRawQty
			,	vphe.HighFabQty
			from
				FT.vwPOHeaderEDI vphe
			where
				vphe.PONumber = po.PurchaseOrderNumber
				and vphe.Part = po.EmpireBlanketPart
			order by
				vphe.Part
		) vhpe
	cross apply
		(	select
				*
			from
				FT.DTGlobals dg
			where
				dg.Name = 'BaseWeek'
		) dg
	outer apply
		(	select
				LastReceivedQty = sum(at.quantity)
			,	LastReceivedDT = max(at.date_stamp)
			,	LastShipperID = max(at.shipper)
			from
				dbo.audit_trail at
			where
				at.part = po.EmpireBlanketPart
				and at.po_number = convert(varchar(30), po.PurchaseOrderNumber)
				and at.type = 'R'
				and at.shipper =
					(	select top(1)
							at.shipper
						from
							dbo.audit_trail at
						where
							at.part = po.EmpireBlanketPart
							and at.po_number = convert(varchar(30), po.PurchaseOrderNumber)
							and at.type = 'R'
						order by
							at.date_stamp desc
					)
		) lr
go

select
	*
from
	EDI_XML.PurchaseOrderInfo poi
where
	poi.TradingPartnerCode = 'PSG'