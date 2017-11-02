SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE view [NALEDI].[BlanketOrders]
as
select
	BlanketOrderNo = oh.order_no
,	TP = trading_partner_code
,	ShipToCode = oh.destination
,   InternalShipTo = oh.destination
,	EDIShipToCode = es.parent_destination
,	ShipToConsignee = es.pool_code
,	SupplierCode = es.supplier_code
,	CustomerPart = oh.customer_part
,	CustomerPO = oh.customer_po
,	CheckCustomerPO = convert(bit, case coalesce(check_po, 'N') when 'Y' then 1 else 0 end)
,	ModelYear = oh.model_year
,	CheckModelYear = convert(bit, case coalesce(check_model_year, 'N') when 'Y' then 1 else 0 end)
,	PartCode = oh.blanket_part
,	OrderUnit = oh.shipping_unit
,	LastSID = oh.shipper
,	LastShipDT = s.date_shipped
,	LastShipQty = (select max(qty_packed) from dbo.shipper_detail where shipper = oh.shipper and order_no = oh.order_no)
,	PackageType = oh.package_type
,	UnitWeight = pi.unit_weight
,	AccumShipped = oh.our_cum
,	ProcessReleases = 1
,	TransitDays = coalesce(es.id_code_type,0)
,   OverrideTransitDays = coalesce(nullif(raw_cum,0), es.id_code_type, 0 )
,	ShipDay = coalesce(ds.ship_day, 'Any Day')
,	StdPack = coalesce(nullif(oh.standard_pack,0),-1.333333)
from
	dbo.order_header oh
	join dbo.edi_setups es
		on es.destination = oh.destination
	left join dbo.destination_shipping ds
		on es.destination = ds.destination
	join dbo.part_inventory pi
		on pi.part = oh.blanket_part
	left join dbo.shipper s
		on s.id = oh.shipper

where
	oh.order_type = 'B' and
	oh.blanket_part like '%NAL%' and
	Coalesce(oh.status,'C') = 'A'




GO