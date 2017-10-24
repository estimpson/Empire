SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [EEIACCT].[usp_PivotCashFlow]
	@TransferPriceAdjustment numeric(20,6) = null
,	@TranDT datetime out
,	@Result integer out
as
set nocount on
set ansi_warnings off
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

if	@@TRANCOUNT > 0 begin
	rollback
end
begin tran @ProcName
save tran @ProcName
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
--- <Update rows="1">
set	@TableName = 'EEIACCT.TransferPriceAdjustments'

update
	tpa
set
	GenerationDT = getdate()
,	Adjustment = coalesce(@TransferPriceAdjustment, Adjustment)
from
	EEIACCT.TransferPriceAdjustments tpa
where
	GenerationWeekNo = datediff(week, '1999-01-01', getdate())

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount != 1 begin
	--- <Insert rows="1">
	insert
		EEIACCT.TransferPriceAdjustments
	(	GenerationDT
	,	Adjustment
	)
	select
		GenerationDT = getdate()
	,	Adjustment = coalesce
		(	@TransferPriceAdjustment
		,	(	select
					Adjustment
				from
					EEIACCT.TransferPriceAdjustments tpa
				where
					GenerationDT = (select max(GenerationDT) from EEIACCT.TransferPriceAdjustments)
			)
		)
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount
	
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount != 1 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end
	--- </Insert>
	
end
--- </Update>

create table #BeginBalance
(	Trans varchar(3)
,	Amount numeric(20,6)
)

insert
	#BeginBalance
(	Trans
,	Amount
)
select
	Trans = 'AR'
,	Amount = sum(gl.Amount)
from
	MONITOR.EEIACCT.GeneralLedger gl
where
	gl.LedgerAccount + gl.SourceDB in ('121011EEI', '121260EEI', '121060ES3')
	and gl.TransactionDate >= '2009-01-01'
	and	datediff(wk, '2009-01-01', gl.TransactionDate) = 0
	and gl.DocumentType = 'Journal Entry'
union all
select
	Trans = 'RM'
,	Amount = sum(gl.Amount)
from
	MONITOR.EEIACCT.GeneralLedger gl
where
	gl.LedgerAccount + gl.SourceDB in ('151011EEI', '151060EEI', '151012EEH')
	and gl.TransactionDate >= '2009-01-01'
	and	datediff(wk, '2009-01-01', gl.TransactionDate) = 0
	and gl.DocumentID3 like '[0-9][0-9][0-9][0-9]'
	and gl.Period = 0
union all
select
	Trans = 'FG'
,	Amount = sum(gl.Amount)
from
	MONITOR.EEIACCT.GeneralLedger gl
where
	gl.LedgerAccount + gl.SourceDB in ('153111EEI','153211EEI','153311EEI','154011EEI','154111EEI','154660EEI')
	and gl.TransactionDate >= '2009-01-01'
	and	datediff(wk, '2009-01-01', gl.TransactionDate) = 0
	and gl.DocumentID3 like '[0-9][0-9][0-9][0-9]'
	and gl.Period = 0
union all
select
	Trans = 'FGH'
,	Amount = sum(gl.Amount)
from
	MONITOR.EEIACCT.GeneralLedger gl
where
	gl.LedgerAccount + gl.SourceDB in ('153112EEH','153212EEH','153312EEH')
	and gl.TransactionDate >= '2009-01-01'
	and	datediff(wk, '2009-01-01', gl.TransactionDate) = 0
	and gl.DocumentID3 like '[0-9][0-9][0-9][0-9]'
	and gl.Period = 0

create table #GLTrans
(	Trans varchar(3)
,	WeekDT datetime
,	WeekNo as datediff(wk, '2009-01-01', WeekDT)
,	Forecast bit default(0)
,	TranDocType int
,	TranDocTypeDescription varchar(25)
,	Amount numeric(20,6)
)

--create index idx_GLTrans_1 on #GLTrans (Trans, TranDocType, WeekDT, Amount)

insert
	#GLTrans
