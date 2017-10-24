SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[csp_RF_ReceiveAccum_fxDelete]
(	@PONumber integer,
	@PartNumber varchar(25),
	@Operator varchar (5),
	@Quantity numeric (20,6),
	@Objects integer,
	@Shipper varchar (20) = null,
	@LotNumber varchar (20) = null,
	@SerialNumber integer = null output,
	@Result integer output )
as
/*
Arguments:
@PONumber	The po number to check the accum against.
@PartNumber	The partnumber to use in the check.
@Operator	The operator performing the operation.
@Quantity	The quantity to check.
@Objects	The number of objects to create.
@Shipper	The shipper on which the receipt came in on.
@LotNumberNumber	Lot number.
@SerialNumber	The serial number of the object created during the receipt.
@Result		Output result.

Result set:
None

Return values:
0	Success
-100	Unable to get next serial number
-101	Unable to create object
-102	Unable to create audit trail
-103	Unable to update part online
-104	Unable to update po detail
-105	Unable to update po detail history
-106	Unable to find next line item
-107	Unable to get conversion
-108	Unable to update part vendor
-109	Unable to delete po detail

Description:

Example:

Author:
Chris Rogers
Copyright © 2004 Fore-Thought, LLC

Process:
*/

--	I.	Declarations and Initializations.
--		A.	Declarations.
declare	@Conversion numeric (20,14),
	@RowID integer,
	@RemainingQuantity numeric (20,6),
	@ReceivedQuantity numeric (20,6),
	@LineBalance numeric (20,6),
	@DateStamp datetime,
	@TempSerial integer,
	@ObjectCount integer

--		B.	Initalize conversion factor and line item row id.
select	@Conversion = IsNull ( conversion, 1 ),
	@RowID = row_id
from	po_detail
	join part_inventory ON po_detail.part_number = part_inventory.part
	left outer join part_unit_conversion ON po_detail.part_number = part_unit_conversion.part
	left outer join unit_conversion ON part_unit_conversion.code = unit_conversion.code and
		unit_conversion.unit1 = part_inventory.standard_unit and
		unit_conversion.unit2 = po_detail.unit_of_measure
where	po_detail.po_number = @PONumber and
	po_detail.part_number = @PartNumber and
	po_detail.row_id =
	(	select	Min ( pod1.row_id )
		from	po_detail pod1
		where	pod1.po_number = po_detail.po_number and
			pod1.part_number = po_detail.part_number and
			pod1.status = 'A' and
			pod1.date_due =
			(	select	Min ( pod2.date_due )
				from	po_detail pod2
				where	pod2.po_number = po_detail.po_number and
					pod2.part_number = po_detail.part_number and
					pod2.status = 'A' ) )

--		C.	Initiliaze date stamp for transaction.
select	@DateStamp = GetDate ( )

--		D.	Initialize result
select @result = 0

--	II.	Validate that lot number has not already been received

--	III.	Generate Inventory.
--		A.	Get block of serial numbers.
update	parameters
set	next_serial = next_serial + @Objects

if @@error <> 0
begin
	select @result = -100
	return @result
end

select	@SerialNumber = next_serial - @Objects
from	parameters

if @@error <> 0
begin
	select @result = -100
	return @result
end

while exists 
(	select	serial
	from	object
	where	serial between @SerialNumber and @SerialNumber + @Objects )
	select	@SerialNumber = @SerialNumber + 1

update	parameters
set	next_serial = @SerialNumber + @Objects

if @@error <> 0
begin
	select @result = -100
	return @result
end

