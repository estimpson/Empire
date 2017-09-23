SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [FT].[AutoCreateShippersReport]

AS

BEGIN

--Andre S. Boulanger ForeThought, LLC		2013-10-06
--Declare Local non Table Variables


DECLARE @Orders TABLE
 ( 		SalesCustomer VARCHAR(MAX),
		SalesDestination VARCHAR(MAX),
		SalesOrderNo INT,
		SalesPartNo VARCHAR(25),
		SalesDueDate DATETIME,
		HorizonEndDate DATETIME,
		SalesOrderQty NUMERIC(20,6),
		SalesOrderAccum NUMERIC(20,6),
		Scheduler VARCHAR(30)
		)

DECLARE @Shippers TABLE
(		ShipperOrderNo INT,
		ShipperPartNo VARCHAR(25),
		ShipperDueDate DATETIME,
		ShipperQty NUMERIC(20,6),	
		ShipperAccum NUMERIC(20,6),
		Scheduler VARCHAR(30)
)

INSERT @Orders
SELECT 
		oh.customer,
		oh.destination,
		od.order_no,
		od.part_number,
		ft.fn_truncDate('dd',od.due_date) ,
		ft.BusinessDaysDateAdd(GETDATE(),CONVERT(INT,'3')),
		SUM(od.quantity),
		NULL,
		d.scheduler
FROM
		order_detail od
JOIN
		order_header oh ON oh.order_no = od.order_no
JOIN
		part p ON p.part = od.part_number
JOIN
		destination d ON d.destination = oh.destination 
JOIN
		destination_shipping ds ON ds.destination = d.destination
JOIN
		customer c ON c.customer = oh.customer
WHERE
	oh.customer NOT LIKE '%EE%'

GROUP BY
		oh.customer,
		oh.destination,
		od.order_no,
		od.part_number,
		ft.fn_truncDate('dd',od.due_date) ,
		d.destination,
		d.scheduler

ORDER BY ft.fn_truncDate('dd',od.due_date), d.destination

DELETE 
		@Orders
WHERE 
		SalesDueDate>HorizonEndDate

INSERT @Shippers

SELECT
		sd.order_no,
		sd.part_original,
		ft.fn_TruncDate('dd', s.date_stamp),
		SUM(sd.qty_required),
		NULL,
		d.scheduler
		
FROM
		shipper_detail sd
JOIN
		shipper s ON s.id = sd.shipper AND s.status IN ('O', 'S') 
JOIN
		destination d ON d.destination = s.destination
WHERE
		sd.part NOT LIKE '%CUM%'


GROUP BY
		sd.order_no,
		sd.part_original,
		ft.fn_TruncDate('dd', s.date_stamp),
		d.scheduler


SELECT					COALESCE(NULLIF(Scheduler,''), ' NotDefined') AS Scheduler,
						SalesDestination,
						SalesOrderNo, 
						SalespartNo, 
						SalesDueDate, 
						SalesOrderQty, 
						(SELECT SUM(SalesOrderQty) FROM @Orders o2 WHERE  o2.SalesOrderNo = o1.SalesOrderNo AND o2.SalesPartNo = o1.SalesPartNo AND o2.salesDueDate<= o1.salesDueDate  ) AS OrderAccum,
						COALESCE((SELECT SUM(ShipperQty) FROM @Shippers s2 WHERE s2.ShipperOrderNo = o1.SalesOrderNo AND s2.ShipperPartNo = o1.SalesPartNo AND s2.ShipperDueDate = o1.SalesDueDate ),0) AS ShipperQty,
						COALESCE((SELECT SUM(ShipperQty) FROM @Shippers s2 WHERE s2.ShipperOrderNo = o1.SalesOrderNo AND s2.ShipperPartNo = o1.SalesPartNo AND s2.ShipperDueDate <= o1.SalesDueDate ),0) AS ShipperAccum

INTO 
		#ShipperOrderCompare
FROM @Orders o1
ORDER BY 1,2,3

