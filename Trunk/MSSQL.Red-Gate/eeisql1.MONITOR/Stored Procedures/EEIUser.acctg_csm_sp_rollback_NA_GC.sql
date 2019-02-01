SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create procedure [EEIUser].[acctg_csm_sp_rollback_NA_GC]
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
-- Step 1: roll back all CSM data one month in the detail table (which will fire a trigger to roll back the legacy table)
---<Delete>
set	@TableName = 'eeiuser.acctg_csm_NAIHS_detail'	
delete from
	eeiuser.acctg_csm_NAIHS_detail
where
	Release_ID =
		(	select
				max(h.Release_ID)
			from
				eeiuser.acctg_csm_NAIHS_header h
			where
				h.RolledForward = 1 )
		
select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount < 1 begin
	set	@Result = 999999
	RAISERROR ('Error deleting from table %s in procedure %s.  Rows deleted: %d.  Expected rows: 1+.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
---</Delete>


-- Step 2: roll back all CSM data one month in the header table
---<Delete>
set	@TableName = 'eeiuser.acctg_csm_NAIHS_header'	
delete from
	eeiuser.acctg_csm_NAIHS_header
where
	Release_ID =
		(	select
				max(h.Release_ID)
			from
				eeiuser.acctg_csm_NAIHS_header h
			where
				h.RolledForward = 1 )
		
select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount < 1 begin
	set	@Result = 999999
	RAISERROR ('Error deleting from table %s in procedure %s.  Rows deleted: %d.  Expected rows: 1+.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
---</Delete>
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
