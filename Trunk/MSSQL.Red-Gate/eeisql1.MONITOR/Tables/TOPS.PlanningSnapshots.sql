CREATE TABLE [TOPS].[PlanningSnapshots]
(
[FinishedPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Revision] [char] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__PlanningS__Statu__500BCD68] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__PlanningSn__Type__50FFF1A1] DEFAULT ((0)),
[PlanningXML] [xml] NOT NULL,
[RowGUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__PlanningS__RowGU__51F415DA] DEFAULT (newid()),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__PlanningS__RowCr__52E83A13] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PlanningS__RowCr__53DC5E4C] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__PlanningS__RowMo__54D08285] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__PlanningS__RowMo__55C4A6BE] DEFAULT (suser_name())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [TOPS].[tr_PlanningSnapshots_uRowModified] on [TOPS].[PlanningSnapshots] after update
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. TOPS.usp_Test
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
		set	@TableName = 'TOPS.PlanningSnapshots'
		
		update
			ps
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			TOPS.PlanningSnapshots ps
			join inserted i
				on i.RowID = ps.RowID
		
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
	TOPS.PlanningSnapshots
...

update
	...
from
	TOPS.PlanningSnapshots
...

delete
	...
from
	TOPS.PlanningSnapshots
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
GO
ALTER TABLE [TOPS].[PlanningSnapshots] ADD CONSTRAINT [CK__PlanningS__Revis__4F17A92F] CHECK (([Revision] like '[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9]'))
GO
ALTER TABLE [TOPS].[PlanningSnapshots] ADD CONSTRAINT [PK__Planning__FFEE745147768767] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [TOPS].[PlanningSnapshots] ADD CONSTRAINT [UQ__Planning__77638A8D4A52F412] UNIQUE NONCLUSTERED  ([FinishedPart], [Revision]) ON [PRIMARY]
GO
ALTER TABLE [TOPS].[PlanningSnapshots] ADD CONSTRAINT [UQ__Planning__B174D9DD4D2F60BD] UNIQUE NONCLUSTERED  ([RowGUID]) ON [PRIMARY]
GO
