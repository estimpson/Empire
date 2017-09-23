SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [FT].[ftsp_CompareOrderToShipper]
as

Begin

--Get OrderDetail

Declare @OrderDetail table(
	id int identity(1,1),
	ShipFromPlant varchar(25),
	CustomerPart varchar(50),
	Destination varchar(25),
	BasePart varchar(25),
	DueDate datetime,
	Qty	int,
	PriorAccum int,
	PostAccum int
	)

Insert	@OrderDetail (
		ShipFromPlant,
		CustomerPart,
		Destination,
		BasePart,		
		DueDate,
		Qty)

Select
	plant,
	customer_part,
	destination,
	left(part_number,7),	
	ft.fn_TruncDate('dd', due_date) as DueDate,
	sum(quantity)
From
	order_detail
Where
	due_date<= dateadd(dd,14, getdate())
group by
	plant,
	customer_part,
	destination,
	left(part_number,7),
	ft.fn_TruncDate('dd', due_date) 
	order by 1,2,4
		

update od
Set	PostAccum =
	coalesce(( Select sum(Qty)
		from
		@OrderDetail od2
		where
		od2.CustomerPart = od.CustomerPart and
		od2.Destination = od.destination and
		od2.BasePart = od.Basepart  and
		od2.ShipFromPlant = od.ShipFromPlant and
		od2.id<= od.id
	),0),
	PriorAccum =
	coalesce(( Select sum(Qty)
		from
		@OrderDetail od2
	where
		od2.CustomerPart = od.CustomerPart and
		od2.Destination = od.destination and
		od2.BasePart = od.Basepart  and
		od2.ShipFromPlant = od.ShipFromPlant and
		od2.id < od.id
	),0)
From
	@OrderDetail od

/*Select 
	*
	From
		@OrderDetail
		*/
	

--Get ShipperDetail

Declare @ShipperDetail table(
	id int identity(1,1),
	ShipperShipFromPlant varchar(25),
	ShipperCustomerPart varchar(50),
	ShipperDestination varchar(25),
	ShipperBasepart varchar(25),
	ShipperDueDate datetime,
	ShipperQty	int,
	ShipperPriorAccum int,
	ShipperPostAccum int
	)

Insert	@ShipperDetail (
		ShipperShipFromPlant,
		ShipperCustomerPart,
		ShipperDestination,
		ShipperBasePart,
		ShipperDueDate,
		ShipperQty)

Select
	shipper.plant,
	customer_part,
	destination,
	left(part_original,7),
	ft.fn_TruncDate('dd', date_stamp) as DueDate,
	sum(qty_required)
From
	shipper_detail
join
	shipper on shipper.id =shipper_detail.shipper
Where
	date_stamp<= dateadd(dd,14, getdate()) and
	shipper.status not in ('C', 'Z', 'E', 'D') and
	shipper.type is Null
group by
	shipper.plant,
	customer_part,
	destination,
	left(Part_original,7),
	ft.fn_TruncDate('dd', date_stamp) 

update sd
Set	ShipperPostAccum =
	coalesce(( Select sum(ShipperQty)
		from
		@ShipperDetail sd2
		where
		sd2.ShipperCustomerPart = sd.ShipperCustomerPart and
		sd2.ShipperDestination = sd.Shipperdestination and
		sd2.ShipperBasePart = sd.ShipperBasepart  and
		sd2.ShipperShipFromPlant = sd.ShipperShipFromPlant and
		sd2.id <= sd.id
	),0),
	ShipperPriorAccum =
	coalesce(( Select sum(ShipperQty)
		from
		@ShipperDetail sd2
		where
		sd2.ShipperCustomerPart = sd.ShipperCustomerPart and
		sd2.ShipperDestination = sd.Shipperdestination and
		sd2.ShipperBasePart = sd.ShipperBasepart  and
		sd2.ShipperShipFromPlant = sd.ShipperShipFromPlant and
		sd2.id < sd.id
	),0)
From
	@ShipperDetail sd

/*Select 
	*
	From
		@ShipperDetail
		*/

Declare @DemandCalendar table(
	ShipFromPlant varchar(25),
	CustomerPart varchar(50),
	Destination varchar(25),
	BasePart varchar(25),
	DueDate datetime

)

Declare	@EndDT datetime,
								@Datepart varchar(25)  = 'D',
								@Increment int  = 1
Select			@EndDT  = dateadd(dd, 14, getdate())

Insert
		@DemandCalendar
(		ShipFromPlant,
		CustomerPart,
		Destination,
		Basepart,
		DueDate
		)
 

Select 
	Parts.ShipFromPlant,
 Parts.CustomerPart,
 Parts.Destination,
 Parts.BasePart,
 EntryDT
		from
		 [dbo].[fn_Calendar_StartCurrentDay] (   @EndDT,   @DatePart,   @Increment, null) Calendar
		 Cross Join
				(		Select CustomerPart, Destination, BasePart, ShipFromPlant From @OrderDetail
							union
						 Select ShipperCustomerPart, ShipperDestination, ShipperBasePart, ShipperShipFromPlant From @ShipperDetail
							) Parts

Declare @EEIApprovedInventory table(
	
	
	BasePart varchar(25),
	Quantity numeric(20,6)

)


Declare @IntransitApprovedInventory table(
	
	
	BasePart varchar(25),
	Quantity numeric(20,6)

)

Insert @EEIApprovedInventory

Select left(part,7),
						sum(quantity)
From
		object
Where
		status = 'A' and
		Plant = 'EEI'
group by left(part,7)

Insert @IntransitApprovedInventory

Select left(part,7),
						sum(quantity)
From
		object
Where
		status = 'A' and
		Plant like '%TRAN-EEI%'
group by 
		left(part,7)





Select 
		DC.ShipFromPlant,
		DC.CustomerPart,
		DC.Destination,
		DC.BasePart,
		DC.DueDate,
		coalesce(( Select max(Qty) 
						from @OrderDetail od
					where od.CustomerPart = dc.CustomerPart and
												od.BasePart = dc.basePart and
												od.Destination = dc.Destination and
												od.DueDate <= dc.DueDate  ),0) as OrderAccumDue,
		coalesce(( Select max(ShipperQty) 
						from @ShipperDetail sd
					where  sd.ShipperCustomerPart = dc.CustomerPart and
												sd.ShipperBasePart = dc.basePart and
												sd.ShipperDestination = dc.Destination and
												sd.ShipperDueDate <= dc.DueDate  ),0) as ShipperAccumDue,

		dbo.fn_GreaterOf (
		 coalesce(( Select max(Qty) 
						from @OrderDetail od
					where od.CustomerPart = dc.CustomerPart and
												od.BasePart = dc.basePart and
												od.Destination = dc.Destination and
												od.DueDate <= dc.DueDate  ),0) ,
		coalesce(( Select max(ShipperQty) 
						from @ShipperDetail sd
					where  sd.ShipperCustomerPart = dc.CustomerPart and
												sd.ShipperBasePart = dc.basePart and
												sd.ShipperDestination = dc.Destination and
												sd.ShipperDueDate <= dc.DueDate  ),0) 
		)  as EffectiveQtyDue,
		coalesce(EEIInv.Quantity,0) as EEIInventory,
		Coalesce(INTran.Quantity,0) as INTransInventory

	From 
		@DemandCalendar DC
		Left join
			@EEIApprovedInventory EEIInv on EEIInv.BasePart = DC.BasePart
		Left join
			@IntransitApprovedInventory INTran on INTran.BasePart = DC.BasePart

		



	
	
End







GO
