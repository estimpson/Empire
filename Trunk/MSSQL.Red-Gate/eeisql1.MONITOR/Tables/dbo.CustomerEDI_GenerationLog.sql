CREATE TABLE [dbo].[CustomerEDI_GenerationLog]
(
[FileStreamID] [uniqueidentifier] NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__CustomerE__Statu__64B8A70E] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__CustomerED__Type__65ACCB47] DEFAULT ((0)),
[ShipperID] [int] NULL,
[FunctionName] [sys].[sysname] NULL,
[FileGenerationDT] [datetime] NOT NULL,
[FileGenerationTime] [datetime] NULL,
[FileSendDT] [datetime] NULL,
[FileAcknowledgementDT] [datetime] NULL,
[OriginalFileName] [sys].[sysname] NULL,
[CurrentFilePath] [sys].[sysname] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__CustomerE__RowCr__66A0EF80] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__CustomerE__RowCr__679513B9] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__CustomerE__RowMo__688937F2] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__CustomerE__RowMo__697D5C2B] DEFAULT (suser_name())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [dbo].[tr_CustomerEDI_GenerationLog_uRowModified] on [dbo].[CustomerEDI_GenerationLog] after update
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
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
		set	@TableName = 'dbo.CustomerEDI_GenerationLog'
		
		update
			cegl
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			dbo.CustomerEDI_GenerationLog cegl
			join inserted i
				on i.RowID = cegl.RowID
		
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
	dbo.CustomerEDI_GenerationLog
...

update
	...
from
	dbo.CustomerEDI_GenerationLog
...

delete
	...
from
	dbo.CustomerEDI_GenerationLog
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
ALTER TABLE [dbo].[CustomerEDI_GenerationLog] ADD CONSTRAINT [PK__Customer__FFEE74515FF3F1F1] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CustomerEDI_GenerationLog] ADD CONSTRAINT [UQ__Customer__2957490C62D05E9C] UNIQUE NONCLUSTERED  ([FileStreamID]) ON [PRIMARY]
GO
