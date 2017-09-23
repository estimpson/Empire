SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[HCSP_CratePottingChange]( 
				@OldPart varchar(25), 
				@NewPart varchar(25),
				@MaterialCum decimal(20,6),
				@TransferPrice decimal(20,6),
				@Result int output )
as
/*
Example
begin Tran

declare	@RC int, @RetValue int,
		@part varchar(25)
		
	
set		@part  = 'AUT0038-HB03'
exec @RC = HCSP_CratePottingChange
		@OldPart = 'AUT0038-HB02',
		@NewPart = 'AUT0038-HB03',
		@MaterialCum  = 3.29,
		@TransferPrice = 3.96, 
		@Result = @RetValue out		

select	@RetValue , @RC

select	*
from	part
where	part = @part 

select	*
from	part_online
where	part = @part

select	*
from	order_header
where	blanket_part = @part 

select	*
from	po_header
where	blanket_part = @part 

select	*
from	part_vendor
where	part = @Part


select	*
from	part_vendor_price_matrix 
where	part = @Part

select	*
from	part_customer
where	part = @Part

select	*
from	part_customer_price_matrix
where	part = @Part

rollback
*/
SET nocount ON

SET	@Result = 999999

--<Tran Required=Yes AutoCreate=Yes>
DECLARE	@TranCount SMALLINT
SET	@TranCount = @@TranCount
IF	@TranCount = 0 
	BEGIN TRANSACTION HCSP_CratePottingChange
ELSE
	SAVE TRANSACTION HCSP_CratePottingChange
--</Tran>

--<Error Handling>
DECLARE @ProcReturn integer, @ProcResult integer
DECLARE @Error integer,	@RowCount integer
--</Error Handling>


declare @TranDT datetime

set	@TranDT = convert(datetime, floor(convert( real, getdate())))


--Validate if the main part exists
--print	'Validate if the main part exists'
if not exists(select 1
			from	part
			where	part.part = @OldPart)
begin
	set	@Result = 20000
	rollback tran HCSP_CratePottingChange
	raiserror( 'The part %s does not exists.',16,1, @OldPart)
	return @Result
end

if exists((select 1
			from	part
			where	part.part = @NewPart))
begin
	set	@Result = 20000
	rollback tran	HCSP_CratePottingChange
	raiserror( 'The part %s already exists.',16,1, @NewPart)
	return @Result
end

--a)	Start coping the setup information of the main part
exec msp_copypart1
	@oldpart = @OldPart,
	@newpart = @NewPart, 
	@returnvalue = @ProcResult output

select	@Error = @@error  

if	@ProcResult != 0
begin
	set	@Result = 20001
	rollback tran	HCSP_CratePottingChange
	raiserror( 'The part %s can not be create by msp_copypart',16,1, @NewPart)
	return @Result
end

if	@Error != 0
begin
	set	@Result = 20001
	rollback tran	HCSP_CratePottingChange
	raiserror( 'An error ocurr when try to copy the part %s',16,1, @NewPart)
	return @Result
end


--Update the cost of the product
update	part_standard
set		material_cum = @MaterialCum,
		material = @MaterialCum,
		cost_cum = @MaterialCum,
		cost = @MaterialCum ,
		price = @TransferPrice,
		labor = 0,
		labor_cum = 0,
		burden = 0,
		burden_cum = 0,
		other = 0,
		other_cum = 0
where	part = @NewPart


select	@Error = @@error,
		@RowCount = @@rowcount

if	@RowCount != 1
begin
	set	@Result = 20002
	rollback tran	HCSP_CratePottingChange
	raiserror( 'The part %s can not be create on Part Standard',16,1, @NewPart)
	return @Result
end


if	@Error != 0
begin
	set	@Result = 20003
	rollback tran	HCSP_CratePottingChange
	raiserror( 'An error ocurr when try to create Part Standard of the part %s',16,1, @NewPart)
	return @Result
end


insert into part_customer (
	part,
	customer,
	customer_part,
	customer_standard_pack,
	taxable,
	customer_unit,
	[type],
	upc_code,
	blanket_price,
	LeadTime,
	FABLeadTime,
	MaterialLeadTime,
	AllowedPosVariance,
	AllowedNegVariance )