(	Trans
,	WeekDT
,	Forecast
,	TranDocType
,	Amount
)
select
	Trans = 'AR'
,	WeekDT = dateadd(wk, datediff(wk, '1995-01-01', gl.TransactionDate), '1995-01-01')
,	ForeCast = 0
,	TranDocType =
	case
		when gl.DocumentType in ('AR INVOICE','AR CREDIT MEMO') then 2
		when gl.DocumentType = 'AR CHECK' then 3
		else 100
	end
,	Amount = sum(gl.Amount)
from
	MONITOR.EEIACCT.GeneralLedger gl
where
	gl.LedgerAccount + gl.SourceDB in ('121011EEI','121260EEI','121060ES3')
	and gl.TransactionDate >= '2009-01-01'
	and gl.DocumentType != 'Journal Entry'
group by
	dateadd(wk, datediff(wk, '1995-01-01', gl.TransactionDate), '1995-01-01')
,	case
		when gl.DocumentType in ('AR INVOICE','AR CREDIT MEMO') then 2
		when gl.DocumentType = 'AR CHECK' then 3
		else 100
	end
union all
select
	Trans = 'AR'
,	WeekDT = MONITOR.ft.fn_TruncDate('wk',date_due)
,	Forecast = 1
,	TranDocType = 2
,	Amount = sum(extended)
from
	MONITOR.dbo.vw_eei_sales_forecast
where
	date_due > getdate()-10
group by
	MONITOR.ft.fn_TruncDate('wk',date_due)
order by
	1
,	2

insert
	#GLTrans
(	Trans
,	WeekDT
,	Forecast
,	TranDocType
,	Amount
)
select
	Trans = 'RM'
,	WeekDT = dateadd(wk, datediff(wk, '1995-01-01', gl.TransactionDate), '1995-01-01')
,	ForeCast = 0
,	TranDocType =
	case
		when gl.DocumentID3 = 'R' then 2
		when gl.DocumentID3 = 'M' then 3
		else 4
	end
,	Amount = sum(gl.Amount)
from
	MONITOR.EEIACCT.GeneralLedger gl
where
	gl.LedgerAccount + gl.SourceDB in ('151011EEI','151060EEI','151012EEH')
	and gl.TransactionDate >= '2009-01-01'
	and
	(	gl.DocumentID3 not like '[0-9][0-9][0-9][0-9]'
		or period > 0
	)
group by
	dateadd(wk, datediff(wk, '1995-01-01', gl.TransactionDate), '1995-01-01')
,	case
		when gl.DocumentID3 = 'R' then 2
		when gl.DocumentID3 = 'M' then 3
		else 4
	end
union all
select
	Trans = 'RM'
,	WeekDT = dateadd(wk, datediff(wk, '1995-01-01', Sales.ShipDT), '1995-01-01')
,	ForeCast = case Sales.Type when 'Forecast' then 1 else 0 end
,	TranDocType = 3
,	Amount = 0.45 * sum(Sales.Amount)
from
	(	select
			Type = 'Forecast'
		,   Customer = left(BasePart, 3)
		,   Part = basepart
		,   ShipDT = case when date_due - 7 < getdate() then getdate() else date_due - 7 end
		,   Qty = qty_projected
		,   Amount = eeiMaterialCumExt
		,   Company = Company
		from
			vw_eei_sales_forecast
		where
			basepart not like 'J[1,3]%'
			and datediff(week, getdate(), date_due) > -1
		union all
		select
			Type = 'History'
		,   Customer = left(BasePart, 3)
		,   Part = basepart
		,   ShipDT = date_shipped - 7
		,   Qty = qty_shipped
		,   Amount = eeiMaterialCumExt
		,   Company = Company
		from
			vw_eei_sales_history
		where
			basepart not like 'J[1,3]%'
			and datediff(week, date_shipped - 7, getdate()) = 0
	) Sales
group by
	Type
,	dateadd(wk, datediff(wk, '1995-01-01', Sales.ShipDT), '1995-01-01')
order by
	2

insert
	#GLTrans
