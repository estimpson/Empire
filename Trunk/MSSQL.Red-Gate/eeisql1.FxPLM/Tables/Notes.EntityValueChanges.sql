CREATE TABLE [Notes].[EntityValueChanges]
(
[NoteID] [int] NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__EntityVal__Statu__4F7D9B64] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__EntityValu__Type__5071BF9D] DEFAULT ((0)),
[OldValueVar] [sql_variant] NULL,
[NewValueVar] [sql_variant] NULL,
[OldValue] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NewValue] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__EntityVal__RowCr__5165E3D6] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__EntityVal__RowCr__525A080F] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__EntityVal__RowMo__534E2C48] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__EntityVal__RowMo__54425081] DEFAULT (suser_name())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [Notes].[tr_EntityValueChanges_uRowModified] on [Notes].[EntityValueChanges] after update
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
		set	@TableName = 'Notes.EntityValueChanges'
		
		update
			evc
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			Notes.EntityValueChanges evc
			join inserted i
				on i.RowID = evc.RowID
		
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
	Notes.EntityValueChanges
...

update
	...
from
	Notes.EntityValueChanges
...

delete
	...
from
	Notes.EntityValueChanges
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
ALTER TABLE [Notes].[EntityValueChanges] ADD CONSTRAINT [PK__EntityVa__FFEE745172C28668] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [Notes].[EntityValueChanges] ADD CONSTRAINT [UQ__EntityVa__EACE357E5F322003] UNIQUE NONCLUSTERED  ([NoteID]) ON [PRIMARY]
GO
ALTER TABLE [Notes].[EntityValueChanges] ADD CONSTRAINT [FK__EntityVal__NoteI__440BE8B8] FOREIGN KEY ([NoteID]) REFERENCES [Notes].[Notes] ([RowID])
GO
ALTER TABLE [Notes].[EntityValueChanges] ADD CONSTRAINT [FK__EntityVal__NoteI__4E89772B] FOREIGN KEY ([NoteID]) REFERENCES [Notes].[Notes] ([RowID])
GO
