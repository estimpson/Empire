SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [EDIYazaki].[usp_Stage_2]
	@TranDT [datetime] = null OUTPUT,
	@Result [int] = null OUTPUT
WITH EXECUTE AS CALLER
AS
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDIYazaki.usp_Test
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
/*		- rename staging tables to prevent any additional data being written to them and to ensure they are not involved in a transaction...*/
/*			- rename StagingShipSchedule tables...*/
/*				- StagingShipScheduleHeaders to StagingShipScheduleHeadersT.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	@ProcReturn = dbo.sp_rename
	@objname = N'EDIYazaki.StagingShipScheduleHeaders'
,	@newName = N'StagingShipScheduleHeadersT'

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

/*				- StagingShipScheduleSuplemental to StagingShipScheduleSuplementalT.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIYazaki.StagingShipScheduleSupplemental'
,	@newName = N'StagingShipScheduleSupplementalT'

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

/*				- StagingShipScheduleAccums to StagingShipScheduleAccumsT.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIYazaki.StagingShipScheduleAccums'
,	@newName = N'StagingShipScheduleAccumsT'

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

/*				- StagingShipScheduleAccums to StagingShipScheduleAuthAccumsT.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIYazaki.StagingShipScheduleAuthAccums'
,	@newName = N'StagingShipScheduleAuthAccumsT'

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


/*				- StagingShipScheduleReleases to StagingShipScheduleReleasesT.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIYazaki.StagingShipSchedules'
,	@newName = N'StagingShipSchedulesT'

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

/*			- rename StagingPlanning tables...*/
/*				- StagingPlanningHeaders to StagingPlanningHeadersT.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIYazaki.StagingPlanningHeaders'
,	@newName = N'StagingPlanningHeadersT'

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

/*				- StagingPlanningSuplemental to StagingPlanningSuplementalT.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIYazaki.StagingPlanningSupplemental'
,	@newName = N'StagingPlanningSupplementalT'

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

/*				- StagingPlanningAccums to StagingPlanningAccumsT.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIYazaki.StagingPlanningAccums'
,	@newName = N'StagingPlanningAccumsT'

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

/*				- StagingPlanningAuthAccums to StagingPlanningAuthAccumsT.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIYazaki.StagingPlanningAuthAccums'
,	@newName = N'StagingPlanningAuthAccumsT'

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


/*				- StagingPlanningReleases to StagingPlanningReleasesT.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIYazaki.StagingPlanningReleases'
,	@newName = N'StagingPlanningReleasesT'

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

/*		- copy rows from Staging Temp to permanent tables. */
/*			- copy StagingShipScheduleT tables...*/
/*				- StagingShipScheduleHeadersT to ShipScheduleHeaders.*/
--- <Insert rows="*">
set	@TableName = 'EDIYazaki.ShipScheduleHeaders'

insert
	EDIYazaki.ShipScheduleHeaders
(	RawDocumentGUID
,	DocumentImportDT
,	TradingPartner
,	DocType
,	Version
,	Release
,	Docnumber
,	ControlNumber
,	DocumentDT
)
select
	sfh.RawDocumentGUID
,	sfh.DocumentImportDT
,	sfh.TradingPartner
,	sfh.DocType
,	sfh.Version
,	sfh.Release
,	sfh.Docnumber
,	sfh.ControlNumber
,	sfh.DocumentDT
from
	EDIYazaki.StagingShipScheduleHeadersT sfh

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

/*				- StagingShipScheduleSuplementalT to ShipScheduleSuplemental.*/
--- <Insert rows="*">
set	@TableName = 'EDIYazaki.ShipScheduleSupplemental'

insert
	EDIYazaki.ShipScheduleSupplemental
(		[RawDocumentGUID]
      ,[ReleaseNo]
      ,[ShipToCode]
      ,[ConsigneeCode]
      ,[ShipFromCode]
      ,[SupplierCode]
      ,[CustomerPart]
      ,[CustomerPO]
      ,[CustomerPOLine]
      ,[CustomerModelYear]
      ,[CustomerECL]
      ,[ReferenceNo]
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
      ,[UserDefined11]
      ,[UserDefined12]
      ,[UserDefined13]
      ,[UserDefined14]
      ,[UserDefined15]
      ,[UserDefined16]
      ,[UserDefined17]
      ,[UserDefined18]
      ,[UserDefined19]
      ,[UserDefined20]

)
select
		[RawDocumentGUID]
      ,[ReleaseNo]
      ,[ShipToCode]
      ,[ConsigneeCode]
      ,[ShipFromCode]
      ,[SupplierCode]
      ,[CustomerPart]
      ,[CustomerPO]
      ,[CustomerPOLine]
      ,[CustomerModelYear]
      ,[CustomerECL]
      ,[ReferenceNo]
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
      ,[UserDefined11]
      ,[UserDefined12]
      ,[UserDefined13]
      ,[UserDefined14]
      ,[UserDefined15]
      ,[UserDefined16]
      ,[UserDefined17]
      ,[UserDefined18]
      ,[UserDefined19]
      ,[UserDefined20]

