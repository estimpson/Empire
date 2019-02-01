SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EEIUser].[acctg_csm_sp_import_NA]
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
declare @Region varchar(50)
set @Region = 'North America'

if exists ( 
		select
			coalesce(h.RolledForward, 0)
		from
			acctg_csm_NAIHS_header h
		where
			h.Region = @Region
			and h.Release_ID = @CurrentRelease
			and h.[Version] = 'CSM'
			and h.RolledForward = 1 ) begin

	set	@Result = 999999
	RAISERROR ('%s CSM NA data has already been rolled forward and imported for release %s.  Procedure %s.', 16, 1, @Region, @CurrentRelease, @ProcName)
	rollback tran @ProcName
	return
end

/* Make sure Selling Prices and Material Cost releases are consistent with North America CSM releases */
declare 
	@PriorRelease char(7)
,	@PriorReleaseSp char(7)
,	@PriorReleaseMc char(7)

select
	@PriorRelease = max(h.Release_ID)
from
	eeiuser.acctg_csm_NAIHS_header h
where	
	Region = @Region


select
	@PriorReleaseSp	= max(h.Release_ID)
from
	eeiuser.acctg_csm_selling_prices_header h

if ( @PriorReleaseSp <> @PriorRelease ) begin

	set	@Result = 999999
	RAISERROR ('The last imported selling prices release (%s) does not match the last imported CSM NA release (%s).  Procedure %s.', 16, 1, @PriorReleaseSp, @PriorRelease, @ProcName)
	rollback tran @ProcName
	return
end


select
	@PriorReleaseMc	= max(h.Release_ID)
from
	eeiuser.acctg_csm_material_cost_header h

if ( @PriorReleaseMc <> @PriorRelease ) begin

	set	@Result = 999999
	RAISERROR ('The last imported material cost release (%s) does not match the last imported CSM NA release (%s).  Procedure %s.', 16, 1, @PriorReleaseMc, @PriorRelease, @ProcName)
	rollback tran @ProcName
	return
end

/* Make sure base part attributes, mnemonic and notes releases are consistent with North America CSM releases */
declare 
	@PriorReleaseBpa char(7)
,	@PriorReleaseBpm char(7)
,	@PriorReleaseBpn char(7)

select
	@PriorReleaseBpa = max(bpa.release_id)
from
	eeiuser.acctg_csm_base_part_attributes bpa

if ( @PriorReleaseBpa <> @PriorRelease ) begin

	set	@Result = 999999
	RAISERROR ('The last imported base part attributes release (%s) does not match the last imported CSM NA release (%s).  Procedure %s.', 16, 1, @PriorReleaseBpa, @PriorRelease, @ProcName)
	rollback tran @ProcName
	return
end

select
	@PriorReleaseBpm = max(bpm.release_id)
from
	eeiuser.acctg_csm_base_part_mnemonic bpm

if ( @PriorReleaseBpm <> @PriorRelease ) begin

	set	@Result = 999999
	RAISERROR ('The last imported base part mnemonic release (%s) does not match the last imported CSM NA release (%s).  Procedure %s.', 16, 1, @PriorReleaseBpm, @PriorRelease, @ProcName)
	rollback tran @ProcName
	return
end

select
	@PriorReleaseBpn = max(bpn.release_id)
from
	eeiuser.acctg_csm_base_part_notes bpn

if ( @PriorReleaseBpn <> @PriorRelease ) begin

	set	@Result = 999999
	RAISERROR ('The last imported base part notes release (%s) does not match the last imported CSM NA release (%s).  Procedure %s.', 16, 1, @PriorReleaseBpn, @PriorRelease, @ProcName)
	rollback tran @ProcName
	return
end
---	</ArgumentValidation>


--- <Body>
-- Step 1: roll forward base part attributes
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_rollforward_base_part_attributes'
execute		@ProcReturn = eeiuser.acctg_csm_sp_rollforward_base_part_attributes
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


-- Step 2: roll forward base part mnemonic
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_rollforward_base_part_mnemonic'
execute		@ProcReturn = eeiuser.acctg_csm_sp_rollforward_base_part_mnemonic
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


-- Step 3: roll forward base part notes
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_rollforward_base_part_notes'
execute		@ProcReturn = eeiuser.acctg_csm_sp_rollforward_base_part_notes
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


-- Step 4: roll forward Selling Prices data into the current release in the header table 
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_rollforward_header_selling_prices'
execute		@ProcReturn = eeiuser.acctg_csm_sp_rollforward_header_selling_prices
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


-- Step 5: roll forward Selling Prices data into the current release in the detail table 
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_rollforward_detail_selling_prices'
execute		@ProcReturn = eeiuser.acctg_csm_sp_rollforward_detail_selling_prices
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


-- Step 6: roll forward Material Cost data into the current release in the header table 
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_rollforward_header_material_cost'
execute		@ProcReturn = eeiuser.acctg_csm_sp_rollforward_header_material_cost
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


-- Step 7: roll forward Material Cost data into the current release in the detail table 
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_rollforward_detail_material_cost'
execute		@ProcReturn = eeiuser.acctg_csm_sp_rollforward_detail_material_cost
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


-- Step 8: roll forward into the header table all CSM, Empire Adjusted and Empire Factor data
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_rollforward_header_NA'
execute		@ProcReturn = eeiuser.acctg_csm_sp_rollforward_header_NA
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


-- Step 9: insert spreadsheet CSM data into the header table
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


-- Step 10: roll forward into the detail table all CSM, Empire Adjusted and Empire Factor data
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_rollforward_detail_NA'
execute		@ProcReturn = eeiuser.acctg_csm_sp_rollforward_detail_NA
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


-- Step 11: insert spreadsheet CSM data into the detail table
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



-- Step 12: update Selling Prices header records, flagging them as rolled forward
--- <Update rows>
set	@TableName = 'eeiuser.acctg_csm_selling_prices_header'	
update
	eeiuser.acctg_csm_selling_prices_header
set
	RolledForward = 1
where
	Release_ID = @CurrentRelease

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



-- Step 13: update Material Cost header records, flagging them as rolled forward
--- <Update rows>
set	@TableName = 'eeiuser.acctg_csm_material_cost_header'	
update
	eeiuser.acctg_csm_material_cost_header
set
	RolledForward = 1
where
	Release_ID = @CurrentRelease

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



-- Step 14: update North America CSM header records, flagging them as rolled forward
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