select 	@Newpart,
	customer,
	customer_part,
	customer_standard_pack,
	taxable,
	customer_unit,
	[type],
	upc_code,
	blanket_price,
	LeadTime,
	FABLeadTime,
	MaterialLeadTime,
	AllowedPosVariance,
	AllowedNegVariance
from	part_customer
where	part = @Oldpart

select	@Error = @@error,
		@RowCount = @@rowcount

if	@Error != 0
begin
	set	@Result = 20003
	rollback tran	HCSP_CratePottingChange
	raiserror( 'An error ocurr when try to create Part Standard of the part %s',16,1, @NewPart)
	return @Result
end


insert into part_customer_price_matrix (
	part,
	customer,
	code,
	price,
	qty_break,
	discount,
	category,
	alternate_price)
select		@NewPart,
		customer,
		code,
		@TransferPrice,
		qty_break,
		discount,
		category,
		@TransferPrice
from	part_customer_price_matrix
where	part = @OldPart


select	@Error = @@error,
		@RowCount = @@rowcount

if	@Error != 0
begin
	set	@Result = 20003
	rollback tran	HCSP_CratePottingChange
	raiserror( '%part_customer_price_matrix of the part %s',16,1, @NewPart)
	return @Result
end

insert into part_vendor (
	part,
	vendor,
	vendor_part,
	vendor_standard_pack,
	accum_received,
	accum_shipped,
	outside_process,
	qty_over_received,
	receiving_um,
	part_name,
	lead_time,
	min_on_order,
	beginning_inventory_date,
	note,
	FABAuthDays,
	ReceiptAuthDays,
	min_release_qty )
select		@newpart,
	vendor,
	vendor_part,
	vendor_standard_pack,
	accum_received,
	accum_shipped,
	outside_process,
	qty_over_received,
	receiving_um,
	part_name,
	lead_time,
	min_on_order,
	beginning_inventory_date,
	note,
	FABAuthDays,
	ReceiptAuthDays,
	min_release_qty
from	part_vendor 
where	part = @Oldpart


select	@Error = @@error,
		@RowCount = @@rowcount

if	@Error != 0
begin
	set	@Result = 20003
	rollback tran	HCSP_CratePottingChange
	raiserror( 'An error ocurr when try to create part_vendor of the part %s',16,1, @NewPart)
	return @Result
end

insert into part_vendor_price_matrix (
	part,
	vendor,
	price,
	break_qty,
	code,
	alternate_price,
	min_release_qty )
select		@NewPart,
	vendor,
	@TransferPrice,
	break_qty,
	code,
	@TransferPrice,
	min_release_qty 
from part_vendor_price_matrix
where	part = @OldPart

select	@Error = @@error,
		@RowCount = @@rowcount

if	@Error != 0
begin
	set	@Result = 20003
	rollback tran	HCSP_CratePottingChange
	raiserror( 'An error ocurr when try to create part_vendor of the part %s',16,1, @NewPart)
	return @Result
end


--	Create the Sales Order
declare @SalesOrder int
declare @OldOrder int


declare Orders cursor local 	
for select	order_no
	from	order_header
	where	blanket_part = @OldPart

open Orders

fetch next from orders
into @OldOrder



