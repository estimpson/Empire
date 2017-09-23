SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE procedure [EDIPILOT].[usp_Stage_2]
	@TranDT datetime = null out
,	@Result integer = null  out
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDIPilot.usp_Test
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

---	</ArgumentValidation>

--- <Body>
/*	Move staging data into permanent tables...*/

--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	@ProcReturn = dbo.sp_rename
	@objname = N'EDIPilot.StagingInvoice210Docs'
,	@newName = N'StagingInvoice210DocsT'

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
--- </Call>


--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIPilot.StagingInvoice210Headers'
,	@newName = N'StagingInvoice210HeadersT'

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
--- </Call>

--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIPilot.StagingInvoice210Address'
,	@newName = N'StagingInvoice210AddressT'

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
--- </Call>

--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIPilot.StagingInvoice210N9REF'
,	@newName = N'StagingInvoice210N9REFT'

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
--- </Call>


--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIPilot.StagingInvoice210Detail'
,	@newName = N'StagingInvoice210DetailT'

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
--- </Call>

--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIPilot.StagingInvoice210Summary'
,	@newName = N'StagingInvoice210summaryT'

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
--- </Call>


--- <Insert rows="*">
set	@TableName = 'EDIPilot.Invoice210Docs'

insert
	EDIPilot.Invoice210Docs
(			[RawDocumentGUID]
           ,[DocumentImportDT]
           ,[TradingPartner]
           ,[DocType]
           ,[Version]
           ,[DocumentDT]
)
select
			[RawDocumentGUID]
           ,[DocumentImportDT]
           ,[TradingPartner]
           ,[DocType]
           ,[Version]
           ,[DocumentDT]
from
	EDIPilot.StagingInvoice210DocsT sfh

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Insert>

/*				210 Headers.*/
--- <Insert rows="*">
set	@TableName = 'EDIPilot.Invoice210Headers'

insert
	EDIPilot.Invoice210Headers
(			[RawDocumentGUID]
           ,[b3ShipmentQualifier]
           ,[b3InvoiceNumber]
           ,[b3ShipperID]
           ,[b3MethodOfPayment]
           ,[b3WeightUnit]
           ,[b3InvoiceDate]
           ,[b3NetAmoutDue]
           ,[b3CorrectionIndicator]
           ,[b3DeliveryDate]
           ,[b3DateTimeQualifier]
           ,[b3SCAC]
           ,[c3Currency]
           ,[r3SCAC]
           ,[r3RoutingSequence]
           ,[r3City]
           ,[r3TransMode]
           ,[r3StdPointLocationCode]
           ,[r3InvoiceNumber]
           ,[r3InvoiceDate]
           ,[r3InvoiceAmount]
           ,[r3Description]
           ,[r3ServiceLevelCode]
           ,[UserDefined1]
           ,[UserDefined2]
           ,[UserDefined3]
           ,[UserDefined4]
           ,[UserDefined5]
           ,[UserDefined6]
           ,[UserDefined7]
           ,[UserDefined8]
           ,[UserDefined9]
           ,[UserDefined10]

)
select
		[RawDocumentGUID]
           ,[b3ShipmentQualifier]
           ,[b3InvoiceNumber]
           ,[b3ShipperID]
           ,[b3MethodOfPayment]
           ,[b3WeightUnit]
           ,[b3InvoiceDate]
           ,[b3NetAmoutDue]
           ,[b3CorrectionIndicator]
           ,[b3DeliveryDate]
           ,[b3DateTimeQualifier]
           ,[b3SCAC]
           ,[c3Currency]
           ,[r3SCAC]
           ,[r3RoutingSequence]
           ,[r3City]
           ,[r3TransMode]
           ,[r3StdPointLocationCode]
           ,[r3InvoiceNumber]
           ,[r3InvoiceDate]
           ,[r3InvoiceAmount]
           ,[r3Description]
           ,[r3ServiceLevelCode]
           ,[UserDefined1]
           ,[UserDefined2]
           ,[UserDefined3]
           ,[UserDefined4]
           ,[UserDefined5]
           ,[UserDefined6]
           ,[UserDefined7]
           ,[UserDefined8]
           ,[UserDefined9]
           ,[UserDefined10]

from
	EDIPilot.StagingInvoice210HeadersT 

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Insert>

/*				210 Address.*/
--- <Insert rows="*">
set	@TableName = 'EDIPilot.Invoice210Address'

