SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [EEIUser].[acctg_csm_sp_price_adjustments_insert_ECNs]
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
-- Insert new ECN parts into the price adjustments table from new job build
declare @temp table
(
	WOEngineerID int
)

insert into @temp
(
	WOEngineerID
)
select
	min(wo.WOEngineerID)
from
	eehsql1.eeh.dbo.ENG_WOEngineer wo
	join eeiuser.QT_QuoteLog ql 
		on wo.QuoteNumber = ql.QuoteNumber
		and wo.QuoteNumber is not null	
where
	ql.Awarded = 'Y'
	and exists (
			select
				1
			from
				eeiuser.acctg_csm_base_prices bp
			where
				bp.BasePart = left(wo.Part, 7) )
group by
	left(wo.Part, 7)


--- <Insert>
set	@TableName = 'eeiuser.acctg_csm_price_adjustments'
insert into eeiuser.acctg_csm_price_adjustments
(	BasePart 
,	Part
,	QuoteNumber
,	AdjustmentType
,	SellingPrice
,	PriceAdjustment
,	EffectiveDT
)
select
	left(wo.Part, 7) -- base part
,	wo.Part -- full part number
,	ql.QuoteNumber
,	'ECN'
,	ql.QuotePrice
,	null -- price adjustment will get calculated later in an update statement
,	woapqp.EEHShipDate
from
	eehsql1.eeh.dbo.ENG_WOEngineer wo
	join eehsql1.eeh.dbo.ENG_WOAPQP woapqp
		on wo.WOEngineerID = woapqp.WOEngineerID
	join eeiuser.QT_QuoteLog ql 
		on wo.QuoteNumber = ql.QuoteNumber
		and wo.QuoteNumber is not null	
where
	ql.Awarded = 'Y'
	and wo.WOEngineerID in (select WOEngineerID from @temp) 
	and not exists (
			select
				1
			from
				eeiuser.acctg_csm_price_adjustments pa
			where
				pa.Part = wo.Part ) -- new ECNs only

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
