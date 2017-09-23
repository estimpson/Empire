SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_RFInvCtrl_Transfer_old]
(	@Operator varchar (10),
	@Serial integer,
	@NewLocationCode varchar (10),
	@Result integer = 0 output
--<Debug>
	, @Debug integer = 0
--</Debug>
)
/*
Example:
begin transaction

select	*
from	object
where	serial = 546871

select	*
from	audit_trail
where	serial = 546871

declare	@ProcReturn int,
	@ProcResult int

execute	@ProcReturn = FT.ftsp_RFInvCtrl_Transfer
	@Operator = 'MON',
	@Serial = 546871,
	@NewLocationCode = 'C-1-1',
	@Result = @ProcResult output

select	@ProcReturn,
	@ProcResult

select	*
from	object
where	serial = 546871

select	*
from	audit_trail
where	serial = 546871

rollback
:End Example
*/
as
set nocount on
set	@Result = 999999

--<Tran Required=Yes AutoCreate=No>
if	@@TranCount = 0 begin
	set	@Result = 900001
	RAISERROR (@Result, 16, 1, 'Transfer')
	return	@Result
end
save tran Transfer 
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

set	@TranType = 'T'
set	@Remark = 'Transfer'
set	@Notes = 'Serial traferred by RF Inventory Control.'

--	I.	Update the object(s) location.
declare	@ObjectLocation varchar (10)

select	@ObjectLocation = min (location)
from	object
where	serial = @Serial or
	parent_serial = @Serial

update	object
set	operator = @Operator,
	location = @NewLocationCode,
	last_date = GetDate ()
where	serial = @Serial or
	parent_serial = @Serial

set	@Error = @@Error
if @Error != 0 begin
	set	@Result = 201
	rollback tran Transfer
	return	@Result
end

--	II.	Insert audit trail.
insert	audit_trail
(	serial,
	date_stamp,
	type,
	part,
	quantity,
	remarks,
	vendor,
	po_number,
	operator,
	from_loc,
	to_loc,
	on_hand,
	parent_serial,
	lot,
	weight,
	status,
	shipper,
	unit,
	std_quantity,
	cost,
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
	(	select	vendor_code
		from	po_header
		where	po_number = object.po_number),
	object.po_number,
	object.operator,
	@ObjectLocation,
	object.location,
	(	select	on_hand
		from	part_online
		where	part = object.part),
	object.parent_serial,
	object.lot,
	object.weight,
	object.status,
	object.shipper,
	object.unit_measure,
	object.std_quantity,
	object.cost,
	object.plant,
	@Notes,
	object.package_type,
	object.cost,
	object.user_defined_status,
	object.tare_weight
from	object object
where	object.serial = @Serial or
	object.parent_serial = @Serial

--	III.	Staged.
set	@Result = 0
return	@Result
GO
