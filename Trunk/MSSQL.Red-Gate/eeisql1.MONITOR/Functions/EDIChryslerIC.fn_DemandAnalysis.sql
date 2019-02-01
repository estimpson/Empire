SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [EDIChryslerIC].[fn_DemandAnalysis] ( )

--Select * From EDIChryslerIC.[fn_DemandAnalysis] ( )
RETURNS @Scheds TABLE
		 ( 
		TradingPartner VARCHAR(50),
		LastSchedDT DATETIME ,
		SchedType VARCHAR(10),
		ReleaseImportDT DATETIME,
		ReleaseNo VARCHAR(50),
		ShipToCode VARCHAR(50),
		Destination VARCHAR(50),
		Scheduler VARCHAR(50),
		SchedulerEmailAddress VARCHAR(255),
		CustomerPart VARCHAR(50),
		CustomerPO VARCHAR(50),
		ShpDT DATETIME,
		CusQty INT,
		lstAccumCust INT,
		lstQtyCust INT,
		lstShipIDCust VARCHAR(50),
		Last3Shipments VARCHAR(255))
AS
BEGIN


DECLARE @LastSchedules TABLE
(  SchedType VARCHAR(10),
	TradingPartner VARCHAR(50),
	RawDocGUID UNIQUEIDENTIFIER,
	ReleaseNo VARCHAR(50),
	ShipToCode VARCHAR(50),
	CustomerPart VARCHAR(50),
	CustomerPO VARCHAR(50),
	SchedImportDT DATETIME 
	)

	INSERT @LastSchedules
	        ( SchedType ,
	          TradingPartner ,
	          RawDocGUID ,
	          ReleaseNo ,
	          ShipToCode ,
	          CustomerPart ,
	          CustomerPO ,
	          SchedImportDT
	        )
	


SELECT 'SS', ssh.TradingPartner, css.RawDocumentGUID, css.ReleaseNo, css.ShipToCode, css.CustomerPart, css.CustomerPO, ssh.RowCreateDT
 FROM 
	EDIChryslerIC.CurrentShipSchedules() css
JOIN
	EDIChryslerIC.ShipScheduleHeaders ssh ON ssh.RawDocumentGUID = css.RawDocumentGUID


	UNION

SELECT 'PR', ph.TradingPartner, cpr.RawDocumentGUID, cpr.ReleaseNo, cpr.ShipToCode, cpr.CustomerPart, cpr.CustomerPO, ph.RowCreateDT
 FROM 
	EDIChryslerIC.CurrentPlanningReleases() cpr
