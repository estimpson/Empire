SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_report_AutolivRANAudit]
AS
BEGIN 
 SET NOCOUNT ON
 SET ANSI_WARNINGS OFF
SELECT 
	UserDefined5 AS RanNumber,
	CustomerPart, 
	ShipToCode,
	MAX(ReleaseQty) RANOrderQty, 
	COALESCE(MAX(ranQtyShipped),0) AS RanQtyShipped, 
	MIN(rowCreateDT) Mindate, MAX(RowCreateDT) maxDate, 
	COUNT(1)  AS InboundranCount 
INTO #RanAudit
FROM EDIAutoLiv.ShipSchedules ss
LEFT JOIN 
	(SELECT RanNumber, 
			SUM(Qty) RanQtyShipped, 
			MIN(date_shipped) FirstdateShipped,
			MAX(date_shipped) lastdateShipped,  
			COUNT(1) AS ShippedCount FROM dbo.AutoLivRanNumbersShipped rans
		JOIN
			Shipper s ON s.id = rans.Shipper
			GROUP BY RanNumber) ransShipped ON ransShipped.RanNumber = ss.UserDefined5
GROUP BY UserDefined5, Customerpart, shipToCode ORDER BY 5 DESC

SELECT *, 
	COALESCE((SELECT SUM(quantity) 
				FROM order_detail WHERE release_no = RanNumber),0) AS CurrentOpenRan 
INTO 
	#OpenRanAudit
FROM 
	#RanAudit

SELECT  RanNumber ,
        ShipToCode ,
		CustomerPart,
        RANOrderQty ,
        RanQtyShipped ,
        maxDate AS OrderProcesseddate,
        CurrentOpenRan AS OpenRANQtyInMonitor, (SELECT   MAX(GeneratedDT)  
FROM dbo.CustomerReleasePlanRaw cpr 
JOIN dbo.CustomerReleasePlans pr ON pr.ID = cpr.ReleasePlanID
WHERE  pr.GeneratedDT >=  DATEADD(dd,-30, GETDATE()) AND ReleaseNo = RanNumber ) AS lasttimeinMonitorOrder ,
COALESCE((SELECT MAX(1)
from
	(SELECT * FROM ediautoliv.CurrentShipSchedules()) a
Where
		coalesce(a.newDocument,0) in (0, 1)
and not exists
( Select 1 from 
		EDIAutoLiv.ShipSchedules b
 Join 
	EDIAutoLiv.BlanketOrders bo on b.CustomerPart = bo.CustomerPart
and
	b.ShipToCode = bo.EDIShipToCode
and
(	bo.CheckCustomerPOShipSchedule = 0
	or bo.CustomerPO = b.CustomerPO)
and
(	bo.CheckModelYearShipSchedule = 0
	or bo.ModelYear862 = b.CustomerModelYear)
where
				a.RawDocumentGUID = b.RawDocumentGUID and
				a.CustomerPart = b.CustomerPart and
				a.ShipToCode = b.ShipToCode and
				coalesce(a.customerPO,'') = coalesce(b.CustomerPO,'') and
				coalesce(a.CustomerModelYear,'') = coalesce(b.CustomerModelYear,'')
) AND a.ReleaseNo =  RanNumber),0) exceptionReported

FROM #OpenRanAudit WHERE RANOrderQty - RanQtyShipped  != CurrentOpenRan AND Mindate>= dateadd(dd,-45, GETDATE())
ORDER BY 2,5 DESC



END
GO
