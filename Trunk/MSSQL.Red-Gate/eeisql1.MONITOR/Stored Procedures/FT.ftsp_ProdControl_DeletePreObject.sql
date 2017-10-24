SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_ProdControl_DeletePreObject]
    @Operator varchar(10)
,	@PreObjectSerial int
,	@Result int out
as
/*
begin transaction
declare	@ProcResult int,
	@ProcReturn int,
	@Operator varchar (10),
	@PreObjectSerial int

set	@Operator = 'Mon'
set	@PreObjectSerial = 6361257

execute	@ProcReturn = FT.ftsp_ProdControl_DeletePreObject
	@Operator = @Operator,
	@PreObjectSerial = @PreObjectSerial,
	@Result = @ProcResult  out

select	@ProcResult,
	@ProcReturn,
	@PreObjectSerial

select	*
from	audit_Trail
where	serial = @PreObjectSerial

rollback

*/
set nocount on
set	@Result = 999999

--<Tran Required=Yes AutoCreate=Yes>
declare	@TranCount smallint
set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin transaction ProdControlDeletePreObject
end
else
begin
	save transaction ProdControlDeletePreObject
end
--</Tran>

--<Error Handling>
declare	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer
--</Error Handling>

--	Argument Validation:
--		Operator required:
if	not exists
	(	select	1
		from	employee
		where	operator_code = @Operator) begin

	set	@Result = 60001
	rollback tran ProdControlDeletePreObject
	RAISERROR (@Result, 16, 1, @Operator)
	return	@Result
end

--		Serial must be a Pre-Object.
if	not exists
	(	select	1
		from	FT.PreObjectHistory
		where	Serial = @PreObjectSerial) begin
	set	@Result = 100101
	rollback tran ProdControlDeletePreObject
	RAISERROR (@Result, 16, 1, @PreObjectSerial)
	return	@Result
end

--		If PreObject is already deleted, do nothing.
if	exists
	(	select	1
		from	FT.PreObjectHistory
		where	Serial = @PreObjectSerial and
			Status & 1 = 1) begin
	set	@Result = 100200
	rollback tran ProdControlDeletePreObject
	RAISERROR (@Result, 10, 1, @PreObjectSerial)
	return	@Result
end

--		If this box has any transaction, return an error.
if	exists
	(	select	1
		from	audit_trail
		where	type != 'P' and
			type != 'H' and
			type != 'T' and
			serial = @PreObjectSerial) begin
	set	@Result = 100201
	rollback tran ProdControlDeletePreObject
	RAISERROR (@Result, 16, 1, @PreObjectSerial)
	return	@Result
end

--	Declarations:
declare	@TranDT datetime,
	@TranType char (1),
	@Remark varchar (10),
	@Notes varchar (50)

set	@TranDT = GetDate ()
set	@TranType = 'P'
set	@Remark = 'PRE-OBJECT'
set	@Notes = 'Pre-Object delete.'

--	I.	Process Pre-Object Delete.
--		A.	Create audit_trail.
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
	@TranDT,
	@TranType,
	object.part,
	-object.quantity,
	@Remark,
	object.operator,
	object.location,
	object.location,
	object.lot,
	object.weight,
	object.status,
	object.unit_measure,
	-object.std_quantity,
	object.plant,
	@Notes,
	object.package_type,
	object.cost,
	object.user_defined_status,
	object.tare_weight
from	object object
where	object.serial = @PreObjectSerial
	
--		B.	Delete object.
delete	object
where	serial = @PreObjectSerial

--		C.	Record in pre-object history.
update	FT.PreObjectHistory
set	Status = Status | 1
where	Serial = @PreObjectSerial

--		D.	Update quantity printed.
update	WODetails
set	QtyLabelled = WODetails.QtyLabelled - PreObjectHistory.Quantity
from	WODetails
	join FT.PreObjectHistory PreObjectHistory on WODetails.ID = PreObjectHistory.WODID
where	PreObjectHistory.Serial = @PreObjectSerial

--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction ProdControlDeletePreObject
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	IV.	Success.
set	@Result = 0
return	@Result
GO