INSERT  [EDIPILOT].[Invoice210Address]
           (
            [RawDocumentGUID]
           ,[InvoiceNumber]
           ,[N1Qualifier]
           ,[N1Name]
           ,[N1IDQualifier]
           ,[N1IDCode]
           ,[N201Name]
           ,[N202Name]
           ,[N301Address]
           ,[N401City]
           ,[N402State]
           ,[N403Zip]
           ,[n404Country]
           ,[UserDefined1]
           ,[UserDefined2]
           ,[UserDefined3]
           ,[UserDefined4]
           ,[UserDefined5]
           ,[UserDefined6]
           ,[UserDefined7]
           ,[UserDefined8]
           ,[UserDefined9]
           ,[UserDefined10]
           )
select
			[RawDocumentGUID]
           ,[InvoiceNumber]
           ,[N1Qualifier]
           ,[N1Name]
           ,[N1IDQualifier]
           ,[N1IDCode]
           ,[N201Name]
           ,[N202Name]
           ,[N301Address]
           ,[N401City]
           ,[N402State]
           ,[N403Zip]
           ,[n404Country]
           ,[UserDefined1]
           ,[UserDefined2]
           ,[UserDefined3]
           ,[UserDefined4]
           ,[UserDefined5]
           ,[UserDefined6]
           ,[UserDefined7]
           ,[UserDefined8]
           ,[UserDefined9]
           ,[UserDefined10]

from
	EDIPilot.StagingInvoice210AddressT 

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Insert>

/*				210 Address.*/
--- <Insert rows="*">
set	@TableName = 'EDIPilot.Invoice210N9REF'

INSERT  [EDIPILOT].[Invoice210N9REF]
           (
            [RawDocumentGUID]
           ,[b3InvoiceNumber]
           ,[N9IDQualifier]
           ,[N9ID]
		    ,[UserDefined1]
           ,[UserDefined2]
           ,[UserDefined3]
           ,[UserDefined4]
           ,[UserDefined5]
           ,[UserDefined6]
           ,[UserDefined7]
           ,[UserDefined8]
           ,[UserDefined9]
           ,[UserDefined10]
           )
select
			[RawDocumentGUID]
           ,[b3InvoiceNumber]
           ,[N9IDQualifier]
           ,[N9ID]
           ,[UserDefined1]
           ,[UserDefined2]
           ,[UserDefined3]
           ,[UserDefined4]
           ,[UserDefined5]
           ,[UserDefined6]
           ,[UserDefined7]
           ,[UserDefined8]
           ,[UserDefined9]
           ,[UserDefined10]

from
	EDIPilot.StagingInvoice210N9REFT 

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Insert>

/*				-210 Detail*/
--- <Insert rows="*">
set	@TableName = 'EDIPilot.Invoice210Detail'

insert
	EDIPilot.Invoice210Detail
(		[RawDocumentGUID]
           ,[InvoiceNumber]
           ,[b3lXAssignedNumber]
           ,[n9Qualifier]
           ,[n9Data]
           ,[podDate]
           ,[podTime]
           ,[podName]
           ,[l5LadingLineItemNumber]
           ,[l5LadingDescription]
           ,[L0LadinglineItemNumber]
           ,[l0BilledQty]
           ,[l0BilledQtyUOM]
           ,[l0WeightQualfier]
           ,[l0Volume]
           ,[l0VolumeUnit]
           ,[l0LadingQty]
           ,[l0PackagingCode]
           ,[l1ladingLineItem]
           ,[l1FreightRate]
           ,[l1RateQualifier]
           ,[l1RateCharge]
           ,[L4Length]
           ,[L4Width]
           ,[L4Height]
           ,[L4UOM]
           ,[L4Qty]
           ,[UserDefined1]
           ,[UserDefined2]
           ,[UserDefined3]
           ,[UserDefined4]
           ,[UserDefined5]
           ,[UserDefined6]
           ,[UserDefined7]
           ,[UserDefined8]
           ,[UserDefined9]
           ,[UserDefined10]
)
select
		[RawDocumentGUID]
           ,[InvoiceNumber]
           ,[b3lXAssignedNumber]
           ,[n9Qualifier]
           ,[n9Data]
           ,[podDate]
           ,[podTime]
           ,[podName]
           ,[l5LadingLineItemNumber]
           ,[l5LadingDescription]
           ,[L0LadinglineItemNumber]
           ,[l0BilledQty]
           ,[l0BilledQtyUOM]
           ,[l0WeightQualfier]
           ,[l0Volume]
           ,[l0VolumeUnit]
           ,[l0LadingQty]
           ,[l0PackagingCode]
           ,[l1ladingLineItem]
           ,[l1FreightRate]
           ,[l1RateQualifier]
           ,[l1RateCharge]
           ,[L4Length]
           ,[L4Width]
           ,[L4Height]
           ,[L4UOM]
           ,[L4Qty]
           ,[UserDefined1]
           ,[UserDefined2]
           ,[UserDefined3]
           ,[UserDefined4]
           ,[UserDefined5]
           ,[UserDefined6]
           ,[UserDefined7]
           ,[UserDefined8]
           ,[UserDefined9]
           ,[UserDefined10]

