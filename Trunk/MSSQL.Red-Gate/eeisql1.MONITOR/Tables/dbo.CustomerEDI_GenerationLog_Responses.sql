CREATE TABLE [dbo].[CustomerEDI_GenerationLog_Responses]
(
[FileStreamID] [uniqueidentifier] NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__CustomerE__Statu__759751D5] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__CustomerED__Type__768B760E] DEFAULT ((0)),
[ParentFileStreamID] [uniqueidentifier] NULL,
[ParentGenerationLogRowID] [int] NULL,
[MessageInfo] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserNotes] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__CustomerE__UserN__7967E2B9] DEFAULT (suser_name()),
[ExceptionHandler] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__CustomerE__RowCr__7A5C06F2] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__CustomerE__RowCr__7B502B2B] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__CustomerE__RowMo__7C444F64] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__CustomerE__RowMo__7D38739D] DEFAULT (suser_name())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [dbo].[tr_CustomerEDI_GenerationLog_Responses_uRowModified] on [dbo].[CustomerEDI_GenerationLog_Responses] after update
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
		set	@TableName = 'dbo.CustomerEDI_GenerationLog_Responses'
		
		update
			ceglr
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			dbo.CustomerEDI_GenerationLog_Responses ceglr
			join inserted i
				on i.RowID = ceglr.RowID
		
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
	dbo.CustomerEDI_GenerationLog_Responses
...

update
	...
from
	dbo.CustomerEDI_GenerationLog_Responses
...

delete
	...
from
	dbo.CustomerEDI_GenerationLog_Responses
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
ALTER TABLE [dbo].[CustomerEDI_GenerationLog_Responses] ADD CONSTRAINT [PK__Customer__FFEE745170D29CB8] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CustomerEDI_GenerationLog_Responses] ADD CONSTRAINT [UQ__Customer__2957490C73AF0963] UNIQUE NONCLUSTERED  ([FileStreamID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CustomerEDI_GenerationLog_Responses] ADD CONSTRAINT [UQ__Customer__2957490CDB93E559] UNIQUE NONCLUSTERED  ([FileStreamID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_CustomerEDI_GenerationLog_Responses_1] ON [dbo].[CustomerEDI_GenerationLog_Responses] ([ParentGenerationLogRowID], [RowID]) INCLUDE ([RowCreateDT]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_CustomerEDI_GenerationLog_Responses_2] ON [dbo].[CustomerEDI_GenerationLog_Responses] ([ParentGenerationLogRowID], [Status], [RowID]) INCLUDE ([RowCreateDT]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_CustomerEDI_GenerationLog_Responses_3] ON [dbo].[CustomerEDI_GenerationLog_Responses] ([RowCreateDT], [ParentGenerationLogRowID], [RowID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CustomerEDI_GenerationLog_Responses] ADD CONSTRAINT [FK__CustomerE__Paren__22109A79] FOREIGN KEY ([ParentFileStreamID]) REFERENCES [dbo].[CustomerEDI_GenerationLog] ([FileStreamID])
GO
ALTER TABLE [dbo].[CustomerEDI_GenerationLog_Responses] ADD CONSTRAINT [FK__CustomerE__Paren__2304BEB2] FOREIGN KEY ([ParentGenerationLogRowID]) REFERENCES [dbo].[CustomerEDI_GenerationLog] ([RowID])
GO
ALTER TABLE [dbo].[CustomerEDI_GenerationLog_Responses] ADD CONSTRAINT [FK__CustomerE__Paren__413A60A7] FOREIGN KEY ([ParentFileStreamID]) REFERENCES [dbo].[CustomerEDI_GenerationLog] ([FileStreamID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CustomerEDI_GenerationLog_Responses] ADD CONSTRAINT [FK__CustomerE__Paren__422E84E0] FOREIGN KEY ([ParentGenerationLogRowID]) REFERENCES [dbo].[CustomerEDI_GenerationLog] ([RowID])
GO
