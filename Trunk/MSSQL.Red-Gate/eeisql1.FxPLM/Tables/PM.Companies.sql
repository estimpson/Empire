CREATE TABLE [PM].[Companies]
(
[Status] [int] NOT NULL CONSTRAINT [DF__Companies__Statu__7484378A] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__Companies__Type__75785BC3] DEFAULT ((0)),
[CompanyCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[xCompanyCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PrimaryAddress1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryAddress2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryAddress3] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryCity] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryState] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryCountry] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryZipCode] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [int] NULL,
[Fax] [int] NULL,
[BillingAddress1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingAddress2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingAddress3] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingCity] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingState] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingCountry] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingZipCode] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Logo] [varbinary] (max) NULL,
[ProfileText] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__Companies__RowCr__7854C86E] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Companies__RowCr__7948ECA7] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__Companies__RowMo__7A3D10E0] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Companies__RowMo__7B313519] DEFAULT (suser_name())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [PM].[tr_Companies_uRowModified] on [PM].[Companies] after update
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. PM.usp_Test
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
		set	@TableName = 'PM.Companies'
		
		update
			c
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			PM.Companies c
			join inserted i
				on i.RowID = c.RowID
		
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
	PM.Companies
...

update
	...
from
	PM.Companies
...

delete
	...
from
	PM.Companies
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
ALTER TABLE [PM].[Companies] ADD CONSTRAINT [PK__Companie__FFEE74516CE315C2] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [PM].[Companies] ADD CONSTRAINT [UQ__Companie__11A0134B729BEF18] UNIQUE NONCLUSTERED  ([CompanyCode]) ON [PRIMARY]
GO
ALTER TABLE [PM].[Companies] ADD CONSTRAINT [UQ__Companie__87BC7F1A6FBF826D] UNIQUE NONCLUSTERED  ([xCompanyCode]) ON [PRIMARY]
GO
ALTER TABLE [PM].[Companies] ADD CONSTRAINT [FK__Companies__Fax__7760A435] FOREIGN KEY ([Fax]) REFERENCES [Contacts].[PhoneNumbers] ([RowID])
GO
ALTER TABLE [PM].[Companies] ADD CONSTRAINT [FK__Companies__Phone__766C7FFC] FOREIGN KEY ([Phone]) REFERENCES [Contacts].[PhoneNumbers] ([RowID])
GO
