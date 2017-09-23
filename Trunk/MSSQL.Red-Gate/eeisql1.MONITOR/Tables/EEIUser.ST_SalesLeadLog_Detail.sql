CREATE TABLE [EEIUser].[ST_SalesLeadLog_Detail]
(
[SalesLeadId] [int] NOT NULL,
[SalesPersonCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__ST_SalesD__Statu__31EC0563] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__ST_SalesD__Type__32E0299C] DEFAULT ((0)),
[Activity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActivityDate] [datetime] NULL,
[MeetingLocation] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactPhoneNumber] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactEmailAddress] [varchar] (320) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Duration] [numeric] (20, 6) NULL,
[Notes] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QuoteNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AwardedVolume] [int] NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__ST_SalesD__RowCr__34C8720E] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ST_SalesD__RowCr__35BC9647] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__ST_SalesD__RowMo__36B0BA80] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__ST_SalesD__RowMo__37A4DEB9] DEFAULT (suser_name())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE trigger [EEIUser].[ST_SalesLeadLog_Detail_uRowModified] on [EEIUser].[ST_SalesLeadLog_Detail] after update
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. custom.usp_Test
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
		set	@TableName = 'EEIUser.ST_SalesLeadLog_Detail'
		
		update
			slld
		set	
			RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			EEIUser.ST_SalesLeadLog_Detail slld
			join inserted i
				on i.RowID = slld.RowID
		
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
GO
ALTER TABLE [EEIUser].[ST_SalesLeadLog_Detail] ADD CONSTRAINT [PK__ST_SaleD__FFEE74512D275046] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[ST_SalesLeadLog_Detail] ADD CONSTRAINT [FK_ST_SalesLeadLog_Detail_ST_SalesLeadLog_Header] FOREIGN KEY ([SalesLeadId]) REFERENCES [EEIUser].[ST_SalesLeadLog_Header] ([RowID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
