SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [EDIEDIFACT04A].[BlanketOrders]
AS
SELECT
	oh.model_year,
	BlanketOrderNo = oh.order_no
,	ShipToCode = oh.destination
,	EDIShipToCode = COALESCE(NULLIF(es.EDIShipToID,''), NULLIF(es.parent_destination,''), es.destination)
,	ShipToConsignee = es.pool_code
,	SupplierCode = es.supplier_code
,	CustomerPart = oh.customer_part
,	CustomerPO = oh.customer_po
,	CheckCustomerPOPlanning = CONVERT(BIT, CASE COALESCE(check_po, 'N') WHEN 'Y' THEN 1 ELSE 0 END)
,	CheckCustomerPOShipSchedule = COALESCE(CheckCustomerPOFirm, 0)
,	ModelYear862 = COALESCE(RIGHT(oh.model_year,1),'')
,	ModelYear830 = COALESCE(LEFT(oh.model_year,1),'')
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
,	ProcessReleases = COALESCE(es.ProcessEDI,0)
,	ActiveOrder = CONVERT(BIT, CASE WHEN COALESCE(order_status,'') = 'A' THEN 1 ELSE 0 END )
,	ModelYear = oh.model_year
,	PlanningFlag= COALESCE(es.PlanningReleasesFlag,'A')
,	TransitDays =  COALESCE(es.TransitDays,0)
,	ReleaseDueDTOffsetDays =	COALESCE(CASE	
								WHEN isNumeric(es.id_code_type) = 1
								THEN ( CASE WHEN es.id_code_type < 0 THEN es.id_code_type ELSE es.id_code_type*-1 END  ) 
								ELSE ( CASE WHEN es.EDIOffsetDays < 0 THEN es.id_code_type ELSE es.EDIOffsetDays*-1 END  )
								END, 0)
,	ReferenceAccum = COALESCE(ReferenceAccum,'O')
,	AdjustmentAccum = COALESCE(AdjustmentAccum,'C')
,	PlanningReleaseHorizonDaysBack = -1*(COALESCE(PlanningReleaseHorizonDaysBack,30))
,	ShipScheduleHorizonDaysBack = -1*(COALESCE(ShipScheduleHorizonDaysBack,30))
,	ShipDay = coalesce(ds.ship_day, 'Any Day')
FROM
	dbo.order_header oh
	JOIN dbo.edi_setups es
		ON es.destination = oh.destination
	LEFT JOIN
		destination_shipping ds on ds.destination = es.destination
	JOIN dbo.part_inventory pi
		ON pi.part = oh.blanket_part
	LEFT JOIN dbo.shipper s
		ON s.id = oh.shipper
WHERE
	oh.order_type = 'B' 
AND COALESCE(es.ProcessEDI,1) = 1
and coalesce(oh.status, '') = 'A' 
--	es.InboundProcessGroup in ( 'EDI2001' )















GO
