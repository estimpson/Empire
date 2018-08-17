CREATE TABLE [NSA].[NewSalesAwards_Legacy]
(
[Status] [int] NOT NULL CONSTRAINT [DF__NewSalesA__Statu__7DCDAAA2] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__NewSalesAw__Type__7EC1CEDB] DEFAULT ((0)),
[Salesperson] [int] NULL,
[ProgramManager] [int] NULL,
[ProgramAwardDate] [datetime] NULL,
[QuoteTransferMeetingFlag] [tinyint] NULL,
[CustomerCommitmentForm] [int] NULL,
[MasterSalesForecastDate] [datetime] NULL,
[Customer] [int] NULL,
[NewBusinessType] [int] NULL,
[EmpireBasePart] [int] NULL,
[CustomerPartNumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Family] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VehicleProgram] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VehicleName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VehicleApplication] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmpireMarketSegment] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmpireMarketSubsegment] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductLine] [int] NULL,
[GeographicMarket] [int] NULL,
[QtyPerVehicle] [numeric] (5, 2) NULL,
[TakeRate] [numeric] (5, 3) NULL,
[FamilyAllocation] [numeric] (5, 3) NULL,
[CSM_EAU] [int] NULL,
[CustomerAnnualCapacityPlanningVolume] [int] NULL,
[QuoteID] [int] NULL,
[QuoteNumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QuoteDate] [datetime] NULL,
[QuotedEAU] [int] NULL,
[MinimumOrderQuantity] [int] NULL,
[QuotedSellingPrice] [numeric] (20, 6) NULL,
[QuotedMaterialCost] [numeric] (20, 6) NULL,
[QuotedAnnualSales] AS ([QuotedEAU]*[QuotedSellingPrice]),
[QuotedLTACommitment] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QuoteNote] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerProductionPONumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProductionPODate] [datetime] NULL,
[AlternativeCustomerCommitment] [int] NULL,
[PurchaseOrderSellingPrice] [numeric] (20, 6) NULL,
[SOPDate] [datetime] NULL,
[EOPDate] [datetime] NULL,
[ProductionNote] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QuotePurchaseOrderPriceVariance] AS ([PurchaseOrderSellingPrice]-[QuotedSellingPrice]),
[ToolingPONumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ToolingPODate] [datetime] NULL,
[ToolingPOAmount] [numeric] (20, 6) NULL,
[ToolingPONote] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CrimpDiePOFlag] [tinyint] NULL,
[CrimpDiePOAmount] [numeric] (20, 6) NULL,
[CrimpDiePONote] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AmortizationFlag] [tinyint] NULL,
[AmortizationAmount] [numeric] (20, 6) NULL,
[AmortizationNote] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BillingTriggerAndInstallments] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ToolingDescription] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BudgetCapexID] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmpireFacility] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FreightTerms] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerShipToLocation] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GeneralNote] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__NewSalesA__RowCr__084B3915] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__NewSalesA__RowCr__093F5D4E] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__NewSalesA__RowMo__0A338187] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__NewSalesA__RowMo__0B27A5C0] DEFAULT (suser_name())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [NSA].[tr_NewSalesAwards_uRowModified] on [NSA].[NewSalesAwards_Legacy] after update
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. NJB.usp_Test
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
		set	@TableName = 'NJB.NewSalesAwards'
		
		update
			NJB
		set	RowModifiedDT = getdate()
		,	RowModifiedUser = suser_name()
		from
			NJB.NewSalesAwards NJB
			join inserted i
				on i.RowID = NJB.RowID
		
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
	NJB.NewSalesAwards
...

update
	...
from
	NJB.NewSalesAwards
...

delete
	...
from
	NJB.NewSalesAwards
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