(	Trans
,	WeekDT
,	Forecast
,	TranDocType
,	Amount
)
select
	Trans = 'FG'
,	WeekDT = dateadd(wk, datediff(wk, '1995-01-01', gl.TransactionDate), '1995-01-01')
,	ForeCast = 0
,	TranDocType =
	case
		when gl.DocumentID3 = 'R' then 3
		when gl.DocumentID3 = 'S' then 4
		else 5
	end
,	Amount = sum(gl.Amount)
from
	MONITOR.EEIACCT.GeneralLedger gl
where
	gl.LedgerAccount + gl.SourceDB in ('153111EEI','153211EEI','153311EEI','154011EEI','154111EEI','154660EEI')
	and gl.TransactionDate >= '2009-01-01'
	and
	(	gl.DocumentID3 not like '[0-9][0-9][0-9][0-9]'
		or period > 0
	)
group by
	dateadd(wk, datediff(wk, '1995-01-01', gl.TransactionDate), '1995-01-01')
,	case
		when gl.DocumentID3 = 'R' then 3
		when gl.DocumentID3 = 'S' then 4
		else 5
	end
union all
select
	Trans = 'FG'
,	WeekDT = dateadd(wk, datediff(wk, '1995-01-01', Sales.ShipDT), '1995-01-01')
,	ForeCast = case Sales.Type when 'Forecast' then 1 else 0 end
,	TranDocType = 4
,	Amount = sum(Sales.Amount)
from
	(	select
			Type = 'Forecast'
		,   Customer = left(BasePart, 3)
		,   Part = basepart
		,   ShipDT = case when date_due < getdate() then getdate() else date_due end
		,   Qty = qty_projected
		,   Amount = eeiMaterialCumExt
		,   Company = Company
		from
			vw_eei_sales_forecast
		where
			basepart not like 'J[1,3]%'
			and datediff(week, getdate(), date_due) > -2
		union all
		select
			Type = 'History'
		,   Customer = left(BasePart, 3)
		,   Part = basepart
		,   ShipDT = date_shipped
		,   Qty = qty_shipped
		,   Amount = eeiMaterialCumExt
		,   Company = Company
		from
			vw_eei_sales_history
		where
			basepart not like 'J[1,3]%'
			and datediff(week, date_shipped, getdate()) = 0
	) Sales
group by
	Type
,	dateadd(wk, datediff(wk, '1995-01-01', Sales.ShipDT), '1995-01-01')
union all
select
	Trans = 'FG'
,	WeekDT = dateadd(wk, datediff(wk, '1995-01-01', gl.TransactionDate), '1995-01-01')
,	ForeCast = 0
,	TranDocType = 2
,	Amount = sum(gl.Amount)
from
	MONITOR.EEIACCT.GeneralLedger gl
where
	gl.LedgerAccount + gl.SourceDB in ('153111EEI','153211EEI','153311EEI','154011EEI','154111EEI','154660EEI')
	and gl.TransactionDate >= '2009-01-01'
	and
	(	gl.DocumentID3 not like '[0-9][0-9][0-9][0-9]'
		or period > 0
	)
	and gl.DocumentID3 = 'R'
group by
	dateadd(wk, datediff(wk, '1995-01-01', gl.TransactionDate), '1995-01-01')
union all
select
	Trans = 'FG'
,	WeekDT = dateadd(wk, datediff(wk, '1995-01-01', gl.TransactionDate), '1995-01-01')
,	ForeCast = 0
,	TranDocType = 8
,	Amount = sum(gl.Amount)
from
	MONITOR.EEIACCT.GeneralLedger gl
where
	gl.LedgerAccount + gl.SourceDB in ('153112EEH','153212EEH','153312EEH')
	and gl.TransactionDate >= '2009-01-01'
	and
	(	gl.DocumentID3 not like '[0-9][0-9][0-9][0-9]'
		or period > 0
	)
group by
	dateadd(wk, datediff(wk, '1995-01-01', gl.TransactionDate), '1995-01-01')
union all
select
	Trans = 'FG'
