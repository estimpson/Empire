SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EDILearMexico].[usp_Stage_2]
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDILearMexico.usp_Test
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
	@objname = N'EDILearMexico.StagingShipScheduleHeaders'
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
	@objname = N'EDILearMexico.StagingShipScheduleSupplemental'
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
	@objname = N'EDILearMexico.StagingShipScheduleAccums'
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
	@objname = N'EDILearMexico.StagingShipScheduleAuthAccums'
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
	@objname = N'EDILearMexico.StagingShipSchedules'
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
	@objname = N'EDILearMexico.StagingPlanningHeaders'
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
	@objname = N'EDILearMexico.StagingPlanningSupplemental'
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
	@objname = N'EDILearMexico.StagingPlanningAccums'
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
	@objname = N'EDILearMexico.StagingPlanningAuthAccums'
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
	@objname = N'EDILearMexico.StagingPlanningReleases'
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
set	@TableName = 'EDILearMexico.ShipScheduleHeaders'

insert
	EDILearMexico.ShipScheduleHeaders
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
	EDILearMexico.StagingShipScheduleHeadersT sfh

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
set	@TableName = 'EDILearMexico.ShipScheduleSupplemental'

insert
	EDILearMexico.ShipScheduleSupplemental
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
	EDILearMexico.StagingshipScheduleSupplementalT 

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
set	@TableName = 'EDILearMexico.ShipScheduleAccums'

insert
	EDILearMexico.ShipScheduleAccums
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
	EDILearMexico.StagingshipScheduleAccumsT sfr

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
set	@TableName = 'EDILearMexico.ShipScheduleAuthAccums'

insert
	EDILearMexico.ShipScheduleAuthAccums
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
	EDILearMexico.StagingShipScheduleAuthAccumsT sfr

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
set	@TableName = 'EDILearMexico.ShipSchedules'

insert
	EDILearMexico.ShipSchedules
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
	EDILearMexico.StagingShipSchedulesT sfr

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
set	@TableName = 'EDILearMexico.PlanningHeaders'

insert
	EDILearMexico.PlanningHeaders
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
	EDILearMexico.StagingPlanningHeadersT sfh

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
set	@TableName = 'EDILearMexico.PlanningSupplemental'

insert
	EDILearMexico.PlanningSupplemental
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
	EDILearMexico.StagingPlanningSupplementalT 

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
set	@TableName = 'EDILearMexico.PlanningAccums'

insert
	EDILearMexico.PlanningAccums
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
	EDILearMexico.StagingPlanningAccumsT sfr

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
set	@TableName = 'EDILearMexico.PlanningAuthAccums'

insert
	EDILearMexico.PlanningAuthAccums
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
	EDILearMexico.StagingPlanningAuthAccumsT 

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
set	@TableName = 'EDILearMexico.PlanningReleases'

insert
	EDILearMexico.PlanningReleases
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
	EDILearMexico.StagingPlanningReleasesT sfr

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
	EDILearMexico.StagingShipScheduleHeadersT
truncate table
	EDILearMexico.StagingShipScheduleSupplementalT
truncate table
	EDILearMexico.StagingShipScheduleAccumsT
truncate table
	EDILearMexico.StagingShipScheduleAuthAccumsT
truncate table
	EDILearMexico.StagingShipSchedulesT
truncate table
	EDILearMexico.StagingPlanningHeadersT
truncate table
	EDILearMexico.StagingPlanningSupplementalT
truncate table
	EDILearMexico.StagingPlanningAccumsT
truncate table
	EDILearMexico.StagingPlanningAuthAccumsT
truncate table
	EDILearMexico.StagingPlanningReleasesT

/*		- rename staging tables to prevent any additional data being written to them and to ensure they are not involved in a transaction.*/
/*			- rename StagingShipSchedule tables...*/
/*				- StagingShipScheduleHeadersT to StagingShipScheduleHeaders.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDILearMexico.StagingShipScheduleHeadersT'
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
	@objname = N'EDILearMexico.StagingShipScheduleSupplementalT'
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
	@objname = N'EDILearMexico.StagingShipScheduleAccumsT'
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
	@objname = N'EDILearMexico.StagingShipScheduleAuthAccumsT'
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
	@objname = N'EDILearMexico.StagingShipSchedulesT'
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
	@objname = N'EDILearMexico.StagingPlanningHeadersT'
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
	@objname = N'EDILearMexico.StagingPlanningSupplementalT'
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
	@objname = N'EDILearMexico.StagingPlanningAccumsT'
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
	@objname = N'EDILearMexico.StagingPlanningAuthAccumsT'
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
	@objname = N'EDILearMexico.StagingPlanningReleasesT'
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
	@ProcReturn = EDILearMexico.usp_Stage_2
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
	EDILearMexico.ShipScheduleHeaders sdhv


Select 'SSSupplemental'
select
	*
from
	EDILearMexico.ShipScheduleSupplemental sdrv

Select 'SSAccums'	
select
	*
from
	EDILearMexico.ShipScheduleAccums sdrv

Select 'SSAuthAccums'
select
	*
from
	EDILearMexico.ShipScheduleAuthAccums sdrv

Select 'SSchedules'
select
	*
from
	EDILearMexico.ShipSchedules sdrv


Select 'PlanningHeaders'
select
	*
from
	EDILearMexico.PlanningHeaders sdhv
Select 'PlanningSupplemental'
select
	*
from
	EDILearMexico.PlanningSupplemental sdrv
Select 'PlanningAccums'
select
	*
from
	EDILearMexico.PlanningAccums sdrv

Select 'PlanningAuthAccums'
select
	*
from
	EDILearMexico.PlanningAuthAccums sdrv

Select 'PlanningReleases'
select
	*
from
	EDILearMexico.PlanningReleases sdrv
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
