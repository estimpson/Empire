SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
Select 
	shipments.id,
	shipments.date_shipped,
	shipments.order_no,
	shipments.part_original,
	shipments.alternative_qty as QtyShipped,
	Shipments.accum_shipped as AccumShipped,
	shipments.customer_part as CustomerPart,
	shipments.destination as Destination,
	LastShipperID ,
	sd.order_no,
	sd.part_original,
	isNull(sd.accum_shipped,0) as PriorAccum

	From (select 
	id, 
	s.date_shipped,
	order_no, 
	part_original, 
	qty_packed, 
	alternative_qty,
	accum_shipped,
	customer_part,
	s.destination,
	(Select max(s3.id) 
		from shipper s3
	
	where	s3.date_shipped = (Select max(s2.date_shipped) 
		from shipper_detail sd2
	join
		shipper s2 on s2.id = sd2.shipper
	where	sd2.customer_part = sd.customer_part and
			s2.destination = s.destination and
			s2.date_Shipped < s.date_shipped  ))  LastShipperID
from 
	shipper s 
join 
	shipper_detail sd on s.id = sd.shipper 
where
	s.date_shipped >= @dateShipped 
and s.type is Null and s.status not in ('E')

) shipments
 left join shipper_detail sd on sd.shipper = LastShipperID and sd.customer_part = shipments.customer_part 
 where 
 isNull(sd.accum_shipped,0) + isnull(shipments.alternative_qty,0) != shipments.accum_shipped

 order by date_shipped

 Select * From shipper_detail where order_no in ( 15462 )

 Select dbdate, 
		shipper,* From audit_trail where shipper in ('57526', '57597') and type = 'S'*/


CREATE procedure [FT].[ftsp_AuditAccums] @dateShipped datetime
as
Begin 

--ft.ftsp_AuditAccums '2012-07-01'
		declare @Shipments table (
		id int identity (1,1),
		dbdate datetime,
		shipper varchar (15),
		orderNo int,
		part varchar(25),
		destination varchar(25),
		customer_part varchar(50),
		ATQtyShipped int,
		shipperAccum int,
		Note varchar(25) )

		insert
			@Shipments

			(dbdate ,
			shipper ,
			OrderNo,
			part ,
			destination,
			customer_part,
			ATQtyShipped,
			shipperAccum ,
			Note)

		
		Select	dbdate,
				at.shipper,
				sd.order_no,
				at.part,
				s.destination,
				sd.customer_part,
				Sum(Quantity) as ATQtyShipped,
				max(sd.accum_shipped) as ShipperAccum,
				'Shipment'
		from 
			audit_trail at
		join
			shipper_detail sd on sd.part_original = at.part and sd.shipper = at.shipper
		join
			shipper s on s.id =sd.shipper
		where at.type = 'S' and 
			dbDate>= @dateShipped and
			at.part != 'pallet'
		group by
			dbDate,
			at.shipper,
			sd.order_no,
			at.part,
			s.destination,
			sd.customer_part

		union all

		 Select	sd.date_shipped,
				sd.shipper,
				sd.order_no,
				oh.blanket_part,
				oh.destination,
				oh.customer_part,
				0,
				accum_shipped as AccumAdjust,
				'AccumAdjustment'
		from
			shipper_detail sd 
		left join order_header oh on sd.order_no = oh.order_no
		join
			shipper s on s.id =sd.shipper
		where sd.part like '%CUM%' and 
			sd.date_shipped >= @dateShipped
		order by 
		5, 6, 1

		--Select * From @shipments

		Select *,
				coalesce(( Select max(ShipperAccum) from @shipments s2 where s2.id < s.id and s2.customer_part  = s.customer_part and s2.destination =  s.destination ), shipperAccum ) as PriorRunningAccum
			
		into	
			#Shipments
		From	
			@Shipments s

		--Select * From #shipments

		Select 
			*,
			((Select sum(ATQtyShipped) from #Shipments s5 where s5.note != 'AccumAdjustment' and  s5.customer_part = s4.customer_part and s5.destination = s4.destination and s5.id <=s4.id ) + PriorRunningAccum) as RunningAccum
			into #shipmentsEvaluate
		From
			#shipments s4
		order by id

		Select 
			dbDate,
			Shipper,
			OrderNo,
			Part,
			Destination,
			Customer_part,
			ATQtyShipped,
			PriorRunningAccum,
			PriorRunningAccum+AtQtyShipped as CalculatedAccum,
			ShipperAccum as SystemAccum,
			ShipperAccum - (PriorRunningAccum + ATQtyShipped ) as AccumDiscrepancy ,
			coalesce((Select max(1) from order_header oh where se.customer_part = oh.customer_part and se.destination = oh.destination and isnull(oh.status,'X') = 'A' ),0) as ActiveOrderExists,
			case when Note = 'AccumAdjustment' then 1 else (Select count (distinct part_original) from shipper_detail sd where sd.customer_part = se.customer_part and sd.shipper  = se.shipper ) end as CountofRevsOnShipper,
			Note
		From
			#shipmentsEvaluate se
		where
			shipperAccum != PriorRunningAccum and
			PriorRunningAccum+ATQtyShipped != ShipperAccum
			
			order by 5,4,1

End
GO
