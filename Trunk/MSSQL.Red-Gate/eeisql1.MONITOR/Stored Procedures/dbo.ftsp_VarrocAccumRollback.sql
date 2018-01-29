SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[ftsp_VarrocAccumRollback]
AS
BEGIN
--BEGIN transaction
SELECT 
	ph.DocumentImportDT, 
	cpr.ShipToCode, 
	cpr.CustomerPart, 
	cpr.customerPO, 
	pa.LastQtyReceived AS LastRecQty, 
	pa.LastQtyDT AS LastQtyDate , 
	LastShipped.lASTDATEsHIPPED AS LstMonitorShipped,  
	LastShipped.Qty AS NewMonitorAccum, 
	oh.order_no AS MonitorOrderNo

	INTO #VarrocAccums
FROM 
	EDIVARROCic.CurrentPlanningReleases() cpr 
JOIN	
	 EDIVARROCic.PlanningHeaders ph ON ph.RawDocumentGUID= cpr.RawDocumentGUID AND CPR.ShipToCode IN (/* 'pp05a', */'0374D','0374E') --Commented  'pp05a' because already rilled back fro 2018 when proc was called for 0374D/E
LEFT JOIN
	EDIVARROCic.PlanningAccums pa ON pa.RawDocumentGUID = cpr.RawDocumentGUID AND
    pa.CustomerPart = cpr.CustomerPart AND
    pa.CustomerPO = cpr.CustomerPO AND
	pa.ShipToCode = cpr.ShipToCode
JOIN
	edi_setups es ON es.parent_destination =  cpr.ShipToCode
JOIN
	dbo.order_header oh ON	es.destination = oh.destination AND
	oh.customer_po = cpr.CustomerPO AND
    oh.customer_part = cpr.CustomerPart
OUTER APPLY
	( SELECT ISNULL(SUM(sd.qty_packed),0) AS Qty, MAX(S.DATE_SHIPPED) AS lASTDATEsHIPPED
			FROM shipper s
			JOIN edi_setups es ON es.destination = s.destination
			JOIN	shipper_detail sd ON sd.shipper = s.id
			WHERE   sd.customer_part = cpr.CustomerPart AND
							es.parent_destination = cpr.ShipToCode AND
							sd.customer_po = cpr.CustomerPO AND
							s.date_shipped>ph.DocumentImportDT ) LastShipped

--following commented select statement used for data verification only
--	SELECT DISTINCT
--	TMP_OUT.CustomerPart,
--	TMP_OUT.CustomerPO,
--	TMP_OUT.ShipToCode,
--	TMP_OUT.LastQtyDate,
--	TMP_OUT.LastRecQty,
--	TMP_OUT.LstMonitorShipped AS lastshippedDate,
--	TMP_OUT.NewMonitorAccum,
--	STUFF(
--			(	
--				SELECT ',' + CONVERT(VARCHAR(15), TMP_IN.MonitorOrderNo) --Replace with delimiter
--				FROM #VarrocAccums TMP_IN
--				WHERE TMP_IN.CustomerPart = TMP_OUT.customerPart AND
--								TMP_IN.CustomerPO = TMP_OUT.customerPO AND
--                                TMP_IN.ShipToCode = TMP_OUT.shipToCode
--				FOR XML PATH ('')
--			)
--				,1,1,'') AS MonitorOrdersToBeupdated
--FROM #VarrocAccums TMP_OUT


SELECT MAX(shipper) LastShipper, order_no, GETDATE() AS DateTimeDT, MAX(NewMonitorAccum) AS Accum, 'ROLLBK '+ CONVERT(VARCHAR(25), order_no ) + '-' +  CONVERT (VARCHAR(25), GETDATE(),104) AS Accumpart , ' AccumRollback  - Performed by SQL job (VarrocAccumRollback) calling ftsp_VarrocAccumRollback)' AS Notes
INTO  #ShipperAccums
 FROM 
Shipper JOIN
shipper_detail ON shipper_detail.shipper =  shipper.id
JOIN
	#VarrocAccums va ON va.MonitorOrderNo = shipper_detail.order_no

 WHERE part NOT LIKE '%CUM%' 
 GROUP BY order_no


 
INSERT shipper_detail
( Shipper, order_no, date_shipped, accum_shipped, part, note )

 SELECT * FROM #shipperAccums

 UPDATE oh 
 SET oh.our_cum = va.NewMonitorAccum 
 FROM order_header oh
 JOIN #VarrocAccums va ON va.MonitorOrderNo = oh.order_no
 

 UPDATE order_detail
 SET 
  our_cum = COALESCE(( SELECT SUM(quantity) FROM order_detail od2 WHERE od2.order_no =  order_detail.order_no AND od2.sequence < order_detail.sequence ),0)+ISNULL(VarrocAccums.NewMonitorAccum,0),
 the_cum = COALESCE(( SELECT SUM(quantity) FROM order_detail od2 WHERE od2.order_no =  order_detail.order_no AND od2.sequence <= order_detail.sequence ),0)+ISNULL(VarrocAccums.NewMonitorAccum,0)
  FROM order_detail
  OUTER APPLY ( SELECT * FROM #VarrocAccums WHERE MonitorOrderNo = order_detail.order_no) AS VarrocAccums
  WHERE order_detail.order_no IN ( SELECT MonitorOrderNo FROM #VarrocAccums )



	--ROLLBACK
			


			END
GO
