SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[acctg_csm_sp_price_adjustments_insert_ECNs]
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
-- Insert ECN price changes into the price adjustments table
declare @temp table
(
	QuoteNumber varchar(50)
,	Part varchar(50)
)

insert into @temp
(
	QuoteNumber
,	Part
)
select
	*
from
	openquery(eehsql1, '
select
	rtrim(wo.QuoteNumber)
,	min(wo.Part)
from
	eeh.dbo.ENG_WOEngineer wo
where
	wo.QuoteNumber is not null
group by
	wo.QuoteNumber
	'
)


--- </Insert>
set @TableName = 'EEIUser.acctg_csm_price_adjustments'
insert into EEIUser.acctg_csm_price_adjustments
(
	BasePart
,	Part
,	QuoteNumber
,	AdjustmentType
,	SellingPrice
,	PriceAdjustment
,	EffectiveDT
)
select
	left(t.Part, 7)
,	t.Part
,	ql.QuoteNumber
,	ql.QuoteReason -- *** need to force data entry
,	coalesce(ql.QuotePrice, 0) -- SellingPrice
,	null -- price adjustment will be calculated later
,	null -- *** need to force data entry of selling price effective date
from
	@temp t
	join eeiuser.QT_QuoteLog ql
		on ql.QuoteNumber = t.QuoteNumber
where
	left(isnull(ql.Awarded, ''), 1) = 'Y'
	and ql.QuoteReason = 'New Print/ECN'
	and not exists (
			select
				*
			from
				eeiuser.acctg_csm_price_adjustments pa
			where
				pa.QuoteNumber = ql.QuoteNumber )

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
