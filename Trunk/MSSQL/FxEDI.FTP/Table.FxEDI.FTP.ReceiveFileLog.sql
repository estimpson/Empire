
/*
Create Table.FxEDI.FTP.ReceiveFileLog.sql
*/

use FxEDI
go

--drop table FTP.ReceiveFileLog
if	objectproperty(object_id('FTP.ReceiveFileLog'), 'IsTable') is null begin

	create table FTP.ReceiveFileLog
	(	SourceFileName sysname not null
	,	Status int not null default(0)
	,	Type int not null default(0)
	,	SourceFileLength int not null
	,	SourceCRC32 varbinary(8) null
	,	SourceFileDT datetime not null
	,	SourceFileAvailable int not null
	,	ReceiveFileGUID uniqueidentifier null
	,	ReceiveFileName sysname null
	,	ReceiveCRC32 varbinary(8) null
	,	ReceiveFileLength int null
	,	RowID int identity(1,1) primary key clustered
	,	RowCreateDT datetime default(getdate())
	,	RowCreateUser sysname default(suser_name())
	,	RowModifiedDT datetime default(getdate())
	,	RowModifiedUser sysname default(suser_name())
	,	unique nonclustered
		(	SourceFileName
		,	SourceFileDT
		)
	)
end
go

/*
Create trigger FTP.tr_ReceiveFileLog_uRowModified on FTP.ReceiveFileLog
*/

--use FxEDI
--go

if	objectproperty(object_id('FTP.tr_ReceiveFileLog_uRowModified'), 'IsTrigger') = 1 begin
	drop trigger FTP.tr_ReceiveFileLog_uRowModified
end
go

create trigger FTP.tr_ReceiveFileLog_uRowModified on FTP.ReceiveFileLog after update
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. FTP.usp_Test
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
		set	@TableName = 'FTP.ReceiveFileLog'
		
		update
			rfl
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			FTP.ReceiveFileLog rfl
			join inserted i
				on i.RowID = rfl.RowID
		
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
	FTP.ReceiveFileLog
...

update
	...
from
	FTP.ReceiveFileLog
...

delete
	...
from
	FTP.ReceiveFileLog
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