from
	EDIYazaki.StagingshipScheduleSupplementalT 

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

/*				- StagingShipScheduleAccumsT to ShipScheduleAccums.*/
--- <Insert rows="*">
set	@TableName = 'EDIYazaki.ShipScheduleAccums'

insert
	EDIYazaki.ShipScheduleAccums
(		[RawDocumentGUID]
      ,[ReleaseNo]
      ,[ShipToCode]
      ,[ConsigneeCode]
      ,[ShipFromCode]
      ,[SupplierCode]
      ,[CustomerPart]
      ,[CustomerPO]
      ,[CustomerPOLine]
      ,[CustomerModelYear]
      ,[CustomerECL]
      ,[ReferenceNo]
      ,[UserDefined1]
      ,[UserDefined2]
      ,[UserDefined3]
      ,[UserDefined4]
      ,[UserDefined5]
      ,[LastQtyReceived]
      ,[LastQtyDT]
			,[LastShipper]
      ,[LastAccumQty]
      ,[LastAccumDT]
)
select
		[RawDocumentGUID]
      ,[ReleaseNo]
      ,[ShipToCode]
      ,[ConsigneeCode]
      ,[ShipFromCode]
      ,[SupplierCode]
      ,[CustomerPart]
      ,[CustomerPO]
      ,[CustomerPOLine]
      ,[CustomerModelYear]
      ,[CustomerECL]
      ,[ReferenceNo]
      ,[UserDefined1]
      ,[UserDefined2]
      ,[UserDefined3]
      ,[UserDefined4]
      ,[UserDefined5]
      ,[LastQtyReceived]
      ,[LastQtyDT]
			,[LastShipper]
      ,[LastAccumQty]
      ,[LastAccumDT]

from
	EDIYazaki.StagingshipScheduleAccumsT sfr

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

/*				- StagingShipScheduleAuthAccumsT to ShipSchedulePlanAuthAccums.*/
--- <Insert rows="*">
set	@TableName = 'EDIYazaki.ShipScheduleAuthAccums'

insert
	EDIYazaki.ShipScheduleAuthAccums
(	[RawDocumentGUID]
      ,[ReleaseNo]
      ,[ShipToCode]
      ,[ConsigneeCode]
      ,[ShipFromCode]
      ,[SupplierCode]
      ,[CustomerPart]
      ,[CustomerPO]
      ,[CustomerPOLine]
      ,[CustomerModelYear]
      ,[CustomerECL]
      ,[ReferenceNo]
      ,[UserDefined1]
      ,[UserDefined2]
      ,[UserDefined3]
      ,[UserDefined4]
      ,[UserDefined5]
      ,[FABCUMStartDT]
      ,[FABCUMEndDT]
      ,[FABCUM]
      ,[RAWCUMStartDT]
      ,[RAWCUMEndDT]
      ,[RAWCUM]
      ,[PriorCUMStartDT]
      ,[PriorCUMEndDT]
      ,[PriorCUM]
)
select
		[RawDocumentGUID]
      ,[ReleaseNo]
      ,[ShipToCode]
      ,[ConsigneeCode]
      ,[ShipFromCode]
      ,[SupplierCode]
      ,[CustomerPart]
      ,[CustomerPO]
      ,[CustomerPOLine]
      ,[CustomerModelYear]
      ,[CustomerECL]
      ,[ReferenceNo]
      ,[UserDefined1]
      ,[UserDefined2]
      ,[UserDefined3]
      ,[UserDefined4]
      ,[UserDefined5]
      ,[FABCUMStartDT]
      ,[FABCUMEndDT]
      ,[FABCUM]
      ,[RAWCUMStartDT]
      ,[RAWCUMEndDT]
      ,[RAWCUM]
      ,[PriorCUMStartDT]
      ,[PriorCUMEndDT]
      ,[PriorCUM]

from
	EDIYazaki.StagingShipScheduleAuthAccumsT sfr

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



