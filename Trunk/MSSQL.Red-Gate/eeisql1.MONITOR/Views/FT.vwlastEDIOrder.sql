SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [FT].[vwlastEDIOrder] AS

SELECT		oh.order_no, 
					oh.blanket_part, 
					oh.customer_part , 
					oh.customer_po, 
					COALESCE(CustomerDemand.TradingPartner, es.trading_partner_code) AS TradingPartner,
					oh.destination,
					COALESCE( NULLIF(es.EDIShipToID,''), NULLIF(es.parent_destination ,''), 'NoEDIShipToID') AS EDIShipToID,
					d.scheduler, 
					ISNULL(CONVERT(VARCHAR(25), CustomerDemand.DocumentImportDT), 'NoEDIOrder') DateOfLastEDIOrder, 
					ISNULL(DATEDIFF( DAY, CustomerDemand.DocumentImportDT, GETDATE()) ,9999) AS DaysSinceLastEDIOrder,
					SUM(od.quantity) AS TotalOrderQty,
					MIN(od.due_date) AS FirstDueDate,
					MAX(od.due_date) AS LastDueDate
FROM ORDER_detail od
JOIN
	order_header oh ON oh.order_no = od.order_no
JOIN
	dbo.edi_setups es ON es.destination = Oh.destination
JOIN
	dbo.destination d ON d.destination = es.destination
OUTER APPLY
 ( SELECT  TOP 1 * FROM [FT].[CustomerDemandList] cdl 
	WHERE cdl.CustomerPart = oh.customer_part AND
   ( cdl. ShipToCode = es.parent_destination OR cdl.ShipToCode = es.EDIShipToID )  ORDER BY cdl.DocumentImportDT DESC) CustomerDemand
WHERE BLANKET_PART NOT LIKE '%-PT%'   AND oh.customer_po NOT LIKE '%SAMPLE%' AND DATEDIFF( DAY, ISNULL(CustomerDemand.DocumentImportDT,GETDATE()-90), GETDATE()) > 10  
AND es.destination NOT LIKE '%EMPIRE%'
AND EXISTS ( SELECT 1 FROM shipper WHERE status ='Z' AND shipper.destination = oh.destination )
GROUP BY	oh.order_no,
					oh.blanket_part, 
					oh.customer_part , 
					oh.customer_po, 
					oh.destination,
					CustomerDemand.TradingPartner,
					COALESCE( NULLIF(es.EDIShipToID,''), NULLIF(es.parent_destination ,''), 'NoEDIShipToID') ,
					d.scheduler, 
					ISNULL(CONVERT(VARCHAR(25), CustomerDemand.DocumentImportDT), 'NoEDIOrder') , 
					ISNULL(DATEDIFF( DAY, CustomerDemand.DocumentImportDT, GETDATE()) ,9999),
					COALESCE(CustomerDemand.TradingPartner, es.trading_partner_code)


--SELECT * FROM ORDER_DETAIL WHERE ORDER_NO = 9121
GO
