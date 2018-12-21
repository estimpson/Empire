SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [FT].[vwPastDueOrder] AS

SELECT		oh.order_no, 
					oh.blanket_part, 
					oh.customer_part , 
					oh.customer_po, 
					oh.customer,
					oh.destination,
					COALESCE( NULLIF(es.EDIShipToID,''), NULLIF(es.parent_destination ,''), 'NoEDIShipToID') AS EDIShipToID,
					d.scheduler, 
					od.due_date AS ReleaseDueDate,
					od.quantity AS OrderReleaseQty,
					ds.ship_day,
					NextShipperScheduled.*,
					ISNULL(Inventory.OnHandInventory,0) AS AvailableInventory
FROM ORDER_detail od
JOIN
	order_header oh ON oh.order_no = od.order_no
JOIN
	dbo.edi_setups es ON es.destination = Oh.destination
JOIN
	dbo.destination d ON d.destination = es.destination
JOIN
	dbo.destination_shipping ds ON ds.destination = d.destination
OUTER APPLY
	( SELECT SUM(stdQty) AS OnHandInventory  FROM FT.vwInventory Inv WHERE Inv.status = 'A' AND Inv.plant IN ('EEI', 'EEA', 'EEP') AND inv.PartECN = od.part_number AND inv.shipper = 0 ) Inventory
OUTER APPLY
	( SELECT TOP 1 s.id AS NextShipper, s.date_stamp AS ScheduledtoShipDT,  sd.qty_required AS ShipperQtyScheduled, sd.qty_packed AS QtyStagedtoShip FROM shipper s JOIN shipper_detail sd ON sd.shipper = s.id AND sd.order_no = od.order_no WHERE s.status IN ( 'S', 'O') AND s.plant IN ('EEI', 'EEA', 'EEP') ORDER BY s.date_stamp ASC) NextShipperScheduled
WHERE /*BLANKET_PART NOT LIKE '%-PT%'   AND oh.customer_po NOT LIKE '%SAMPLE%' and */ es.destination NOT LIKE '%EMPIRE%' AND od.quantity> 1 AND ft.fn_TruncDate('dd', od.due_date) < ft.fn_TruncDate('dd', GETDATE())
 


GO
