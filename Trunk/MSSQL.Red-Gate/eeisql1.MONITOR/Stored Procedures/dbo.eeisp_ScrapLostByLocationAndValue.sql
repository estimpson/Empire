SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [dbo].[eeisp_ScrapLostByLocationAndValue] (	@OperatorPWD varchar(10),
						@DollarAmount numeric(20,6), 
						@location varchar(15),
						@Result integer = 0 output)
 as
-- exec [dbo].[eeisp_ScrapLostByLocationAndValue] '14', 19838.50 , 'TRAN7-20FR'

set nocount on

set	@Result = 999999


declare	@TransDate datetime,
	@RowCount int,
	@operator varchar(5),
	@Error int,
	@year int,
	@month int,
	@day int

Select	@transDate = Getdate()

Select @year=datepart(Year, @transDate)
Select @month = datepart(Month, @transDate)
Select @day=datepart(Day, @transDate)


if	not exists
	(	select	1
		from	employee
		where	password = @OperatorPWD) begin

	RAISERROR ('Invalid Operator Password', 16, 1, @OperatorPWD)
	return	-1
end

Select	@operator = operator_code
from		employee
Where	password = @operatorPWD

Select	@transDate = Getdate()

begin transaction ScrapSerials


--Get Running Total of dollar amount
Select	serial,
		(Select	sum(quantity*cost_cum)
			from	object o2
			join	part_standard on o2.part = part_standard.part
			where	o2.serial <= object.serial and
					o2.location = object.location) as running_inventory_value
into	#tempSerials

From	object
where	location = @location
order	by serial

Select	serial
into	#serialstoscrap
from	#tempSerials
where	running_inventory_value<=@DollarAmount

Select	*
from	#serialstoscrap


insert	audit_trail (
	serial,
	date_stamp,
	type,
	part,
	quantity,
	remarks,
	price,
	salesman,
	customer,
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
	workorder,
	std_quantity,
	cost,
	custom1,
	custom2,
	custom3,
	custom4,
	custom5,
	plant,
	notes,
	gl_account,
	package_type,
	suffix,
	due_date,
	group_no,
	sales_order,
	release_no,
	std_cost,
	user_defined_status,
	engineering_level,
	parent_serial,
	destination,
	sequence,
	object_type,
	part_name,
	start_date,
	field1,
	field2,
	show_on_shipper,
	tare_weight,
	kanban_number,
	dimension_qty_string,
	dim_qty_string_other,
	varying_dimension_code )
	select	object.serial,
		@TransDate,
		'Q',
		object.part,
		IsNull ( object.quantity, 1),
		'Quality',
		0,
		'',
		'',
		'',
		object.po_number,
		@operator,
		'H',
		'S',
		part_online.on_hand,
		object.lot,
		object.weight,
		'S',
		NULL,
		object.unit_measure,
		object.workorder,
		object.std_quantity,
		object.cost,
		object.custom1,
		object.custom2,
		object.custom3,
		object.custom4,
		object.custom5,
		object.plant,
		'',
		'11',
		object.package_type,
		object.suffix,
		object.date_due,
		'',
		'',
		'',
		object.std_cost,
		object.user_defined_status,
		object.engineering_level,
		object.parent_serial,
		'',
		object.sequence,
		object.type,
		object.name,
		object.start_date,
		object.field1,
		object.field2,
		object.show_on_shipper,
		object.tare_weight,
		object.kanban_number,
		object.dimension_qty_string,
		object.dim_qty_string_other,
		object.varying_dimension_code
	from	object
		left outer join part_online on object.part = part_online.part
		Where	serial in (select serial From #SerialsToScrap)
		
		insert	audit_trail (
	serial,
	date_stamp,
	type,
	part,
	quantity,
	remarks,
	price,
	salesman,
	customer,
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
	workorder,
	std_quantity,
	cost,
	custom1,
	custom2,
	custom3,
	custom4,
	custom5,
	plant,
	notes,
	gl_account,
	package_type,
	suffix,
	due_date,
	group_no,
	sales_order,
	release_no,
	std_cost,
	user_defined_status,
	engineering_level,
	parent_serial,
	destination,
	sequence,
	object_type,
	part_name,
	start_date,
	field1,
	field2,
	show_on_shipper,
	tare_weight,
	kanban_number,
	dimension_qty_string,
	dim_qty_string_other,
	varying_dimension_code )
	select	object.serial,
		dateadd(s,1,@TransDate),
		'D',
		object.part,
		0,
		'Delete',
		0,
		'',
		'',
		'',
		object.po_number,
		@operator,
		object.location,
		'Trash',
		part_online.on_hand,
		object.lot,
		object.weight,
		'S',
		NULL,
		object.unit_measure,
		object.workorder,
		0,
		object.cost,
		object.custom1,
		object.custom2,
		object.custom3,
		object.custom4,
		object.custom5,
		object.plant,
		'',
		'11',
		object.package_type,
		object.suffix,
		object.date_due,
		'',
		'',
		'',
		object.std_cost,
		object.user_defined_status,
		object.engineering_level,
		object.parent_serial,
		'',
		object.sequence,
		object.type,
		object.name,
		object.start_date,
		object.field1,
		object.field2,
		object.show_on_shipper,
		object.tare_weight,
		object.kanban_number,
		object.dimension_qty_string,
		object.dim_qty_string_other,
		object.varying_dimension_code
	from	object
		left outer join part_online on object.part = part_online.part
		Where	serial in (select serial From #SerialsToScrap)
		
Delete	from object where serial in (select serial From #SerialsToScrap)

select	@Error = @@Error,
		@RowCount = @@Rowcount


if	@Error != 0  or @RowCount !> 0 begin
	set	@Result = 999999
	RAISERROR ('Zero Serials Scrapped%S', 16, 1, '-Auto Scrap Process')
	rollback tran ScrapSerials
	return	@Result
end

commit transaction ScrapSerials


--	Success.
set	@Result = 0


Select	Serial, 
		audit_trail.Part, 
		from_loc, 
		to_loc,
		quantity,
		cost_cum*quantity as ExtendedSerialCost
from	audit_trail
join	part_standard on audit_trail.part = part_standard.part 
where	date_stamp = @TransDate and
		audit_trail.type = 'Q' and
		to_loc = 'S' and
		serial in (select serial from #SerialsToScrap)

return	@Result

GO
