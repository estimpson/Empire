
if	objectproperty(object_id('EEA.ftsp_ProdControl_CreateAssemblyJob'), 'IsProcedure') = 1 begin
	drop procedure EEA.ftsp_ProdControl_CreateAssemblyJob
end
go

create procedure EEA.ftsp_ProdControl_CreateAssemblyJob
	@Operator varchar (10)
,	@PartCode varchar (25)
,	@ShiftDate datetime
,	@QtyRequired numeric (20,6)
,	@WOID int out
,	@WODID int out
,	@TranDT datetime out
,	@Result integer out
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
/*	Create new job or update existing job. */
/*		Get the machine for the scheduled part. */
declare
	@MachineCode varchar(10)

set	@MachineCode =
	(	select
			min(pm.machine)
		from
			dbo.part_machine pm
		where
			pm.part = @PartCode
	)

/*		Look for a job scheduled for the specified shift (or next day). */
set	@ShiftDate = coalesce(@ShiftDate,(select FT.fn_TruncDate('day', getdate()) + 1))
select
	@WOID = wh.ID
,	@WODID = wd.ID
from
	dbo.WOHeaders wh
	join dbo.WODetails wd on
		wd.WOID = wh.ID
	join dbo.WOShift ws on
		ws.WOID = wh.ID
where
	wh.Machine = @MachineCode
	and wh.Status = 0
	and wd.Part = @PartCode

if	@WOID is not null
	and @WODID is not null begin
/*			Adjust quantity for existing job. */
	--- <Update rows="1">
	set	@TableName = 'WODetails'
	
	update
		wd
	set
		QtyRequired = @QtyRequired
	from
		dbo.WODetails wd
	where
		ID = @WODID
	
	select
		@Error = @@Error
	,	@RowCount = @@Rowcount
	
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount != 1 begin
		set	@Result = 999999
		RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Update>
end else begin
/*			Create new job. */
/*				Get the due date for this part. */
	declare
		@DueDT datetime
	
	set	@DueDT =
		(	select
				min(DueDT)
			from
				EEA.ProgramShippingRequirements psr
			where
				PartCode = @PartCode
				and 
					QtyFG < QtyDue
		)
		
	--- <Call>	
	set	@CallProcName = 'FT.ftsp_ProdControl_NewJob'
	execute
		@ProcReturn = FT.ftsp_ProdControl_NewJob
			@Operator = @Operator,
			@TopPart = @PartCode,
			@Part = @PartCode,
			@Machine = @MachineCode,
			@ShiftDate = @ShiftDate,
			@Shift = null,
			@QtyRequired = @QtyRequired,
			@NewWOID = @WOID out,
			@NewWODID = @WODID out,
			@Result = @ProcResult out
	
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
--- </Body>

--- <CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction @ProcName
end
--- </CloseTran Required=Yes AutoCreate=Yes>

---	<Return>
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
	@Operator varchar (10)
,	@ProgramCode varchar (7)
,	@ShiftDate datetime
,	@QtyRequired numeric (20,6)
,	@WOID int
,	@WODID int

set @Operator = 'ES'
set	@ProgramCode = 'NAL0157'
set @ShiftDate = '4/2/2011'
set @QtyRequired = 900

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = EEA.ftsp_ProdControl_CreateAssemblyJob
	@Operator = @Operator
,	@ProgramCode = @ProgramCode
,	@ShiftDate = @ShiftDate
,	@QtyRequired = @QtyRequired
,	@WOID = @WOID out
,	@WODID = @WODID out
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @WOID, @WODID, @TranDT, @ProcResult


select
	*
from
	dbo.WOHeaders wh
where
	ID = @WOID

select
	*
from
	dbo.WODetails wd
where
	ID = @WODID
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
go

declare
	@Operator varchar (10)
,	@ProgramCode varchar (7)
,	@ShiftDate datetime
,	@QtyRequired numeric (20,6)
,	@WOID int
,	@WODID int

set	@Operator = 'ES'
set	@ProgramCode = 'NAL0069'
set	@ShiftDate = '2/14/2011 12:00:00 AM'
set	@QtyRequired = 1000

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = EEA.ftsp_ProdControl_CreateAssemblyJob
	@Operator = @Operator
,	@ProgramCode = @ProgramCode
,	@ShiftDate = @ShiftDate
,	@QtyRequired = @QtyRequired
,	@WOID = @WOID out
,	@WODID = @WODID out
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

if	@@trancount > 0 begin
	rollback
end
go
