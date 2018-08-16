CREATE TABLE [PM].[CompanyLocations]
(
[Status] [int] NOT NULL CONSTRAINT [DF__CompanyLo__Statu__0C5BC11B] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__CompanyLoc__Type__0D4FE554] DEFAULT ((0)),
[Company] [int] NOT NULL,
[LocationCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[xLocationCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
[ShippingAddress1] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShippingAddress2] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShippingAddress3] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShippingCity] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShippingState] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShippingCountry] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShippingZipCode] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__CompanyLo__RowCr__11207638] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__CompanyLo__RowCr__12149A71] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__CompanyLo__RowMo__1308BEAA] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__CompanyLo__RowMo__13FCE2E3] DEFAULT (suser_name())
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [PM].[tr_CompanyLocations_uRowModified] on [PM].[CompanyLocations] after update
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
		set	@TableName = 'PM.CompanyLocations'
		
		update
			cl
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			PM.CompanyLocations cl
			join inserted i
				on i.RowID = cl.RowID
		
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
	PM.CompanyLocations
...

update
	...
from
	PM.CompanyLocations
...

delete
	...
from
	PM.CompanyLocations
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
ALTER TABLE [PM].[CompanyLocations] ADD CONSTRAINT [PK__CompanyL__FFEE745107970BFE] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [PM].[CompanyLocations] ADD CONSTRAINT [UQ__CompanyL__BBBE55420A7378A9] UNIQUE NONCLUSTERED  ([Company], [Name]) ON [PRIMARY]
GO
ALTER TABLE [PM].[CompanyLocations] ADD CONSTRAINT [FK__CompanyLo__Compa__0E44098D] FOREIGN KEY ([Company]) REFERENCES [PM].[Companies] ([RowID])
GO
ALTER TABLE [PM].[CompanyLocations] ADD CONSTRAINT [FK__CompanyLo__Phone__0F382DC6] FOREIGN KEY ([Phone]) REFERENCES [Contacts].[PhoneNumbers] ([RowID])
GO
ALTER TABLE [PM].[CompanyLocations] ADD CONSTRAINT [FK__CompanyLoca__Fax__102C51FF] FOREIGN KEY ([Fax]) REFERENCES [Contacts].[PhoneNumbers] ([RowID])
GO
