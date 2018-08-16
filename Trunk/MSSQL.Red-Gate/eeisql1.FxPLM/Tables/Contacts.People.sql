CREATE TABLE [Contacts].[People]
(
[Status] [int] NOT NULL CONSTRAINT [DF__People__Status__64D7DFA6] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__People__Type__65CC03DF] DEFAULT ((0)),
[Prefix] [int] NULL,
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Title] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Company] [int] NULL,
[CompanyLocation] [int] NULL,
[Department] [int] NULL,
[PrimaryEmailAddress] [int] NULL,
[PrimaryPhone] [int] NULL,
[EmploymentStatus] [int] NULL,
[DateOfBirth] [datetime] NULL,
[ProfilePic] [varbinary] (max) NULL,
[ProfileText] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__People__RowCreat__6D6D25A7] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__People__RowCreat__6E6149E0] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__People__RowModif__6F556E19] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__People__RowModif__70499252] DEFAULT (suser_name())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [Contacts].[tr_People_uRowModified] on [Contacts].[People] after update
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
		set	@TableName = 'Contacts.People'
		
		update
			p
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			Contacts.People p
			join inserted i
				on i.RowID = p.RowID
		
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
	Contacts.People
...

update
	...
from
	Contacts.People
...

delete
	...
from
	Contacts.People
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
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [PK__People__FFEE745162EF9734] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__Company__2B9F624A] FOREIGN KEY ([Company]) REFERENCES [PM].[Companies] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__Company__4D35603F] FOREIGN KEY ([Company]) REFERENCES [PM].[Companies] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__Company__67B44C51] FOREIGN KEY ([Company]) REFERENCES [PM].[Companies] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__Company__763775D2] FOREIGN KEY ([Company]) REFERENCES [PM].[Companies] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__CompanyL__2C938683] FOREIGN KEY ([CompanyLocation]) REFERENCES [PM].[CompanyLocations] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__CompanyL__4E298478] FOREIGN KEY ([CompanyLocation]) REFERENCES [PM].[CompanyLocations] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__CompanyL__68A8708A] FOREIGN KEY ([CompanyLocation]) REFERENCES [PM].[CompanyLocations] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__CompanyL__772B9A0B] FOREIGN KEY ([CompanyLocation]) REFERENCES [PM].[CompanyLocations] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__Departme__2D87AABC] FOREIGN KEY ([Department]) REFERENCES [Contacts].[CompanyDepartments] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__Departme__4F1DA8B1] FOREIGN KEY ([Department]) REFERENCES [Contacts].[CompanyDepartments] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__Departme__699C94C3] FOREIGN KEY ([Department]) REFERENCES [Contacts].[CompanyDepartments] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__Departme__781FBE44] FOREIGN KEY ([Department]) REFERENCES [Contacts].[CompanyDepartments] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__Employme__30641767] FOREIGN KEY ([EmploymentStatus]) REFERENCES [Contacts].[ContactEmploymentStatus] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__Employme__51FA155C] FOREIGN KEY ([EmploymentStatus]) REFERENCES [Contacts].[ContactEmploymentStatus] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__Employme__6C79016E] FOREIGN KEY ([EmploymentStatus]) REFERENCES [Contacts].[ContactEmploymentStatus] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__Employme__7AFC2AEF] FOREIGN KEY ([EmploymentStatus]) REFERENCES [Contacts].[ContactEmploymentStatus] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__Prefix__2AAB3E11] FOREIGN KEY ([Prefix]) REFERENCES [Contacts].[NamePrefix] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__Prefix__4C413C06] FOREIGN KEY ([Prefix]) REFERENCES [Contacts].[NamePrefix] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__Prefix__66C02818] FOREIGN KEY ([Prefix]) REFERENCES [Contacts].[NamePrefix] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__Prefix__75435199] FOREIGN KEY ([Prefix]) REFERENCES [Contacts].[NamePrefix] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__PrimaryE__2E7BCEF5] FOREIGN KEY ([PrimaryEmailAddress]) REFERENCES [Contacts].[EmailAddresses] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__PrimaryE__5011CCEA] FOREIGN KEY ([PrimaryEmailAddress]) REFERENCES [Contacts].[EmailAddresses] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__PrimaryE__6A90B8FC] FOREIGN KEY ([PrimaryEmailAddress]) REFERENCES [Contacts].[EmailAddresses] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__PrimaryE__7913E27D] FOREIGN KEY ([PrimaryEmailAddress]) REFERENCES [Contacts].[EmailAddresses] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__PrimaryP__2F6FF32E] FOREIGN KEY ([PrimaryPhone]) REFERENCES [Contacts].[PhoneNumbers] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__PrimaryP__5105F123] FOREIGN KEY ([PrimaryPhone]) REFERENCES [Contacts].[PhoneNumbers] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__PrimaryP__6B84DD35] FOREIGN KEY ([PrimaryPhone]) REFERENCES [Contacts].[PhoneNumbers] ([RowID])
GO
ALTER TABLE [Contacts].[People] ADD CONSTRAINT [FK__People__PrimaryP__7A0806B6] FOREIGN KEY ([PrimaryPhone]) REFERENCES [Contacts].[PhoneNumbers] ([RowID])
GO