while @@fetch_status = 0
Begin

	SELECT	@SalesOrder = sales_order
	FROM	parameters with (TABLOCKX)

	WHILE	EXISTS
		(	SELECT	1
			FROM	order_header
			WHERE	order_no BETWEEN @SalesOrder AND @SalesOrder)
	BEGIN
		SET	@SalesOrder = @SalesOrder + 1
	END

	UPDATE	parameters
	SET	sales_order = @SalesOrder + 1

	insert into order_header (
		order_no,
		customer,
		order_date,
		contact,
		destination,
		blanket_part,
		model_year,
		customer_part,
		box_label,
		pallet_label,
		standard_pack,
		our_cum,
		the_cum,
		order_type,
		amount,
		shipped,
		deposit,
		artificial_cum,
		shipper,
		status,
		location,
		ship_type,
		unit,
		revision,
		customer_po,
		blanket_qty,
		price,
		price_unit,
		salesman,
		zone_code,
		term,
		dock_code,
		package_type,
		plant,
		notes,
		shipping_unit,
		line_feed_code,
		fab_cum,
		raw_cum,
		fab_date,
		raw_date,
		po_expiry_date,
		begin_kanban_number,
		end_kanban_number,
		line11,
		line12,
		line13,
		line14,
		line15,
		line16,
		line17,
		custom01,
		custom02,
		custom03,
		quote,
		due_date,
		engineering_level,
		currency_unit,
		alternate_price,
		show_euro_amount,
		cs_status)
	select 	
		@SalesOrder,
		customer,
		order_date,
		contact,
		destination,
		@NewPart,
		model_year,
		customer_part,
		box_label,
		pallet_label,
		standard_pack,
		0,
		the_cum,
		order_type,
		amount,
		shipped,
		deposit,
		artificial_cum,
		shipper,
		status,
		location,
		ship_type,
		unit,
		revision,
		customer_po,
		blanket_qty,
		price,
		price_unit,
		salesman,
		zone_code,
		term,
		dock_code,
		package_type,
		plant,
		notes,
		shipping_unit,
		line_feed_code,
		fab_cum,
		raw_cum,
		fab_date,
		raw_date,
		po_expiry_date,
		begin_kanban_number,
		end_kanban_number,
		line11,
		line12,
		line13,
		line14,
		line15,
		line16,
		line17,
		custom01,
		custom02,
		custom03,
		quote,
		due_date,
		engineering_level,
		currency_unit,
		alternate_price,
		show_euro_amount,
		cs_status
	from	order_header
	where	order_no = @OldOrder

	select	@Error = @@error,
			@RowCount = @@rowcount

	if	@Error != 0
	begin
		set	@Result = 20003
		rollback tran	HCSP_CratePottingChange
		raiserror( 'An error ocurr when try to create part_vendor of the part %s',16,1, @NewPart)
		return @Result
	end


	fetch next from orders
	into @OldOrder

End


--Generate PO
declare @PONumber int
declare @OldPO int
declare @OldDefaultPO int

select	@OldDefaultPO = default_po_number
from	Part_online
where	part = @OldPart

declare POs cursor local 	
for select	po_number
	from	po_header
	where	blanket_part = @OldPart

open POs

fetch next from POs
into @OldPO



while @@fetch_status = 0
Begin

	SELECT	@PONumber = purchase_order
	FROM	parameters with (TABLOCKX)

	WHILE	EXISTS
		(	SELECT	1
			FROM	po_header
			WHERE	po_number BETWEEN @PONumber AND @PONumber)
	BEGIN
		SET	@PONumber = @PONumber + 1
	END

	UPDATE	parameters
	SET	purchase_order = @PONumber + 1

	insert into po_header (
		po_number,
		vendor_code,
		po_date,
		date_due,
		terms,
		fob,
		ship_via,
		ship_to_destination,
		status,
		[type],
		description,
		plant,
		freight_type,
		buyer,
		printed,
		notes,
		total_amount,
		shipping_fee,
		sales_tax,
		blanket_orderded_qty,
		blanket_frequency,
		blanket_duration,
		blanket_qty_per_release,
		blanket_part,
		blanket_vendor_part,
		price,
		std_unit,
		ship_type,
		flag,
		release_no,
		release_control,
		tax_rate,
		scheduled_time,
		trusted,
		currency_unit,
		show_euro_amount,
		ppap,
		idms,
		cum_received_qty,
		next_seqno,
		ship_from ) 
	select			
		@PONumber,
		vendor_code,
		po_date,
		date_due,
		terms,
		fob,
		ship_via,
		ship_to_destination,
		status,
		[type],
		description,
		plant,
		freight_type,
		buyer,
		printed,
		notes,
		total_amount,
		shipping_fee,
		sales_tax,
		blanket_orderded_qty,
		blanket_frequency,
		blanket_duration,
		blanket_qty_per_release,
		@newPart,
		blanket_vendor_part,
		price,
		std_unit,
		ship_type,
		flag,
		release_no,
		release_control,
		tax_rate,
		scheduled_time,
		trusted,
		currency_unit,
		show_euro_amount,
		ppap,
		idms,
		cum_received_qty,
		next_seqno,
		ship_from
	from	po_header 
	where	po_number  = @OldPO

	if @OldDefaultPO = @OldPO
	BEGIN
		update	part_online
		set		default_po_number = @PONumber
		where	part = @NewPart
	END

	fetch next from orders
	into @OldPO

End

if	@TranCount = 0 begin
	commit transaction HCSP_CratePottingChange
end
--</CloseTran Required=Yes AutoCreate=Yes>

set	@Result = 0
return	@Result
GO
