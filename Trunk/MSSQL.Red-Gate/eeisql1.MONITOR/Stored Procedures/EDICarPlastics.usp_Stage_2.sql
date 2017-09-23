SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EDICarPlastics].[usp_Stage_2]
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDICarPlastics.usp_Test
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
	@objname = N'EDICarPlastics.StagingShipScheduleHeaders'
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
	@objname = N'EDICarPlastics.StagingShipScheduleSupplemental'
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
	@objname = N'EDICarPlastics.StagingShipScheduleAccums'
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
	@objname = N'EDICarPlastics.StagingShipScheduleAuthAccums'
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
	@objname = N'EDICarPlastics.StagingShipSchedules'
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
	@objname = N'EDICarPlastics.StagingPlanningHeaders'
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
	@objname = N'EDICarPlastics.StagingPlanningSupplemental'
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
	@objname = N'EDICarPlastics.StagingPlanningAccums'
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
	@objname = N'EDICarPlastics.StagingPlanningAuthAccums'
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
	@objname = N'EDICarPlastics.StagingPlanningReleases'
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
set	@TableName = 'EDICarPlastics.ShipScheduleHeaders'

insert
	EDICarPlastics.ShipScheduleHeaders
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
	EDICarPlastics.StagingShipScheduleHeadersT sfh

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
set	@TableName = 'EDICarPlastics.ShipScheduleSupplemental'

insert
	EDICarPlastics.ShipScheduleSupplemental
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
	EDICarPlastics.StagingshipScheduleSupplementalT 

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
set	@TableName = 'EDICarPlastics.ShipScheduleAccums'

insert
	EDICarPlastics.ShipScheduleAccums
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
	EDICarPlastics.StagingshipScheduleAccumsT sfr

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
set	@TableName = 'EDICarPlastics.ShipScheduleAuthAccums'

insert
	EDICarPlastics.ShipScheduleAuthAccums
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
	EDICarPlastics.StagingShipScheduleAuthAccumsT sfr

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
set	@TableName = 'EDICarPlastics.ShipSchedules'

insert
	EDICarPlastics.ShipSchedules
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
	EDICarPlastics.StagingShipSchedulesT sfr

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
set	@TableName = 'EDICarPlastics.PlanningHeaders'

insert
	EDICarPlastics.PlanningHeaders
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
	EDICarPlastics.StagingPlanningHeadersT sfh

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
set	@TableName = 'EDICarPlastics.PlanningSupplemental'

insert
	EDICarPlastics.PlanningSupplemental
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
	EDICarPlastics.StagingPlanningSupplementalT 

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
set	@TableName = 'EDICarPlastics.PlanningAccums'

insert
	EDICarPlastics.PlanningAccums
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
	EDICarPlastics.StagingPlanningAccumsT sfr

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
set	@TableName = 'EDICarPlastics.PlanningAuthAccums'

insert
	EDICarPlastics.PlanningAuthAccums
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
	EDICarPlastics.StagingPlanningAuthAccumsT 

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
set	@TableName = 'EDICarPlastics.PlanningReleases'

insert
	EDICarPlastics.PlanningReleases
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
	EDICarPlastics.StagingPlanningReleasesT sfr

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
	EDICarPlastics.StagingShipScheduleHeadersT
truncate table
	EDICarPlastics.StagingShipScheduleSupplementalT
truncate table
	EDICarPlastics.StagingShipScheduleAccumsT
truncate table
	EDICarPlastics.StagingShipScheduleAuthAccumsT
truncate table
	EDICarPlastics.StagingShipSchedulesT
truncate table
	EDICarPlastics.StagingPlanningHeadersT
truncate table
	EDICarPlastics.StagingPlanningSupplementalT
truncate table
	EDICarPlastics.StagingPlanningAccumsT
truncate table
	EDICarPlastics.StagingPlanningAuthAccumsT
truncate table
	EDICarPlastics.StagingPlanningReleasesT

/*		- rename staging tables to prevent any additional data being written to them and to ensure they are not involved in a transaction.*/
/*			- rename StagingShipSchedule tables...*/
/*				- StagingShipScheduleHeadersT to StagingShipScheduleHeaders.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDICarPlastics.StagingShipScheduleHeadersT'
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
	@objname = N'EDICarPlastics.StagingShipScheduleSupplementalT'
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
	@objname = N'EDICarPlastics.StagingShipScheduleAccumsT'
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
	@objname = N'EDICarPlastics.StagingShipScheduleAuthAccumsT'
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
	@objname = N'EDICarPlastics.StagingShipSchedulesT'
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
	@objname = N'EDICarPlastics.StagingPlanningHeadersT'
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
	@objname = N'EDICarPlastics.StagingPlanningSupplementalT'
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
	@objname = N'EDICarPlastics.StagingPlanningAccumsT'
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
	@objname = N'EDICarPlastics.StagingPlanningAuthAccumsT'
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
	@objname = N'EDICarPlastics.StagingPlanningReleasesT'
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
	@ProcReturn = EDICarPlastics.usp_Stage_2
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
	EDICarPlastics.ShipScheduleHeaders sdhv


Select 'SSSupplemental'
select
	*
from
	EDICarPlastics.ShipScheduleSupplemental sdrv

Select 'SSAccums'	
select
	*
from
	EDICarPlastics.ShipScheduleAccums sdrv

Select 'SSAuthAccums'
select
	*
from
	EDICarPlastics.ShipScheduleAuthAccums sdrv

Select 'SSchedules'
select
	*
from
	EDICarPlastics.ShipSchedules sdrv


Select 'PlanningHeaders'
select
	*
from
	EDICarPlastics.PlanningHeaders sdhv
Select 'PlanningSupplemental'
select
	*
from
	EDICarPlastics.PlanningSupplemental sdrv
Select 'PlanningAccums'
select
	*
from
	EDICarPlastics.PlanningAccums sdrv

Select 'PlanningAuthAccums'
select
	*
from
	EDICarPlastics.PlanningAuthAccums sdrv

Select 'PlanningReleases'
select
	*
from
	EDICarPlastics.PlanningReleases sdrv
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
