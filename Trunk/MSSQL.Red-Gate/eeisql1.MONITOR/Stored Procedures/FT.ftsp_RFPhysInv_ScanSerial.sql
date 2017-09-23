SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FT].[ftsp_RFPhysInv_ScanSerial]
(	@Operator varchar (10),
	@BoxSerial int,
	@Aisle char(1),
	@Shelf int,
	@Subshelf int,
	@Result integer = 0 output
--<Debug>
	, @Debug integer = 0
--</Debug>
)
/*
Example:
begin transaction

declare	@ProcReturn int,
	@ProcResult int

execute	@ProcReturn = FT.ftsp_RFPhysInv_ScanSerial
	@Operator = 'MON',
	@BoxSerial = 2086,
	@Aisle = 'C',
	@Shelf = 1,
	@Subshelf = 10,
	@Result = @ProcResult output

select	@ProcReturn,
	@ProcResult

select	*
from	FT.WarehouseInventory WarehouseInventory
where	Serial = 2086

select	*
from	audit_trail
where	serial = 2086

rollback
:End Example
*/
as
set nocount on
set	@Result = 999999

--<Tran Required=Yes AutoCreate=No>
if	@@TranCount = 0 begin
	set	@Result = 900001
	RAISERROR (@Result, 16, 1, 'BeginPhysical')
	return	@Result
end
save tran BeginPhysical 
--</Tran>

--<Error Handling>
declare	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer
--</Error Handling>

--	Declarations:
declare	@TranType char (1),
	@Remark varchar (10),
	@Notes varchar (50)

set	@TranType = 'H'
set	@Remark = 'Phys Scan'
set	@Notes = 'Serial scanned during physical inventory.'

--	I.	Update the object location and shipper.
declare	@PhysicalLocation varchar (10),
	@ObjectLocation varchar (10)

set	@PhysicalLocation = @Aisle + '-' + convert (varchar, @Shelf) + '-' + convert (varchar, @Subshelf)
select	@ObjectLocation = location
from	object
where	serial = @BoxSerial

update	object
set	last_date = GetDate (),
	operator = @Operator,
	last_time = GetDate (),
	location = IsNull (@PhysicalLocation,'')
where	serial = @BoxSerial

--	II.	Insert audit trail.
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
	parent_serial,
	lot,
	weight,
	status,
	shipper,
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
	@ObjectLocation,
	object.location,
	object.parent_serial,
	object.lot,
	object.weight,
	object.status,
	object.shipper,
	object.unit_measure,
	object.std_quantity,
	object.plant,
	@Notes,
	object.package_type,
	object.cost,
	object.user_defined_status,
	object.tare_weight
from	object object
where	object.serial = @BoxSerial

--	III.	Staged.
set	@Result = 0
return	@Result
GO
