CREATE TABLE [TOPS].[CustomerRequirementOverrides]
(
[FinishedPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Revision] [char] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__CustomerR__Statu__2F9FC92D] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__CustomerRe__Type__3093ED66] DEFAULT ((0)),
[OverrideXML] [xml] NULL,
[RowGUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__CustomerR__RowGU__3188119F] DEFAULT (newid()),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__CustomerR__RowCr__327C35D8] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__CustomerR__RowCr__33705A11] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__CustomerR__RowMo__34647E4A] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__CustomerR__RowMo__3558A283] DEFAULT (suser_name())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [TOPS].[tr_CustomerRequirementOverrides_uRowModified] on [TOPS].[CustomerRequirementOverrides] after update
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
		set	@TableName = 'TOPS.CustomerRequirementOverrides'
		
		update
			cro
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			TOPS.CustomerRequirementOverrides cro
			join inserted i
				on i.RowID = cro.RowID
		
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
	TOPS.CustomerRequirementOverrides
...

update
	...
from
	TOPS.CustomerRequirementOverrides
...

delete
	...
from
	TOPS.CustomerRequirementOverrides
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
ALTER TABLE [TOPS].[CustomerRequirementOverrides] ADD CONSTRAINT [CK__CustomerR__Revis__2EABA4F4] CHECK (([Revision] like '[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9]'))
GO
ALTER TABLE [TOPS].[CustomerRequirementOverrides] ADD CONSTRAINT [PK__Customer__FFEE7451270A832C] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [TOPS].[CustomerRequirementOverrides] ADD CONSTRAINT [UQ__Customer__77638A8D29E6EFD7] UNIQUE NONCLUSTERED  ([FinishedPart], [Revision]) ON [PRIMARY]
GO
ALTER TABLE [TOPS].[CustomerRequirementOverrides] ADD CONSTRAINT [UQ__Customer__B174D9DD2CC35C82] UNIQUE NONCLUSTERED  ([RowGUID]) ON [PRIMARY]
GO