SELECT * INTO #ShippersOrdersReport FROM #ShipperOrderCompare WHERE (SalesOrderQty!=ShipperQty) OR (OrderAccum!=ShipperAccum)

SELECT * From #ShippersOrdersReport ORDER BY 1,2,3,5

/*


Declare @CurrentShipperID int
Declare @EndDate datetime = dateadd(dd, 30, getdate())

--Declare Local Table Variables

Declare @UnscheduledOrders table
 (  ID int identity(1,1),
		SalesOrderNo int,
		SalesCustomer varchar(20),
		SalesDestination varchar(20),
		Salesman varchar(25),
		SalesPartNo varchar(25),
		SalesPartName varchar(100),
		SalesCustomerPO varchar(50),
		SalesCustomerpart varchar(50),
		SalesReleaseNo varchar(50),
		SalesOrderQty int,
		SalesOrderUnit varchar(15),
		SalesOrderPrice numeric(20,6),
		SalesOrderAccountCode varchar(25),
		SalesOrderPriorAccum int,
		SalesOrderAccum int,
		SalesDueDate datetime,
		SalesHorizonEndDT datetime,
		SalesAllowMultipleLineItems bit,
		SalesOrderCarrier varchar(50),
		SalesOrderFOB varchar(50),
		SalesOrderFreightType varchar(50),
		SalesOrderTransMode varchar(50),
		SalesOrderShippingDock varchar(50),
		SalesOrderNotes varchar( 255),
		SalesOrderTerms varchar(50),
		SalesOrderCSStatus varchar(50)

		)

Declare @OpenShippers table
(		ShipperID int,
		DueDate datetime,
		ShipperStatus varchar(5),
		FrozenShipper bit ,
		OrderNo int,
		Customer varchar(25),
		Destination varchar(25),
		PartNo varchar(25),
		CustomerPO varchar(50),
		Customerpart varchar(50),
		ReleaseNo varchar(50),
		ShipperQty int,	
		AccumShipper int,
		FrozenAccumShipper int,
		NewShipperID int,
		NewShipperQty int,
		NewShipperDueDate datetime,
		NewShipperStatus varchar(5)
)

-- Insert Open Orders and Delete any orders outside auto schediule horizon
Insert @UnscheduledOrders
 (
		SalesOrderNo,
		SalesCustomer,
		SalesDestination,
		Salesman,
		SalesPartNo,
		SalesPartName,
		SalesCustomerPO,
		SalesCustomerpart,
		SalesReleaseNo,
		SalesOrderQty,
		SalesOrderUnit,
		SalesDueDate,
		SalesOrderPrice,
		SalesOrderAccountCode,
		SalesHorizonEndDT,
		SalesAllowMultipleLineItems,
		SalesOrderCarrier ,
		SalesOrderFOB ,
		SalesOrderFreightType ,
		SalesOrderTransMode,
		SalesOrderShippingDock ,
		SalesOrderNotes,
		SalesOrderTerms,
		SalesOrderCSStatus
 )

Select 
		od.order_no,
		d.customer,
		d.destination,
		max(oh.salesman),
		od.part_number,
		p.name,
		oh.customer_po,
		od.customer_part,
		od.release_no,
		sum(od.quantity),
		max(od.unit),
		case when ft.fn_truncDate('dd',od.due_date) < ft.fn_truncDate('dd',getdate()) then ft.fn_truncDate('dd',getdate()) else  ft.fn_truncDate('dd',od.due_date) end  ,
		max(oh.price),
		max(p.gl_account_code),
		ft.BusinessDaysDateAdd(getdate(),convert(int,d.region_code)-1),
		case coalesce(ds.allow_mult_po,'N')
						when 'Y'
						then 1
						else 0
						end,
		coalesce(ds.scac_code,'') ,
		coalesce(ds.FOB,'') ,
		coalesce(ds.freigt_type,'') ,
		coalesce(ds.trans_mode,'') ,
		coalesce(oh.dock_code,'') ,
		coalesce(ds.note_for_shipper,''),
		coalesce(c.terms,''),
		coalesce(c.cs_status,'')
From
		order_detail od
join
		order_header oh on oh.order_no = od.order_no
join
		part p on p.part = od.part_number
join
		destination d on d.destination = oh.destination 
join
		destination_shipping ds on ds.destination = d.destination
join
		customer c on c.customer = oh.customer
where
		coalesce(d.region_code,'') not like '%[a-Z]%'	and 	coalesce(d.region_code,'') > '0'
group by
		od.order_no,
		d.customer,
		d.destination,
		od.part_number,
		p.name,
		oh.customer_po,
		od.customer_part,
		od.release_no,
		case when ft.fn_truncDate('dd',od.due_date) < ft.fn_truncDate('dd',getdate()) then ft.fn_truncDate('dd',getdate()) else  ft.fn_truncDate('dd',od.due_date) end,
	ft.BusinessDaysDateAdd(getdate(),convert(int,d.region_code)-1),
		case coalesce(ds.allow_mult_po,'N')
						when 'Y'
						then 1
						else 0
						end,
		coalesce(ds.scac_code,'') ,
		coalesce(ds.FOB,'') ,
		coalesce(ds.freigt_type,'') ,
		coalesce(ds.trans_mode,''),
		coalesce(oh.dock_code,'') ,
		coalesce(ds.note_for_shipper,''),
		coalesce(c.terms,''),
		coalesce(c.cs_status,'')

order by case when ft.fn_truncDate('dd',od.due_date) < ft.fn_truncDate('dd',getdate()) then ft.fn_truncDate('dd',getdate()) else  ft.fn_truncDate('dd',od.due_date) end

delete @UnscheduledOrders
where SalesDueDate>SalesHorizonEndDT

-- Insert Open Shippers; Update @OpenShippers..Set FrozenFlag to 1 for shipper than has inventory staged to it
Insert	@OpenShippers

(		ShipperID,
		DueDate,
		ShipperStatus,
		FrozenShipper,
		OrderNo,
		Customer,
		Destination,
		PartNo,
		CustomerPO,
		Customerpart,
		ReleaseNo,
		ShipperQty
		
)

Select
		sd.shipper,
		case when ft.fn_truncDate('dd',s.date_stamp) < ft.fn_truncDate('dd',getdate()) then ft.fn_truncDate('dd',getdate()) else  ft.fn_truncDate('dd',s.date_stamp) end,
		s.status,
		case when coalesce(s.plant,'')  = 'FROZEN' then 1 when s.date_stamp  <  dateadd(day,1,ft.Fn_TruncDate('d',getdate()))   then 1 when s.status = 'S' then 1 else 0 end,
		sd.order_no,
		s.customer,
		s.destination,
		sd.part_original,
		sd.customer_po,
		sd.customer_part,
		max(sd.release_no),
		sum(sd.qty_required)
		
From
		shipper_detail sd
join
		shipper s on s.id = sd.shipper and s.status in ('O', 'S') and sd.part not like 'CERT%'
join
		destination d on d.destination = s.destination
where
		coalesce(d.region_code,'') not like '%[a-Z]%'	and 	coalesce(d.region_code,'') > '0'


group by
		s.status,
		sd.shipper,
		s.customer,
		s.destination,
		coalesce(s.plant,''),
		sd.order_no,
		sd.part_original,
		sd.customer_po,
		sd.customer_part,
		case when ft.fn_truncDate('dd',s.date_stamp) < ft.fn_truncDate('dd',getdate()) then ft.fn_truncDate('dd',getdate()) else  ft.fn_truncDate('dd',s.date_stamp) end,
		case when coalesce(s.plant,'')  = 'FROZEN' then 1 when s.date_stamp  <  dateadd(day,1,ft.Fn_TruncDate('d',getdate()))   then 1 when s.status = 'S' then 1 else 0 end

Update	OS
		Set			OS.FrozenShipper = 1
		From
				@OpenShippers OS
		Where exists 
				( Select 1 from Object where object .shipper = ShipperID		)

Select * 
into 
		#OrdersShippersTemp
		from 
		[dbo].[fn_Calendar_StartCurrentDay] 	(	@EndDate,'day',1, null) OOCalendar
				Cross Join ( Select salesOrderNo as OrderNumber, Salespartno as PartNumber, SalesDestination as ShipToCode  from @UnScheduledOrders
														Union
														 Select OrderNo as OrderNumber, partno as PartNumber, Destination as ShipToCode  from @OpenShippers) SalesShippers

--Select * From 	#OrdersShippersTemp

Select 
		* 
into #OrdersShippers
from
		#OrdersShippersTemp OOT
left Join
		@UnscheduledOrders OO on OO.SalesDueDate = OOT.EntryDT and OO.SalesOrderNo = OOT.OrderNumber and OO.SalesPartNo = OOT.PartNumber
left Join
		@OpenShippers OS on OS.DueDate = OOT.EntryDT and OS.OrderNo = OOT.OrderNumber and OS.PartNo = OOT.PartNumber
order by Coalesce(ID, 0), DueDate, Destination, PartNo

Delete 
		#OrdersShippers
where 
		SalesDueDate is NULL and DueDate is NULL		

-- Update Sales Demand Accum and Prior Accum
UPDATE	OS1
SET			Os1.SalesOrderAccum = 
								COALESCE((SELECT 
										SUM(COALESCE(SalesOrderQty,0)) 
										FROM 
												#OrdersShippers OS2 
									WHERE 
										OS2.EntryDT<= OS1.EntryDT AND 
										OS2.OrderNumber = OS1.OrderNumber AND 
										Os2.PartNumber = Os1.PartNumber),0)
FROM
		#OrdersShippers OS1

UPDATE	OS1
SET			Os1.SalesOrderPriorAccum = 
								COALESCE((SELECT 
										SUM(COALESCE(SalesOrderQty,0)) 
										FROM 
												#OrdersShippers OS2 
									WHERE 
										OS2.EntryDT< OS1.EntryDT AND 
										OS2.OrderNumber = OS1.OrderNumber AND 
										Os2.PartNumber = Os1.PartNumber),0)
FROM
		#OrdersShippers OS1


-- Update Accumand Frozen Accum on Shippers by order number and part_number
UPDATE	OS1
SET					Os1.AccumShipper = 
								COALESCE((SELECT 
																		SUM(COALESCE(ShipperQty,0)) 
																		FROM 
																				#OrdersShippers OS2 
																			WHERE 
																				OS2.EntryDT<=OS1.EntryDT AND 
																				OS2.OrderNumber = OS1.OrderNumber AND 
																				Os2.PartNumber = Os1.PartNumber),0)
FROM
		#OrdersShippers OS1

UPDATE	OS1
SET					Os1.FrozenAccumShipper = 
								COALESCE((SELECT 
																		SUM(COALESCE(ShipperQty,0)) 
																		FROM 
																				#OrdersShippers OS2 
																		WHERE 
																				OS2.EntryDT<=OS1.EntryDT AND 
																				OS2.OrderNumber = OS1.OrderNumber AND 
																				Os2.PartNumber = Os1.PartNumber AND 
																				COALESCE(FrozenShipper ,0) = 1 ),0)
FROM
		#OrdersShippers OS1

UPDATE	OS1 
SET			
		Os1.FrozenAccumShipper = 0 
FROM
		#OrdersShippers OS1
WHERE
			Os1.FrozenAccumShipper  IS NULL

-- Update New Shipper Quantities Considering the accum of Shippers.
UPDATE OS1 
		SET   OS1.NewShipperQty =  
		CASE WHEN FrozenAccumShipper>SalesOrderAccum THEN 0 
		WHEN FrozenAccumShipper > SalesOrderPriorAccum AND FrozenAccumShipper<= SalesOrderAccum THEN SalesorderAccum-FrozenAccumShipper  
		WHEN FrozenAccumShipper < SalesOrderPriorAccum AND FrozenAccumShipper> 0  THEN SalesorderAccum-FrozenAccumShipper   
		ELSE SalesOrderAccum-SalesOrderPriorAccum 
		END
FROM
		#OrdersShippers OS1
WHERE
		COALESCE(OS1.FrozenShipper,0) = 0

--Select * From #OrdersShippers

-- Mark -NewShipperQtys with 'E' and close shipper detail and shippers

UPDATE OS1 SET   OS1.NewShipperStatus = 'E'
FROM
			#OrdersShippers OS1
WHERE	
		COALESCE(OS1.FrozenShipper ,0) = 0 AND
		OS1.ShipperID IS NOT NULL AND
		COALESCE(NewShipperQty,0) <= 0 
-- Delete Shipper Detail for New Status of 'E'; Set Shipper Status to 'E' for any shipper in #ordersShippers that have no demand

UPDATE OS1 
		SET   OS1.ShipperID = (SELECT MIN(ShipperID) 
																								FROM 
																										@OpenShippers OS 
																									WHERE OS.Destination = OS1.SalesDestination AND 
																									OS.DueDate = OS1.SalesDueDate AND 
																									COALESCE(OS.FrozenShipper,0) = 0 )
FROM
		#OrdersShippers OS1
WHERE
		COALESCE(OS1.SalesallowMultipleLineItems,1) = 1 AND
		OS1.ShipperID IS NULL AND
		COALESCE(OS1.NewShipperQty,0) > 0 AND
		COALESCE(OS1.FrozenShipper,0) = 0 



	
	/*Select 
		ID,
		SalesOrderNo,
		SalesDestination,
		SalesPartNo,
		SalesOrderQty,
		SalesDueDate,
		SalesHorizonEndDT,
		DueDate,
		SalesOrderPriorAccum,
		SalesOrderAccum,
		SalesallowMultipleLineItems,
		FrozenAccumShipper,	
		ShipperID,
		OrderNo,		
		FrozenShipper,
		ShipperQty,	
		NewShipperID,
		NewShipperQty,
		NewShipperStatus

		From 
	#OrdersShippers 
order by 
		coalesce(ID,0), EntryDT */


