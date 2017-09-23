SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [EDI].[usp_Stage_2_GMSPO]
	@TranDT datetime out
,	@Result integer out
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDI.usp_Test
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
/*	Move staging data into permanent tables. */
/*		Rename staging tables to prevent any additional data being written to them and to ensure they are not involved in a transaction. */
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	@ProcReturn = dbo.sp_rename
	@objname = N'EDI.StagingGMSPO_DELJIT_Headers'
,	@newName = N'StagingGMSPO_DELJIT_Headerst'

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
	@objname = N'EDI.StagingGMSPO_DELJIT_Releases'
,	@newName = N'StagingGMSPO_DELJIT_Releasest'

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
	@objname = N'EDI.StagingGMSPO_DELFOR_Headers'
,	@newName = N'StagingGMSPO_DELFOR_Headerst'

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
	@objname = N'EDI.StagingGMSPO_DELFOR_Releases'
,	@newName = N'StagingGMSPO_DELFOR_Releasest'

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
	@objname = N'EDI.StagingDELFOR_Cumulatives_GMSPO'
,	@newName = N'StagingDELFOR_Cumulatives_GMSPOt'

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





/*		Copy rows from staging to permanent tables. */
--- <Insert rows="*">
set	@TableName = 'EDI.GMSPO_DELJIT_Headers'

insert
	EDI.GMSPO_DELJIT_Headers
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
	EDI.StagingGMSPO_DELJIT_Headerst sfh

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
set	@TableName = 'EDI.GMSPO_DELJIT_Releases'

insert
	EDI.GMSPO_DELJIT_Releases
(	RawDocumentGUID
,	ShipToCode
,	CustomerPart
,	CustomerPO
,	ShipFromCode
,	ReleaseNo
,	DockCode
,	LineFeedCode
,	ReserveLineFeedCode
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
,	sfr.DockCode
,	sfr.LineFeedCode
,	sfr.ReserveLineFeedCode
,	sfr.ReleaseQty
,	sfr.ReleaseDT
from
	EDI.StagingGMSPO_DELJIT_Releasest sfr

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
set	@TableName = 'EDI.GMSPO_DELFOR_Headers'

insert
	EDI.GMSPO_DELFOR_Headers
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
	EDI.StagingGMSPO_DELFOR_Headerst sfh

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
set	@TableName = 'EDI.GMSPO_DELFOR_Releases'

insert
	EDI.GMSPO_DELFOR_Releases
(	RawDocumentGUID
,	ShipToCode
,	CustomerPart
,	CustomerPO
,	ShipFromCode
,	ICCode
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
,	sfr.ICCode
,	sfr.ReleaseNo
,	sfr.ReleaseQty
,	sfr.ReleaseDT
from
	EDI.StagingGMSPO_DELFOR_Releasest sfr

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
set	@TableName = 'EDI.GMSPO_DELFOR_Cumulatives'

insert
	EDI.GMSPO_DELFOR_Cumulatives
(	RawDocumentGUID
,	ShipToCode
,	CustomerPO
,	CustomerPart
,	QtyQualifier
,	CumulativeQty
,	CumulativeStartDT
)
select
	RawDocumentGUID
,	ShipToCode
,	CustomerPO
,	CustomerPart
,	QtyQualifier
,	CumulativeQty
,	CumulativeStartDT
from
	 EDI.StagingDELFOR_Cumulatives_GMSPOt sdcv

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


/*		Truncate data from staging tables. */
truncate table
	EDI.StagingGMSPO_DELJIT_Headerst
truncate table
	EDI.StagingGMSPO_DELJIT_Releasest
truncate table
	EDI.StagingGMSPO_DELFOR_Headerst
truncate table
	EDI.StagingGMSPO_DELFOR_Releasest
truncate table
	 EDI.StagingDELFOR_Cumulatives_GMSPOt

/*		Rename staging tables to prevent any additional data being written to them and to ensure they are not involved in a transaction. */
--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDI.StagingGMSPO_DELJIT_Headerst'
,	@newName = N'StagingGMSPO_DELJIT_Headers'

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
	@objname = N'EDI.StagingGMSPO_DELJIT_Releasest'
,	@newName = N'StagingGMSPO_DELJIT_Releases'

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
	@objname = N'EDI.StagingGMSPO_DELFOR_Headerst'
,	@newName = N'StagingGMSPO_DELFOR_Headers'

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
	@objname = N'EDI.StagingGMSPO_DELFOR_Releasest'
,	@newName = N'StagingGMSPO_DELFOR_Releases'

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
	@objname = N'EDI.StagingDELFOR_Cumulatives_GMSPOt'
,	@newName = N'StagingDELFOR_Cumulatives_GMSPO'

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
	@ProcReturn = EDI.usp_Stage_2_GMSPO
	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

select
	*
from
	EDI.GMSPO_DELJIT_Headers sdhv

select
	*
from
	EDI.GMSPO_DELJIT_Releases sdrv

select
	*
from
	EDI.GMSPO_DELFOR_Headers sdhv

select
	*
from
	EDI.GMSPO_DELFOR_Releases sdrv
go

--commit transaction
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
