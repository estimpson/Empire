CREATE TABLE [Notes].[Notes]
(
[Status] [int] NOT NULL CONSTRAINT [DF__Notes__Status__1269A02C] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__Notes__Type__135DC465] DEFAULT ((0)),
[Author] [int] NOT NULL,
[SubjectLine] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Body] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReferencedURI] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category] [int] NULL,
[ImportanceFlag] [int] NULL,
[PrivacyFlag] [int] NULL,
[EntityGUID] [uniqueidentifier] NULL,
[Hierarchy] [sys].[hierarchyid] NOT NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__Notes__RowCreate__18227982] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Notes__RowCreate__19169DBB] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__Notes__RowModifi__1A0AC1F4] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Notes__RowModifi__1AFEE62D] DEFAULT (suser_name())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [Notes].[tr_Notes_uRowModified] on [Notes].[Notes] after update
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
	if	not update(RowModifiedDT)
		or not update(RowModifiedUser) begin
		--- <Update rows="*">
		set	@TableName = 'Notes.Notes'
		
		update
			n
		set	RowModifiedDT = case when update(RowModifiedDT) then i.RowModifiedDT else getdate() end
		,	RowModifiedUser = case when update(RowModifiedUser) then i.RowModifiedUser else suser_name() end
		from
			Notes.Notes n
			join inserted i
				on i.RowID = n.RowID
		
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
		
	end
		--- </Body>
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
	Notes.Notes
...

update
	...
from
	Notes.Notes
...

delete
	...
from
	Notes.Notes
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
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [CK__Notes__Importanc__163A3110] CHECK (([ImportanceFlag]>=(0) AND [ImportanceFlag]<=(3)))
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [CK__Notes__PrivacyFl__172E5549] CHECK (([PrivacyFlag]>=(0) AND [PrivacyFlag]<=(1)))
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [PK__Notes__FFEE74510DA4EB0F] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [UQ__Notes__A20F6C63108157BA] UNIQUE NONCLUSTERED  ([Hierarchy]) ON [PRIMARY]
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [FK__Notes__Author__1451E89E] FOREIGN KEY ([Author]) REFERENCES [PM].[Employees] ([RowID])
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [FK__Notes__Author__2DF1BF10] FOREIGN KEY ([Author]) REFERENCES [PM].[Employees] ([RowID])
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [FK__Notes__Author__36BC0F3B] FOREIGN KEY ([Author]) REFERENCES [PM].[Employees] ([RowID])
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [FK__Notes__Author__49EEDF40] FOREIGN KEY ([Author]) REFERENCES [PM].[Employees] ([RowID])
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [FK__Notes__Category__15460CD7] FOREIGN KEY ([Category]) REFERENCES [Notes].[NoteCategories] ([RowID])
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [FK__Notes__Category__2EE5E349] FOREIGN KEY ([Category]) REFERENCES [Notes].[NoteCategories] ([RowID])
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [FK__Notes__Category__37B03374] FOREIGN KEY ([Category]) REFERENCES [Notes].[NoteCategories] ([RowID])
GO
ALTER TABLE [Notes].[Notes] ADD CONSTRAINT [FK__Notes__Category__4AE30379] FOREIGN KEY ([Category]) REFERENCES [Notes].[NoteCategories] ([RowID])
GO
