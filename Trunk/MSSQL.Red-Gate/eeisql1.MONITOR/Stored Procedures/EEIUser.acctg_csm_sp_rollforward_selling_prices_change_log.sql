SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create procedure [EEIUser].[acctg_csm_sp_rollforward_selling_prices_change_log]
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
--- <Insert rows>
set	@TableName = 'eeiuser.acctg_csm_selling_prices_change_log'	
insert
	eeiuser.acctg_csm_selling_prices_change_log
(
	[ReleaseID]
,	[BasePart]
,	[EffectiveDT]
,	[Reason]
,	[PriceAdjustmentID]

--,	[JAN_08], [FEB_08],	[MAR_08], [APR_08],	[MAY_08], [JUN_08],	[JUL_08], [AUG_08],	[SEP_08], [OCT_08],	[NOV_08], [DEC_08]
--,	[JAN_09], [FEB_09],	[MAR_09], [APR_09],	[MAY_09], [JUN_09],	[JUL_09], [AUG_09],	[SEP_09], [OCT_09],	[NOV_09], [DEC_09]
--,	[JAN_10], [FEB_10],	[MAR_10], [APR_10],	[MAY_10], [JUN_10],	[JUL_10], [AUG_10],	[SEP_10], [OCT_10],	[NOV_10], [DEC_10]
--,	[JAN_11], [FEB_11],	[MAR_11], [APR_11],	[MAY_11], [JUN_11],	[JUL_11], [AUG_11],	[SEP_11], [OCT_11],	[NOV_11], [DEC_11]
--,	[JAN_12], [FEB_12],	[MAR_12], [APR_12],	[MAY_12], [JUN_12],	[JUL_12], [AUG_12],	[SEP_12], [OCT_12],	[NOV_12], [DEC_12]
--,	[JAN_13], [FEB_13],	[MAR_13], [APR_13],	[MAY_13], [JUN_13],	[JUL_13], [AUG_13],	[SEP_13], [OCT_13],	[NOV_13], [DEC_13]
--,	[JAN_14], [FEB_14],	[MAR_14], [APR_14],	[MAY_14], [JUN_14],	[JUL_14], [AUG_14],	[SEP_14], [OCT_14],	[NOV_14], [DEC_14]
,	[JAN_15], [FEB_15],	[MAR_15], [APR_15],	[MAY_15], [JUN_15],	[JUL_15], [AUG_15],	[SEP_15], [OCT_15],	[NOV_15], [DEC_15]
,	[JAN_16], [FEB_16],	[MAR_16], [APR_16],	[MAY_16], [JUN_16],	[JUL_16], [AUG_16],	[SEP_16], [OCT_16],	[NOV_16], [DEC_16]
,	[JAN_17], [FEB_17],	[MAR_17], [APR_17],	[MAY_17], [JUN_17],	[JUL_17], [AUG_17],	[SEP_17], [OCT_17],	[NOV_17], [DEC_17]
,	[JAN_18], [FEB_18],	[MAR_18], [APR_18],	[MAY_18], [JUN_18],	[JUL_18], [AUG_18],	[SEP_18], [OCT_18],	[NOV_18], [DEC_18]
,	[JAN_19], [FEB_19],	[MAR_19], [APR_19],	[MAY_19], [JUN_19],	[JUL_19], [AUG_19],	[SEP_19], [OCT_19],	[NOV_19], [DEC_19]
,	[JAN_20], [FEB_20],	[MAR_20], [APR_20],	[MAY_20], [JUN_20],	[JUL_20], [AUG_20],	[SEP_20], [OCT_20],	[NOV_20], [DEC_20]
,	[JAN_21], [FEB_21],	[MAR_21], [APR_21],	[MAY_21], [JUN_21],	[JUL_21], [AUG_21],	[SEP_21], [OCT_21],	[NOV_21], [DEC_21]

,	[DEC_22], [DEC_23],	[DEC_24], [DEC_25],	[DEC_26]
)
select
	@CurrentRelease
,	[BasePart]
,	[EffectiveDT]
,	[Reason]
,	[PriceAdjustmentID]

--,	[JAN_08], [FEB_08],	[MAR_08], [APR_08],	[MAY_08], [JUN_08],	[JUL_08], [AUG_08],	[SEP_08], [OCT_08],	[NOV_08], [DEC_08]
--,	[JAN_09], [FEB_09],	[MAR_09], [APR_09],	[MAY_09], [JUN_09],	[JUL_09], [AUG_09],	[SEP_09], [OCT_09],	[NOV_09], [DEC_09]
--,	[JAN_10], [FEB_10],	[MAR_10], [APR_10],	[MAY_10], [JUN_10],	[JUL_10], [AUG_10],	[SEP_10], [OCT_10],	[NOV_10], [DEC_10]
--,	[JAN_11], [FEB_11],	[MAR_11], [APR_11],	[MAY_11], [JUN_11],	[JUL_11], [AUG_11],	[SEP_11], [OCT_11],	[NOV_11], [DEC_11]
--,	[JAN_12], [FEB_12],	[MAR_12], [APR_12],	[MAY_12], [JUN_12],	[JUL_12], [AUG_12],	[SEP_12], [OCT_12],	[NOV_12], [DEC_12]
--,	[JAN_13], [FEB_13],	[MAR_13], [APR_13],	[MAY_13], [JUN_13],	[JUL_13], [AUG_13],	[SEP_13], [OCT_13],	[NOV_13], [DEC_13]
--,	[JAN_14], [FEB_14],	[MAR_14], [APR_14],	[MAY_14], [JUN_14],	[JUL_14], [AUG_14],	[SEP_14], [OCT_14],	[NOV_14], [DEC_14]
,	[JAN_15], [FEB_15],	[MAR_15], [APR_15],	[MAY_15], [JUN_15],	[JUL_15], [AUG_15],	[SEP_15], [OCT_15],	[NOV_15], [DEC_15]
,	[JAN_16], [FEB_16],	[MAR_16], [APR_16],	[MAY_16], [JUN_16],	[JUL_16], [AUG_16],	[SEP_16], [OCT_16],	[NOV_16], [DEC_16]
,	[JAN_17], [FEB_17],	[MAR_17], [APR_17],	[MAY_17], [JUN_17],	[JUL_17], [AUG_17],	[SEP_17], [OCT_17],	[NOV_17], [DEC_17]
,	[JAN_18], [FEB_18],	[MAR_18], [APR_18],	[MAY_18], [JUN_18],	[JUL_18], [AUG_18],	[SEP_18], [OCT_18],	[NOV_18], [DEC_18]
,	[JAN_19], [FEB_19],	[MAR_19], [APR_19],	[MAY_19], [JUN_19],	[JUL_19], [AUG_19],	[SEP_19], [OCT_19],	[NOV_19], [DEC_19]
,	[JAN_20], [FEB_20],	[MAR_20], [APR_20],	[MAY_20], [JUN_20],	[JUL_20], [AUG_20],	[SEP_20], [OCT_20],	[NOV_20], [DEC_20]
,	[JAN_21], [FEB_21],	[MAR_21], [APR_21],	[MAY_21], [JUN_21],	[JUL_21], [AUG_21],	[SEP_21], [OCT_21],	[NOV_21], [DEC_21]

,	[DEC_22], [DEC_23],	[DEC_24], [DEC_25],	[DEC_26]
from
	eeiuser.acctg_csm_selling_prices_change_log cl
where
	cl.ReleaseID = @PriorRelease


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
