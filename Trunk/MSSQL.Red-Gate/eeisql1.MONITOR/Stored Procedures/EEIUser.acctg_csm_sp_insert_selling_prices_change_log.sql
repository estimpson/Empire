SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create procedure [EEIUser].[acctg_csm_sp_insert_selling_prices_change_log]
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
-- Insert from New Job Build
--- <Insert>
set	@TableName = 'eeiuser.acctg_csm_selling_prices_change_log'
insert
	EEIUser.acctg_csm_selling_prices_change_log
(
	[ReleaseID]
,	[BasePart]
,	[QuoteNumber]
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
	cl.ReleaseID
,	bp.BasePart
,	bp.QuoteNumber
,	bp.EffectiveDT
,	'Base Price'
,	null

,	[JAN_15] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[FEB_15] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[MAR_15] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[APR_15] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[MAY_15] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[JUN_15] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[JUL_15] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[AUG_15] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[SEP_15] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[OCT_15] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[NOV_15] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[DEC_15] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)

,	[JAN_16] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[FEB_16] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[MAR_16] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[APR_16] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[MAY_16] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[JUN_16] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[JUL_16] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[AUG_16] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[SEP_16] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[OCT_16] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[NOV_16] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[DEC_16] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)

,	[JAN_17] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[FEB_17] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[MAR_17] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[APR_17] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[MAY_17] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[JUN_17] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[JUL_17] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[AUG_17] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[SEP_17] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[OCT_17] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[NOV_17] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[DEC_17] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)

,	[JAN_18] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[FEB_18] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[MAR_18] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[APR_18] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[MAY_18] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[JUN_18] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[JUL_18] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[AUG_18] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[SEP_18] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[OCT_18] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[NOV_18] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[DEC_18] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)

,	[JAN_19] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[FEB_19] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[MAR_19] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[APR_19] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[MAY_19] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[JUN_19] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[JUL_19] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[AUG_19] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[SEP_19] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[OCT_19] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[NOV_19] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[DEC_19] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)

,	[JAN_20] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[FEB_20] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[MAR_20] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[APR_20] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[MAY_20] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[JUN_20] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[JUL_20] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[AUG_20] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[SEP_20] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[OCT_20] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[NOV_20] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[DEC_20] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)

,	[JAN_21] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[FEB_21] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[MAR_21] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[APR_21] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[MAY_21] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[JUN_21] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[JUL_21] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[AUG_21] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[SEP_21] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[OCT_21] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[NOV_21] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[DEC_21] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)

,	[DEC_22] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[DEC_23] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[DEC_24] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[DEC_25] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
,	[DEC_26] = (select min(Price) from eeiuser.acctg_csm_base_prices where BasePart = bp.BasePart)
from
	eeiuser.acctg_csm_base_prices bp
	join eeiuser.acctg_csm_selling_prices_change_log cl
		on cl.BasePart = bp.BasePart
where
	cl.ReleaseID = ( select max(ReleaseID) from eeiuser.acctg_csm_selling_prices_change_log )
	and cl.BasePart is null


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





-- Insert from Quote price adjustments
--- <Insert>
set	@TableName = 'eeiuser.acctg_csm_selling_prices_change_log'
insert
	EEIUser.acctg_csm_selling_prices_change_log
(
	[ReleaseID]
,	[BasePart]
,	[QuoteNumber]
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
	cl.ReleaseID
,	pa.BasePart
,	pa.QuoteNumber
,	pa.EffectiveDT
,	pa.AdjustmentType
,	pa.RowID

,	[JAN_15] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20150101')
,	[FEB_15] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20150201')
,	[MAR_15] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20150301')
,	[APR_15] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20150401')
,	[MAY_15] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20150501')
,	[JUN_15] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20150601')
,	[JUL_15] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20150701')
,	[AUG_15] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20150801')
,	[SEP_15] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20150901')
,	[OCT_15] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20151001')
,	[NOV_15] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20151101')
,	[DEC_15] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20151201')
					   																										   
,	[JAN_16] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20160101')
,	[FEB_16] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20160201')
,	[MAR_16] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20160301')
,	[APR_16] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20160401')
,	[MAY_16] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20160501')
,	[JUN_16] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20160601')
,	[JUL_16] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20160701')
,	[AUG_16] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20160801')
,	[SEP_16] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20160901')
,	[OCT_16] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20161001')
,	[NOV_16] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20161101')
,	[DEC_16] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20161201')
					   																										   
,	[JAN_17] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20170101')
,	[FEB_17] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20170201')
,	[MAR_17] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20170301')
,	[APR_17] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20170401')
,	[MAY_17] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20170501')
,	[JUN_17] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20170601')
,	[JUL_17] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20170701')
,	[AUG_17] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20170801')
,	[SEP_17] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20170901')
,	[OCT_17] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20171001')
,	[NOV_17] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20171101')
,	[DEC_17] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20171201')
					 																										   
,	[JAN_18] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20180101')
,	[FEB_18] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20180201')
,	[MAR_18] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20180301')
,	[APR_18] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20180401')
,	[MAY_18] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20180501')
,	[JUN_18] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20180601')
,	[JUL_18] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20180701')
,	[AUG_18] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20180801')
,	[SEP_18] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20180901')
,	[OCT_18] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20181001')
,	[NOV_18] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20181101')
,	[DEC_18] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20181201')
																															   
,	[JAN_19] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20190101')
,	[FEB_19] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20190201')
,	[MAR_19] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20190301')
,	[APR_19] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20190401')
,	[MAY_19] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20190501')
,	[JUN_19] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20190601')
,	[JUL_19] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20190701')
,	[AUG_19] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20190801')
,	[SEP_19] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20190901')
,	[OCT_19] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20191001')
,	[NOV_19] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20191101')
,	[DEC_19] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20191201')
					  																										   
,	[JAN_20] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20200101')
,	[FEB_20] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20200201')
,	[MAR_20] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20200301')
,	[APR_20] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20200401')
,	[MAY_20] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20200501')
,	[JUN_20] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20200601')
,	[JUL_20] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20200701')
,	[AUG_20] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20200801')
,	[SEP_20] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20200901')
,	[OCT_20] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20201001')
,	[NOV_20] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20201101')
,	[DEC_20] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20201201')
																															   
,	[JAN_21] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20210101')
,	[FEB_21] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20210201')
,	[MAR_21] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20210301')
,	[APR_21] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20210401')
,	[MAY_21] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20210501')
,	[JUN_21] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20210601')
,	[JUL_21] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20210701')
,	[AUG_21] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20210801')
,	[SEP_21] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20210901')
,	[OCT_21] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20211001')
,	[NOV_21] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20211101')
,	[DEC_21] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20211201')
																															   
,	[DEC_22] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20221201')
,	[DEC_23] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20231201')
,	[DEC_24] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20241201')
,	[DEC_25] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20251201')
,	[DEC_26] = (select sum(SellingPrice) from eeiuser.acctg_csm_price_adjustments where BasePart = pa.BasePart and EffectiveDT < '20261201')
from
	eeiuser.acctg_csm_price_adjustments pa
	join eeiuser.acctg_csm_selling_prices_change_log cl
		on cl.PriceAdjustmentID = pa.RowID
where
	cl.ReleaseID = ( select max(ReleaseID) from eeiuser.acctg_csm_selling_prices_change_log )
	and cl.PriceAdjustmentID is null


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
