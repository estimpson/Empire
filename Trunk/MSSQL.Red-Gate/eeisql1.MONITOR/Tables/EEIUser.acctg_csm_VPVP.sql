CREATE TABLE [EEIUser].[acctg_csm_VPVP]
(
[Region] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DesignParent] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Platform] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Program] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Vehicle] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SOP] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EOP] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ChangeDate] [datetime] NOT NULL,
[ChangeType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__acctg_csm__RowCr__502373FF] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__acctg_csm__RowCr__51179838] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__acctg_csm__RowMo__520BBC71] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__acctg_csm__RowMo__52FFE0AA] DEFAULT (suser_name())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [EEIUser].[tr_acctg_csm_VPVP_uRowModified] on [EEIUser].[acctg_csm_VPVP] after update
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
		set	@TableName = 'EEIUser.acctg_csm_VPVP'
		
		update
			acv
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			EEIUser.acctg_csm_VPVP acv
			join inserted i
				on i.RowID = acv.RowID
		
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
	EEIUser.acctg_csm_VPVP
...

update
	...
from
	EEIUser.acctg_csm_VPVP
...

delete
	...
from
	EEIUser.acctg_csm_VPVP
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
ALTER TABLE [EEIUser].[acctg_csm_VPVP] ADD CONSTRAINT [PK__acctg_cs__FFEE74514B5EBEE2] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_VPVP] ADD CONSTRAINT [UQ__acctg_cs__D3C774074E3B2B8D] UNIQUE NONCLUSTERED  ([Region]) ON [PRIMARY]
GO
