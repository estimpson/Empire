CREATE TABLE [Programs].[OEM_xRefs]
(
[Status] [int] NOT NULL CONSTRAINT [DF__OEM_xRefs__Statu__1332DBDC] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__OEM_xRefs__Type__14270015] DEFAULT ((0)),
[OEM] [int] NULL,
[xName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__OEM_xRefs__RowCr__160F4887] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__OEM_xRefs__RowCr__17036CC0] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__OEM_xRefs__RowMo__17F790F9] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__OEM_xRefs__RowMo__18EBB532] DEFAULT (suser_name())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [Programs].[tr_OEM_xRefs_uRowModified] on [Programs].[OEM_xRefs] after update
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. Programs.usp_Test
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
		set	@TableName = 'Programs.OEM_xRefs'
		
		update
			oxr
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			Programs.OEM_xRefs oxr
			join inserted i
				on i.RowID = oxr.RowID
		
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
	Programs.OEM_xRefs
...

update
	...
from
	Programs.OEM_xRefs
...

delete
	...
from
	Programs.OEM_xRefs
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
ALTER TABLE [Programs].[OEM_xRefs] ADD CONSTRAINT [PK__OEM_xRef__FFEE74510B91BA14] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [Programs].[OEM_xRefs] ADD CONSTRAINT [UQ__OEM_xRef__B5184F2F0E6E26BF] UNIQUE NONCLUSTERED  ([xName]) ON [PRIMARY]
GO
ALTER TABLE [Programs].[OEM_xRefs] ADD CONSTRAINT [FK__OEM_xRefs__OEM__151B244E] FOREIGN KEY ([OEM]) REFERENCES [Programs].[OEMs] ([RowID])
GO