--		B.	Create Objects, update Part Online, and create Audit Trail records.
select	@ObjectCount = 0
while	@ObjectCount < @Objects
begin
	select @TempSerial = @SerialNumber + @ObjectCount
	
	IF exists
	(	select	1
		from	part
			join po_detail on po_detail.part_number = part.part
		where	po_number = @PONumber and
			row_id = @RowID )
	begin
		insert	object
		(	serial,
			part,
			lot,
			location,
			last_date,
			unit_measure,
			operator,
			status,
			origin,
			cost,
			note,
			po_number,
			name,
			plant,
			quantity,
			last_time,
			package_type,
			std_quantity,
			custom1,
			custom2,
			custom3,
			custom4,
			custom5,
			user_defined_status,
			std_cost,
			field1 )
		select	@TempSerial,
			po_detail.part_number,
			@LotNumber,
			part_inventory.primary_location,
			@DateStamp,
			po_detail.unit_of_measure,
			@Operator,
			(	CASE	WHEN IsNull ( part.quality_alert, 'N' ) = 'Y' THEN 'H'
					else 'A'
				end ),
			@Shipper,
			po_detail.price / @Conversion,
			null, --@note,
			convert(varchar,@PONumber),
			part.name,
			location.plant,
			@Quantity * @Conversion,
			@DateStamp,
			null, --@packagecode,
			@Quantity,
			null, --@custom1,
			null, --@custom2,
			null, --@custom3,
			null, --@custom4,
			null, --@custom5,
			(	CASE	WHEN IsNull ( part.quality_alert, 'N' ) = 'Y' THEN 'On Hold'
					else 'Approved'
				end ),
			po_detail.price / @Conversion,
		''
--			'RFReceipt'
		from	po_detail
			join part ON po_detail.part_number = part.part
			join part_inventory on part_inventory.part = part.part
			left outer join location ON code = part_inventory.primary_location
		where	po_number = @PONumber and
			row_id = @RowID and
			part.class <> 'N'
	
		if @@error <> 0 or @@rowcount <= 0
		begin
			select @result = -101
			return @result
		end
	end
	
	insert	audit_trail
	(	serial,
		date_stamp,
		type,
		part,
		quantity,
		remarks,
		price,
		vendor,
		po_number,
		operator,
		from_loc,
		to_loc,
		on_hand,
		lot,
		weight,
		status,
		shipper,
		unit,
		std_quantity,
		cost,
		control_number,
		custom1,
		custom2,
		custom3,
		custom4,
		custom5,
		plant,
		notes,
		gl_account,
		package_type,
		release_no,
		std_cost,
		user_defined_status,
		part_name,
		tare_weight,
		field1 )
	select	@TempSerial,
		@DateStamp,
		'R',
		po_detail.part_number,
		@Quantity * @Conversion,
		'Receiving',
		po_detail.price / @Conversion,
		po_header.vendor_code,
		convert(varchar,@PONumber),
		@Operator,
		po_header.vendor_code,
		object.location,
		IsNull ( part_online.on_hand, 0 ) + object.std_quantity,
		@LotNumber,
		IsNull ( object.weight, part_inventory.unit_weight * @Quantity ),
		(	CASE	WHEN IsNull ( part_vendor.outside_process, 'N' ) = 'Y' THEN 'P'
				else IsNull ( object.status, 'A' )
			end ),
		@Shipper,
		po_detail.unit_of_measure,
		@Quantity,
		po_detail.price / @Conversion,
		convert(varchar,po_detail.requisition_id),
		null, --@custom1,
		null, --@custom2,
		null, --@custom3,
		null, --@custom4,
		null, --@custom5,
		location.plant,
		null, --@note,
		part_purchasing.gl_account_code,
		null, --@packagecode,
		convert(varchar,po_detail.release_no),
		po_detail.price / @Conversion,
		(	CASE	WHEN IsNull ( part.quality_alert, 'N' ) = 'Y' THEN 'On Hold'
				else 'Approved'
			end ),
		IsNull ( object.name, po_detail.description ),
		object.tare_weight,
		''
