SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [EDI].[usp_stage_2_Nascote]
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


--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDI.StagingNascote_830_Headers'
,	@newName = N'StagingNascote_830_Headerst'

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
	@objname = N'EDI.StagingNascote_830_Releases'
,	@newName = N'StagingNascote_830_Releasest'

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
	@objname = N'EDI.StagingNascote_830_Cumulatives'
,	@newName = N'StagingNascote_830_Cumulativest'

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
set	@TableName = 'EDI.Nascote_830_Headers'

insert
	EDI.Nascote_830_Headers
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
	EDI.StagingNascote_830_Headerst sfh

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
set	@TableName = 'EDI.Nascote_830_Releases'

insert
	EDI.Nascote_830_Releases
(	RawDocumentGUID
,	ShipToCode
,	CustomerPart
,	CustomerPO
,	ShipFromCode
,	ICCode
,	ReleaseNo
,	ReleaseQty
,	AccumReceived
,	LastBOLReceived
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
,	sfr.AccumReceived
,	sfr.LastBOLReceived
,	sfr.ReleaseDT
from
	EDI.StagingNascote_830_Releasest sfr

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
set	@TableName = 'EDI.Nascote_830_Cumulatives'

insert
	EDI.Nascote_830_Cumulatives
	        ( 
	          RawDocumentGUID ,
	          ShipToCode ,
	          CustomerPO ,
	          CustomerPart ,
	          ReleaseNo, 
	          QtyQualifier ,
	          CumulativeQty ,
	          CumulativeEndDT ,
	          LastReceivedQty ,
	          LastReceivedDT ,
	          LastReceivedBOL
	        )

select
	sfr.RawDocumentGUID
,	sfr.ShipToCode
,	sfr.CustomerPO
,	sfr.CustomerPart
,	sfr.ReleaseNo
     , sfr.QtyQualifier
     , sfr.CumulativeQty
      , sfr.CumulativeEndDT
     , sfr.LastReceivedQty
     , sfr.LastReceivedDT
     , sfr.LastReceivedBOL
from
	EDI.StagingNascote_830_Cumulativest sfr

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
	EDI.StagingNascote_830_Headerst
truncate table
	EDI.StagingNascote_830_Releasest
truncate table
	EDI.StagingNascote_830_Cumulativest

/*		Rename staging tables to prevent any additional data being written to them and to ensure they are not involved in a transaction. */


--- <Call>	
set	@CallProcName = 'dbo.sp_rename'
execute
	/*@ProcReturn = */dbo.sp_rename
	@objname = N'EDI.StagingNascote_830_Headerst'
,	@newName = N'StagingNascote_830_Headers'

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
	@objname = N'EDI.StagingNascote_830_Releasest'
,	@newName = N'StagingNascote_830_Releases'

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
	@objname = N'EDI.StagingNascote_830_Cumulativest'
,	@newName = N'StagingNascote_830_Cumulatives'

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
	@ProcReturn = EDI.usp_stage_2_Nascote
	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

select
	*
from
	EDI.TRW_DELJIT_Headers sdhv

select
	*
from
	EDI.TRW_DELJIT_Releases sdrv

select
	*
from
	EDI.Nascote_830_Headers sdhv

select
	*
from
	EDI.Nascote_830_Releases sdrv
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
