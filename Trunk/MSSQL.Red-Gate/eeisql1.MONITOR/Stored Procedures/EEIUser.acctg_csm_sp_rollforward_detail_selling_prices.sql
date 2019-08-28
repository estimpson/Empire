SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EEIUser].[acctg_csm_sp_rollforward_detail_selling_prices]
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
-- Roll forward all data into the current release
--  (Trigger will fire, creating new records in the data warehouse (legacy) table)
--- <Insert rows>
set	@TableName = 'eeiuser.acctg_csm_selling_prices_detail'	
insert
	eeiuser.acctg_csm_selling_prices_detail
(
	Header_ID
,	Release_ID
,	Row_ID
,	BasePart
,	[Version]
,	Period
,	EffectiveYear
,	EffectiveDT
,	SellingPrice
)
select
	h.ID
,	@CurrentRelease
,	d.Row_ID
,	d.BasePart
,	d.[Version]
,	d.Period
,	d.EffectiveYear
,	d.EffectiveDT
,	d.SellingPrice
from
	eeiuser.acctg_csm_selling_prices_detail d
	join eeiuser.acctg_csm_selling_prices_header h
		on h.BasePart = d.BasePart
		and (h.[Version] = d.[Version] or (h.[Version] is null and d.[Version] is null))
		and h.Release_ID = @CurrentRelease
where
	d.Release_ID = @PriorRelease


select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount = 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: >0.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Insert>
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
