SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EEIUser].[acctg_csm_sp_rollback]
	@OperatorCode varchar(5)
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
---	</ArgumentValidation>


--- <Body>
-- Step 1: roll back base part attributes one month 
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_rollback_base_part_attributes'
execute		@ProcReturn = eeiuser.acctg_csm_sp_rollback_base_part_attributes
			@OperatorCode = @OperatorCode,
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


-- Step 2: roll back base part mnemonic one month 
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_rollback_base_part_mnemonic'
execute		@ProcReturn = eeiuser.acctg_csm_sp_rollback_base_part_mnemonic
			@OperatorCode = @OperatorCode,
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


-- Step 3: roll back base part notes one month 
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_rollback_base_part_notes'
execute		@ProcReturn = eeiuser.acctg_csm_sp_rollback_base_part_notes
			@OperatorCode = @OperatorCode,
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


-- Step 4: roll back Selling Prices one month 
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_rollback_selling_prices'
execute		@ProcReturn = eeiuser.acctg_csm_sp_rollback_selling_prices
			@OperatorCode = @OperatorCode,
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


-- Step 5: roll back Material Cost one month
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_rollback_material_cost'
execute		@ProcReturn = eeiuser.acctg_csm_sp_rollback_material_cost
			@OperatorCode = @OperatorCode,
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


-- Step 6: roll back all CSM, Empire Adjusted and Empire Factor data one month
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_rollback_NA_GC'
execute		@ProcReturn = eeiuser.acctg_csm_sp_rollback_NA_GC
			@OperatorCode = @OperatorCode,
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