--		'RFReceipt'
	from	object
		join location ON code = object.location
		join po_header ON po_header.po_number = @PONumber
		join po_detail ON po_detail.po_number = @PONumber
		left outer join part ON part.part = po_detail.part_number
		left outer join part_inventory ON part_inventory.part = po_detail.part_number
		left outer join part_online ON part_online.part = po_detail.part_number
		left outer join part_purchasing ON part_purchasing.part = po_detail.part_number
		left outer join part_vendor ON part_vendor.part = po_detail.part_number and
			part_vendor.vendor = po_header.vendor_code
		cross join parameters
	where	object.serial = @TempSerial and
		po_detail.row_id = @RowID
	
	if @@error <> 0 or @@rowcount <= 0
	begin
		select @result = -102
		return @result
	end

	select	@ObjectCount = @ObjectCount + 1
end

update	part_online
set	on_hand =
	(	select	Sum ( std_quantity )
		from	object
		where	part = part_online.part and
			status = 'A' )
where	part = @PartNumber

if @@error <> 0
begin
	select @result = -103
	return @result
end

--	IV.	update Purchase Order and Part-Vendor relationship.
select	@RemainingQuantity = @Quantity * @Objects
while	@RemainingQuantity > 0 and @RowID > 0
begin

--		A.	update the Line Item with receipt quantities and date.
	select	@LineBalance = balance
	from	po_detail
	where	po_number = @PONumber and
		row_id = @RowID
	
	IF @RemainingQuantity < @LineBalance
	begin
		update	po_detail
		set	received = received + @RemainingQuantity * @Conversion,
			balance = balance - @RemainingQuantity * @Conversion,
			standard_qty = @RemainingQuantity,
			last_recvd_date = @DateStamp,
			last_recvd_amount = @RemainingQuantity * @Conversion
		where	po_detail.po_number = @PONumber and
			po_detail.row_id = @RowID
		
		if @@error <> 0
		begin
			select @result = -104
			return @result
		end

		select	@ReceivedQuantity = @RemainingQuantity * @Conversion
		select	@RemainingQuantity = 0
	end
	else
	begin
		update	po_detail
		set	received = received + @LineBalance * @Conversion,
			balance = balance - @LineBalance * @Conversion,
			standard_qty = @LineBalance,
			last_recvd_date = @DateStamp,
			last_recvd_amount = @LineBalance * @Conversion
		where	po_detail.po_number = @PONumber and
			po_detail.row_id = @RowID
		
		if @@error <> 0
		begin
			select @result = -104
			return @result
		end

		select	@ReceivedQuantity = @LineBalance * @Conversion
		select	@RemainingQuantity = @RemainingQuantity - @LineBalance
	end
	