JOIN
	EDIChryslerIC.PlanningHeaders ph ON ph.RawDocumentGUID = cpr.RawDocumentGUID
	ORDER BY 6


	
	DECLARE @lastSchedByTPSchedType TABLE
		(	 SchedType VARCHAR(10),
			TradingPartner VARCHAR(50),
			SchedImportDT DATETIME 
		)

	INSERT @lastSchedByTPSchedType

	(		SchedType ,
			TradingPartner ,
			SchedImportDT
	)

	SELECT 
			SchedType ,
			TradingPartner ,
			max(SchedImportDT)
	FROM
		@LastSchedules
	GROUP BY
			SchedType ,
			TradingPartner 
			

	--SELECT * FROM @lastSchedByTPSchedType
	
	DECLARE @Schedules TABLE
		 ( 
		TradingPartner VARCHAR(50),
		LastSchedDT DATETIME ,
		SchedType VARCHAR(10),
		ReleaseImportDT DATETIME,
		ReleaseNo VARCHAR(50),
		ShipToCode VARCHAR(50),
		Destination VARCHAR(50),
		CustomerPart VARCHAR(50),
		CustomerPO VARCHAR(50),
		ReleaseDT DATETIME,
		ReleaseQty INT,
		CustomerAccum INT,
		LastQtyReceived INT,
		Lastshipper VARCHAR(50)

		)

	INSERT @Schedules
	        ( TradingPartner ,
	          LastSchedDT ,
	          SchedType ,
	          ReleaseImportDT ,
	          ReleaseNo ,
	          ShipToCode ,
			  Destination,
	          CustomerPart ,
	          CustomerPO ,
	          ReleaseDT ,
	          ReleaseQty ,
	          CustomerAccum ,
	          LastQtyReceived ,
	          Lastshipper
	        )

		
	
	SELECT 
				lst.TradingPartner,
				lst.SchedImportDT AS LastSchedReceivedDT,
				ls.SchedType ,
				pr.RowCreateDT AS ScheduleDate,
				 pr.ReleaseNo,
				 pr.ShipToCode,
				  [FT].[fn_ReturnDestination] ( pr.ShipToCode),
				 pr.CustomerPart,
				 pr.CustomerPO,
				  pr.ReleaseDT,
				 pr.ReleaseQty,
				 pa.LastAccumQty AS LastCustomerAccum,
				 pa.LastQtyReceived AS LastQtyReceived,
				 pa.LastShipper AS LastShipperReceived
				
		FROM @LastSchedules ls
		JOIN
			@lastSchedByTPSchedType lst ON
            lst.TradingPartner = ls.TradingPartner AND 
			lst.SchedType = ls.SchedType
			JOIN
			EDIChryslerIC.PlanningReleases pr ON pr.RawDocumentGUID = ls.RawDocGUID 
			AND pr.CustomerPart = ls.CustomerPart AND
					pr.CustomerPO = ls.CustomerPO AND
                    pr.ShipToCode = ls.ShipToCode
			LEFT JOIN
			EDIChryslerIC.PlanningAccums pa ON pa.RawDocumentGUID = ls.RawDocGUID 
			AND pa.CustomerPart = ls.CustomerPart AND
					pa.CustomerPO = ls.CustomerPO AND
                    pa.ShipToCode = ls.ShipToCode
			
		WHERE
			ls.SchedImportDT<lst.SchedImportDT
			AND pr.ReleaseQty >0 
				UNION
				
				SELECT 
				lst.TradingPartner,
				lst.SchedImportDT AS LastSchedReceivedDT,
				ls.SchedType ,
				ss.RowCreateDT AS ScheduleDate,
				 ss.ReleaseNo,
				 ss.ShipToCode,
				  [FT].[fn_ReturnDestination] ( ss.ShipToCode),
				 ss.CustomerPart,
				 ss.CustomerPO,
				  ss.ReleaseDT,
				 ss.ReleaseQty,
				 ssa.LastAccumQty AS LastCustomerAccum,
				 ssa.LastQtyReceived AS LastQtyReceived,
				 ssa.LastShipper AS LastShipperReceived
				
		FROM @LastSchedules ls
		JOIN
			@lastSchedByTPSchedType lst ON
            lst.TradingPartner = ls.TradingPartner AND 
			lst.SchedType = ls.SchedType
			JOIN
			EDIChryslerIC.ShipSchedules ss ON ss.RawDocumentGUID = ls.RawDocGUID 
			AND ss.CustomerPart = ls.CustomerPart AND
					ss.CustomerPO = ls.CustomerPO AND
                    ss.ShipToCode = ls.ShipToCode
			LEFT JOIN
			EDIChryslerIC.ShipScheduleAccums ssa ON ssa.RawDocumentGUID = ls.RawDocGUID 
			AND ssa.CustomerPart = ls.CustomerPart AND
					ssa.CustomerPO = ls.CustomerPO AND
                    ssa.ShipToCode = ls.ShipToCode
				
		WHERE
			ls.SchedImportDT<lst.SchedImportDT
			AND ss.ReleaseQty > 0
	ORDER BY 1,3,7,6,13

	DECLARE @PriorShipments TABLE
		(	DateShipped DATETIME,
			Destination VARCHAR(25),
			EDIShipToID VARCHAR(50),
			CustomerPart VARCHAR(50),
			CustomerPO VARCHAR(50),
			ShippedQty INT,
			AccumShipped INT,
			ShipmentText VARCHAR(255)
	)

	INSERT @PriorShipments
	        ( DateShipped ,
	          Destination ,
	          EDIShipToID ,
	          CustomerPart ,
	          CustomerPO ,
	          ShippedQty ,
	          AccumShipped,
			  ShipmentText
	        )


	SELECT
			  DateShipped = s.date_shipped,
	          Destination = s.destination ,
	          EDIShipToID =  COALESCE(NULLIF(es.EDIShipToID,''), NULLIF(es.parent_destination,''), ''),
	          CustomerPart = sd.customer_part,
	          CustomerPO =  sd.customer_po ,
	          ShippedQty = sd.qty_packed ,
	          AccumShipped = sd.accum_shipped,
			  ShipmentText ='[ ' + 'Shipper: ' + CONVERT(VARCHAR(12), s.id )+ '   Date Shp : ' + CONVERT(VARCHAR(12), s.date_shipped, 112) + '  Qty Shp : ' + CONVERT(varchar(12), CONVERT(INT, sd.qty_packed)) + '   Accum Shp :  ' + CONVERT(varchar(12), CONVERT (INT,sd.accum_shipped)) + ' ]'
		FROM
			shipper s
		JOIN
			edi_setups es ON es.destination = s.destination
		JOIN
			shipper_detail sd ON sd.shipper = s.id AND s.date_shipped> GETDATE()-365
		WHERE EXISTS (
			SELECT 1 FROM  
					@Schedules sch 
					WHERE 
						sch.CustomerPart = sd.customer_part
						AND sch.CustomerPO = sd.customer_po
						AND sch.Destination =  s.destination 
						)
