SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [EDINAL].[BlanketOrders]
AS

-- 2017/01/25 asb FT, LLC : Modified ReleaseDueDTOffsetDays use id_code_type from edi-setups if it is numeric.
--2018/09/21/2018 asb FT, LLC : Modified
SELECT
	oh.model_year,
	BlanketOrderNo = oh.order_no
,	ShipToCode = oh.destination
,	EDIShipToCode = COALESCE(NULLIF(es.EDIShipToID,''), NULLIF(es.parent_destination,''), es.destination)
,	ShipToConsignee = es.pool_code
,	SupplierCode = es.supplier_code
,	CustomerPart = oh.customer_part
,	CustomerPO = oh.customer_po
,	CheckCustomerPOPlanning = CONVERT(BIT, CASE COALESCE(check_po, 'N') WHEN 'Y' THEN 1 ELSE 1 END)  --always appropriate to check customer po  so setting to 1 always asb 09/21/2018
,	CheckCustomerPOShipSchedule = COALESCE(CheckCustomerPOFirm, 1)  --always appropriate to check customer po  so setting to 1 always asb 09/21/2018
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
,	ReleaseDueDTOffsetDays =	CASE WHEN ( es.id_code_type IS NULL OR ISNUMERIC(es.id_code_type) != 1 ) THEN 
											(CASE WHEN COALESCE(es.EDIOffsetDays,0) > 0  THEN -1*COALESCE(es.EDIOffsetDays,0)   WHEN COALESCE(es.EDIOffsetDays,0) < 0 THEN COALESCE(es.EDIOffsetDays,0) ELSE 0 END)
									 WHEN ( ISNUMERIC(es.id_code_type) = 1 ) THEN 
											(CASE WHEN COALESCE(es.id_code_type,0) > 0  THEN -1*COALESCE(es.id_code_type,0)   WHEN COALESCE(es.id_code_type,0) < 0 THEN COALESCE(es.id_code_type,0) ELSE 0 END)
									ELSE 0
									END
											
,	ReferenceAccum = COALESCE(ReferenceAccum,'O')
,	AdjustmentAccum = COALESCE(AdjustmentAccum,'C')
,	PlanningReleaseHorizonDaysBack = -1*(COALESCE(PlanningReleaseHorizonDaysBack,30))
,	ShipScheduleHorizonDaysBack = -1*(COALESCE(ShipScheduleHorizonDaysBack,30))
,	ProcessPlanningRelease = COALESCE(es.ProcessPlanningRelease,1)
,	ProcessShipSchedule = COALESCE(es.ProcessShipSchedule,1)
,	UseLastaccum =  COALESCE( (CASE WHEN iConnectID = '14282' THEN 1 ELSE 0 END ), 0 )
,	Scheduler =  d.scheduler
FROM
	dbo.order_header oh
	JOIN dbo.edi_setups es
		ON es.destination = oh.destination
	JOIN	dbo.destination d 
		ON d.destination = es.destination		
	JOIN dbo.part_inventory pi
		ON pi.part = oh.blanket_part
	LEFT JOIN dbo.shipper s
		ON s.id = oh.shipper
WHERE
	oh.order_type = 'B' 
 AND COALESCE(ProcessEDI,1) = 1
 AND COALESCE(oh.status,'') = 'A'
 AND es.destination NOT IN ( 'IISTANLEY','SUS', 'SUSJAPAN')--turn of Stanley until Joanie and Andre discuss gameplan
--	es.InboundProcessGroup in ( 'EDI2001' )


















GO
