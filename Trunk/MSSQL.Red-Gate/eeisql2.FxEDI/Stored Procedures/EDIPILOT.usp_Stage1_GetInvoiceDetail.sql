SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE procedure [EDIPILOT].[usp_Stage1_GetInvoiceDetail]
	@TranDT datetime = null out
,	@Result integer = null out
,	@Debug int = 0
as
set nocount on
set ansi_warnings on
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDI4010.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
--declare
--	@TranCount smallint

--set	@TranCount = @@TranCount
--if	@TranCount = 0 begin
--	begin tran @ProcName
--end
--else begin
--	save tran @ProcName
--end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
if	@Debug > 0 begin
	declare
	@toc time
end





Insert
		#210InvoiceDetail
	(	RawDocumentGUID
	,	InvoiceNumber
	,	b3lXAssignedNumber
	,	n9Qualifier
	,	n9Data  	
	,	podDate 
	,	podTime 
	,	podName 
	,	l5LadingLineItemNumber 
	,	l5LadingDescription 	
	,	L0LadinglineItemNumber  
	,	l0BilledQty  
	,	l0BilledQtyUOM 
	,	l0WeightQualfier 
	,	l0Volume  
	,	l0VolumeUnit 
	,	l0LadingQty 
	,	l0PackagingCode 
	,	l1ladingLineItem 
	,	l1FreightRate 
	,	l1RateQualifier 
	,	l1RateCharge 
	,	L4Length 
	,	L4Width 
	,	L4Height  
	,	L4UOM  
	,	L4Qty   
	,	UserDefined1  
	,	UserDefined2  
	,	UserDefined3  
	,	UserDefined4  
	,	UserDefined5  
	,	UserDefined6  
	,	UserDefined7 
	,	UserDefined8 
	,	UserDefined9 
	,	UserDefined10 
	)

select
		RawDocumentGUID
	,	b3InvoiceNumber = ed.Data.value('(/TRN-210/SEG-B3/DE[@code="0076"])[1]', 'varchar(50)')
	,	b3lXAssignedNumber = EDIData.InvoiceLines.value('(./SEG-LX/DE[@code="0554"])[1]', 'varchar(50)')
	,	n9Qualifier = EDIData.InvoiceLines.value('(./SEG-N9/DE[@code="0128"])[1]', 'varchar(50)')
	,	n9Data = EDIData.InvoiceLines.value('(./SEG-N9/DE[@code="0127"])[1]', 'varchar(50)') 
	,	podDate = EDIData.InvoiceLines.value('(./SEG-POD/DE[@code="0373"])[1]', 'varchar(50)') 
	,	podTime = EDIData.InvoiceLines.value('(./SEG-POD/DE[@code="0337"])[1]', 'varchar(50)') 
	,	podName = EDIData.InvoiceLines.value('(./SEG-POD/DE[@code="0093"])[1]', 'varchar(50)') 
	,	l5LadingLineItemNumber = EDIData.InvoiceLines.value('(./SEG-L5/DE[@code="0213"])[1]', 'varchar(50)') 
	,	l5LadingDescription = EDIData.InvoiceLines.value('(./SEG-L5/DE[@code="0079"])[1]', 'varchar(50)') 	
	,	L0LadinglineItemNumber = EDIData.InvoiceLines.value('(./SEG-L0/DE[@code="0213"])[1]', 'varchar(50)')  
	,	l0BilledQty = EDIData.InvoiceLines.value('(./SEG-L0/DE[@code="0220"])[1]', 'varchar(50)')  
	,	l0BilledQtyUOM = EDIData.InvoiceLines.value('(./SEG-L0/DE[@code="0221"])[1]', 'varchar(50)') 
	,	l0WeightQualfier = EDIData.InvoiceLines.value('(./SEG-L0/DE[@code="0187"])[1]', 'varchar(50)') 
	,	l0Volume = EDIData.InvoiceLines.value('(./SEG-L0/DE[@code="0183"])[1]', 'varchar(50)')  
	,	l0VolumeUnit = EDIData.InvoiceLines.value('(./SEG-L0/DE[@code="0184"])[1]', 'varchar(50)') 
	,	l0LadingQty = EDIData.InvoiceLines.value('(./SEG-L0/DE[@code="0080"])[1]', 'varchar(50)') 
	,	l0PackagingCode = EDIData.InvoiceLines.value('(./SEG-L0/DE[@code="0211"])[1]', 'varchar(50)') 
	,	l1ladingLineItem = EDIData.InvoiceLines.value('(./SEG-L1/DE[@code="0213"])[1]', 'varchar(50)') 
	,	l1FreightRate = EDIData.InvoiceLines.value('(./SEG-L1/DE[@code="0060"])[1]', 'varchar(50)') 
	,	l1RateQualifier = EDIData.InvoiceLines.value('(./SEG-L1/DE[@code="0122"])[1]', 'varchar(50)') 
	,	l1RateCharge = EDIData.InvoiceLines.value('(./SEG-L1/DE[@code="0058"])[1]', 'varchar(50)') 
	,	L4Length = EDIData.InvoiceLines.value('(./SEG-L4/DE[@code="0082"])[1]', 'varchar(50)') 
	,	L4Width = EDIData.InvoiceLines.value('(./SEG-L4/DE[@code="0189"])[1]', 'varchar(50)')
	,	L4Height = EDIData.InvoiceLines.value('(./SEG-L4/DE[@code="0065"])[1]', 'varchar(50)') 
	,	L4UOM  = EDIData.InvoiceLines.value('(./SEG-L4/DE[@code="0090"])[1]', 'varchar(50)')
	,	L4Qty  = EDIData.InvoiceLines.value('(./SEG-L4/DE[@code="0380"])[1]', 'varchar(50)')
	,	UserDefined1 = ''
	,	UserDefined2 = ''
	,	UserDefined3 = ''
	,	UserDefined4 = '' 
	,	UserDefined5 = ''
	,	UserDefined6 = '' 
	,	UserDefined7 = ''
	,	UserDefined8 = ''
	,	UserDefined9 = ''
	,	UserDefined10 = '' 

from
	#210Headers ed
cross apply 
	ed.Data.nodes('/TRN-210/LOOP-LX') as EDIData(InvoiceLines)
	
	
if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '#InvoiceDetail', @toc
end
--- </Body>

---	<CloseTran AutoCommit=Yes>
--if	@TranCount = 0 begin
--	commit tran @ProcName
--end
---	</CloseTran AutoCommit=Yes>

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
	@Param1 [scalar_data_type]

set	@Param1 = [test_value]

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = EDI4010.usp_Stage1_GetPlanningAccums
	@Param1 = @Param1
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