--Select 		* 	From #NewShippers

--Select * From shipper where  id >= (Select min(coalesce(ShipperID, NewShipperID)) From #OrdersShippers) ; Select * From shipper_detail where Shipper >=   (Select min(coalesce(ShipperID, NewShipperID)) From #OrdersShippers)

--Reporting

DECLARE @Report TABLE 

(		EntryDT DATETIME,
		SalesOrderNo INT,
		Destination VARCHAR(25),
		PartNumber VARCHAR(25),
		Note VARCHAR(MAX)
)

INSERT @Report
(		EntryDT,
		SalesOrderNo,
		Destination ,
		PartNumber,
		Note
)

 --Frozen Shipper Requirement does not match current Customer Demand
SELECT 
		EntryDT,
		OrderNumber,
		ShipToCode,
		PartNumber,	
		'Frozen Shipper'+ ' ( '+ CONVERT(VARCHAR(15), ShipperID) + ' ) ' + (CASE WHEN SalesOrderAccum> FrozenAccumShipper THEN 'Under scheduled by :  ' ELSE 'Over scheduled by :  ' END ) +  CONVERT(VARCHAR(10), ABS(SalesOrderAccum-FrozenAccumShipper))
FROM
		#OrdersShippers
		WHERE 
				ShipperID IS NOT NULL AND 
				COALESCE(FrozenShipper,0) = 1 AND
				SalesOrderAccum != FrozenAccumShipper


		SELECT * FROM @Report  Report
*/

/*Test
Begin Transaction
Execute [FT].[AutoCreateShippersReport]
Commit Transaction
*/



END














GO
