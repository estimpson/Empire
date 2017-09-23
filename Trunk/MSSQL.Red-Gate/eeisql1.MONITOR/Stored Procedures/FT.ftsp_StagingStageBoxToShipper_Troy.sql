SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [FT].[ftsp_StagingStageBoxToShipper_Troy]
(	@Operator varchar (10),
	@ShipperID integer,
	@BoxSerial integer,
	@PalletSerial integer,
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

execute	@ProcReturn = FT.ftsp_StagingStageBoxToShipper_Troy
	@ShipperID = ?,
	@BoxSerial = ?,
	@Result = @ProcResult output

select	@ProcReturn,
	@ProcResult

rollback
:End Example
*/
as
set nocount on
set	@Result = 999999

--<Tran Required=Yes AutoCreate=No>
if	@@TranCount = 0 begin
	set	@Result = 900001
	RAISERROR (@Result, 16, 1, 'StagingStageBoxToShipper_Troy')
	return	@Result
end
--</Tran>

--	Declarations:
declare	@TranType char (1),
	@Remark varchar (10),
	@Notes varchar (50)

set	@TranType = 'T'
set	@Remark = 'STAGE-BOX'
set	@Notes = 'Add a box to a shipper.'

--	I.	Update the object location and shipper.
declare	@ShippingDock varchar (10),
	@ObjectLocation varchar (10)

select	@ShippingDock = shipping_dock
from	shipper
where	id = @ShipperID

select	@ObjectLocation = location
from	object
where	serial = @BoxSerial

update	object
set	last_date = GetDate (),
	operator = @Operator,
	last_time = GetDate (),
	location = coalesce (@ShippingDock, location),
	shipper = @ShipperID,
	show_on_shipper = case when @PalletSerial is null then 'Y' else 'N' end,
	parent_serial = @PalletSerial
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
