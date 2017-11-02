SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE procedure [EDIPILOT].[usp_Stage1_GetInvoiceSummary]
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
	#210InvoiceSummary
	(	RawDocumentGUID 
	,	b3InvoiceNumber
	,	l3Weight 
	,	l3WeightQualifier	
	,	l3FreightWeight
	,	l3rateQualifier 
	,	l3Charge
	,	l3Advances
	,	l3PrepaidAmount 
	,	l3SAC 
	,	l3Volume 
	,	l3VolumneQual 
	,	l3ladingQty 
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
	,	b3InvoiceNumber =  ed.Data.value('(/TRN-210/SEG-B3/DE[@code="0076"])[1]', 'varchar(50)')
	,	l3Weight = ed.Data.value('(/TRN-210/SEG-L3/DE[@code="0081"])[1]', 'varchar(50)')
	,	l3WeightQualifier = ed.Data.value('(/TRN-210/SEG-L3/DE[@code="0187"])[1]', 'varchar(50)')	
	,	l3FreightWeight = ed.Data.value('(/TRN-210/SEG-L3/DE[@code="0060"])[1]', 'varchar(50)')
	,	l3rateQualifier = ed.Data.value('(/TRN-210/SEG-L3/DE[@code="0122"])[1]', 'varchar(50)')
	,	l3Charge = ed.Data.value('(/TRN-210/SEG-L3/DE[@code="0058"])[1]', 'varchar(50)')
	,	l3Advances = ed.Data.value('(/TRN-210/SEG-L3/DE[@code="0191"])[1]', 'varchar(50)')
	,	l3PrepaidAmount = ed.Data.value('(/TRN-210/SEG-L3/DE[@code="0117"])[1]', 'varchar(50)') 
	,	l3SAC = ed.Data.value('(/TRN-210/SEG-L3/DE[@code="0150"])[1]', 'varchar(50)')
	,	l3Volume = ed.Data.value('(/TRN-210/SEG-L3/DE[@code="0183"])[1]', 'varchar(50)')
	,	l3VolumneQual = ed.Data.value('(/TRN-210/SEG-L3/DE[@code="0184"])[1]', 'varchar(50)')
	,	l3ladingQty =  ed.Data.value('(/TRN-210/SEG-L3/DE[@code="0080"])[1]', 'varchar(50)')
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
