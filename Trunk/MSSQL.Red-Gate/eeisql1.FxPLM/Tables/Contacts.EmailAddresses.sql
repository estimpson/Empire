CREATE TABLE [Contacts].[EmailAddresses]
(
[Status] [int] NOT NULL CONSTRAINT [DF__EmailAddr__Statu__014935CB] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__EmailAddre__Type__023D5A04] DEFAULT ((0)),
[Person] [int] NOT NULL,
[EmailType] [int] NOT NULL,
[EmailAddress] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__EmailAddr__RowCr__03317E3D] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__EmailAddr__RowCr__0425A276] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__EmailAddr__RowMo__0519C6AF] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__EmailAddr__RowMo__060DEAE8] DEFAULT (suser_name())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [Contacts].[tr_EmailAddresses_uRowModified] on [Contacts].[EmailAddresses] after update
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. Contacts.usp_Test
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
		set	@TableName = 'Contacts.EmailAddresses'
		
		update
			pn
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			Contacts.EmailAddresses pn
			join inserted i
				on i.RowID = pn.RowID
		
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
	Contacts.EmailAddresses
...

update
	...
from
	Contacts.EmailAddresses
...

delete
	...
from
	Contacts.EmailAddresses
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
ALTER TABLE [Contacts].[EmailAddresses] ADD CONSTRAINT [PK__EmailAdd__FFEE74517F60ED59] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [Contacts].[EmailAddresses] ADD CONSTRAINT [FK__EmailAddr__Email__5812160E] FOREIGN KEY ([EmailType]) REFERENCES [Contacts].[EmailTypes] ([RowID])
GO
ALTER TABLE [Contacts].[EmailAddresses] ADD CONSTRAINT [FK__EmailAddr__Email__6D0D32F4] FOREIGN KEY ([EmailType]) REFERENCES [Contacts].[EmailTypes] ([RowID])
GO
ALTER TABLE [Contacts].[EmailAddresses] ADD CONSTRAINT [FK__EmailAddr__Perso__59063A47] FOREIGN KEY ([Person]) REFERENCES [Contacts].[People] ([RowID])
GO
ALTER TABLE [Contacts].[EmailAddresses] ADD CONSTRAINT [FK__EmailAddr__Perso__6E01572D] FOREIGN KEY ([Person]) REFERENCES [Contacts].[People] ([RowID])
GO
