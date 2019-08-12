SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EEIUser].[acctg_csm_sp_rollforward_detail_NA]
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
-- Roll forward all data for Empire Adjusted and Empire Factor into the current release (exclude CSM)
--  (Trigger will fire, creating new records in the data warehouse (legacy) table)
declare @Region varchar(50)
set @Region = 'North America'

--- <Insert rows>
set	@TableName = 'eeiuser.acctg_csm_NAIHS_detail'	
insert
	eeiuser.acctg_csm_NAIHS_detail
(
	Header_ID
,	Release_ID
,	[Version]
,	[Mnemonic-Vehicle/Plant]
,	[Period]
,	EffectiveYear
,	EffectiveDT
,	SalesDemand
)
select
	h.ID
,	@CurrentRelease
,	d.[Version]
,	d.[Mnemonic-Vehicle/Plant]
,	d.[Period]
,	d.EffectiveYear
,	d.EffectiveDT
,	d.SalesDemand
from
	eeiuser.acctg_csm_NAIHS_detail d
	join eeiuser.acctg_csm_NAIHS_header h
		on h.[Mnemonic-Vehicle/Plant] = d.[Mnemonic-Vehicle/Plant]
		and (h.[Version] = d.[Version] or (h.[Version] is null and d.[Version] is null))
		and h.Release_ID = @CurrentRelease
		and (h.Region = @Region or h.Region is null)
where
	d.Release_ID = @PriorRelease
	--and ( ( d.[Version] = 'CSM' and d.EffectiveYear < (convert(int, left (@CurrentRelease, 4)) - 1) ) or d.[Version] <> 'CSM' )
	and d.[Version] <> 'CSM'
	


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