,	WeekDT = tpa.GenerationDT
,	Forecast = 0
,	TranDocType = 7
,	Amount = tpa.Adjustment
from
	EEIACCT.TransferPriceAdjustments tpa
union all
select
	Trans = 'FG'
,	WeekDT = dateadd(week, futureRows.RowNo, '2009-01-01')
,	Forecast = 1
,	TranDocType = 7
,	Amount = tpa.Adjustment
from
	EEIACCT.TransferPriceAdjustments tpa
	join EEIACCT.f_Rows (125) futureRows on
		futureRows.RowNo > datediff(week, '2009-01-01', getdate())
where
	tpa.GenerationDT = (select max(GenerationDT) from EEIACCT.TransferPriceAdjustments)
order by
	2

declare
	@Weeks int

set	@Weeks = datediff(week, '2009-01-01', getdate()) + 18

declare
	@PivotSyntax nvarchar(4000)

set	@PivotSyntax = N'
create table EEIACCT.R
(	Forecast varchar(3) not null
,	RowType tinyint not null
,	Status varchar(6) default('''') not null
,	[Week of] varchar(100) not null
,	[Forecast Version] datetime not null
,	[Beginning Balance] n null
' + EEIACCT.f_WeekColumnDeclaration (@Weeks) + N'
)'

print @PivotSyntax

exec sp_executesql
	@PivotSyntax

/*	Accounts receivable rows... */
set	@PivotSyntax = N'
insert
	EEIACCT.R
(
	Forecast
,	RowType
,	Status
,	[Week of]
,	[Forecast Version]
,	[Beginning Balance]
)
select
	Forecast = max(glt.Trans)
,	RowType = 1
,	Status = ''''
,	[Week of] = ''Beginning Accounts Receivable ('' + convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110) + '' Forecast)''
,	[Forecast Version] = convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110)
,	[Beginning Balance] = max(bb.Amount)
from
	#GLTrans glt
	join #BeginBalance bb on
		bb.Trans = glt.Trans
where
	glt.Trans = ''AR''
union all
select
	Forecast = max(glt.Trans)
,	RowType = 2
,	Status = ''''
,	[Week of] = ''+ Sales  ('' + convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110) + '' PSF @ sp $)''
,	[Forecast Version] = convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110)
,	[Beginning Balance] = null
from
	#GLTrans glt
where
	glt.Trans = ''AR''
	and
		glt.TranDocType = 2
union all
select
	Forecast = max(glt.Trans)
,	RowType = 3
,	Status = ''''
,	[Week of] = ''- Receipts  ('' + convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110) + '' ERF @ sp $)''
,	[Forecast Version] = convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110)
,	[Beginning Balance] = null
from
	#GLTrans glt
where
	glt.Trans = ''AR''
	and
		glt.TranDocType = 3
union all
select
	Forecast = max(glt.Trans)
,	RowType = 4
,	Status = ''''
,	[Week of] = ''Ending Accounts Receivable ('' + convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110) + '' Forecast)''
,	[Forecast Version] = convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110)
,	[Beginning Balance] = max(bb.Amount)
from
	#GLTrans glt
	join #BeginBalance bb on
		bb.Trans = glt.Trans
where
	glt.Trans = ''AR''
order by
	1, 2
'

print @PivotSyntax

exec sp_executesql
	@PivotSyntax

/*	Accounts receivable rows... */
set	@PivotSyntax = N'
insert
	EEIACCT.R
(
	Forecast
,	RowType
,	Status
,	[Week of]
,	[Forecast Version]
,	[Beginning Balance]
)
select
	Forecast = max(glt.Trans)
,	RowType = 1
,	Status = ''''
,	[Week of] = ''Beginning Raw Material ('' + convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110) + '' Forecast)''
,	[Forecast Version] = convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110)
,	[Beginning Balance] = max(bb.Amount)
from
	#GLTrans glt
	join #BeginBalance bb on
		bb.Trans = glt.Trans
where
	glt.Trans = ''RM''
union all
select
	Forecast = max(glt.Trans)
