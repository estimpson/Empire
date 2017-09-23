SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [EDILiteTek].[usp_Stage_2]
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDILiteTek.usp_Test
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
	@objname = N'EDILiteTek.StagingShipScheduleHeaders'
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
	@objname = N'EDILiteTek.StagingShipScheduleSupplemental'
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
	@objname = N'EDILiteTek.StagingShipScheduleAccums'
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

/*				- StagingShipScheduleReleases to StagingShipScheduleReleasesT.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDILiteTek.StagingShipSchedules'
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
	@objname = N'EDILiteTek.StagingPlanningHeaders'
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
	@objname = N'EDILiteTek.StagingPlanningSupplemental'
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
	@objname = N'EDILiteTek.StagingPlanningAccums'
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

/*				- StagingPlanningReleases to StagingPlanningReleasesT.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDILiteTek.StagingPlanningReleases'
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
set	@TableName = 'EDILiteTek.ShipScheduleHeaders'

insert
	EDILiteTek.ShipScheduleHeaders
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
	EDILiteTek.StagingShipScheduleHeadersT sfh

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
set	@TableName = 'EDILiteTek.ShipScheduleSupplemental'

insert
	EDILiteTek.ShipScheduleSupplemental
(	RawDocumentGUID
,	ShipToCode
,	CustomerPart
,	CustomerPO
,	ShipFromCode
,	ConsigneeCode
,	ReleaseNo
,	UserDefined1 --DockCode
,	UserDefined2 --Line Feed Code
,	UserDefined3 --Reserve Line Feed Code
)
select
	sfr.RawDocumentGUID
,	sfr.ShipToCode
,	sfr.CustomerPart
,	sfr.CustomerPO
,	sfr.ShipFromCode
,	sfr.ConsigneeCode
,	sfr.ReleaseNo
,	sfr.UserDefined1
,	sfr.UserDefined2
,	sfr.UserDefined3
from
	EDILiteTek.StagingshipScheduleSupplementalT sfr

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
set	@TableName = 'EDILiteTek.ShipScheduleAccums'

insert
	EDILiteTek.ShipScheduleAccums
(	RawDocumentGUID
,	ShipToCode
,	CustomerPart
,	CustomerPO
,	ShipFromCode
,	ConsigneeCode
,	ReleaseNo
,	UserDefined1
,	LastQtyReceived
,	LastQtyDT
,	LastAccumQty
,	LastAccumDT
)
select
	sfr.RawDocumentGUID
,	sfr.ShipToCode
,	sfr.CustomerPart
,	sfr.CustomerPO
,	sfr.ShipFromCode
,	sfr.ConsigneeCode
,	sfr.ReleaseNo
,	sfr.UserDefined1
,	sfr.LastQtyReceived
,	sfr.LastQtyDT
,	sfr.LastAccumQty
,	sfr.LastAccumDT
from
	EDILiteTek.StagingshipScheduleAccumsT sfr

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
set	@TableName = 'EDILiteTek.ShipSchedules'

insert
	EDILiteTek.ShipSchedules
(	RawDocumentGUID
,	ShipToCode
,	CustomerPart
,	CustomerPO
,	ShipFromCode
,	ReleaseNo
,	ReleaseQty
,	ReleaseDT
)
select
	sfr.RawDocumentGUID
,	sfr.ShipToCode
,	sfr.CustomerPart
,	sfr.CustomerPO
,	sfr.ShipFromCode
,	sfr.ReleaseNo
,	sfr.ReleaseQty
,	sfr.ReleaseDT
from
	EDILiteTek.StagingShipSchedulesT sfr

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
set	@TableName = 'EDILiteTek.PlanningHeaders'

insert
	EDILiteTek.PlanningHeaders
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
	EDILiteTek.StagingPlanningHeadersT sfh

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
set	@TableName = 'EDILiteTek.PlanningSupplemental'

insert
	EDILiteTek.PlanningSupplemental
(	RawDocumentGUID
,	ShipToCode
,	CustomerPart
,	CustomerPO
,	ShipFromCode
,	ConsigneeCode
,	ReleaseNo
,	UserDefined1 --Dock Code
,	UserDefined2 --Line Feed Code
,	UserDefined3 --Zone Code
,	UserDefined4 --ModelYear
)
select
	sfr.RawDocumentGUID
,	sfr.ShipToCode
,	sfr.CustomerPart
,	sfr.CustomerPO
,	sfr.ShipFromCode
,	sfr.ConsigneeCode
,	sfr.ReleaseNo
,	sfr.UserDefined1 --DockCode
,	sfr.UserDefined2 --Line Feed Code
,	sfr.UserDefined3 --ZoneCode
,	sfr.UserDefined4 --ModelYear
from
	EDILiteTek.StagingPlanningSupplementalT sfr

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
set	@TableName = 'EDILiteTek.PlanningAccums'

insert
	EDILiteTek.PlanningAccums
(	RawDocumentGUID
,	ShipToCode
,	CustomerPart
,	CustomerPO
,	ShipFromCode
,	ConsigneeCode
,	ReleaseNo
,	LastQtyReceived
,	LastQtyDT
,	LastAccumQty
,	LastAccumDT
,	UserDefined4 --ModelYear
)
select
	sfr.RawDocumentGUID
,	sfr.ShipToCode
,	sfr.CustomerPart
,	sfr.CustomerPO
,	sfr.ShipFromCode
,	sfr.ConsigneeCode
,	sfr.ReleaseNo
,	sfr.LastQtyReceived
,	sfr.LastQtyDT
,	sfr.LastAccumQty
,	sfr.LastAccumDT
,	sfr.UserDefined4 --ModelYear
from
	EDILiteTek.StagingPlanningAccumsT sfr

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
set	@TableName = 'EDILiteTek.PlanningReleases'

insert
	EDILiteTek.PlanningReleases
(	RawDocumentGUID
,	ShipToCode
,	CustomerPart
,	CustomerPO
,	ShipFromCode
,	ConsigneeCode
,	ReleaseNo
,	ReleaseQty
,	ReleaseDT
,	UserDefined4 --ModelYear
)
select
	sfr.RawDocumentGUID
,	sfr.ShipToCode
,	sfr.CustomerPart
,	sfr.CustomerPO
,	sfr.ShipFromCode
,	sfr.ConsigneeCode
,	sfr.ReleaseNo
,	sfr.ReleaseQty
,	sfr.ReleaseDT
,	sfr.UserDefined4 --ModelYear
from
	EDILiteTek.StagingPlanningReleasesT sfr

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
	EDILiteTek.StagingShipScheduleHeadersT
truncate table
	EDILiteTek.StagingShipScheduleSupplementalT
truncate table
	EDILiteTek.StagingShipScheduleAccumsT
truncate table
	EDILiteTek.StagingShipSchedulesT
truncate table
	EDILiteTek.StagingPlanningHeadersT
truncate table
	EDILiteTek.StagingPlanningSupplementalT
truncate table
	EDILiteTek.StagingPlanningAccumsT
truncate table
	EDILiteTek.StagingPlanningReleasesT

/*		- rename staging tables to prevent any additional data being written to them and to ensure they are not involved in a transaction.*/
/*			- rename StagingShipSchedule tables...*/
/*				- StagingShipScheduleHeadersT to StagingShipScheduleHeaders.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDILiteTek.StagingShipScheduleHeadersT'
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
	@objname = N'EDILiteTek.StagingShipScheduleSupplementalT'
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
	@objname = N'EDILiteTek.StagingShipScheduleAccumsT'
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

/*				- StagingShipScheduleReleasesT to StagingShipScheduleReleases.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDILiteTek.StagingShipSchedulesT'
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
	@objname = N'EDILiteTek.StagingPlanningHeadersT'
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
	@objname = N'EDILiteTek.StagingPlanningSupplementalT'
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
	@objname = N'EDILiteTek.StagingPlanningAccumsT'
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

/*				- StagingPlanningReleasesT to StagingPlanningReleases.*/
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDILiteTek.StagingPlanningReleasesT'
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
	@ProcReturn = EDILiteTek.usp_Stage_2
	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

select
	*
from
	EDILiteTek.ShipScheduleHeaders sdhv

select
	*
from
	EDILiteTek.ShipScheduleSupplemental sdrv
	
select
	*
from
	EDILiteTek.ShipScheduleAccums sdrv

select
	*
from
	EDILiteTek.ShipSchedules sdrv

select
	*
from
	EDILiteTek.PlanningHeaders sdhv

select
	*
from
	EDILiteTek.PlanningSupplemental sdrv

select
	*
from
	EDILiteTek.PlanningAccums sdrv

select
	*
from
	EDILiteTek.PlanningReleases sdrv
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
