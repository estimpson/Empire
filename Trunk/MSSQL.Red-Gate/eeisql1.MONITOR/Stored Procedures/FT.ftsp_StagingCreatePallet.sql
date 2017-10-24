SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_StagingCreatePallet]
(	@Operator varchar (10),
	@ShipperID integer,
	@PalletSerial integer output,
	@Result integer = 0 output
--<Debug>
	, @Debug integer = 0
--</Debug>
)
as
/*
Example:
begin transaction

declare	@ProcReturn int,
	@ProcResult int,
	@NextSerial int

select	@NextSerial = next_serial
from	parameters

execute	@ProcReturn = FT.ftsp_StagingCreatePallet
	@Operator = 'MON',
	@Pallets = 15,
	@Result = @ProcResult output

select	@ProcReturn,
	@ProcResult

select	*
from	object
where	serial >= @NextSerial

rollback
:End Example
*/
set nocount on
set	@Result = 999999

--<Tran Required=Yes AutoCreate=Yes>
declare	@TranCount smallint
set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin transaction StagingCreatePallet
end
save transaction StagingCreatePallet
--</Tran>

--	Argument Validation:
--		Operator required:
if	not exists
	(	select	1
		from	employee
		where	operator_code = @Operator) begin

	set	@Result = 60001
	rollback tran StagingCreatePallet
	RAISERROR (@Result, 16, 1, @Operator)
	return	@Result
end

--	Declarations:
declare	@Part varchar (25),
	@WeekNo integer,
	@Unit char (2),
	@Status char (1),
	@UserStatus varchar (10),
	@ObjectType char (1),
	@TranType char (1),
	@Remark varchar (10),
	@Notes varchar (50)

set	@Part = 'PALLET'
set	@WeekNo = DatePart (week, GetDate ())
set	@Unit = 'EA'
set	@Status = 'A'
set	@UserStatus = 'Approved'
set	@ObjectType = 'S'
set	@TranType = 'P'
set	@Remark = 'PALLET'
set	@Notes = 'New shipper pallet.'

--	I.	Get a block of serial numbers.
--<Debug>
if	@Debug & 1 = 1 begin
	print	'I.	Get a serial numbers.'
end
--</Debug>
select	@PalletSerial = next_serial
from	parameters with (TABLOCKX)

while	exists
	(	select	serial
		from	object
		where	serial = @PalletSerial) or
	exists
	(	select	serial
		from	audit_trail
		where	serial = @PalletSerial) begin

	set	@PalletSerial = @PalletSerial + 1
end

update	parameters
set	next_serial = @PalletSerial + 1

--	II.	Generate pallet.
--		A.	Create object.
declare	@ShippingDock varchar (10),
	@Plant varchar (10)

select	@ShippingDock = shipping_dock,
	@Plant = plant
from	shipper
where	id = @ShipperID

insert	object
(	serial,
	part,
	location,
	last_date,
	unit_measure,
	operator,
	status,
	plant,
	last_time,
	user_defined_status,
	type )
select	@PalletSerial,
	@Part,
	@ShippingDock,
	GetDate (),
	@Unit,
	@Operator,
	@Status,
	@Plant,
	GetDate (),
	@UserStatus,
	@ObjectType

--		B.	Create audit_trail.
insert	audit_trail
(	serial,
	date_stamp,
	type,
	part,
	quantity,
	remarks,
	operator,
	from_loc,
	to_loc,
	lot,
	weight,
	status,
	unit,
	std_quantity,
	plant,
	notes,
	package_type,
	std_cost,
	user_defined_status,
	tare_weight )
select	object.serial,
	object.last_date,
	@TranType,
	object.part,
	object.quantity,
	@Remark,
	object.operator,
	object.location,
	object.location,
	object.lot,
	object.weight,
	object.status,
	object.unit_measure,
	object.std_quantity,
	object.plant,
	@Notes,
	object.package_type,
	object.cost,
	object.user_defined_status,
	object.tare_weight
from	object object
where	object.serial = @PalletSerial
	
--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction StagingCreatePallet
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	IV.	Success.
set	@Result = 0
return	@Result
GO
