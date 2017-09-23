SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[ftsp_ImportRleases]
as
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
