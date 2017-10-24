SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create procedure [dbo].[ftsp_rpt_nestedfor Shipper_DiscretePOs]
	@ShipperID int
,	@OrderNo int
as
Begin

	Declare  
		@OrderDetail table 
	( 
	id int not null Identity (1,1) primary key ,
	DueDate datetime,
	Quantity numeric (20,6),
	PriorAccum	numeric(20,6),
	Accum numeric(20,6),
	DiscretePO varchar(30) 
	)
		
	insert 
		@OrderDetail
	( 
	DueDate ,
	Quantity ,
	DiscretePO
	 )
		
	select
		due_date,
		quantity,
		release_no
	from	
		dbo.order_detail
	where
		order_no = @OrderNo
	order by 
		due_date, release_no, id
			
			
	update	 od
			set	Accum = (select sum(quantity) from @OrderDetail where ID <= od.ID ),
					PriorAccum = COALESCE((select sum(quantity) from @OrderDetail where ID < od.ID ),0)
					
	from
		@OrderDetail od
			
	 --select	* from		@OrderDetail

	--get Shipper Detail for Order No

	Declare  
		@ShipperDetail table 
	( 
	id int not null Identity (1,1) primary key,
	ShipperID int,
	DateStamp datetime,
	Quantity numeric(20,6),
	PriorAccum numeric (20,6),
	Accum numeric(20,6)
	)
		
	insert 
		@ShipperDetail
	( 
	ShipperID ,
	DateStamp ,
	Quantity
	 )
		
	select
		s.id,
		s.date_stamp,
		sd.qty_required
	from	
		dbo.shipper s
	join
		shipper_detail sd on s.id = sd.shipper
	where
		sd.order_no = @OrderNo and
		s.status in ('O', 'A', 'S') and
		s.type is NULL
	order by 
		ft.fn_DatePart('Year',date_stamp),ft.fn_DatePart('DayofYear',date_stamp), ft.fn_DatePart('Hour',scheduled_ship_time), ft.fn_DatePart('Minute',scheduled_ship_time), ft.fn_DatePart('Second',scheduled_ship_time) , s.id
		
	update	 sd
			set	
				Accum = (select sum(quantity) from @ShipperDetail where ID <= sd.ID),
				PriorAccum = COALESCE((select sum(quantity) from @shipperDetail where ID < sd.ID),0)
	from
		@ShipperDetail sd


	declare
		@ShipperDetailID int,	
		@ShipperPriorAccum numeric(20,6),
		@ShipperAccum	numeric(20,6),
		@ShipperQty numeric(20,6)
					
	select
		@ShipperDetailID =ShipperID,
		@ShipperPriorAccum = PriorAccum,
		@ShipperAccum = Accum	,
		@ShipperQty = Quantity
	From
		@ShipperDetail sd 
	where	
		ShipperID = @shipperID
		
		
	select	
		DiscretePO,
			--ShipperID = @ShipperDetailID,
			--ShipperQty = @ShipperQty,
			--ShipperPriorAccum =@ShipperPriorAccum ,
			--ShipperAccum =@ShipperAccum ,
			--OrderDetailQuantity=od.quantity,
			--OrderDetailPriorAccum=od.priorAccum,
			--OrderDetailAccum=od.accum,
		DiscretePOQuantity= case
			when od.Accum<=@ShipperAccum and od.PriorAccum>=@ShipperPriorAccum
			then od.quantity
			when od.Accum>=@ShipperAccum and od.PriorAccum<=@ShipperPriorAccum
			then @shipperAccum-@ShipperPriorAccum
			when od.Accum>=@ShipperPriorAccum and od.PriorAccum<=@ShipperPriorAccum
			then od.Accum-@ShipperPriorAccum
			when od.Accum>@ShipperPriorAccum and od.PriorAccum<=@ShipperAccum
			then @shipperAccum-od.priorAccum
			else	0
			end
	from		
		@OrderDetail od
	where	
		od.Accum>@ShipperPriorAccum and
		od.PriorAccum<@ShipperAccum
end

GO
