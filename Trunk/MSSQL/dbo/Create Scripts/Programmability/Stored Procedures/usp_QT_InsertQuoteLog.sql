USE [MONITOR]
GO

/****** Object:  StoredProcedure [EEIUser].[usp_QT_InsertQuoteLog]    Script Date: 03/04/2013 11:20:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [EEIUser].[usp_QT_InsertQuoteLog]
	@QuoteNumber varchar(50)
--,	@Status int = 0
--,	@Type int = 0
,	@ParentQuoteID int = null
,	@CustomerRFQNumber varchar(50) = null
,	@ReceiptDate datetime = null
,	@Customer varchar(50) = null
,	@RequestedDueDate datetime = null
,	@EEIPromisedDueDate datetime = null
,	@CustomerPartNumber varchar(50) = null
,	@EEIPartNumber varchar(50) = null
,	@Requote char(2) = null
,	@Notes varchar(max) = null
,	@EAU numeric(20,6) = null
,	@ApplicationName varchar(255) = null
,	@ApplicationCode varchar(10) = null
,	@FunctionName varchar(50) = null
,	@Program varchar(50) = null
,	@OEM varchar(50) = null
--,	@Nameplate varchar(50) = null
,	@ModelYear varchar(10) = null
--,	@SOP varchar(10) = null
--,	@EOP varchar(10) = null
,	@SalesInitials varchar(10) = null
,	@ProgramManagerInitials varchar(10) = null
,	@EngineeringInitials varchar(10) = null
--,	@LTAPercentage varchar(10) = null
--,	@LTAYears varchar(10) = null
,	@EngineeringMaterialsInitials varchar(10) = null
,	@EngineeringMaterialsDate datetime = null
,	@QuoteReviewInitials varchar(10) = null
,	@QuoteReviewDate datetime = null
,	@QuotePricingInitials varchar(10) = null
,	@QuotePricingDate datetime = null
,	@CustomerQuoteInitials varchar(10) = null
,	@CustomerQuoteDate datetime = null
,	@StraightMaterialCost numeric(20,6) = null
,	@QuotePrice numeric(20,6) = null
,	@PrototypePrice numeric(20,6) = null
--,	@QuoteStatus varchar(10) = null
,	@Awarded char(3) = null
--,	@ProductionLevel char(3) = null
--,	@RevLevel varchar(50) = null
--,	@ProductionMaterialRollup numeric(20,6) = null
,	@TranDT datetime = null out
,	@Result integer = null out
as
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>
if exists (	select	1
			from	EEIUser.QT_QuoteLog
			where	QuoteNumber = @QuoteNumber) begin
	RAISERROR ('Quote Number %s already exists in the system.', 16, 1, @QuoteNumber)
	set	@Result = 999997
	rollback tran @ProcName
	return
end
---	</ArgumentValidation>

--- <Body>
declare
	@Status int = 0
,	@Type int = 0
,	@Nameplate varchar(50) = null
,	@SOP varchar(10) = null
,	@EOP varchar(10) = null
,	@LTAPercentage varchar(10) = null
,	@LTAYears varchar(10) = null
,	@QuoteStatus varchar(10) = null
,	@ProductionLevel char(3) = null
,	@RevLevel varchar(50) = null
,	@ProductionMaterialRollup numeric(20,6) = null

--- <Insert rows="1">
set	@TableName = 'EEIUser.QT_QuoteLog'

insert
	EEIUser.QT_QuoteLog
(	QuoteNumber
,	Status
,	Type
,	ParentQuoteID
,	CustomerRFQNumber
,	ReceiptDate
,	Customer
,	RequestedDueDate
,	EEIPromisedDueDate
,	CustomerPartNumber
,	EEIPartNumber
,	Requote
,	Notes
,	EAU
,	ApplicationName
,	ApplicationCode
,	FunctionName
,	Program
,	OEM
,	Nameplate
,	ModelYear
,	SOP
,	EOP
,	SalesInitials
,	ProgramManagerInitials
,	EngineeringInitials
,	LTAPercentage
,	LTAYears
,	EngineeringMaterialsInitials
,	EngineeringMaterialsDate
,	QuoteReviewInitials
,	QuoteReviewDate
,	QuotePricingInitials
,	QuotePricingDate
,	CustomerQuoteInitials
,	CustomerQuoteDate
,	StraightMaterialCost
,	QuotePrice
,	PrototypePrice
,	QuoteStatus
,	Awarded
,	ProductionLevel
,	RevLevel
,	ProductionMaterialRollup
)
select
	QuoteNumber = @QuoteNumber
,	Status = @Status
,	Type = @Type
,	ParentQuoteID = @ParentQuoteID
,	CustomerRFQNumber = @CustomerRFQNumber
,	ReceiptDate = @ReceiptDate
,	Customer = @Customer
,	RequestedDueDate = @RequestedDueDate
,	EEIPromisedDueDate = @EEIPromisedDueDate
,	CustomerPartNumber = @CustomerPartNumber
,	EEIPartNumber = @EEIPartNumber
,	Requote = @Requote
,	Notes = @Notes
,	EAU = @EAU
,	ApplicationName = @ApplicationName
,	ApplicationCode = @ApplicationCode
,	FunctionName = @FunctionName
,	Program = @Program
,	OEM = @OEM
,	Nameplate = @Nameplate
,	ModelYear = @ModelYear
,	SOP = @SOP
,	EOP = @EOP
,	SalesInitials = @SalesInitials
,	ProgramManagerInitials = @ProgramManagerInitials
,	EngineeringInitials = @EngineeringInitials
,	LTAPercentage = @LTAPercentage
,	LTAYears = @LTAYears
,	EngineeringMaterialsInitials = @EngineeringMaterialsInitials
,	EngineeringMaterialsDate = @EngineeringMaterialsDate
,	QuoteReviewInitials = @QuoteReviewInitials
,	QuoteReviewDate = @QuoteReviewDate
,	QuotePricingInitials = @QuotePricingInitials
,	QuotePricingDate = @QuotePricingDate
,	CustomerQuoteInitials = @CustomerQuoteInitials
,	CustomerQuoteDate = @CustomerQuoteDate
,	StraightMaterialCost = @StraightMaterialCost
,	QuotePrice = @QuotePrice
,	PrototypePrice = @PrototypePrice
,	QuoteStatus = @QuoteStatus
,	Awarded = @Awarded
,	ProductionLevel = @ProductionLevel
,	RevLevel = @RevLevel
,	ProductionMaterialRollup = @ProductionMaterialRollup

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999998
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount != 1 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Insert>
--- </Body>

--- <Tran AutoClose=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
--- </Tran>

---	<Return>
set	@Result = 0
return
	@Result
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

declare
	@User varchar(10)
,	@CycleCountNumber varchar(50)
,	@Serial int = null

set	@User = 'mon'
set	@CycleCountNumber = '0'
set	@Serial = '0'

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_InventoryControl_CycleCount_RecoverObject
	@User = @User
,	@CycleCountNumber = @CycleCountNumber
,	@Serial = @Serial
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
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

