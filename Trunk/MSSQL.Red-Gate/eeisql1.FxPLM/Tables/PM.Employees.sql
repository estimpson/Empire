CREATE TABLE [PM].[Employees]
(
[Status] [int] NOT NULL CONSTRAINT [DF__Employees__Statu__71DCD509] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__Employees__Type__72D0F942] DEFAULT ((0)),
[Person] [int] NULL,
[HireDate] [datetime] NULL,
[MonitorEmployeeCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__Employees__RowCr__74B941B4] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Employees__RowCr__75AD65ED] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__Employees__RowMo__76A18A26] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Employees__RowMo__7795AE5F] DEFAULT (suser_name())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [PM].[tr_Employees_uRowModified] on [PM].[Employees] after update
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. PM.usp_Test
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
		set	@TableName = 'PM.Employees'
		
		update
			e
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			PM.Employees e
			join inserted i
				on i.RowID = e.RowID
		
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
	PM.Employees
...

update
	...
from
	PM.Employees
...

delete
	...
from
	PM.Employees
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
ALTER TABLE [PM].[Employees] ADD CONSTRAINT [PK__Employee__FFEE74516D181FEC] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [PM].[Employees] ADD CONSTRAINT [UQ__Employee__2BC2597D6FF48C97] UNIQUE NONCLUSTERED  ([Person]) ON [PRIMARY]
GO
ALTER TABLE [PM].[Employees] ADD CONSTRAINT [FK__Employees__Perso__2B4A5C8F] FOREIGN KEY ([Person]) REFERENCES [Contacts].[People] ([RowID])
GO
ALTER TABLE [PM].[Employees] ADD CONSTRAINT [FK__Employees__Perso__73C51D7B] FOREIGN KEY ([Person]) REFERENCES [Contacts].[People] ([RowID])
GO
