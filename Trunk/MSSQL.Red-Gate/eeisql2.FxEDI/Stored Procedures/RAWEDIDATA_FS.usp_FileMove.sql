SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [RAWEDIDATA_FS].[usp_FileMove]
	@FromFolder sysname
,	@ToFolder sysname
,	@FileNamePattern sysname
,	@FileAppendPrefix sysname = null
,	@FileAppendSuffix sysname = null
,	@IncludeSub bit = 0
,	@ERRHAND_OnDuplicateTargetFileName_AppendSuffix int = 0
,	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings off
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. RAWEDIDATA_FS.usp_Test
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
declare
	@fromPath hierarchyid
,	@toPath hierarchyid

select
	@fromPath =
		(	select
				uds.PathLocator
			from
				RAWEDIDATA_FS.udf_DIR_Summary(@FromFolder) uds
		)
,	@toPath =
		(	select
				uds.PathLocator
			from
				RAWEDIDATA_FS.udf_DIR_Summary(@ToFolder) uds
		)

if	@fromPath is null begin
	set	@Result = 999998
	RAISERROR ('Error encountered in %s.  Failure: Invalid "FromFolder" specified.  Folder "%s" not found.', 16, 1, @ProcName, @FromFolder)
	rollback tran @ProcName
	return	@Result
end

if	@toPath is null begin
	set	@Result = 999998
	RAISERROR ('Error encountered in %s.  Failure: Invalid "ToFolder" specified.  Folder "%s" not found.', 16, 1, @ProcName, @ToFolder)
	rollback tran @ProcName
	return	@Result
end

set ansi_warnings on

if	@IncludeSub = 0 begin
	update
		red
	set
		path_locator = red.path_locator.GetReparentedValue(@fromPath, @toPath)
	,	name = coalesce(@FileAppendPrefix, '') + red.name + coalesce(@FileAppendSuffix, '')
	from
		FxEDI.dbo.RawEDIData red
	where
		red.parent_path_locator = @fromPath
		and red.is_directory = 0
end
else begin
	update
		red
	set
		path_locator = red.path_locator.GetReparentedValue(@fromPath, @toPath)
	,	name = coalesce(@FileAppendPrefix, '') + red.name + coalesce(@FileAppendSuffix, '')
	from
		FxEDI.dbo.RawEDIData red
	where
		red.parent_path_locator.IsDescendantOf(@fromPath) = 1
end
set ansi_warnings off
--- </Body>

---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
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
	@FromFolder sysname = '\Temp\From'
,	@ToFolder sysname = '\Temp\To'
,	@FileNamePattern sysname = '%'
,	@FileAppendPrefix sysname = null
,	@FileAppendSuffix sysname = null
,	@IncludeSub bit = 1

begin transaction Test

select
	*
from
	RAWEDIDATA_FS.udf_DIR(@FromFolder, 1)

select
	*
from
	RAWEDIDATA_FS.udf_DIR(@ToFolder, 1)

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = RAWEDIDATA_FS.usp_FileMove
	@FromFolder = @FromFolder
,	@ToFolder = @ToFolder
,	@FileNamePattern = @FileNamePattern
,	@FileAppendPrefix = @FileAppendPrefix
,	@FileAppendSuffix = @FileAppendSuffix
,	@IncludeSub = @IncludeSub
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult

select
	*
from
	RAWEDIDATA_FS.udf_DIR(@FromFolder, 1)

select
	*
from
	RAWEDIDATA_FS.udf_DIR(@ToFolder, 1)
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
