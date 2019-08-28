SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [dbo].[vw_sales_history]
AS
SELECT	shipper.id AS ShipperID,
		shipper.invoice_number AS InvoiceNumber,
		shipper.date_shipped AS DateShipped,
		CONVERT(CHAR(4), DATEPART(yyyy,shipper.date_shipped))+'/'+CONVERT(CHAR(1), DATEPART(qq,shipper.date_shipped)) AS ShippedDateQtr,
		CONVERT(CHAR(4), DATEPART(yyyy,shipper.date_shipped)) +'/'+ CONVERT(CHAR(2), DATEPART(mm,shipper.date_shipped)) AS ShippedDateMonth,
		CONVERT(CHAR(4), DATEPART(yyyy,shipper.date_shipped)) AS ShippedDateYear,
		(CASE ISNULL(NULLIF(shipper.status,''),'O') WHEN 'O' THEN 'Open' WHEN 'C' THEN 'Shipped' WHEN 'E' THEN 'Empty' WHEN 'S' THEN 'Staged' WHEN 'Z' THEN 'ASN Created' ELSE 'NotClassified' END) AS ShipperStatus,
		(CASE ISNULL(NULLIF(shipper.type,''),'N') WHEN 'N' THEN 'Normal' WHEN 'R' THEN 'RMA' WHEN 'Q' THEN 'QuickShipper' WHEN 'M' THEN 'ManualInvoice' WHEN 'V' THEN 'ReturnToVendor' ELSE 'NotClassified' END) AS ShipperType,
		shipper_detail.part_original AS Part,
		part.name AS PartName,
		shipper_detail.customer_part AS CustomerPart,
		shipper_detail.customer_po AS CustomerPurchaseOrder,
		part_inventory.standard_unit AS StandardUnit,
		shipper_detail.qty_packed AS QuantityShipped,
		ISNULL(shipper_detail.alternate_price,0) AS Price,
		shipper_detail.alternative_qty*ISNULL(shipper_detail.alternate_price,0) AS ExtendedSales,
		ISNULL(part_standard.cost_cum,0) AS UnitStandardCost,
		shipper_detail.alternative_qty*ISNULL(part_standard.cost_cum,0) AS ExtendedStandardCost,
		shipper_detail.alternative_qty*ISNULL(part_standard.material_cum,0) AS ExtendedMaterialCost,
		shipper_detail.salesman AS SalesPerson,
		salesrep.commission_type AS CommissionType,
		salesrep.commission_rate AS CommissionRate,
		customer.customer AS CustomerCode,
		customer.name AS CustomerName,
		customer.address_1 AS CustomerAddress1,
		customer.address_2 AS CustomerAddress2,
		customer.address_3 AS CustomerAddress3,
		customer.address_4 AS CustomerAddress4,
		customer.address_5 AS CustomerAddress5,
		customer.address_6 AS CustomerAddress6,
		destination.destination AS DestinationCode,
		destination.name AS DestinationName,
		destination.address_1 AS DestinationAddress1,
		Destination.address_2 AS DestinationAddress2,
		Destination.address_3 AS DestinationAddress3,
		Destination.address_4 AS DestinationAddress4,
		Destination.address_5 AS DestinationAddress5,
		Destination.address_6 AS DestinationAddress6,
		Shipper.Plant AS ShippingPlant,
		shipper_detail.alternative_qty*ISNULL(shipper_detail.alternate_price,0)-shipper_detail.alternative_qty*ISNULL(part_standard.material_cum,0) AS GrossProfit,
		COALESCE(NULLIF(part.user_defined_2,''),'PlatformNotDefined') AS [Platform],
		COALESCE(NULLIF(Customer.custom2,''), 'CustomerGroupNotDefined') AS [CustomerGroup]
		
FROM	dbo.shipper with (nolock)
JOIN	dbo.shipper_detail with (nolock) ON dbo.shipper.id = dbo.shipper_detail.shipper
LEFT JOIN	dbo.order_header with (nolock) ON dbo.shipper_detail.order_no = dbo.order_header.order_no
LEFT JOIN	dbo.salesrep with (nolock) ON dbo.shipper_detail.salesman = dbo.salesrep.salesrep	
JOIN	dbo.customer with (nolock) ON dbo.shipper.customer = dbo.customer.customer
JOIN	dbo.destination with (nolock) ON dbo.shipper.destination = dbo.destination.destination
JOIN	dbo.part with (nolock) ON dbo.shipper_detail.part_original = dbo.part.part
JOIN	dbo.part_standard with (nolock) ON dbo.part.part = dbo.part_standard.part
JOIN	dbo.part_inventory with (nolock) ON dbo.part.part = dbo.part_inventory.part








GO
