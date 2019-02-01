SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EEIUser].[acctg_csm_sp_import_GC]
	@OperatorCode varchar(5)
,	@CurrentRelease char(7)
,	@TranDT datetime = null out
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDIStanley.usp_Test
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
if not exists (
		select
			*
		from
			dbo.employee e
		where	
			e.operator_code = @OperatorCode ) begin

	set	@Result = 999999
	RAISERROR ('Invalid operator code.  Procedure %s.', 16, 1, @ProcName)
	rollback tran @ProcName
	return
end

/* Exit if CSM data has already been imported for this release */
if exists ( 
		select
			coalesce(h.RolledForward, 0)
		from
			acctg_csm_NAIHS_header h
		where
			h.Region = 'Greater China'
			and h.Release_ID = @CurrentRelease
			and h.[Version] = 'CSM'
			and h.RolledForward = 1 ) begin

	set	@Result = 999999
	RAISERROR ('Greater China CSM data has already been rolled forward and imported for release %s.  Procedure %s.', 16, 1, @CurrentRelease, @ProcName)
	rollback tran @ProcName
	return
end

/* Exit if North America CSM data has not been imported yet for this release (and by default, rolling forward has not happened yet) */
if not exists (
		select
			coalesce(h.RolledForward, 0)
		from
			acctg_csm_NAIHS_header h
		where
			h.Region = 'North America'
			and h.Release_ID = @CurrentRelease
			and h.[Version] = 'CSM'
			and h.RolledForward = 1 ) begin

	set	@Result = 999999
	RAISERROR ('North America CSM data has not been imported yet for release %s. Please complete this first so that all data is rolled forward.  Procedure %s.', 16, 1, @CurrentRelease, @ProcName)
	rollback tran @ProcName
	return
end
---	</ArgumentValidation>


--- <Body>
declare 
	@Region varchar(50)
,	@PriorRelease char(7)

set @Region = 'Greater China'

select
	@PriorRelease = max(h.Release_ID)
from
	eeiuser.acctg_csm_NAIHS_header h
where	
	Region = @Region


-- Step 1: roll forward into the header table all CSM, Empire Adjusted and Empire Factor data
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_rollforward_header_GC'
execute		@ProcReturn = eeiuser.acctg_csm_sp_rollforward_header_GC
			@OperatorCode = @OperatorCode,
			@CurrentRelease = @CurrentRelease,
			@PriorRelease = @PriorRelease,
			@TranDT = @TranDT out,
			@Result = @ProcResult out
			
				
set @Error = @@Error
if @Error > 0 begin
	set	@Result = 999999
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return @Result
end
if @ProcResult != 0 begin
	set	@Result = 999999
	RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcResult != 0 begin
	set	@Result = 999999
	RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
-- </Call>


-- Step 2: insert spreadsheet CSM data into the header table
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_insert_header'
execute		@ProcReturn = eeiuser.acctg_csm_sp_insert_header
			@OperatorCode = @OperatorCode,
			@CurrentRelease = @CurrentRelease,
			@TranDT = @TranDT out,
			@Result = @ProcResult out


set @Error = @@Error
if @Error > 0 begin
	set	@Result = 999999
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return @Result
end
if @ProcResult != 0 begin
	set	@Result = 999999
	RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcResult != 0 begin
	set	@Result = 999999
	RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
-- </Call>


-- Step 3: roll forward into the detail table all CSM, Empire Adjusted and Empire Factor data
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_rollforward_detail_GC'
execute		@ProcReturn = eeiuser.acctg_csm_sp_rollforward_detail_GC
			@OperatorCode = @OperatorCode,
			@CurrentRelease = @CurrentRelease,
			@PriorRelease = @PriorRelease,
			@TranDT = @TranDT out,
			@Result = @ProcResult out
			
				
set @Error = @@Error
if @Error > 0 begin
	set	@Result = 999999
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return @Result
end
if @ProcResult != 0 begin
	set	@Result = 999999
	RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcResult != 0 begin
	set	@Result = 999999
	RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
-- </Call>


-- Step 4: insert spreadsheet CSM data into the detail table
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_insert_detail'
execute		@ProcReturn = eeiuser.acctg_csm_sp_insert_detail
			@OperatorCode = @OperatorCode,
			@CurrentRelease = @CurrentRelease,
			@TranDT = @TranDT out,
			@Result = @ProcResult out


set @Error = @@Error
if @Error > 0 begin
	set	@Result = 999999
	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return @Result
end
if @ProcResult != 0 begin
	set	@Result = 999999
	RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
if	@ProcResult != 0 begin
	set	@Result = 999999
	RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
	rollback tran @ProcName
	return	@Result
end
-- </Call>


-- Step 5: update header records, flagging them as rolled forward
--- <Update rows>
set	@TableName = 'eeiuser.acctg_csm_NAIHS_header'	
update
	eeiuser.acctg_csm_NAIHS_header
set
	RolledForward = 1
where
	Release_ID = @CurrentRelease
	and Region = @Region

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount < 1 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1+.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Update>
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

GO
