SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create procedure [EEIUser].[acctg_csm_sp_price_adjustments]
	@OperatorCode varchar(5)
,	@CurrentRelease char(7)
,	@PriorRelease char(7)
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
/*  Valid operator  */
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

/*  Valid release  */
if exists (
		select
			1
		from
			eeiuser.acctg_csm_selling_prices_change_log cl
		where
			@CurrentRelease <= ( select max(ReleaseID) from eeiuser.acctg_csm_selling_prices_change_log ) ) begin

	set	@Result = 999999
	RAISERROR ('Release %s has already been processed.  Procedure %s.', 16, 1, @CurrentRelease, @ProcName)
	rollback tran @ProcName
	return
end
---	</ArgumentValidation>


--- <Body>
-- Step 1: insert into the base prices table from new job build (insert new part prices)
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_base_prices_insert'
execute		@ProcReturn = eeiuser.acctg_csm_sp_base_prices_insert
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


-- Step 2: insert into the price adjustments table from new job build (insert ECN price changes)
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_price_adjustments_insert_ECNs'
execute		@ProcReturn = eeiuser.acctg_csm_sp_price_adjustments_insert_ECNs
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


-- Step 3: insert selling prices into the price adjustments table from Quote Log (new quote price changes)
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_price_adjustments_insert_quote'
execute		@ProcReturn = eeiuser.acctg_csm_sp_price_adjustments_insert_quote
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


-- Step 4: update the price adjustments table, performing adjustment calculations against any new selling prices that were inserted
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_price_adjustments_update'
execute		@ProcReturn = eeiuser.acctg_csm_sp_price_adjustments_update
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


-- Step 5: roll forward selling price change log data into the current release 
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_rollforward_selling_prices_change_log'
execute		@ProcReturn = eeiuser.acctg_csm_sp_rollforward_selling_prices_change_log
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


-- Step 6: insert New Job Build prices, ECN price adjustments, and Quote Log price adjustments into the selling prices change log 
-- <Call>
set			@CallProcName = 'eeiuser.acctg_csm_sp_insert_selling_prices_change_log'
execute		@ProcReturn = eeiuser.acctg_csm_sp_insert_selling_prices_change_log
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
