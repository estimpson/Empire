SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [EDIAutoSystems].[BlanketOrders]
AS
SELECT
	BlanketOrderNo = oh.order_no
,	ShipToCode = oh.destination
,	EDIShipToCode = es.parent_destination
,	ShipToConsignee = es.pool_code
,	SupplierCode = es.supplier_code
,	CustomerPart = oh.customer_part
,	CustomerPO = oh.customer_po
,	CheckCustomerPOPlanning = CONVERT(BIT, CASE COALESCE(check_po, 'N') WHEN 'Y' THEN 1 ELSE 0 END)
,	CheckCustomerPOShipSchedule = 0
,	ModelYear = oh.model_year
,	CheckModelYearPlanning = CONVERT(BIT, CASE COALESCE(check_model_year, 'N') WHEN 'Y' THEN 1 ELSE 0 END)
,	CheckModelYearShipSchedule = 0
,	PartCode = oh.blanket_part
,	OrderUnit = oh.shipping_unit
,	LastSID = oh.shipper
,	LastShipDT = s.date_shipped
,	LastShipQty = (SELECT MAX(qty_packed) FROM dbo.shipper_detail WHERE shipper = oh.shipper AND order_no = oh.order_no)
,	PackageType = oh.package_type
,	UnitWeight = pi.unit_weight
,	AccumShipped = oh.our_cum
,	ProcessReleases = CONVERT (BIT, CASE WHEN COALESCE(es.release_flag, 'P') = 'F' THEN 1 ELSE 1 END)
,	ActiveOrder = CONVERT(BIT, CASE WHEN COALESCE(oh.status,'') = 'A' THEN 1 ELSE 0 END )
FROM
	dbo.order_header oh
	JOIN dbo.edi_setups es
		ON es.destination = oh.destination
	JOIN dbo.part_inventory pi
		ON pi.part = oh.blanket_part
	LEFT JOIN dbo.shipper s
		ON s.id = oh.shipper
WHERE
	oh.order_type = 'B'
AND	trading_partner_code like '%AUTOSYSTEMS%'
AND	COALESCE(oh.status,'X') = 'A'
	





GO