from
	EDIPilot.StagingInvoice210DetailT sfr

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Insert>


--- <Insert rows="*">
set	@TableName = 'EDIPilot.Invoice210Summary'

insert
	EDIPilot.Invoice210Summary
(	[RawDocumentGUID]
           ,[b3InvoiceNumber]
           ,[l3Weight]
           ,[l3WeightQualifier]
           ,[l3FreightWeight]
           ,[l3rateQualifier]
           ,[l3Charge]
           ,[l3Advances]
           ,[l3PrepaidAmount]
           ,[l3SAC]
           ,[l3Volume]
           ,[l3VolumneQual]
           ,[l3ladingQty]
           ,[UserDefined1]
           ,[UserDefined2]
           ,[UserDefined3]
           ,[UserDefined4]
           ,[UserDefined5]
           ,[UserDefined6]
           ,[UserDefined7]
           ,[UserDefined8]
           ,[UserDefined9]
           ,[UserDefined10]
)
select
		[RawDocumentGUID]
           ,[b3InvoiceNumber]
           ,[l3Weight]
           ,[l3WeightQualifier]
           ,[l3FreightWeight]
           ,[l3rateQualifier]
           ,[l3Charge]
           ,[l3Advances]
           ,[l3PrepaidAmount]
           ,[l3SAC]
           ,[l3Volume]
           ,[l3VolumneQual]
           ,[l3ladingQty]
           ,[UserDefined1]
           ,[UserDefined2]
           ,[UserDefined3]
           ,[UserDefined4]
           ,[UserDefined5]
           ,[UserDefined6]
           ,[UserDefined7]
           ,[UserDefined8]
           ,[UserDefined9]
           ,[UserDefined10]

from
	EDIPilot.StagingInvoice210SummaryT sfr

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end


/*		- truncate data from staging tables.*/
truncate table
	EDIPilot.StagingInvoice210DocsT
truncate table
	EDIPilot.StagingInvoice210HeadersT
truncate table
	EDIPilot.StagingInvoice210AddressT
truncate table
	EDIPilot.StagingInvoice210DetailT
truncate table
	EDIPilot.StagingInvoice210SummaryT
truncate table
	EDIPilot.StagingInvoice210N9REFT

--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIPilot.StagingInvoice210DocsT'
,	@newName = N'StagingInvoice210Docs'

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
--- </Call>


--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIPilot.stagingInvoice210HeadersT'
,	@newName = N'StagingInvoice210Headers'

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
--- </Call>

--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIPilot.stagingInvoice210AddressT'
,	@newName = N'StagingInvoice210Address'

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
--- </Call>

--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIPilot.stagingInvoice210N9REFT'
,	@newName = N'StagingInvoice210N9REF'

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
--- </Call>


--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIPilot.StagingInvoice210DetailT'
,	@newName = N'StagingInvoice210Detail'

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
--- </Call>


--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIPilot.StagingInvoice210SummaryT'
,	@newName = N'StagingInvoice210Summary'

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
--- </Call>



--- </Body>

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

begin transaction
go

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = EDIPilot.usp_Stage_2
	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

Select 'SSHeaders'
select
	*
from
	EDIPilot.ShipScheduleHeaders sdhv


Select 'SSSupplemental'
select
	*
from
	EDIPilot.ShipScheduleSupplemental sdrv

Select 'SSAccums'	
select
	*
from
	EDIPilot.ShipScheduleAccums sdrv

Select 'SSAuthAccums'
select
	*
from
	EDIPilot.ShipScheduleAuthAccums sdrv

Select 'SSchedules'
select
	*
from
	EDIPilot.ShipSchedules sdrv


Select 'PlanningHeaders'
select
	*
from
	EDIPilot.PlanningHeaders sdhv
Select 'PlanningSupplemental'
select
	*
from
	EDIPilot.PlanningSupplemental sdrv
Select 'PlanningAccums'
select
	*
from
	EDIPilot.PlanningAccums sdrv

Select 'PlanningAuthAccums'
select
	*
from
	EDIPilot.PlanningAuthAccums sdrv

Select 'PlanningReleases'
select
	*
from
	EDIPilot.PlanningReleases sdrv
go

--commit transaction
rollback transaction
go

set statistics io off
set statistics time off
go

}

Results {
}
*/





























GO
