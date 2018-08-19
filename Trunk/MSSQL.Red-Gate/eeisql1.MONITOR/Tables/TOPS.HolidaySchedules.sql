CREATE TABLE [TOPS].[HolidaySchedules]
(
[Status] [int] NOT NULL CONSTRAINT [DF__HolidaySc__Statu__4933E750] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__HolidaySch__Type__4A280B89] DEFAULT ((0)),
[HolidayScheduleXML] [xml] NOT NULL,
[RowGUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__HolidaySc__RowGU__4B1C2FC2] DEFAULT (newid()),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__HolidaySc__RowCr__4C1053FB] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__HolidaySc__RowCr__4D047834] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__HolidaySc__RowMo__4DF89C6D] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__HolidaySc__RowMo__4EECC0A6] DEFAULT (suser_name())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [TOPS].[tr_HolidaySchedules_uRowModified] on [TOPS].[HolidaySchedules] after update
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
		set	@TableName = 'TOPS.HolidaySchedules'
		
		update
			pc
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			TOPS.HolidaySchedules pc
			join inserted i
				on i.RowID = pc.RowID
		
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
	TOPS.HolidaySchedules
...

update
	...
from
	TOPS.HolidaySchedules
...

delete
	...
from
	TOPS.HolidaySchedules
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
ALTER TABLE [TOPS].[HolidaySchedules] ADD CONSTRAINT [PK__HolidayS__FFEE7451446F3233] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [TOPS].[HolidaySchedules] ADD CONSTRAINT [UQ__HolidayS__B174D9DD474B9EDE] UNIQUE NONCLUSTERED  ([RowGUID]) ON [PRIMARY]
GO