/*				- StagingShipScheduleReleasesT to ShipScheduleReleases.*/
--- <Insert rows="*">
set	@TableName = 'EDIYazaki.ShipSchedules'

insert
	EDIYazaki.ShipSchedules
(		[RawDocumentGUID]
      ,[ReleaseNo]
      ,[ShipToCode]
      ,[ConsigneeCode]
      ,[ShipFromCode]
      ,[SupplierCode]
      ,[CustomerPart]
      ,[CustomerPO]
      ,[CustomerPOLine]
      ,[CustomerModelYear]
      ,[CustomerECL]
      ,[ReferenceNo]
      ,[UserDefined1]
      ,[UserDefined2]
      ,[UserDefined3]
      ,[UserDefined4]
      ,[UserDefined5]
	  ,[ScheduleType]
      ,[ReleaseQty]
      ,[ReleaseDT]
)
select
	   [RawDocumentGUID]
      ,[ReleaseNo]
      ,[ShipToCode]
      ,[ConsigneeCode]
      ,[ShipFromCode]
      ,[SupplierCode]
      ,[CustomerPart]
      ,[CustomerPO]
      ,[CustomerPOLine]
      ,[CustomerModelYear]
      ,[CustomerECL]
      ,[ReferenceNo]
      ,[UserDefined1]
      ,[UserDefined2]
      ,[UserDefined3]
      ,[UserDefined4]
      ,[UserDefined5]
	  ,[ScheduleType]	
      ,[ReleaseQty]
      ,[ReleaseDT]
from
	EDIYazaki.StagingShipSchedulesT sfr

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

/*			- copy StagingPlanningT tables...*/
/*				- StagingPlanningHeadersT to ReleasePlanHeaders.*/
--- <Insert rows="*">
set	@TableName = 'EDIYazaki.PlanningHeaders'

insert
	EDIYazaki.PlanningHeaders
(	RawDocumentGUID
,	DocumentImportDT
,	TradingPartner
,	DocType
,	Version
,	Release
,	Docnumber
,	ControlNumber
,	DocumentDT
)
select
	sfh.RawDocumentGUID
,	sfh.DocumentImportDT
,	sfh.TradingPartner
,	sfh.DocType
,	sfh.Version
,	sfh.Release
,	sfh.Docnumber
,	sfh.ControlNumber
,	sfh.DocumentDT
from
	EDIYazaki.StagingPlanningHeadersT sfh

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

/*				- StagingPlanningSuplementalT to ReleasePlanSuplemental.*/
--- <Insert rows="*">
set	@TableName = 'EDIYazaki.PlanningSupplemental'

insert
	EDIYazaki.PlanningSupplemental
(	[RawDocumentGUID]
      ,[ReleaseNo]
      ,[ShipToCode]
      ,[ConsigneeCode]
      ,[ShipFromCode]
      ,[SupplierCode]
      ,[CustomerPart]
      ,[CustomerPO]
      ,[CustomerPOLine]
      ,[CustomerModelYear]
      ,[CustomerECL]
      ,[ReferenceNo]
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
      ,[UserDefined11]
      ,[UserDefined12]
      ,[UserDefined13]
      ,[UserDefined14]
      ,[UserDefined15]
      ,[UserDefined16]
      ,[UserDefined17]
      ,[UserDefined18]
      ,[UserDefined19]
      ,[UserDefined20]
)
select
	[RawDocumentGUID]
      ,[ReleaseNo]
      ,[ShipToCode]
      ,[ConsigneeCode]
      ,[ShipFromCode]
      ,[SupplierCode]
      ,[CustomerPart]
      ,[CustomerPO]
      ,[CustomerPOLine]
      ,[CustomerModelYear]
      ,[CustomerECL]
      ,[ReferenceNo]
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
      ,[UserDefined11]
      ,[UserDefined12]
      ,[UserDefined13]
      ,[UserDefined14]
      ,[UserDefined15]
      ,[UserDefined16]
      ,[UserDefined17]
      ,[UserDefined18]
      ,[UserDefined19]
      ,[UserDefined20]

from
	EDIYazaki.StagingPlanningSupplementalT 

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

/*				- StagingPlanningAccumsT to ReleasePlanAccums.*/
--- <Insert rows="*">
set	@TableName = 'EDIYazaki.PlanningAccums'

insert
	EDIYazaki.PlanningAccums
