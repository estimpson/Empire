CREATE TABLE [Notes].[NoteAttachments]
(
[Status] [int] NOT NULL CONSTRAINT [DF__NoteAttac__Statu__5ECA0095] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__NoteAttach__Type__5FBE24CE] DEFAULT ((0)),
[Note] [int] NULL,
[FileAttachment] [uniqueidentifier] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__NoteAttac__RowCr__629A9179] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__NoteAttac__RowCr__638EB5B2] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__NoteAttac__RowMo__6482D9EB] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__NoteAttac__RowMo__6576FE24] DEFAULT (suser_name())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [Notes].[tr_NoteAttachments_uRowModified] on [Notes].[NoteAttachments] after update
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. Notes.usp_Test
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
		set	@TableName = 'Notes.NoteAttachments'
		
		update
			na
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			Notes.NoteAttachments na
			join inserted i
				on i.RowID = na.RowID
		
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
	Notes.NoteAttachments
...

update
	...
from
	Notes.NoteAttachments
...

delete
	...
from
	Notes.NoteAttachments
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
ALTER TABLE [Notes].[NoteAttachments] ADD CONSTRAINT [PK__NoteAtta__FFEE74515A054B78] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [Notes].[NoteAttachments] ADD CONSTRAINT [UQ__NoteAtta__8AE4C74E5CE1B823] UNIQUE NONCLUSTERED  ([Note], [FileAttachment]) ON [PRIMARY]
GO
ALTER TABLE [Notes].[NoteAttachments] ADD CONSTRAINT [FK__NoteAttac__FileA__61A66D40] FOREIGN KEY ([FileAttachment]) REFERENCES [PM].[FileAttachments] ([StreamID])
GO
ALTER TABLE [Notes].[NoteAttachments] ADD CONSTRAINT [FK__NoteAttach__Note__60B24907] FOREIGN KEY ([Note]) REFERENCES [Notes].[Notes] ([RowID])
GO
