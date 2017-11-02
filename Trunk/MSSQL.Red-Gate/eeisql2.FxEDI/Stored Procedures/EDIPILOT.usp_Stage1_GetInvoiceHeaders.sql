SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [EDIPILOT].[usp_Stage1_GetInvoiceHeaders]
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
	#210InvoiceHeader
	(	RawDocumentGUID 
	,	b3ShipmentQualifier 
	,	b3InvoiceNumber 
	,	b3ShipperID 
	,	b3MethodOfPayment 	
	,	b3WeightUnit 
	,	b3InvoiceDate
	,	b3NetAmoutDue 
	,	b3CorrectionIndicator 
	,	b3DeliveryDate 	
	,	b3DateTimeQualifier  
	,	b3SCAC  
	,	c3Currency 
	,	r3SCAC 
	,	r3RoutingSequence 
	,	r3City  
	,	r3TransMode
	,	r3StdPointLocationCode
	,	r3InvoiceNumber 
	,	r3InvoiceDate 
	,	r3InvoiceAmount 
	,	r3Description 
	,	r3ServiceLevelCode
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
	,	b3ShipmentQualifier = ed.Data.value('(/TRN-210/SEG-B3/DE[@code="0147"])[1]', 'varchar(50)')
	,	b3InvoiceNumber = ed.Data.value('(/TRN-210/SEG-B3/DE[@code="0076"])[1]', 'varchar(50)')
	,	b3ShipperID = ed.Data.value('(/TRN-210/SEG-B3/DE[@code="0145"])[1]', 'varchar(50)')
	,	b3MethodOfPayment = ed.Data.value('(/TRN-210/SEG-B3/DE[@code="0146"])[1]', 'varchar(50)')
	,	b3WeightUnit = ed.Data.value('(/TRN-210/SEG-B3/DE[@code="0188"])[1]', 'varchar(50)')
	,	b3InvoiceDate = ed.Data.value('(/TRN-210/SEG-B3/DE[@code="0373"])[1]', 'varchar(50)')
	,	b3NetAmoutDue = ed.Data.value('(/TRN-210/SEG-B3/DE[@code="0193"])[1]', 'varchar(50)')
	,	b3CorrectionIndicator = ed.Data.value('(/TRN-210/SEG-B3/DE[@code="0202"])[1]', 'varchar(50)')
	,	b3DeliveryDate 	= ed.Data.value('(/TRN-210/SEG-B3/DE[@code="0032"])[1]', 'varchar(50)')
	,	b3DateTimeQualifier  = ed.Data.value('(/TRN-210/SEG-B3/DE[@code="0374"])[1]', 'varchar(50)')
	,	b3SCAC  = ed.Data.value('(/TRN-210/SEG-B3/DE[@code="0140"])[1]', 'varchar(50)')
	,	c3Currency = ed.Data.value('(/TRN-210/SEG-C3/DE[@code="0100"])[1]', 'varchar(50)')
	,	r3SCAC  = ed.Data.value('(/TRN-210/SEG-R3/DE[@code="0140"])[1]', 'varchar(50)')
	,	r3RoutingSequence = ed.Data.value('(/TRN-210/SEG-R3/DE[@code="0133"])[1]', 'varchar(50)')
	,	r3City  = ed.Data.value('(/TRN-210/SEG-R3/DE[@code="0019"])[1]', 'varchar(50)')
	,	r3TransMode = ed.Data.value('(/TRN-210/SEG-R3/DE[@code="0091"])[1]', 'varchar(50)')
	,	r3StdPointLocationCode = ed.Data.value('(/TRN-210/SEG-R3/DE[@code="0154"])[1]', 'varchar(50)')
	,	r3InvoiceNumber  = ed.Data.value('(/TRN-210/SEG-R3/DE[@code="0076"])[1]', 'varchar(50)')
	,	r3InvoiceDate = ed.Data.value('(/TRN-210/SEG-R3/DE[@code="0373"])[1]', 'varchar(50)')
	,	r3InvoiceAmount = ed.Data.value('(/TRN-210/SEG-R3/DE[@code="0610"])[1]', 'varchar(50)') 
	,	r3Description =  ed.Data.value('(/TRN-210/SEG-R3/DE[@code="0369"])[1]', 'varchar(50)')
	,	r3ServiceLevelCode = ed.Data.value('(/TRN-210/SEG-R3/DE[@code="0284"])[1]', 'varchar(50)')
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
	
	
if	@Debug > 0 begin
	set	@toc = getdate() - @TranDT
	select '#PlanningAccums', @toc
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
