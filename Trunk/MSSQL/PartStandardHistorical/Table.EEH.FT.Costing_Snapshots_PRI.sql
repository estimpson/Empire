
/*
insert
	FT.Costing_Snapshots_PRI
(	SnapshotDT
,	Reason
)
select
	phd.time_stamp
,	reason=max(phd.reason)
from
	dbo.po_receiver_items_historical_daily phd
where
	phd.time_stamp >
		(	select
				max(csp.SnapshotDT)
			from
				FT.Costing_Snapshots_PRI csp
		)
group by
	phd.time_stamp
union all
select
	ph.time_stamp
,	reason=max(ph.reason)
from
	dbo.po_receiver_items_historical ph 
group by
	ph.time_stamp
order by
	1 asc
*/

/*
Create Table.EEH.FT.Costing_Snapshots_PRI.sql
*/

--use EEH
--go

--drop table FT.Costing_Snapshots_PRI
if	objectproperty(object_id('FT.Costing_Snapshots_PRI'), 'IsTable') is null begin

	create table FT.Costing_Snapshots_PRI
	(	SnapshotDT datetime
	,	Status int not null default(0)
	,	Type int not null default(0)
	,	Reason varchar(100) not null
	,	RowID int identity(1,1) primary key clustered
	,	RowCreateDT datetime default(getdate())
	,	RowCreateUser sysname default(suser_name())
	,	RowModifiedDT datetime default(getdate())
	,	RowModifiedUser sysname default(suser_name())
	,	unique nonclustered
		(	SnapshotDT
		)
	)
end
go

/*
Create trigger FT.tr_Costing_Snapshots_PRI_uRowModified on FT.Costing_Snapshots_PRI
*/

--use EEH
--go

if	objectproperty(object_id('FT.tr_Costing_Snapshots_PRI_uRowModified'), 'IsTrigger') = 1 begin
	drop trigger FT.tr_Costing_Snapshots_PRI_uRowModified
end
go

create trigger FT.tr_Costing_Snapshots_PRI_uRowModified on FT.Costing_Snapshots_PRI after update
as
declare
	@TranDT datetime
,	@Result int

set xact_abort off
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. FT.usp_Test
--- </Error Handling>

begin try
	--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
	declare
		@TranCount smallint

	set	@TranCount = @@TranCount
	set	@TranDT = coalesce(@TranDT, GetDate())
	save tran @ProcName
	--- </Tran>

	---	<ArgumentValidation>

	---	</ArgumentValidation>
	
	--- <Body>
	if	not update(RowModifiedDT) begin
		--- <Update rows="*">
		set	@TableName = 'FT.Costing_Snapshots_PRI'
		
		update
			csp
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			FT.Costing_Snapshots_PRI csp
			join inserted i
				on i.RowID = csp.RowID
		
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
	end
end try
begin catch
	declare
		@errorName int
	,	@errorSeverity int
	,	@errorState int
	,	@errorLine int
	,	@errorProcedures sysname
	,	@errorMessage nvarchar(2048)
	,	@xact_state int
	
	select
		@errorName = error_number()
	,	@errorSeverity = error_severity()
	,	@errorState = error_state ()
	,	@errorLine = error_line()
	,	@errorProcedures = error_procedure()
	,	@errorMessage = error_message()
	,	@xact_state = xact_state()

	if	xact_state() = -1 begin
		print 'Error number: ' + convert(varchar, @errorName)
		print 'Error severity: ' + convert(varchar, @errorSeverity)
		print 'Error state: ' + convert(varchar, @errorState)
		print 'Error line: ' + convert(varchar, @errorLine)
		print 'Error procedure: ' + @errorProcedures
		print 'Error message: ' + @errorMessage
		print 'xact_state: ' + convert(varchar, @xact_state)
		
		rollback transaction
	end
	else begin
		/*	Capture any errors in SP Logging. */
		rollback tran @ProcName
	end
end catch

---	<Return>
set	@Result = 0
return
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

begin transaction Test
go

insert
	FT.Costing_Snapshots_PRI
...

update
	...
from
	FT.Costing_Snapshots_PRI
...

delete
	...
from
	FT.Costing_Snapshots_PRI
...
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

