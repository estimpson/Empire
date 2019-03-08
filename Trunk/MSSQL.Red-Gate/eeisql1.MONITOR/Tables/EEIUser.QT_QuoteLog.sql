CREATE TABLE [EEIUser].[QT_QuoteLog]
(
[QuoteNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__QT_QuoteL__Statu__31EC0563] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__QT_QuoteLo__Type__32E0299C] DEFAULT ((0)),
[ParentQuoteID] [int] NULL,
[CustomerRFQNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReceiptDate] [datetime] NULL,
[Customer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RequestedDueDate] [datetime] NULL,
[EEIPromisedDueDate] [datetime] NULL,
[CustomerPartNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EEIPartNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Requote] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Notes] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EAU] [numeric] (20, 0) NULL,
[ApplicationName] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApplicationCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FunctionName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Program] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OEM] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Nameplate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModelYear] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOP] [datetime] NULL,
[EOP] [datetime] NULL,
[SalesInitials] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProgramManagerInitials] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EngineeringInitials] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LTAPercentage] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LTAYears] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EngineeringMaterialsInitials] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EngineeringMaterialsDate] [datetime] NULL,
[QuoteReviewInitials] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QuoteReviewDate] [datetime] NULL,
[QuotePricingInitials] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QuotePricingDate] [datetime] NULL,
[CustomerQuoteInitials] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerQuoteDate] [datetime] NULL,
[StraightMaterialCost] [numeric] (20, 6) NULL,
[QuotePrice] [numeric] (20, 4) NULL,
[TotalQuotedSales] AS ([QuotePrice]*[EAU]),
[QuoteStatus] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Awarded] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AwardedDate] [datetime] NULL,
[ProductionLevel] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RevLevel] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductionMaterialRollup] [numeric] (20, 6) NULL,
[EmpireMarketSegment] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmpireMarketSubsegment] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__QT_QuoteL__RowCr__34C8720E] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QT_QuoteL__RowCr__35BC9647] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__QT_QuoteL__RowMo__36B0BA80] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__QT_QuoteL__RowMo__37A4DEB9] DEFAULT (suser_name()),
[Tooling] [numeric] (20, 0) NULL,
[ProgramComputed] AS ([EEIUser].[fn_QT_GetCSMProgramsForQuote]([QuoteNumber])),
[OEMComputed] AS ([EEIUser].[fn_QT_GetCSMManufacturersForQuote]([QuoteNumber])),
[NameplateComputed] AS ([EEIUser].[fn_QT_GetCSMNameplatesForQuote]([QuoteNumber])),
[PrototypePrice] [numeric] (20, 2) NULL,
[LTA] AS ([EEIUSER].[fn_QT_GetLTAsForQuote]([QuoteNumber])),
[PrintFilePath] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrintNo] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrintDate] [datetime] NULL,
[CustomerQuoteFilePath] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StdHours] [numeric] (20, 4) NULL,
[PackageNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberOfDaysLate] AS ([EEIUser].[fn_QT_GetDaysLateForQuote]([QuoteNumber])),
[ProductLine] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QuoteReason] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileServerQuotePrint] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileServerCustomerQuote] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MinimumOrderQuantity] [int] NULL,
[QuoteTransferComplete] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QuoteTransferCompletedDate] [datetime] NULL,
[AmortizationAmount] [numeric] (20, 6) NULL,
[AmortizationQuantity] [numeric] (20, 6) NULL,
[AmortizationPrice] AS ([AmortizationAmount]/nullif([AmortizationQuantity],(0))),
[TotalPrice] AS ([QuotePrice]+([AmortizationAmount]/nullif([AmortizationQuantity],(0)))),
[AmortizationToolingDescription] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HardToolingAmount] [numeric] (20, 6) NULL,
[HardToolingTrigger] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HardToolingDescription] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssemblyTesterToolingAmount] [numeric] (20, 6) NULL,
[AssemblyTesterToolingQuantity] [numeric] (20, 6) NULL,
[AssemblyTesterToolingTrigger] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AssemblyTesterToolingDescription] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SetupChargeAmount] [numeric] (20, 6) NULL,
[SetupTrigger] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SetupDescription] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE trigger [EEIUser].[tr_QT_QuoteLog_RowDeleted] on [EEIUser].[QT_QuoteLog] after delete
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EEIUser.usp_Test
--- </Error Handling>

begin try
	--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
	declare
		@TranCount smallint

	set	@TranCount = @@TranCount
	set	@TranDT = coalesce(@TranDT, GetDate())
	--- </Tran>

	---	<ArgumentValidation>
	---	</ArgumentValidation>
	
	--- <Body>
	--- Clean up all data tied to the deleted quote number
	delete
		qmpd
	from
		EEIUser.QT_QuoteManualProgramData qmpd
		join deleted d
			on d.QuoteNumber = qmpd.QuoteNumber
	
	delete
		qcsm
	from
		EEIUser.QT_QuoteCSM qcsm
		join deleted d
			on d.QuoteNumber = qcsm.QuoteNumber

	delete
		qlta
	from
		EEIUser.QT_QuoteLTA qlta
		join deleted d
			on d.QuoteNumber = qlta.QuoteNumber
			
	delete
		qp
	from
		EEIUser.QT_QuotePrints qp
		join deleted d
			on d.QuoteNumber = qp.QuoteNumber
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
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE trigger [EEIUser].[tr_QT_QuoteLog_uRowInserted] on [EEIUser].[QT_QuoteLog] after insert
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EEIUser.usp_Test
--- </Error Handling>