,	RowType = 2
,	Status = ''''
,	[Week of] = '' + Receipts  ('' + convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110) + '' POs to Vendors @ mc $)''
,	[Forecast Version] = convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110)
,	[Beginning Balance] = null
from
	#GLTrans glt
where
	Trans = ''RM''
	and
		TranDocType = 2
union all
select
	Forecast = max(glt.Trans)
,	RowType = 3
,	Status = ''''
,	[Week of] = ''- Material Issues  ('' + convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110) + ''  [Calculated Field @ mc $ {EEH Sos /.83 x.45 offset by 1 wk}])''
,	[Forecast Version] = convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110)
,	[Beginning Balance] = null
from
	#GLTrans glt
where
	Trans = ''RM''
	and
		TranDocType = 3
union all
select
	Forecast = max(glt.Trans)
,	RowType = 4
,	Status = ''''
,	[Week of] = '' +/- Other activity (@ mc $)''
,	[Forecast Version] = convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110)
,	[Beginning Balance] = null
from
	#GLTrans glt
where
	Trans = ''RM''
	and
		TranDocType = 4
union all
select
	Forecast = max(glt.Trans)
,	RowType = 5
,	Status = ''''
,	[Week of] = ''Ending Raw Material ('' + convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110) + '' Forecast)''
,	[Forecast Version] = convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110)
,	[Beginning Balance] = max(bb.Amount)
from
	#GLTrans glt
	join #BeginBalance bb on
		bb.Trans = glt.Trans
where
	glt.Trans = ''RM''
order by
	1, 2
'

print @PivotSyntax

exec sp_executesql
	@PivotSyntax

/*	Finished goods rows [1-6]... */
set	@PivotSyntax = N'
insert
	EEIACCT.R
(
	Forecast
,	RowType
,	Status
,	[Week of]
,	[Forecast Version]
,	[Beginning Balance]
)
select
	Forecast = max(glt.Trans)
,	RowType = 1
,	Status = ''''
,	[Week of] = ''Beginning EEI Finished Goods ('' + convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110) + '' Forecast)''
,	[Forecast Version] = convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110)
,	[Beginning Balance] = max(bb.Amount)
from
	#GLTrans glt
	join #BeginBalance bb on
		bb.Trans = glt.Trans
where
	glt.Trans = ''FG''
union all
select
	Forecast = max(glt.Trans)
,	RowType = 2
,	Status = ''''
,	[Week of] = ''+ Receipts  ('' + convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110) + '' EEI SOs @ xfr $)''
,	[Forecast Version] = convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110)
,	[Beginning Balance] = null
from
	#GLTrans glt
where
	glt.Trans = ''FG''
	and
		TranDocType = 2
union all
select
	Forecast = max(glt.Trans)
,	RowType = 3
,	Status = ''''
,	[Week of] = ''+ Receipts  ('' + convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110) + '' EEH SOs @ xfr $)''
,	[Forecast Version] = convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110)
,	[Beginning Balance] = null
from
	#GLTrans glt
where
	glt.Trans = ''FG''
	and
		TranDocType = 3
union all
select
	Forecast = max(glt.Trans)
,	RowType = 4
,	Status = ''''
,	[Week of] = ''- Sales   ('' + convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110) + '' PSF @ xfr $)''
,	[Forecast Version] = convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110)
,	[Beginning Balance] = null
from
	#GLTrans glt
where
	glt.Trans = ''FG''
	and
		TranDocType = 4
union all
select
	Forecast = max(glt.Trans)
,	RowType = 5
,	Status = ''''
,	[Week of] = ''+/- Other activity (@ xfr $)''
,	[Forecast Version] = convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110)
,	[Beginning Balance] = null
from
	#GLTrans glt
where
	glt.Trans = ''FG''
union all
select
	Forecast = max(glt.Trans)
,	RowType = 6
,	Status = ''''
,	[Week of] = ''Ending EEI Finished Goods ('' + convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110) + '' Forecast)''
,	[Forecast Version] = convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110)
,	[Beginning Balance] = max(bb.Amount)
from
	#GLTrans glt
	join #BeginBalance bb on
		bb.Trans = glt.Trans