--		B.	Create receipt history.
	IF exists (	select	1
			from	po_detail_history
			where	po_number = @PONumber and
				row_id = @RowID )
	begin
		update	po_detail_history
		set	po_detail_history.received = po_detail.received,
			po_detail_history.balance = po_detail.balance,
			po_detail_history.standard_qty = po_detail.standard_qty,
			po_detail_history.last_recvd_date = po_detail.last_recvd_date,
			po_detail_history.last_recvd_amount = po_detail.last_recvd_amount
		from	po_detail
		where	po_detail_history.po_number = @PONumber and
			po_detail_history.row_id = @RowID and
			po_detail.po_number = po_detail_history.po_number and
			po_detail.row_id = po_detail_history.row_id

		if @@error <> 0
		begin
			select @result = -105
			return @result
		end
	end
	else
	begin
		insert	po_detail_history
		(	po_number,
			vendor_code,
			part_number,
			description,
			unit_of_measure,
			date_due,
			requisition_number,
			status,
			type,
			last_recvd_date,
			last_recvd_amount,
			cross_reference_part,
			account_code,
			notes,
			quantity,
			received,
			balance,
			active_release_cum,
			received_cum,
			price,
			row_id,
			invoice_status,
			invoice_date,
			invoice_qty,
			invoice_unit_price,
			release_no,
			ship_to_destination,
			terms,
			week_no,
			plant,
			invoice_number,
			standard_qty,
			sales_order,
			dropship_oe_row_id,
			ship_type,
			dropship_shipper,
			price_unit,
			ship_via,
			release_type,
			alternate_price )
		select	po_detail.po_number,
			po_detail.vendor_code,
			po_detail.part_number,
			po_detail.description,
			po_detail.unit_of_measure,
			po_detail.date_due,
			po_detail.requisition_number,
			'C',
			po_detail.type,
			@DateStamp,
			@ReceivedQuantity,
			po_detail.cross_reference_part,
			po_detail.account_code,
			null, --@note,
			po_detail.quantity,
			po_detail.received,
			po_detail.balance,
			po_detail.active_release_cum,
			po_detail.received_cum,
			po_detail.price,
			po_detail.row_id,
			po_detail.invoice_status,
			po_detail.invoice_date,
			po_detail.invoice_qty,
			po_detail.invoice_unit_price,
			po_detail.release_no,
			po_detail.ship_to_destination,
			po_detail.terms,
			po_detail.week_no,
			po_detail.plant,
			po_detail.invoice_number,
			po_detail.standard_qty,
			po_detail.sales_order,
			po_detail.dropship_oe_row_id,
			po_detail.ship_type,
			po_detail.dropship_shipper,
			po_detail.price_unit,
			po_detail.ship_via,
			po_detail.release_type,
			po_detail.alternate_price
		from	po_detail
		where	po_detail.po_number = @PONumber and
			po_detail.row_id = @RowID

		if @@error <> 0
		begin
			select @result = -105
			return @result
		end
	end

--		C.	Find next conversion factor and line item row id.
	select	@RowID = IsNull (
		(	select	Min ( pod1.row_id )
			from	po_detail pod1
			where	pod1.po_number = @PONumber and
				pod1.part_number = @PartNumber and
				pod1.status = 'A' and
				pod1.row_id > @RowID and
				pod1.date_due =
				(	select	Min ( pod2.date_due )
					from	po_detail pod2
					where	pod2.po_number = @PONumber and
						pod2.part_number = @PartNumber and
						pod2.row_id > @RowID and
						pod2.date_due >=
						(	select	pod3.date_due
							from	po_detail pod3
							where	pod3.po_number = @PONumber and
								pod3.row_id = @RowID ) and
						pod2.status = 'A' ) ), -1 )
	
	if @@error <> 0
	begin
		select @result = -106
		return @result
	end

	select	@Conversion = IsNull ( conversion, 1 )
	from	po_detail
		join part_inventory ON po_detail.part_number = part_inventory.part
		left outer join part_unit_conversion ON po_detail.part_number = part_unit_conversion.part
		left outer join unit_conversion ON part_unit_conversion.code = unit_conversion.code and
			unit_conversion.unit1 = part_inventory.standard_unit and
			unit_conversion.unit2 = po_detail.unit_of_measure
	where	po_detail.po_number = @PONumber and
		po_detail.row_id = @RowID

	if @@error <> 0
	begin
		select @result = -107
		return @result
	end

	select	@Conversion = IsNull ( @Conversion, 1 )
end

--		D.	update Part-Vendor relationship.
update	part_vendor
set	accum_received = IsNull ( accum_received, 0 ) + ( @Quantity * @Objects ),
	qty_over_received = @RemainingQuantity
where	part = 
	(	select	part_number
		from	po_detail
		where	po_number = @PONumber and
			po_detail.row_id = @RowID ) and
	vendor =
	(	select	vendor_code
		from	po_detail
		where	po_number = @PONumber and
			po_detail.row_id = @RowID )
	
if @@error <> 0
begin
	select @result = -108
	return @result
end

--		E.	Remove releases which have been fully met.
delete	po_detail
where	po_number = @PONumber and
	balance = 0

if @@error <> 0
begin
	select @result = -109
	return @result
end

return @result
GO