(	[RawDocumentGUID]
      ,[ReleaseNo]
      ,[ShipToCode]
      ,[ConsigneeCode]
      ,[ShipFromCode]
      ,[SupplierCode]
      ,[CustomerPart]
      ,[CustomerPO]
      ,[CustomerPOLine]
      ,[CustomerModelYear]
      ,[CustomerECL]
      ,[ReferenceNo]
      ,[UserDefined1]
      ,[UserDefined2]
      ,[UserDefined3]
      ,[UserDefined4]
				,[UserDefined5]
      ,[LastQtyReceived]
      ,[LastQtyDT]
			,[LastShipper]
      ,[LastAccumQty]
      ,[LastAccumDT]
)
select
	[RawDocumentGUID]
      ,[ReleaseNo]
      ,[ShipToCode]
      ,[ConsigneeCode]
      ,[ShipFromCode]
      ,[SupplierCode]
      ,[CustomerPart]
      ,[CustomerPO]
      ,[CustomerPOLine]
      ,[CustomerModelYear]
      ,[CustomerECL]
      ,[ReferenceNo]
      ,[UserDefined1]
      ,[UserDefined2]
      ,[UserDefined3]
      ,[UserDefined4]
	  ,[UserDefined5]
      ,[LastQtyReceived]
      ,[LastQtyDT]
			,[LastShipper]
      ,[LastAccumQty]
      ,[LastAccumDT]

from
	EDIYazaki.StagingPlanningAccumsT sfr

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

/*				- StagingPlanningAuthAccumsT to ReleasePlanAuthAccums.*/
--- <Insert rows="*">
set	@TableName = 'EDIYazaki.PlanningAuthAccums'

insert
	EDIYazaki.PlanningAuthAccums
(	[RawDocumentGUID]
      ,[ReleaseNo]
      ,[ShipToCode]
      ,[ConsigneeCode]
      ,[ShipFromCode]
      ,[SupplierCode]
      ,[CustomerPart]
      ,[CustomerPO]
      ,[CustomerPOLine]
      ,[CustomerModelYear]
      ,[CustomerECL]
      ,[ReferenceNo]
      ,[UserDefined1]
      ,[UserDefined2]
      ,[UserDefined3]
      ,[UserDefined4]
	  ,[UserDefined5]
      ,[PriorCUMStartDT]
      ,[PriorCUMEndDT]
      ,[PriorCUM]
      ,[FABCUMStartDT]
      ,[FABCUMEndDT]
      ,[FABCUM]
      ,[RAWCUMStartDT]
      ,[RAWCUMEndDT]
      ,[RAWCUM]
)
select
	[RawDocumentGUID]
      ,[ReleaseNo]
      ,[ShipToCode]
      ,[ConsigneeCode]
      ,[ShipFromCode]
      ,[SupplierCode]
      ,[CustomerPart]
      ,[CustomerPO]
      ,[CustomerPOLine]
      ,[CustomerModelYear]
      ,[CustomerECL]
      ,[ReferenceNo]
      ,[UserDefined1]
      ,[UserDefined2]
      ,[UserDefined3]
      ,[UserDefined4]
	  ,[UserDefined5]
      ,[PriorCUMStartDT]
      ,[PriorCUMEndDT]
      ,[PriorCUM]
      ,[FABCUMStartDT]
      ,[FABCUMEndDT]
      ,[FABCUM]
      ,[RAWCUMStartDT]
      ,[RAWCUMEndDT]
      ,[RAWCUM]

from
	EDIYazaki.StagingPlanningAuthAccumsT 

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

/*				- StagingPlanningReleasesT to ReleasePlanReleases.*/
--- <Insert rows="*">
set	@TableName = 'EDIYazaki.PlanningReleases'

insert
	EDIYazaki.PlanningReleases
(	[RawDocumentGUID]
      ,[ReleaseNo]
      ,[ShipToCode]
      ,[ConsigneeCode]
      ,[ShipFromCode]
      ,[SupplierCode]
      ,[CustomerPart]
      ,[CustomerPO]
      ,[CustomerPOLine]
      ,[CustomerModelYear]
      ,[CustomerECL]
      ,[ReferenceNo]
      ,[UserDefined1]
      ,[UserDefined2]
      ,[UserDefined3]
      ,[UserDefined4]
      ,[UserDefined5]
	  ,[ScheduleType]
      ,[ReleaseQty]
      ,[ReleaseDT]
)
select
		[RawDocumentGUID]
      ,[ReleaseNo]
      ,[ShipToCode]
      ,[ConsigneeCode]
      ,[ShipFromCode]
      ,[SupplierCode]
      ,[CustomerPart]
      ,[CustomerPO]
      ,[CustomerPOLine]
      ,[CustomerModelYear]
      ,[CustomerECL]
      ,[ReferenceNo]
      ,[UserDefined1]
      ,[UserDefined2]
      ,[UserDefined3]
      ,[UserDefined4]
      ,[UserDefined5]
	  ,[QuantityType]
      ,[Quantity]
      ,[DateDT]
