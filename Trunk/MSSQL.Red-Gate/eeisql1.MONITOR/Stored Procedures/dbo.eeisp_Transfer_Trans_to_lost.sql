SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[eeisp_Transfer_Trans_to_lost] (	@OperatorPWD varchar(10),
						@keycode varchar(15), 
						@note varchar(255),
						@Result integer = 0 output)
 as


set nocount on

set	@Result = 999999


declare	@TransDate datetime,
	@RowCount int,
	@operator varchar(5),
	@Error int,
	@year int,
	@month int,
	@day int,
	@keyvalid varchar(20)

Select	@transDate = Getdate()

Select @year=datepart(Year, @transDate)
Select @month = datepart(Month, @transDate)
Select @day=datepart(Day, @transDate)

Select @keyvalid = 'PISTONS'+convert(varchar(10),@year)+convert(varchar(10),@month)+convert(varchar(10),@day)


if	UPPER(@Keycode) !=  @keyvalid begin

	RAISERROR ('Invalid Key Code', 16, 1, @keycode)
	return	-1
end

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

begin transaction TransferSerials

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
		'T',
		object.part,
		IsNull ( object.quantity, 1),
		'Transfer',
		0,
		'',
		'',
		'',
		object.po_number,
		@operator,
		object.location,
		'LOST',
		part_online.on_hand,
		object.lot,
		object.weight,
		object.status,
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
		@Note,
		'',
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
		join	vw_eei_Lost_trans on object.serial = vw_eei_Lost_trans.serial

select	@Error = @@Error,
	@RowCount = @@Rowcount


if	@Error != 0  or @RowCount !> 0 begin
	set	@Result = 999999
	RAISERROR ('Zero Serials Transferred%S', 16, 1, '-Auto Transfer Process')
	rollback tran TransferSerials
	return	@Result
end

Select * into #tempLost 
from vw_eei_Lost_trans 


Update	object
set	location = 'LOST',
	operator = @operator,
	last_date = @TransDate,
	last_time = @TransDate,
	note = @note
from	object
join	vw_eei_Lost_trans on object.serial = vw_eei_Lost_trans.serial

select	@Error = @@Error,
	@RowCount = @@Rowcount


if	@Error != 0  or @RowCount !> 0 begin
	set	@Result = 999999
	RAISERROR ('Zero Serials Updated%S', 16, 1, '-Auto Transfer Process')
	rollback tran TransferSerials
	return	@Result
end

commit transaction TransferSerials


--	Success.
set	@Result = 0


Select Serial, Part, 'Transferred to Lost' from #tempLost

return	@Result
GO
