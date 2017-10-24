SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FT].[ftsp_ProdControl_PutAway]
	@OperatorCode varchar(5)
,	@WODID int
,	@PutAwayLocation varchar(10)
,	@DoAssignPallet tinyint = 0
,	@PalletSerial int = null out
,	@TranDT datetime = null out
,	@Result integer = null out
as
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

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
declare
	@oldLocation varchar(10) =
		(	select
				min(o.location)
			from
				dbo.object o
				join dbo.location l
					on l.code = @PutAwayLocation
				join FT.PreObjectHistory poh
					on poh.Serial = o.serial
				join dbo.WODetails wd
					on wd.ID = @WODID
				join dbo.WOHeaders wh
					on wh.ID = wd.WOID
			where
				poh.WODID = @WODID
				and poh.Status = 2
				and o.location = wh.machine
		)

/*	If necessary, create a pallet. */
if	@DoAssignPallet = 1
	and exists
		(	select
				*
			from
				dbo.object o
				join dbo.location l
					on l.code = @PutAwayLocation
				join FT.PreObjectHistory poh
					on poh.Serial = o.serial
				join dbo.WODetails wd
					on wd.ID = @WODID
				join dbo.WOHeaders wh
					on wh.ID = wd.WOID
			where
				poh.WODID = @WODID
				and poh.Status = 2
				and o.location = @oldLocation
				and o.parent_serial is null
		) begin

	--- <Call>
	set	@CallProcName = 'FT.usp_InvControl_NewPallet'
	execute
		@ProcReturn = FT.usp_InvControl_NewPallet
			@Operator = @OperatorCode
		,	@PalletLocation = @PutAwayLocation
		,	@PalletSerial = @PalletSerial out
		,	@TranDT = @TranDT out
		,	@Result = @ProcResult out
	
	set	@Error = @@Error
	if	@Error != 0 begin
		set	@Result = 900501
		RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	if	@ProcReturn != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	if	@ProcResult != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	--- </Call>
end

/*	Write audit trail for transfer. */
--- <Insert rows="*">
set	@TableName = 'dbo.audit_trail'

insert into dbo.audit_trail
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
,	package_type
,	std_cost
,	user_defined_status
,	parent_serial
,	tare_weight
,	on_hand
,	shipper
,	field1 
)
select
	o.serial
,	@TranDT
,	type = 'T'
,	o.part
,	o.quantity
,	remarks = 'Transfer'
,	@OperatorCode
,	from_loc = o.location
,	to_loc = @PutAwayLocation
,	o.lot
,	o.weight
,	o.status
,	o.unit_measure
,	o.std_quantity
,	o.plant
,	o.package_type
,	o.cost
,	o.user_defined_status
,	coalesce(@PalletSerial, o.parent_serial)
,	o.tare_weight
,	on_hand = 0
,	o.shipper
,	o.field1
from
	dbo.object o
	join dbo.location l
		on l.code = @PutAwayLocation
	join FT.PreObjectHistory poh
		on poh.Serial = o.serial
	join dbo.WODetails wd
		on wd.ID = @WODID
	join dbo.WOHeaders wh
		on wh.ID = wd.WOID
where
	poh.WODID = @WODID
	and poh.Status = 2
	and o.location = @oldLocation

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Insert>

/*	Move boxes (and optionally place them on a pallet). */
--- <Update rows="*">
set	@TableName = 'dbo.object'

update
	o
set
	location = @PutAwayLocation
,	last_date = @TranDT
,	operator = @OperatorCode
,	last_time = @TranDT
,	plant = l.plant
,	parent_serial = coalesce(case when @DoAssignPallet = 1 then @PalletSerial end, o.parent_serial)
from
	dbo.object o
	join dbo.location l
		on l.code = @PutAwayLocation
	join FT.PreObjectHistory poh
		on poh.Serial = o.serial
	join dbo.WODetails wd
		on wd.ID = @WODID
	join dbo.WOHeaders wh
		on wh.ID = wd.WOID
where
	poh.WODID = @WODID
	and poh.Status = 2
	and o.location = @oldLocation

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Update>
--- </Body>

---	<Return>
if	@trancount = 0 begin
	commit tran @ProcName
end

set	@Result = 0
return
	@Result
--- </Return>

/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go

declare
	@OperatorCode varchar(5)
,	@WODID int
,	@PutAwayLocation varchar(10)
,	@FromLocation varchar(10)

set	@OperatorCode = 'ES'
set	@WODID = 6593
set @PutAwayLocation = 'ALA-B-1-5'
set @FromLocation = 'ALA-B-1-14'

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FT.ftsp_ProdControl_PutAway
	@OperatorCode = @OperatorCode
,	@WODID = @WODID
,	@PutAwayLocation = @PutAwayLocation
,	@FromLocation = @FromLocation
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult

select
	o.*
from
	FT.PreObjectHistory poh
	join dbo.object o
		on o.serial = poh.Serial
	join dbo.WOHeaders wh
		join dbo.WODetails wd
			on wh.ID = wd.WOID
		on poh.WODID = wd.ID
where
	poh.WODID = @WODID
	and o.location in (@FromLocation, @PutAwayLocation)
go

if	@@trancount > 0 begin
	rollback
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/
GO