INSERT @Scheds
        ( TradingPartner ,
          LastSchedDT ,
          SchedType ,
          ReleaseImportDT ,
          ReleaseNo ,
          ShipToCode ,
          Destination ,
		  Scheduler,
		  SchedulerEmailAddress,
          CustomerPart ,
          CustomerPO ,
          ShpDT ,
          CusQty ,
          lstAccumCust ,
          lstQtyCust ,
          lstShipIDCust ,
          Last3Shipments
        )

			SELECT 
				 scheds.TradingPartner ,
                   scheds.LastSchedDT ,
                   scheds.SchedType ,
                   scheds.ReleaseImportDT ,
                   scheds.ReleaseNo ,
                   scheds.ShipToCode ,
                   scheds.Destination ,
				   d.scheduler,
				   [FT].[fn_ReturnSchedulerEMailAddress] (d.scheduler),
                   scheds.CustomerPart ,
                   scheds.CustomerPO ,
                   scheds.ReleaseDT ShpDT ,
                   scheds.ReleaseQty CustQty ,
                   scheds.CustomerAccum lstAccumCust ,
                   scheds.LastQtyReceived AS LstQtyCust ,
                   scheds.Lastshipper AS LstShipIDCust ,
					ISNULL(		STUFF(
			(	
				SELECT TOP 3 ',' + CONVERT(VARCHAR(255), PriorShip.ShipmentText) --Replace with delimiter
				FROM @PriorShipments PriorShip
				WHERE PriorShip.CustomerPart = scheds.customerPart AND
								PriorShip.CustomerPO = scheds.customerPO AND
                                PriorShip.Destination = scheds.destination
					ORDER BY PriorShip.DateShipped DESC
				FOR XML PATH ('')
			)
				,1,1,'') , 'No Shipment Data Available')
				FROM @Schedules scheds
				JOIN
					destination d ON d.destination = scheds.Destination
				WHERE scheds.ReleaseImportDT<GETDATE()-7
		
		RETURN
END		
			


GO
