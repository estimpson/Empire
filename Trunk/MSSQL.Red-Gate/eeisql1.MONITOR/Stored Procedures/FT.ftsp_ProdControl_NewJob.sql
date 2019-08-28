SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [FT].[ftsp_ProdControl_NewJob]
(	@Operator varchar (10),
	@TopPart varchar (25),
	@Part varchar (25),
	@Machine varchar (10),
	@ShiftDate datetime,
	@Shift char (1),
	@QtyRequired numeric (20,6),
	@Status int = 0,
	@Type int = 0,
	@NewWOID int out,
	@NewWODID int out,
	@Result int out)
as
/*
begin transaction
declare	@ProcReturn int,
	@ProcResult int,
	@Operator varchar (5),
	@Part varchar (25),
	@Machine varchar (10),
	@ShiftDate datetime,
	@Shift char (1),
	@QtyRequired numeric (20,6),
	@NewWOID int,
	@NewWODID int

select	@Operator = 'OKOMA',
	@Part =  'TRW0271-PT07',
	@Machine = 'TRW0271',
	@ShiftDate = '2008-11-16',
	@Shift = 'A',
	@QtyRequired = 6

execute	@ProcReturn = FT.ftsp_ProdControl_NewJob
	@Operator = @Operator,
	@TopPart = @Part,
	@Part = @Part,
	@Machine = @Machine,
	@ShiftDate = @ShiftDate,
	@Shift = @Shift,
	@QtyRequired = @QtyRequired,
	@NewWOID = @NewWOID out,
	@NewWODID = @NewWODID out,
	@Result = @ProcResult out

select	*
from	WOHeaders
where	ID = @NewWOID

select	*
from	WODetails
where	ID = @NewWODID

rollback
*/
set nocount on
set	@Result = 999999

--<Tran Required=Yes AutoCreate=Yes>
declare	@TranCount smallint
set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin transaction NewJob
end
else	begin
	save transaction NewJob
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
	rollback tran NewJob
	RAISERROR (@Result, 16, 1, @Operator)
	return	@Result
end

--		Valid part required:
if	not exists
	(	select	1
		from	part
		where	part = @Part) begin

	set	@Result = 70001
	rollback tran NewJob
	RAISERROR (@Result, 16, 1, @Part)
	return	@Result
end

--		Valid machine required:
if	not exists
	(	select	1
		from	machine
		where	machine_no = @Machine) begin

	set	@Result = 90101
	rollback tran NewJob
	RAISERROR (@Result, 16, 1, @Machine)
	return	@Result
end

--		Source type required for machine.
declare
	@SourceType varchar(10)

select
	@SourceType = Source_Type
from
	group_technology
where
	id in
	(	select
			group_no
		from
			location
		where
			code = @Machine
	)
--if	coalesce( @SourceType, '') = '' begin
--	set	@Result = 999999
--	RAISERROR (@Result, 16, 1, 'ProdControl_NewJob:No Source Material Type')
--	rollback tran NewJob
--	return	@Result
--end

--	I.	Create work order header.
insert
	WOHeaders
(	Machine,
	Tool,
	Sequence,
	Status,
	Type
)
select
	@Machine
,	Tool =
	(	select
			min (tool)
		from
			dbo.part_machine_tool pmt
		where
			pmt.part = @Part
			and
				machine = @Machine
	)
,	Sequence = coalesce
	(	(	select
				max (Sequence)
			from
				dbo.WOHeaders
			where
				Machine = @Machine
				and
					Status = 0
		) + 1
	,	1
	)
,	Status = @Status
,	Type = @Type

select
	@Error = @@Error
,	@RowCount = @@RowCount
,	@NewWOID = scope_identity()

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_NewJob')
	rollback tran NewJob
	return	@Result
end
if	@RowCount != 1 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_NewJob')
	rollback tran NewJob
	return	@Result
end

--	II.	Create work order detail.
insert
	WODetails
(	WOID
,	TopPart
,	Part
,	Sequence
,	QtyRequired
,	SourceType
)
select
	WOID = @NewWOID
,	TopPart = @TopPart
,	Part = @Part
,	Sequence = coalesce
	(	(	select
				max (Sequence)
			from
				WODetails
			where
				WOID = @NewWOID
				and
					Status = 0
		) + 1
	,	1
	)
,	QtyRequired = @QtyRequired
,	@SourceType

select
	@Error = @@Error
,	@RowCount = @@RowCount
,	@NewWODID = scope_identity()

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_NewJob')
	rollback tran NewJob
	return	@Result
end
if	@RowCount != 1 begin
	set	@Result = 999999
	RAISERROR (@Result, 16, 1, 'ProdControl_NewJob')
	rollback tran NewJob
	return	@Result
end

--	III.	Create work order shift.
if	@ShiftDate is not null
	or
		@Shift is not null begin
	
	insert
		WOShift
	(	WOID
	,	ShiftDate
	,	Shift
	)
	select
		@NewWOID
	,	@ShiftDate
	,	@Shift

	select
		@Error = @@Error
	,	@RowCount = @@RowCount

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR (@Result, 16, 1, 'ProdControl_NewJob')
		rollback tran NewJob
		return	@Result
	end
	if	@RowCount != 1 begin
		set	@Result = 999999
		RAISERROR (@Result, 16, 1, 'ProdControl_NewJob')
		rollback tran NewJob
		return	@Result
	end
end

--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction NewJob
end
--</CloseTran Required=Yes AutoCreate=Yes>

set	@Result = 0
return
	@Result
GO
