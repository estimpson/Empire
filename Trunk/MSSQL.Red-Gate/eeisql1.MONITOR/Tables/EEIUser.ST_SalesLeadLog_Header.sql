CREATE TABLE [EEIUser].[ST_SalesLeadLog_Header]
(
[CombinedLightingId] [int] NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__ST_SalesL__Statu__31EC0563] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__ST_SalesL__Type__32E0299C] DEFAULT ((0)),
[SalesPersonCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__ST_SalesL__RowCr__34C8720E] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ST_SalesL__RowCr__35BC9647] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__ST_SalesL__RowMo__36B0BA80] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ST_SalesL__RowMo__37A4DEB9] DEFAULT (suser_name())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE trigger [EEIUser].[tr_ST_SalesLeadLog_uRowModified] on [EEIUser].[ST_SalesLeadLog_Header] after update
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EEIUser.usp_Test
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
		set	@TableName = 'EEIUser.ST_SalesLeadLog_Header'
	
		update
			sll
		set	
			RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			EEIUser.ST_SalesLeadLog_Header sll
			join inserted i
				on i.RowID = sll.RowID
		--- </Update>
	end	
	--- </Body>
end try
begin catch
/*
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
*/
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
	EEIUser.QT_QuoteLog
...

update
	...
from
	EEIUser.QT_QuoteLog
...

delete
	...
from
	EEIUser.QT_QuoteLog
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
ALTER TABLE [EEIUser].[ST_SalesLeadLog_Header] ADD CONSTRAINT [PK__ST_Sales__FFEE74512D275046] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