from
	EDIYazaki.StagingPlanningReleasesT sfr

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

/*		- truncate data from staging tables.*/
truncate table
	EDIYazaki.StagingShipScheduleHeadersT
truncate table
	EDIYazaki.StagingShipScheduleSupplementalT
truncate table
	EDIYazaki.StagingShipScheduleAccumsT
truncate table
	EDIYazaki.StagingShipScheduleAuthAccumsT
truncate table
	EDIYazaki.StagingShipSchedulesT
truncate table
	EDIYazaki.StagingPlanningHeadersT
truncate table
	EDIYazaki.StagingPlanningSupplementalT
truncate table
	EDIYazaki.StagingPlanningAccumsT
truncate table
	EDIYazaki.StagingPlanningAuthAccumsT
truncate table
	EDIYazaki.StagingPlanningReleasesT

/*		- rename staging tables to prevent any additional data being written to them and to ensure they are not involved in a transaction.*/
/*			- rename StagingShipSchedule tables...*/
/*				- StagingShipScheduleHeadersT to StagingShipScheduleHeaders.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIYazaki.StagingShipScheduleHeadersT'
,	@newName = N'StagingShipScheduleHeaders'

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

/*				- StagingShipScheduleSuplementalT to StagingShipScheduleSuplemental.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIYazaki.StagingShipScheduleSupplementalT'
,	@newName = N'StagingShipScheduleSupplemental'

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

/*				- StagingShipScheduleAccumsT to StagingShipScheduleAccums.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIYazaki.StagingShipScheduleAccumsT'
,	@newName = N'StagingShipScheduleAccums'

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

/*				- StagingShipScheduleAuthAccumsT to StagingShipScheduleAuthAccums.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIYazaki.StagingShipScheduleAuthAccumsT'
,	@newName = N'StagingShipScheduleAuthAccums'

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




/*				- StagingShipScheduleReleasesT to StagingShipScheduleReleases.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIYazaki.StagingShipSchedulesT'
,	@newName = N'StagingShipSchedules'

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

/*			- rename StagingPlanning tables...*/
/*				- StagingPlanningHeadersT to StagingPlanningHeaders.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIYazaki.StagingPlanningHeadersT'
,	@newName = N'StagingPlanningHeaders'

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

/*				- StagingPlanningSuplementalT to StagingPlanningSuplemental.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIYazaki.StagingPlanningSupplementalT'
,	@newName = N'StagingPlanningSupplemental'

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

/*				- StagingPlanningAccumsT to StagingPlanningAccums.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIYazaki.StagingPlanningAccumsT'
,	@newName = N'StagingPlanningAccums'

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

/*				- StagingPlanningAuthAccumsT to StagingPlanningAuthAccums.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIYazaki.StagingPlanningAuthAccumsT'
,	@newName = N'StagingPlanningAuthAccums'

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

/*				- StagingPlanningReleasesT to StagingPlanningReleases.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDIYazaki.StagingPlanningReleasesT'
,	@newName = N'StagingPlanningReleases'

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
	@ProcReturn = EDIYazaki.usp_Stage_2
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
	EDIYazaki.ShipScheduleHeaders sdhv


Select 'SSSupplemental'
select
	*
from
	EDIYazaki.ShipScheduleSupplemental sdrv

Select 'SSAccums'	
select
	*
from
	EDIYazaki.ShipScheduleAccums sdrv

Select 'SSAuthAccums'
select
	*
from
	EDIYazaki.ShipScheduleAuthAccums sdrv

Select 'SSchedules'
select
	*
from
	EDIYazaki.ShipSchedules sdrv


Select 'PlanningHeaders'
select
	*
from
	EDIYazaki.PlanningHeaders sdhv
Select 'PlanningSupplemental'
select
	*
from
	EDIYazaki.PlanningSupplemental sdrv
Select 'PlanningAccums'
select
	*
from
	EDIYazaki.PlanningAccums sdrv

Select 'PlanningAuthAccums'
select
	*
from
	EDIYazaki.PlanningAuthAccums sdrv

Select 'PlanningReleases'
select
	*
from
	EDIYazaki.PlanningReleases sdrv
go

commit transaction
--rollback transaction
go

set statistics io off
set statistics time off
go

}

Results {
}
*/




























GO