where
	glt.Trans = ''FG''
'

print @PivotSyntax

exec sp_executesql
	@PivotSyntax

/*	Finished goods rows [7-9]... */
set	@PivotSyntax = N'
insert
	EEIACCT.R
(
	Forecast
,	RowType
,	Status
,	[Week of]
,	[Forecast Version]
,	[Beginning Balance]
)
select
	Forecast = max(glt.Trans)
,	RowType = 7
,	Status = ''''
,	[Week of] = ''- built-in profit (transfer price adjustment)''
,	[Forecast Version] = convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110)
,	[Beginning Balance] = null
from
	#GLTrans glt
where
	glt.Trans = ''FG''
union all
select
	Forecast = max(glt.Trans)
,	RowType = 8
,	Status = ''''
,	[Week of] = ''+ EEH FG on Hand ('' + convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110) + '' Forecast)''
,	[Forecast Version] = convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110)
,	[Beginning Balance] = max(bb.Amount)
from
	#GLTrans glt
	join #BeginBalance bb on
		bb.Trans = ''FGH''
where
	glt.Trans = ''FG''
union all
select
	Forecast = max(glt.Trans)
,	RowType = 9
,	Status = ''''
,	[Week of] = ''Ending Finished Goods ('' + convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110) + '' Forecast)''
,	[Forecast Version] = convert(char(10), MONITOR.ft.fn_TruncDate(''wk'',getdate()), 110)
,	[Beginning Balance] = max(bb1.Amount) + max(bb2.Amount)
from
	#GLTrans glt
	join #BeginBalance bb1 on
		bb1.Trans = ''FG''
	join #BeginBalance bb2 on
		bb2.Trans = ''FGH''
where
	glt.Trans = ''FG''
order by
	1, 2
'

print @PivotSyntax

exec sp_executesql
	@PivotSyntax

declare
	@Week int

set	@Week = 0

while
	@Week <= @Weeks begin

	set	@PivotSyntax = N'
update
	EEIACCT.R
set
	[' + EEIACCT.f_WeekName(@Week) + '] = coalesce ([Beginning Balance], 0) + coalesce(
	(
		select
			sum (case when WeekNo <= ' + convert(varchar, @Week - 1) + ' then Amount else 0 end)
		from
			#GLTrans
		where
			Trans = r.Forecast
	), 0)
from
	EEIACCT.R r
where
	Forecast = ''AR''
	and RowType = 1

update
	EEIACCT.R
set
	[' + EEIACCT.f_WeekName(@Week) + '] = coalesce(
	(
		select
			sum (case when WeekNo = ' + convert(varchar, @Week) + ' then Amount else 0 end)
		from
			#GLTrans
		where
			Trans = r.Forecast
			and
				TranDocType = 2
	), 0)
from
	EEIACCT.R r
where
	Forecast = ''AR''
	and RowType = 2

update
	EEIACCT.R
set
	[' + EEIACCT.f_WeekName(@Week) + '] = coalesce(
	(
		select
			sum (case when WeekNo = ' + convert(varchar, @Week) + ' then Amount else 0 end)
		from
			#GLTrans
		where
			Trans = r.Forecast
			and
				TranDocType = 3
	), 0)
from
	EEIACCT.R r
where
	Forecast = ''AR''
	and RowType = 3

update
	EEIACCT.R
set
	[' + EEIACCT.f_WeekName(@Week) + '] = coalesce ([Beginning Balance], 0) + coalesce(
	(
		select
			sum (case when WeekNo <= ' + convert(varchar, @Week) + ' then Amount else 0 end)
		from
			#GLTrans
		where
			Trans = r.Forecast
	), 0)
from
	EEIACCT.R r
where
	Forecast = ''AR''
	and RowType = 4
'

	--print @PivotSyntax

	exec sp_executesql
		@PivotSyntax

	/*	Accounts receivable rows... */
	set	@PivotSyntax = N'
update
	EEIACCT.R
set
	[' + EEIACCT.f_WeekName(@Week) + '] = coalesce ([Beginning Balance], 0) + coalesce(
	(
		select
			sum (case when WeekNo <= ' + convert(varchar, @Week - 1) + ' then Amount else 0 end)
		from
			#GLTrans
		where
			Trans = r.Forecast
	), 0)
from
	EEIACCT.R r
where
	Forecast = ''RM''
	and RowType = 1

update
	EEIACCT.R
set
	[' + EEIACCT.f_WeekName(@Week) + '] = coalesce(
	(
		select
			sum (case when WeekNo = ' + convert(varchar, @Week) + ' then Amount else 0 end)
		from
			#GLTrans
		where
			Trans = r.Forecast
			and
				TranDocType = 2
	), 0)
from
	EEIACCT.R r
where
	Forecast = ''RM''
	and RowType = 2

update
	EEIACCT.R
set
	[' + EEIACCT.f_WeekName(@Week) + '] = coalesce(
	(
		select
			sum (case when WeekNo = ' + convert(varchar, @Week) + ' then Amount else 0 end)
		from
			#GLTrans
		where
			Trans = r.Forecast
			and
				TranDocType = 3
	), 0)
from
	EEIACCT.R r
where
	Forecast = ''RM''
	and RowType = 3

update
	EEIACCT.R
set
	[' + EEIACCT.f_WeekName(@Week) + '] = coalesce(
	(
		select
			sum (case when WeekNo = ' + convert(varchar, @Week) + ' then Amount else 0 end)
		from
			#GLTrans
		where
			Trans = r.Forecast
			and
				TranDocType = 4
	), 0)
from
	EEIACCT.R r
where
	Forecast = ''RM''
	and RowType = 4

update
	EEIACCT.R
set
	[' + EEIACCT.f_WeekName(@Week) + '] = coalesce ([Beginning Balance], 0) + coalesce(
	(
		select
			sum (case when WeekNo <= ' + convert(varchar, @Week) + ' then Amount else 0 end)
		from
			#GLTrans
		where
			Trans = r.Forecast
	), 0)
from
	EEIACCT.R r
where
	Forecast = ''RM''
	and RowType = 5
'

	--print @PivotSyntax

	exec sp_executesql
		@PivotSyntax

	/*	Finished good rows [1-6]... */
	set	@PivotSyntax = N'
update
	EEIACCT.R
set
	[' + EEIACCT.f_WeekName(@Week) + '] = coalesce ([Beginning Balance], 0) + coalesce(
	(
		select
			sum (case when WeekNo <= ' + convert(varchar, @Week - 1) + ' then Amount else 0 end)
		from
			#GLTrans
		where
			Trans = r.Forecast
			and
				TranDocType in (3, 4, 5)
	), 0)
from
	EEIACCT.R r
where
	Forecast = ''FG''
	and RowType = 1

update
	EEIACCT.R
set
	[' + EEIACCT.f_WeekName(@Week) + '] = coalesce(
	(
		select
			sum (case when WeekNo = ' + convert(varchar, @Week) + ' then Amount else 0 end)
		from
			#GLTrans
		where
			Trans = r.Forecast
			and
				TranDocType = 2
	), 0)
from
	EEIACCT.R r
where
	Forecast = ''FG''
	and RowType = 2

update
	EEIACCT.R
set
	[' + EEIACCT.f_WeekName(@Week) + '] = coalesce(
	(
		select
			sum (case when WeekNo = ' + convert(varchar, @Week) + ' then Amount else 0 end)
		from
			#GLTrans
		where
			Trans = r.Forecast
			and
				TranDocType = 3
	), 0)
from
	EEIACCT.R r
where
	Forecast = ''FG''
	and RowType = 3

update
	EEIACCT.R
set
	[' + EEIACCT.f_WeekName(@Week) + '] = coalesce(
	(
		select
			sum (case when WeekNo = ' + convert(varchar, @Week) + ' then Amount else 0 end)
		from
			#GLTrans
		where
			Trans = r.Forecast
			and
				TranDocType = 4
	), 0)
from
	EEIACCT.R r
where
	Forecast = ''FG''
	and RowType = 4

update
	EEIACCT.R
set
	[' + EEIACCT.f_WeekName(@Week) + '] = coalesce(
	(
		select
			sum (case when WeekNo = ' + convert(varchar, @Week) + ' then Amount else 0 end)
		from
			#GLTrans
		where
			Trans = r.Forecast
			and
				TranDocType = 5
	), 0)
from
	EEIACCT.R r
where
	Forecast = ''FG''
	and RowType = 5

update
	EEIACCT.R
set
	[' + EEIACCT.f_WeekName(@Week) + '] = coalesce ([Beginning Balance], 0) + coalesce(
	(
		select
			sum (case when WeekNo <= ' + convert(varchar, @Week) + ' then Amount else 0 end)
		from
			#GLTrans
		where
			Trans = r.Forecast
			and
				TranDocType in (3, 4, 5)
	), 0)
from
	EEIACCT.R r
where
	Forecast = ''FG''
	and RowType = 6
'

	--print @PivotSyntax

	exec sp_executesql
		@PivotSyntax

	/*	Finished good rows [7-9]... */
	set	@PivotSyntax = N'
update
	EEIACCT.R
set
	[' + EEIACCT.f_WeekName(@Week) + '] = coalesce ([Beginning Balance], 0) + coalesce(
	(
		select
			sum (case when WeekNo = ' + convert(varchar, @Week) + ' then Amount else 0 end)
		from
			#GLTrans
		where
			Trans = r.Forecast
			and
				TranDocType = 7
	), 0)
from
	EEIACCT.R r
where
	Forecast = ''FG''
	and RowType = 7

update
	EEIACCT.R
set
	[' + EEIACCT.f_WeekName(@Week) + '] = coalesce ([Beginning Balance], 0) + coalesce(
	(
		select
			sum (case when WeekNo <= ' + convert(varchar, @Week) + ' then Amount else 0 end)
		from
			#GLTrans
		where
			Trans = r.Forecast
			and
				TranDocType = 8
	), 0)
from
	EEIACCT.R r
where
	Forecast = ''FG''
	and RowType = 8

update
	EEIACCT.R
set
	[' + EEIACCT.f_WeekName(@Week) + '] = coalesce ([Beginning Balance], 0) + coalesce(
	(
		select
			sum (case when WeekNo <= ' + convert(varchar, @Week) + ' then Amount else 0 end)
		from
			#GLTrans
		where
			Trans = r.Forecast
			and
				TranDocType in (3, 4, 5)
	), 0) + coalesce(
	(
		select
			sum (case when WeekNo = ' + convert(varchar, @Week) + ' then Amount else 0 end)
		from
			#GLTrans
		where
			Trans = r.Forecast
			and
				TranDocType = 7
	), 0) + coalesce(
	(
		select
			sum (case when WeekNo <= ' + convert(varchar, @Week) + ' then Amount else 0 end)
		from
			#GLTrans
		where
			Trans = r.Forecast
			and
				TranDocType = 8
	), 0)
from
	EEIACCT.R r
where
	Forecast = ''FG''
	and RowType = 9
'
	--print @PivotSyntax

	exec sp_executesql
		@PivotSyntax
	
	set	@Week = @Week + 1
end

select
	*
from
	EEIACCT.R
order by
	case Forecast when 'AR' then 0 when 'RM' then 1 when 'FG' then 2 end
,	2

drop table
	EEIACCT.R
--- </Body>

---	<Return>
rollback
set	@Result = 0
return
	@Result
--- </Return>

/*
Example:
Initial queries
{

}

Test syntax
{

declare
	@TransferPriceAdjustment numeric(20,6)

set	@TransferPriceAdjustment = null

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = EEIACCT.usp_PivotCashFlow
	@TransferPriceAdjustment = @TransferPriceAdjustment
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

if	@@trancount > 0 begin
	rollback
end
go

}

Results {
}
*/
GO
