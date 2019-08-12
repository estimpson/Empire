SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[ftsp_ImportRleases]
--(
--	@SalesOrder varchar(5)=NULL,
--	@OperatorCode varchar(10) ,
--	@Result integer out
--)
as
--set @Result = 6999

declare	@PONumber integer,
	@VendorCode varchar (10),
	@Status char (1),
	@Type char (1),
	@ShipVia varchar (15),
	@Terms varchar (20),
	@ShipTo varchar (25),
	@Plant varchar (10),
	@Part varchar (25),
	@UM char (2),
	@Partname varchar (100),
	@PreviousPart varchar (25),
	@Quantity numeric (20,6),
	@Price numeric (20,6),
	@DueDT datetime,
	@RowID integer,
	@WeekNo integer

declare poreleases cursor local static for
select	distinct po_number
from	importedporel
--where	OperatorCode = @OperatorCode

open	poreleases

fetch	poreleases
into	@PONumber

while @@fetch_status = 0 begin

	update po_header set  date_due = getdate() where po_number = @PONumber

	select	@VendorCode = vendor_code,
			@Status = status,
			@Type = type,
			@ShipTo = ship_to_destination,
			@Terms = terms,
			@Plant = plant,
			@ShipVia = ship_via,
			@PreviousPart = ''
	from	po_header
	where	po_number = @PONumber
	
	declare popartreleases cursor local static for
	select	part, due_date, quantity, week_no 
	from	importedporel 
	where	po_number = @PONumber
			--and OperatorCode = @OperatorCode
	order by
		part, due_date
	
	open	popartreleases
	
	fetch	popartreleases
	into	@Part,
			@DueDT,
			@Quantity,
			@WeekNo
	
	while @@fetch_status = 0 begin
		if @PreviousPart <> @Part begin

			delete	po_detail_history
			where	po_number = @PONumber and
				part_number = @Part
		
			delete	po_detail
			where	po_number = @PONumber and
				part_number = @Part
				
			set	@PreviousPart = @Part	
		end

		select	@RowID = isnull(Max(row_id),0) + 1
		from 	po_detail
		where	po_number = @PONumber
		
		select	@Partname = name,
			@UM = standard_unit
		from	part
			join part_inventory pi on pi.part = part.part
		where	part.part = @Part

		select	@Price = price 
		from	part_vendor_price_matrix 
		where	part = @Part and 
			vendor = @VendorCode and
			break_qty = (select	max(break_qty) 
					from	part_vendor_price_matrix 
					where	vendor = @VendorCode and 
						part = @Part and 
						break_qty <= @Quantity) 
		
		insert	po_detail
		(	po_number, vendor_code, part_number, description, unit_of_measure, date_due, 
			status, type, quantity, balance, price, row_id, ship_to_destination, terms, 
			week_no, plant, standard_qty, ship_type, ship_via, received,
			alternate_price)
		values	(@PONumber, @VendorCode, @Part, @Partname, @UM, @DueDT,
			@Status, @Type, @Quantity, @Quantity, @Price, @RowID, @ShipTo, @Terms,
			@WeekNo, @Plant, @Quantity, 'N', @ShipVia, 0,
			@Price)

		fetch	popartreleases
		into	@Part,
			@DueDT,
			@Quantity,
			@WeekNo
	end
	close	popartreleases
	deallocate
		popartreleases

	fetch	poreleases
	into	@PONumber
end
close	poreleases
deallocate
	poreleases

	--if @SalesOrder = 'YES' begin
