SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [EEIUser].[acctg_csm_sp_price_adjustments_update]
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
-- Update price adjustments table 
declare @tempPriceAdj table
(
	RowID int
,	BasePart char(7)
,	EffectiveDT datetime
,	SellingPrice decimal(18,6)
,	AdjustmentAmount decimal(18,6)
,	PriceAdjustmentRowID int
)

insert into @tempPriceAdj
(
	RowID
,	BasePart
,	EffectiveDT
,	SellingPrice
,	AdjustmentAmount
,	PriceAdjustmentRowID
)
select
	ROW_NUMBER() OVER (ORDER by pa.BasePart, pa.EffectiveDT)  
,	pa.BasePart
,	pa.EffectiveDT
,	pa.SellingPrice
,	null
,	pa.RowID
from
	eeiuser.acctg_csm_price_adjustments pa
where
	pa.PriceAdjustment is null
order by
	pa.BasePart
,	pa.EffectiveDT


update
	tpa1
set
	tpa1.AdjustmentAmount = tpa1.SellingPrice - coalesce(
		(	select top(1)
				tpa2.SellingPrice
			from
				@tempPriceAdj tpa2
			where
				tpa1.BasePart = tpa2.BasePart
				and tpa1.RowID > tpa2.RowID
			order by
				tpa2.RowID desc ), (select bp.Price from eeiuser.acctg_csm_base_prices bp where bp.BasePart = tpa1.BasePart) )	
from
	@tempPriceAdj tpa1


--- <Update>
set	@TableName = 'eeiuser.acctg_csm_price_adjustments'
update
	pa
set
	pa.PriceAdjustment = tpa.AdjustmentAmount
from
	eeiuser.acctg_csm_price_adjustments pa
	join @tempPriceAdj tpa
		on tpa.PriceAdjustmentRowID = pa.RowID

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount = 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Rows updated: %d.  Expected rows: >0.', 16, 1, @TableName, @ProcName, @RowCount)
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
