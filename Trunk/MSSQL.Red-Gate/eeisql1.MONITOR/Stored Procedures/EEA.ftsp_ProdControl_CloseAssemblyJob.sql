SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [EEA].[ftsp_ProdControl_CloseAssemblyJob]
	@WODID int
,	@TranDT datetime out
,	@Result int out
,	@Override int = 0
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
/*	Close job and make the next job be the current job. */
declare
	@CurrentWODID int
,	@NextWODID int

set	@CurrentWODID =
	(	select
			WODID
		from
			EEA.CurrentSchedules
		where
			Part + ShipTo =
			(	select
					min(Part + ShipTo)
				from
					EEA.CurrentSchedules
				where
					WODID = @WODID
			)
			and JobStatus = 'CurrentBuild'
	)

set	@NextWODID =
	(	select
			WODID
		from
			EEA.CurrentSchedules
		where
			Part + ShipTo =
			(	select
					min(Part + ShipTo)
				from
					EEA.CurrentSchedules
				where
					WODID = @WODID
			)
			and JobStatus = 'NextBuild'
	)

--- <Update rows="1">
set	@TableName = 'WOHeaders'

update
	wh
set
	Status = 2
from
	dbo.WOHeaders wh
	join dbo.WODetails wd
		on wd.WOID = wh.ID
where
	wd.ID = @CurrentWODID
	and
		wh.Status = 1

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount > 1 begin
	set	@Result = 999999
	RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: *1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Update>

--- <Update rows="*1">
set	@TableName = 'WOHeaders'

update
	wh
set
	Status = 1
from
	dbo.WOHeaders wh
	join dbo.WODetails wd
		on wd.WOID = wh.ID
where
	wd.ID = @NextWODID
	and
		wh.Status = 0

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount > 1 begin
	set	@Result = 999999
	RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: *1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Update>

/*	Move unused pre-objects to the next build or cancel them. */
if	exists
	(	select
			*
		from
			FT.PreObjectHistory poh
		where
			WODID = @CurrentWODID
			and Status = 0
	) begin
	
	/*	If no next build, cancel pre-objects or require override. */
	if	@NextWODID is null begin
		if	@Override = 0 begin
			set	@Result = 100
			RAISERROR ('Warning, a next build has not been scheduled.  Remaining pre-objects will be cancelled.', 16, 1)
			rollback tran @ProcName
			return
		end
		else begin
			/*	Cancel pre-objects.*/
			--- <Update rows="*">
			set	@TableName = 'FT.PreObjectHistory'

			update
				poh
			set
				Status = 1
			from
				FT.PreObjectHistory poh
			where
				WODID = @CurrentWODID
				and Status = 0

			select
				@Error = @@Error,
				@RowCount = @@Rowcount

			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
				rollback tran @ProcName
				return
			end
		end
	end
	/*	Move pre-objects to next build. */
	else begin
		--- <Update rows="*">
		set	@TableName = 'FT.PreObjectHistory'

		update
			poh
		set
			WODID = @NextWODID
		from
			FT.PreObjectHistory poh
		where
			WODID = @CurrentWODID
			and Status = 0

		select
			@Error = @@Error,
			@RowCount = @@Rowcount

		if	@Error != 0 begin
			set	@Result = 999999
			RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			rollback tran @ProcName
			return
		end
	end
end

--- <Update rows="*2">
set	@TableName = 'dbo.WODetails'

update
	wd
set
	QtyLabelled = coalesce((select sum(Quantity) from FT.PreObjectHistory where WODID = wd.ID and Status in (0,2)), 0)
from
	dbo.WODetails wd
where
	ID in (@CurrentWODID, @NextWODID)

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount > 2 begin
	set	@Result = 999999
	RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 2.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Update>

--- </Update>
--- </Body>
commit tran @ProcName

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
	@Param1 [scalar_data_type]

set	@Param1 = [test_value]

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = EEA.ftsp_ProdControl_CloseAssemblyJob
	@Param1 = @Param1
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

set statistics io off
set statistics time off
go

}

Results {
}
*/
GO
