
if	objectproperty(object_id('FT.ftsp_ProdControl_NewPreObject'), 'IsProcedure') = 1 begin
	drop procedure FT.ftsp_ProdControl_NewPreObject
end
go

create procedure FT.ftsp_ProdControl_NewPreObject
(	@Operator varchar (10),
	@WODID int,
	@Boxes int,
	@QtyBox int = null,
	@FirstNewSerial int out,
	@Result integer = 0 output
--<Debug>
	, @Debug integer = 0
--</Debug>
)
as
/*
Example:
begin transaction

declare
	@ProcReturn int,
	@ProcResult int,
	@FirstNewSerial int

execute	@ProcReturn = FT.ftsp_ProdControl_NewPreObject
	@Operator = 'ES',
	@WODID = 11,
	@Boxes = 1,
	@FirstNewSerial = @FirstNewSerial out,
	@Result = @ProcResult output

select
	@ProcReturn,
	@ProcResult,
	@FirstNewSerial
,	@@trancount

select	*
from	object
where	serial between @FirstNewSerial and @FirstNewSerial + 1 - 1

rollback
:End Example
*/
set nocount on
set ansi_warnings off
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=No>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
--- </Tran>

--	Argument Validation:
--		Operator required:
if	not exists
	(	select	1
		from	employee
		where	operator_code = @Operator) begin

	set	@Result = 60001
	rollback tran ProdControlNewPreObject
	RAISERROR (@Result, 16, 1, @Operator)
	return	@Result
end

--		WOD ID must be valid.
declare	@Part varchar (25)
select	@Part =	Part
from	WODetails
where	ID = @WODID
if	@@RowCount != 1 or @@Error != 0 begin
	
	set	@Result = 200101
	rollback tran ProdControlNewPreObject
	RAISERROR (@Result, 16, 1, @WODID)
	return	@Result
end

--		Part valid:
if	not exists
	(	select	1
		from	part
		where	part = @Part) begin

	set	@Result = 70001
	rollback tran ProdControlNewPreObject
	RAISERROR (@Result, 16, 1, @Part)
	return	@Result
end

declare @PO varchar(20)

if	left(@Part, 7) = 'MIT0005' begin

	select	@PO = Min(convert(int,PONumber))
	from	hn.mitsubishi_inventory MitPOs
			left join (	select po_number, Qty = SUM(std_quantity)
					from	audit_trail
					where	part like 'MIT0005%'
							and type = 'P'
					group by po_number) poqty on poqty.po_number = MitPOs.PONumber
	where	Status = 'O'
			and MitPOs.Quantity > isnull(poqty.Qty,0)
			
	set	@PO = ISNULL(@PO, 'RE-LABEL')
end

declare	@Unit char (2)
select	@Unit = standard_unit,
	@QtyBox = coalesce (@QtyBox, standard_pack)
from	part_inventory
where	part = @Part
if	@@RowCount != 1 or @@Error != 0 begin
	set	@Result = 70002
	rollback tran ProdControlNewPreObject
	RAISERROR (@Result, 16, 1, @Part)
	return	@Result
end

--	Declarations:
declare
	@TranDT datetime
,   @BoxCount integer
,   @Status char(1)
,   @UserStatus varchar(10)
,   @ObjectType char(1)
,   @TranType char(1)
,   @Remark varchar(10)
,   @Notes varchar(50)
,   @AssemblyPreObjectLocation varchar(10)

set	@TranDT = GetDate ()
set	@Status = 'H'
set	@UserStatus = 'PRESTOCK'
set	@ObjectType = null
set	@TranType = 'P'
set	@Remark = 'PRE-OBJECT'
set	@Notes = 'Pre-Object.'
set	@AssemblyPreObjectLocation = FT.fn_VarcharGlobal ('AssemblyPreObject')

--	I.	Get a block of serial numbers.
--<Debug>
if	@Debug & 1 = 1 begin
	print	'I.	Get a block of serial numbers.'
end
--</Debug>
select
	@FirstNewSerial = next_serial
from
	parameters with (tablockx)

while exists
	(	select
			serial
		from
			object
		where
			serial between @FirstNewSerial and @FirstNewSerial + @Boxes - 1
	)
	or exists
	(	select
			serial
		from
			audit_trail
		where
			serial between @FirstNewSerial and @FirstNewSerial + @Boxes - 1
	) begin

	set @FirstNewSerial = @FirstNewSerial + 1
end

update
	parameters
set next_serial = @FirstNewSerial + @Boxes

--	II.	Loop to generate boxes.
set	@BoxCount = 0
while
	@BoxCount < @Boxes begin

--		A.	Create object.
	--- <Insert rows="1">
	set	@TableName = 'dbo.object'
	
	insert
		dbo.object
	(	serial
	,	part
	,	location
	,	last_date
	,	unit_measure
	,	operator
	,	status
	,	quantity
	,	plant
	,	std_quantity
	,	last_time
	,	user_defined_status
	,	type
	,	po_number 
	)
	select
		@FirstNewSerial + @BoxCount
	,   @Part
	,   location.code
	,   @TranDT
	,   @Unit
	,   @Operator
	,   @Status
	,   @QtyBox
	,   location.plant
	,   @QtyBox
	,   @TranDT
	,   @UserStatus
	,   @ObjectType
	,   @PO
	from
		location
	where
		location.code = @AssemblyPreObjectLocation
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount
	
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount != 1 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Insert>
	
--		B.	Create audit_trail.
	insert
		audit_trail
	(	serial
	,	date_stamp
	,	type
	,	part
	,	quantity
	,	remarks
	,	operator
	,	from_loc
	,	to_loc
	,	lot
	,	weight
	,	status
	,	unit
	,	std_quantity
	,	plant
	,	notes
	,	package_type
	,	std_cost
	,	user_defined_status
	,	tare_weight
	,	po_number 
	)	
	select
		object.serial
	,   object.last_date
	,   @TranType
	,   object.part
	,   object.quantity
	,   @Remark
	,   object.operator
	,   object.location
	,   object.location
	,   object.lot
	,   object.weight
	,   object.status
	,   object.unit_measure
	,   object.std_quantity
	,   object.plant
	,   @Notes
	,   object.package_type
	,   object.cost
	,   object.user_defined_status
	,   object.tare_weight
	,   @PO
	from
		object object
	where
		object.serial = @FirstNewSerial + @BoxCount
	
--		C.	Record in pre-object history.
	insert	FT.PreObjectHistory
	(	Serial,
		CreateDT,
		WODID,
		Operator,
		Part,
		Quantity)
	select
		@FirstNewSerial + @BoxCount,
		@TranDT,
		@WODID,
		@Operator,
		@Part,
		@QtyBox

	select	@BoxCount = @BoxCount + 1
end

--	III.	Update quantity printed.
update	WODetails
set	QtyLabelled = QtyLabelled + @QtyBox * @Boxes
where	ID = @WODID

--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction ProdControlNewPreObject
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	IV.	Success.
select
	CreateDT
,   Serial
,   WODID
,   Operator
,   Part
,   Quantity
,	Status
from
	FT.PreObjectHistory
where
	Serial between @FirstNewSerial and @FirstNewSerial + @BoxCount
order by
	Serial

set	@Result = 0
return	@Result
go