if	2=1 begin


	create table #OrderDetailCalculations(
			OrderNo int,
			Part varchar(25),
			DueDate datetime,
			OrderQty numeric(20,6),
			SaleQty numeric(20,6),
			Sequence int )

	create table #NewOrderValues(
		OrderNo int, 
		Part varchar(25),
		DueDate datetime,
		IsNewRow smallint,
		SequenceForNewROW int,
		NewEEIQty numeric(20,6),
		MinRowID int )


	update	importedporel
	set		OrderNo = (	select	Max(SalesOrderNo)
						from	BlanketOrderInquiry
						where	BlanketOrderInquiry.BlanketPart = importedporel.part and ActiveFlag = 1 )
	from	importedporel
	--where	OperatorCode = @OperatorCode

	update	importedporel
	set		OrderNo = (	select	Max(SalesOrderNo)
						from	BlanketOrderInquiry
						where	left(BlanketOrderInquiry.BlanketPart,7) = left(importedporel.part,7) and ActiveFlag = 1 )
	from	importedporel
	where	OrderNo is null
			--and OperatorCode = @OperatorCode

	update	importedporel
	set		OrderNo = (	select	Max(order_no)
						from	order_header
						where	left(order_header.Blanket_Part,7) = left(importedporel.part,7)
								and order_header.Blanket_Part not like '%-PT%' )
	from	importedporel
	where	OrderNo is null
			--and OperatorCode = @OperatorCode

	insert into #OrderDetailCalculations( Orderno, Part, DueDate,  OrderQty, Sequence )
	select	order_detail.Order_no, order_detail.part_number, order_detail.due_date,  order_detail.quantity, Sequence
	from	order_detail
			join importedporel on order_detail.Order_no = isnull(importedporel.Orderno,0) and importedporel.Part = order_detail.part_number
	--where	importedporel.OperatorCode = @OperatorCode

	insert into #OrderDetailCalculations( Orderno, Part, DueDate, SaleQty )
	select	Orderno, part, Due_Date, Qty = EEIQty
	from	importedporel
	where	OrderNo is not null
			--and importedporel.OperatorCode = @OperatorCode

	insert into #NewOrderValues( OrderNo, Part, DueDate, IsNewRow, SequenceForNewROW, NewEEIQty )
	select	OrderNo, Part, DueDate, 		
			IsNewRow = case when sum(OrderQty) is null then 1 else 0 end,
			SequenceForNewROW = isnull((select Max(Sequence) from #OrderDetailCalculations Dates where Dates.DueDate < FinalReport.DueDate and isnull(Dates.OrderQty,0) >0),0),
			NewSalesQty = isnull(sum(SaleQty),0)
	from	#OrderDetailCalculations FinalReport
	group by Part, DueDate, OrderNo
	having	not (sum(OrderQty) is null and isnull(sum(SaleQty ),0) =  0)
	
	update	#NewOrderValues
	set		SequenceForNewROW = 1
	where	SequenceForNewROW <= 0

	insert into order_detail( Order_no, Part_number, type, Product_Name, Quantity, Price, Our_Cum, The_Cum, Due_Date, Sequence, Destination, 
							Unit, Committed_Qty, Row_ID, Plant, Release_no, flag,
							week_no, std_qty, Customer_part, ship_type, weight, engineering_level, box_label, Pallet_label, alternate_price )
	select	Order_no, Part_number, type, Product_Name, Quantity = 0, Price, Our_Cum, The_Cum, NewOrders.DueDate, Sequence = 0, Destination, Unit, Committed_Qty, 
			Row_ID = 0, Plant, Release_no, flag,week_no = datediff( week,  '2001-01-01', NewOrders.DueDate), std_qty = 0, Customer_part, ship_type, 
			weight, engineering_level, box_label, Pallet_label, alternate_price
	from	#NewOrderValues NewOrders
			join order_detail on order_detail.part_number = NewOrders.Part and NewOrders.OrderNo = order_detail.Order_no
								and order_detail.Sequence= NewOrders.SequenceForNewROW
	where	IsNewRow = 1

	update	order_detail
	set		eeiqty = 0
	from	order_detail
	where	left( order_detail.part_number, 7) in (select left(importedporel.part,7) from importedporel 
	--where importedporel.OperatorCode = @OperatorCode 
	)
	
	--order_no in (	select	distinct SalesOrderNo
	--						from	BlanketOrderInquiry
	--								join importedporel on left(BlanketOrderInquiry.BlanketPart,7) = left(importedporel.part,7)  ) 
			
	update	order_detail
	set		sequence = (select	count(1)
						from	order_detail NewOrders
						where	order_detail.part_number = NewOrders.part_number and NewOrders.Order_no = order_detail.Order_no
									and (NewOrders.due_date < order_detail.due_date or
											( NewOrders.due_date = order_detail.due_date and NewOrders.ID <= order_detail.id) ) ),
			row_id = (select	count(1)
						from	order_detail NewOrders
						where	order_detail.part_number = NewOrders.part_number and NewOrders.Order_no = order_detail.Order_no
									and NewOrders.ID <= order_detail.id )
	from	#NewOrderValues NewOrders
			join order_detail on order_detail.part_number = NewOrders.Part and NewOrders.OrderNo = order_detail.Order_no


	update	#NewOrderValues
	set		MinRowID = (select	min(row_id) 
						from	order_detail 
						where	order_detail.part_number = NewOrders.Part 
								and NewOrders.OrderNo = order_detail.Order_no
								and datediff( day, order_detail.due_date, NewOrders.DueDate) = 0 )
	from	#NewOrderValues NewOrders

	update	order_detail
	set		eeiqty = NewEEIQty
	from	#NewOrderValues NewOrders
			join order_detail on order_detail.part_number = NewOrders.Part and NewOrders.OrderNo = order_detail.Order_no
									and datediff( day, order_detail.due_date, NewOrders.DueDate) = 0
									and NewOrders.MinRowID = order_detail.row_id


end

--if @SalesOrder = 'YES' begin
--	if	Not exists(	select	1
--				from	importedporel
--				where	OrderNo is null 
--						and OperatorCode = @OperatorCode) begin
--		set	@Result = 0
--	end
--end
--else
--	set	@Result = 0


select	*
from	po_detail
where	exists
	(	select	1
		from	importedporel
		where	po_detail.po_number = importedporel.po_number and
			po_detail.part_number = importedporel.part)
order by
	po_number,
	part_number,
	date_due
GO
