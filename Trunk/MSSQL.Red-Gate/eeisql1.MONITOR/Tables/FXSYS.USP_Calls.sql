CREATE TABLE [FXSYS].[USP_Calls]
(
[Status] [int] NOT NULL CONSTRAINT [DF__USP_Calls__Statu__082F5FA3] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__USP_Calls__Type__092383DC] DEFAULT ((0)),
[USP_Name] [sys].[sysname] NOT NULL,
[BeginDT] [datetime] NOT NULL,
[EndDT] [datetime] NULL,
[RunTime] AS (case  when datediff(day,[EndDT]-[BeginDT],CONVERT([datetime],'1900-01-01',(0)))>(1) then (CONVERT([varchar],datediff(day,[EndDT]-[BeginDT],CONVERT([datetime],'1900-01-01',(0))),(0))+' day(s) ')+CONVERT([char](12),[EndDT]-[BeginDT],(114)) else CONVERT([varchar](12),[EndDT]-[BeginDT],(114)) end),
[InArguments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OutArguments] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__USP_Calls__RowCr__0A17A815] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__USP_Calls__RowCr__0B0BCC4E] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__USP_Calls__RowMo__0BFFF087] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__USP_Calls__RowMo__0CF414C0] DEFAULT (suser_name())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE trigger [FXSYS].[tr_USP_Calls_uRowModified] on [FXSYS].[USP_Calls] after update
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. FXSYS.usp_Test
--- </Error Handling>

begin try
	--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
	declare
		@TranCount smallint

	set	@TranCount = @@TranCount
	set	@TranDT = coalesce(@TranDT, GetDate())
	--save tran @ProcName
	--- </Tran>

	---	<ArgumentValidation>

	---	</ArgumentValidation>
	
	--- <Body>
	if	not update(RowModifiedDT) begin
		--- <Update rows="*">
		set	@TableName = 'FXSYS.USP_Calls'
		
		update
			uc
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			FXSYS.USP_Calls uc
			join inserted i
				on i.RowID = uc.RowID
		
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
	FXSYS.USP_Calls
...

update
	...
from
	FXSYS.USP_Calls
...

delete
	...
from
	FXSYS.USP_Calls
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
ALTER TABLE [FXSYS].[USP_Calls] ADD CONSTRAINT [PK__USP_Call__FFEE745106471731] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