begin try
	--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
	declare
		@TranCount smallint

	set	@TranCount = @@TranCount
	set	@TranDT = coalesce(@TranDT, GetDate())
	--- </Tran>

	---	<ArgumentValidation>

	---	</ArgumentValidation>
	
	--- <Body>
	set @TableName = 'EEIUser.QT_QuoteLog'
		
	if	exists
		(	select	
				*
			from	
				inserted i
			where
				i.CustomerQuoteDate is not null
				and (i.QuoteStatus != 'COMPLETED' or i.QuoteStatus is null)
		) begin 
				
		update
			ql
		set	
			ql.QuoteStatus = 'COMPLETED'	
		from
			EEIUser.QT_QuoteLog ql
			join inserted i
				on i.RowID = ql.RowID
		where
			i.CustomerQuoteDate is not null
			and (i.QuoteStatus != 'COMPLETED' or i.QuoteStatus is null)	
	end
	else if
		exists
		(	select	
				*
			from	
				inserted i
			where
				i.CustomerQuoteDate is null
				and (i.QuoteStatus != 'OPEN' or i.QuoteStatus is null)
		) begin 
		
		update
			ql
		set	
			QuoteStatus = 'OPEN'	
		from
			EEIUser.QT_QuoteLog ql
			join inserted i
				on i.RowID = ql.RowID
		where
			i.CustomerQuoteDate is null
			and (i.QuoteStatus != 'OPEN' or i.QuoteStatus is null)
	end
	
	
	-- Account for the RowCreateDT not getting set
	update
		ql
	set	
		RowCreateDT = getdate()	
	from
		EEIUser.QT_QuoteLog ql
		join inserted i
			on i.RowID = ql.RowID
	--- </Body>
end try
begin catch
/*
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
*/
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
	EEIUser.QT_QuoteLog
...

update
	...
from
	EEIUser.QT_QuoteLog
...

delete
	...
from
	EEIUser.QT_QuoteLog
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
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE trigger [EEIUser].[tr_QT_QuoteLog_uRowModified] on [EEIUser].[QT_QuoteLog] after update
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EEIUser.usp_Test
--- </Error Handling>

begin try
	--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
	declare
		@TranCount smallint

	set	@TranCount = @@TranCount
	set	@TranDT = coalesce(@TranDT, GetDate())
	--- </Tran>

	---	<ArgumentValidation>

	---	</ArgumentValidation>
	
	--- <Body>
	if	not update(RowModifiedDT) begin
    
		--- <Update rows="*">
		set	@TableName = 'EEIUser.QT_QuoteLog'
	
		update
			ql
		set	
			RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			EEIUser.QT_QuoteLog ql
			join inserted i
				on i.RowID = ql.RowID
		--- </Update>
	end
	
	-- If CustomerQuoteDate has been updated, then set the QuoteStatus
	if	not update(QuoteStatus) and update(CustomerQuoteDate)
		begin
	
		set @TableName = 'EEIUser.QT_QuoteLog'
		
		if	exists
			(	select	
					*
				from	
					inserted i
				where
					i.CustomerQuoteDate is not null
					and (i.QuoteStatus != 'COMPLETED' or i.QuoteStatus is null)
			) begin 

			update
				ql
			set	
				ql.QuoteStatus = 'COMPLETED'	
			from
				EEIUser.QT_QuoteLog ql
				join inserted i
					on i.RowID = ql.RowID
			where
				i.CustomerQuoteDate is not null
				and (i.QuoteStatus != 'COMPLETED' or i.QuoteStatus is null)
		end
		else if
			exists
			(	select	
					*
				from	
					inserted i
				where
					i.CustomerQuoteDate is null
					and (i.QuoteStatus != 'OPEN' or i.QuoteStatus is null)
			) begin 
			
			update
				ql
			set	
				QuoteStatus = 'OPEN'	
			from
				EEIUser.QT_QuoteLog ql
				join inserted i
					on i.RowID = ql.RowID
			where
				i.CustomerQuoteDate is null
				and (i.QuoteStatus != 'OPEN' or i.QuoteStatus is null)
		end
	end
	
	-- If a Quote Price of zero has been entered, then this is a No Quote
	--  A No Quote is a quote that will never be completed
	if	not update(QuoteStatus) and update(QuotePrice)
		begin
		
		set @TableName = 'EEIUser.QT_QuoteLog'
		
		if	exists
			(	select	
					*
				from	
					inserted i
				where
					i.QuotePrice = 0
					and (i.QuoteStatus != 'NO QUOTE' or i.QuoteStatus is null)
			) begin 
		
				update
					ql
				set	
					ql.QuoteStatus = 'NO QUOTE'	
				from
					EEIUser.QT_QuoteLog ql
					join inserted i
						on i.RowID = ql.RowID
				where
					i.QuotePrice = 0
					and (i.QuoteStatus != 'NO QUOTE' or i.QuoteStatus is null)
		end
	end	
	--- </Body>
end try
begin catch
/*
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
*/
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
	EEIUser.QT_QuoteLog
...

update
	...
from
	EEIUser.QT_QuoteLog
...

delete
	...
from
	EEIUser.QT_QuoteLog
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
ALTER TABLE [EEIUser].[QT_QuoteLog] ADD CONSTRAINT [PK__QT_Quote__FFEE74512D275046] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_QuoteLog_ApplicationCode] ON [EEIUser].[QT_QuoteLog] ([ApplicationCode]) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_QuoteLog] ADD CONSTRAINT [UQ__QT_Quote__8A47966A3003BCF1] UNIQUE NONCLUSTERED  ([QuoteNumber]) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[QT_QuoteLog] ADD CONSTRAINT [FK__QT_QuoteL__Paren__33D44DD5] FOREIGN KEY ([ParentQuoteID]) REFERENCES [EEIUser].[QT_QuoteLog] ([RowID])
GO
