SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_ProdControl_ModifyPreObject]
    @Operator varchar(10)
,	@PreObjectSerial int
,	@QtyUpdate numeric(20,6)
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

execute	@ProcReturn = FT.ftsp_ProdControl_ModifyPreObject
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
	begin transaction ProdControlModifyPreObject
end
else
begin
	save transaction ProdControlModifyPreObject
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
	rollback tran ProdControlModifyPreObject
	RAISERROR (@Result, 16, 1, @Operator)
	return	@Result
end

--		Serial must be a Pre-Object.
if	not exists
	(	select	1
		from	FT.PreObjectHistory
		where	Serial = @PreObjectSerial) begin
	set	@Result = 100101
	rollback tran ProdControlModifyPreObject
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
	rollback tran ProdControlModifyPreObject
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
	rollback tran ProdControlModifyPreObject
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
set	@Notes = 'Pre-Object Update.'

--	I.	Process Pre-Object Delete.
--		A.	Create audit_trail.
declare
	@QtyChange numeric(20,6)

set	@QtyChange =
(	select
		@QtyUpdate - object.quantity
	from
		dbo.object
	where
		serial = @PreObjectSerial
)

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
	@QtyChange,
	@Remark,
	object.operator,
	object.location,
	object.location,
	object.lot,
	object.weight,
	object.status,
	object.unit_measure,
	@QtyChange,
	object.plant,
	@Notes,
	object.package_type,
	object.cost,
	object.user_defined_status,
	object.tare_weight
from	object object
where	object.serial = @PreObjectSerial
	
--		B.	Update object.
update	object
set	quantity = @QtyUpdate
,	std_quantity = @QtyUpdate
where	serial = @PreObjectSerial

update
	FT.PreObjectHistory
set
	Quantity = @QtyUpdate
where
	serial = @PreObjectSerial

--		D.	Update quantity printed.
update	WODetails
set	QtyLabelled = WODetails.QtyLabelled + @QtyChange
from	WODetails
	join FT.PreObjectHistory PreObjectHistory on WODetails.ID = PreObjectHistory.WODID
where	PreObjectHistory.Serial = @PreObjectSerial

--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction ProdControlModifyPreObject
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	IV.	Success.
set	@Result = 0
return	@Result
GO
