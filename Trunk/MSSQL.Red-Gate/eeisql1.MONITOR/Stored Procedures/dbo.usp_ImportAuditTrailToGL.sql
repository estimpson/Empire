SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--begin transaction

CREATE procedure [dbo].[usp_ImportAuditTrailToGL]
	@ImportDate datetime = null
,	@Ledger varchar(40) = 'EMPIRE' -- or 'HONDURAS'
,	@GLEntry varchar(25) = null --out
,	@TranDT datetime = null --out
,	@Result integer = null --out
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

--- <Tran Required=No AutoCreate=No TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
set	@ImportDate = coalesce(@ImportDate, FT.fn_TruncDate('day', getdate()) - 1)
set @GLEntry = 'MINV' + convert(char(8), @ImportDate, 112)

declare
	@fiscalYear varchar(5) = convert(varchar, datepart(year, @ImportDate))
,	@period int = datepart(month, @ImportDate)
,	@documentType char(7) = 'MON INV'
,	@User varchar(25) = 'dba'
,	@application varchar(25) = 'MONITOR'

--select
--	@ImportDate
--,	@fiscalYear
--,	@period
--,	@glEntry
--,	@ledger

declare
	@JECommitted varchar(3)

select
	@JECommitted = je_committed
from
	journal_entries
where
	fiscal_year = @fiscalYear
	and ledger = @ledger
	and gl_entry = @glEntry

if	@JECommitted = 'Y' begin
	set	@Result = 999999
	RAISERROR ('Error importing GL.  Journal entry for fiscal year %s, ledger %s, and GL entry %s is already closed.', 16, 1, @fiscalYear, @ledger, @glEntry)
	return
end

/*???*/
--select
--	count(*)
--from
--	calendar_periods
--where
--	calendar_periods.fiscal_year = @fiscalYear

declare
	@currency varchar(25)

select
	@currency = ledger_definition.currency
from
	ledger_definition
where
	ledger_definition.fiscal_year = @fiscalYear
	and ledger_definition.ledger = @ledger

declare
	@calendar varchar(40)
,	@postingConsolidating char(1)
,	@ledgerCurrency varchar(25)
,	@plLedgerAccount varchar(50)

select
	@calendar = ledger_definition.calendar
,	@postingConsolidating = ledger_definition.posting_consolidating
,	@ledgerCurrency = ledger_definition.currency
,	@plLedgerAccount = ledger_definition.profit_loss_ledger_account
from
	ledger_definition
where
	ledger_definition.fiscal_year = @fiscalYear
	and ledger_definition.ledger = @ledger

declare
	@periodStartDT datetime
,	@periodEndDT datetime

--select
--	period_start_date
--,	period_end_date
--from
--	calendar_periods
--where
--	calendar_periods.fiscal_year = @fiscalYear
--	and calendar_periods.calendar = @calendar
--	and calendar_periods.period = @period

--select
--	ap_closed
--,	ar_closed
--,	ba_closed
--,	fa_closed
--,	gl_closed
--,	iv_closed
--,	py_closed
--,	po_closed
--,	so_closed
--,	cv_closed
--,	co_closed
--from
--	ledger_periods
--where
--	ledger_periods.fiscal_year = @fiscalYear
--	and ledger_periods.ledger = @ledger
--	and ledger_periods.period = @period

declare
	@balanceName varchar(25) = 'ACTUAL'

--select
--	count(*)
--from
--	dbo.balance_definition bd
--where
--	bd.fiscal_year = @fiscalYear
--	and bd.balance_name = @balanceName

--select
--	exchange_rates.exchange_rate
--from
--	exchange_rates
--where
--	exchange_rates.currency = @currency
--	and exchange_rates.effective_on_date <= @ImportDate
--	and exchange_rates.effective_off_date >= @ImportDate

declare
	@balancingRequired char(1)

select
	@balancingRequired = bd.balancing_required
from
	dbo.balance_definition bd
where
	bd.fiscal_year = @fiscalYear
	and bd.balance_name = @balanceName

declare
	@at table
(	serial int
,	date_stamp datetime
,	type varchar(2)
,	part varchar(25)
,	remarks varchar(10)
,	plant varchar(10)
,	cost numeric(20,6)
,	to_loc varchar(10)
,	po_number varchar(30)
,	price numeric(20,6)
,	std_quantity numeric(20,6)
,	quantity numeric(20,6)
,	parent_serial int
,	id int not null IDENTITY(1, 1) primary key
)
insert
	@at
select
	at.serial
,	at.date_stamp
,	at.type
,	at.part
,	isnull(at.remarks, type) remarks
,	isnull(at.plant, '') plant
,	isnull(at.cost, 0) cost
,	isnull(at.to_loc, '') to_loc
,	isnull(at.po_number, '') po_number
,	isnull(at.price, 0) price
,	isnull(at.std_quantity, at.quantity) std_quantity
,	isnull(at.quantity, 0) quantity
,	at.parent_serial
from
	dbo.audit_trail at
where
	datediff(day, at.date_stamp, @ImportDate) = 0
	and (	at.posted is null
			or at.posted <> 'Y'
		)
order by
	at.part asc
,	at.type asc
,	at.serial asc
,	at.date_stamp asc

if	object_id('tempdb.dbo.Insert_at') is not null begin
	drop table tempdb.dbo.Insert_at
end

select
	*
into
	tempdb.dbo.Insert_at
from
	@at

declare
	@atMia table
(	serial int
,	date_stamp datetime
,	type varchar(2)
,	part varchar(25)
,	description varchar(100)
,	remarks varchar(10)
,	plant varchar(10)
,	cost numeric(20,6)
,	to_loc varchar(10)
,	po_number varchar(30)
,	price numeric(20,6)
,	std_quantity numeric(20,6)
,	quantity numeric(20,6)
,	parent_serial int
,	product_line_gl_segment varchar(50)
,	plant_gl_segment varchar(50)
,	empower_interface char(1)
,	material_debit varchar(50)
,	material_credit varchar(50)
,	material_variance varchar(50)
,	labor_debit varchar(50)
,	labor_credit varchar(50)
,	burden_debit varchar(50)
,	burden_credit varchar(50)
,	other_debit varchar(50)
,	other_credit varchar(50)
,	cost_cum numeric(20,6)
,	material_cum numeric(20,6)
,	labor_cum numeric(20,6)
,	burden_cum numeric(20,6)
,	other_cum numeric(20,6)
,	id int not null IDENTITY(1, 1) primary key
)

insert
	@atMia 
select
	a.serial
,	a.date_stamp
,	a.type
,	a.part
,	p.name
,	a.remarks
,	a.plant
,	a.cost
,	a.to_loc
,	a.po_number
,	a.price
,	a.std_quantity
,	a.quantity
,	a.parent_serial
,	product_line_gl_segment = pl.gl_segment
,	plant_gl_segment = d.gl_segment
,	mia.empower_interface
,	mia.material_debit
,	mia.material_credit
,	mia.material_variance
,	mia.labor_debit
,	mia.labor_credit
,	mia.burden_debit
,	mia.burden_credit
,	mia.other_debit
,	mia.other_credit
,	cost_cum = coalesce(ps.cost_cum, 0)
,	material_cum = coalesce(ps.material_cum, 0)
,	labor_cum = coalesce(ps.labor_cum, 0)
,	burden_cum = coalesce(ps.burden_cum, 0)
,	other_cum = coalesce(ps.other_cum, 0)
from
	@at a
		join dbo.part p
			join dbo.product_line pl
				on pl.id = p.product_line
			on p.part = a.part
		join dbo.part_standard ps
			on ps.part = a.part
		join dbo.monitor_inventory_accounts mia
			on mia.fiscal_year = @fiscalYear
			and mia.ledger = @ledger
			and mia.audit_trail_type = a.type
			and mia.part_type = p.type
			and mia.product_line = p.product_line
		join dbo.destination d
			on d.plant = a.plant
			and d.destination = a.plant
order by
	a.id

if	object_id('tempdb.dbo.Insert_atMia') is not null begin
	drop table tempdb.dbo.Insert_atMia
end

select
	*
into
	tempdb.dbo.Insert_atMia
from
	@atMia

declare atMia cursor local for
select
	am.id
from
	@atMia am
where
	am.empower_interface = 'Y'
order by
	am.id

open
	atMia

if	object_id('tempdb.dbo.Insert_gl_cost_transactions') is not null begin
	drop table tempdb.dbo.Insert_gl_cost_transactions
end

if	object_id('tempdb.dbo.Delete_gl_cost_transactions') is not null begin
	drop table tempdb.dbo.Delete_gl_cost_transactions
end

while
	1 = 1 begin
	declare
		@amID int
	
	fetch
		atMia
	into
		@amID
	
	if	@@FETCH_STATUS != 0 begin
		break
	end 

	--select
	--	*
	--from
	--	@atMia am
	--where
	--	am.id = @amID

	begin transaction TransactionPosting

	declare
		@glAccounts table
	(	LedgerAccount varchar(50)
	,	DocumentLine int
	,	ActiveInactive char(1) -- must be 'A'
	,	ExhangeGainLedgerAccount varchar(50)
	,	ExhangeLossLedgerAccount varchar(50)
	,	AccountDescription varchar(50)
	,	BalanceProfit char(1)
	,	DebitCreditStat char(1)
	,	PostingReporting char(1)
	,	CostAccountRequired char(1)
	)

	delete
		@glAccounts

	insert
		@glAccounts
	select
		la.ledger_account
	,	DocumentLine = row_number() over (order by miaAccount.GLLine)
	,	la.active_inactive
	,	la.exchange_gain_ledger_account
	,	la.exchange_loss_ledger_account
	,	coa.account_description
	,	coa.balance_profit
	,	coa.debit_credit_stat
	,	la.posting_reporting
	,	la.cost_account_required
	from
		dbo.ledger_accounts la
		join dbo.chart_of_accounts coa
			on coa.fiscal_year = la.fiscal_year
			and coa.coa = la.coa
			and coa.account = la.account
		join
			(	select
					Account = am.material_debit + am.product_line_gl_segment
				,	GLLine = 1
				from
					@atMia am
				where
					am.id = @amID
					and am.material_debit is not null
					and am.product_line_gl_segment is not null
				union all
				select
					am.material_credit + am.product_line_gl_segment
				,	GLLine = 2
				from
					@atMia am
				where
					am.id = @amID
					and am.material_credit is not null
					and am.product_line_gl_segment is not null
				union all
				select
					am.labor_debit + am.product_line_gl_segment
				,	GLLine = 3
				from
					@atMia am
				where
					am.id = @amID
					and am.labor_debit is not null
					and am.product_line_gl_segment is not null
				union all
				select
					am.labor_credit + am.product_line_gl_segment
				,	GLLine = 4
				from
					@atMia am
				where
					am.id = @amID
					and am.labor_credit is not null
					and am.product_line_gl_segment is not null
				union all
				select
					am.burden_debit + am.product_line_gl_segment
				,	GLLine = 5
				from
					@atMia am
				where
					am.id = @amID
					and am.labor_debit is not null
					and am.product_line_gl_segment is not null
				union all
				select
					am.burden_credit + am.product_line_gl_segment
				,	GLLine = 6
				from
					@atMia am
				where
					am.id = @amID
					and am.labor_credit is not null
					and am.product_line_gl_segment is not null
				union all
				select
					am.other_debit + am.product_line_gl_segment
				,	GLLine = 7
				from
					@atMia am
				where
					am.id = @amID
					and am.labor_debit is not null
					and am.product_line_gl_segment is not null
				union all
				select
					am.other_credit + am.product_line_gl_segment
				,	GLLine = 8
				from
					@atMia am
				where
					am.id = @amID
					and am.labor_credit is not null
					and am.product_line_gl_segment is not null
			) miaAccount
		on miaAccount.Account = la.ledger_account
	where
		la.fiscal_year = @fiscalYear
		and la.ledger = @ledger

	/*	Delete previously posted GL transaction. */
			--	sum(gct.amount) * -1
			--,	max(period)
			--,	max(gct.fiscal_year)
			--,	max(gct.ledger)
			--,	count(*)
	if	exists
			(	select
					*
				from
					@atMia am
					join dbo.gl_cost_transactions gct
						on document_type = @documentType
						and document_id1 = convert(varchar, am.serial)
						and document_id2 = convert(char(10), am.date_stamp, 101) + ' ' + convert(char(12), am.date_stamp, 114) --'07/19/2013 10:36:41.860'
						and document_id3 = am.type
				where
					am.id = @amID
					--and (	gct.update_balances = 'Y'
					--		or gct.update_balances is null
					--	)
			) begin

		if	object_id('tempdb.dbo.Delete_gl_cost_transactions') is null begin
			select 
				*
			into
				tempdb.dbo.Delete_gl_cost_transactions
			from
				dbo.gl_cost_transactions gct
			where
				1 = 0
		end

		insert
			tempdb.dbo.Delete_gl_cost_transactions
		select
			gct.*
		from
			@atMia am  
			join dbo.gl_cost_transactions gct
				on document_type = @documentType
				and document_id1 = convert(varchar, am.serial)
				and document_id2 = convert(char(10), am.date_stamp, 101) + ' ' + convert(char(12), am.date_stamp, 114) --'07/19/2013 10:36:41.860'
				and document_id3 = am.type
		where
			am.id = @amID
			--and (
			--		gct.update_balances = 'Y'
			--		or gct.update_balances is null
			--	)
			
		delete
			gct
		from
			@atMia am  
			join dbo.gl_cost_transactions gct
				on document_type = @documentType
				and document_id1 = convert(varchar, am.serial)
				and document_id2 = convert(char(10), am.date_stamp, 101) + ' ' + convert(char(12), am.date_stamp, 114) --'07/19/2013 10:36:41.860'
				and document_id3 = am.type
		where
			am.id = @amID  
			--and (
			--		gct.update_balances = 'Y'
			--		or gct.update_balances is null
			--	)
	end

	declare
		@entryDate char(10)
	select
		@entryDate = convert(char(10), am.date_stamp, 121)
	from
		@atMia am
	where
		id = @amID  
	
	exec dbo.WriteJournalEntry 
		@as_fiscalyear = @fiscalYear
	,	@as_ledger = @ledger
	,	@as_glentry = @GLEntry out
	,	@as_jedescription = N'Monitor Inv'
	,	@as_balancename = @balanceName
	,	@as_entrydate = @entryDate
	,	@as_entrytype = N'GL'
	,	@as_relatedglentry = N''
	,	@as_userid = @User
	,	@ai_period = @period
	,	@as_approved = N'Y'
	,	@as_currency = @currency
	
	if	object_id('tempdb.dbo.Insert_gl_cost_transactions') is null begin
		select 
			document_type = @documentType
		,	document_id1 = convert(varchar, am.serial)
		,	document_id2 = convert(char(10), am.date_stamp, 101) + ' ' + convert(char(12), am.date_stamp, 114)
		,	document_id3 = am.type
		,	document_line = ga.DocumentLine
		,	ledger_account = ga.LedgerAccount
		,	contract_id = ''
		,	contract_account_id = ''
		,	costrevenue_type_id = ''
		,	fiscal_year = @fiscalYear
		,	ledger = @Ledger
		,	gl_entry = @glEntry
		,	period = @period
		,	transaction_date = FT.fn_TruncDate('day', am.date_stamp)
		,	amount =
				case
					when ga.LedgerAccount = am.material_debit + am.product_line_gl_segment then abs(am.material_cum * am.std_quantity)
					when ga.LedgerAccount = am.material_credit + am.product_line_gl_segment then -1 * abs(am.material_cum * am.std_quantity)
					when ga.LedgerAccount = am.labor_debit + am.product_line_gl_segment then abs(am.labor_cum * am.std_quantity)
					when ga.LedgerAccount = am.labor_credit + am.product_line_gl_segment then -1 * abs(am.labor_cum * am.std_quantity)
					when ga.LedgerAccount = am.burden_debit + am.product_line_gl_segment then abs(am.burden_cum * am.std_quantity)
					when ga.LedgerAccount = am.burden_credit + am.product_line_gl_segment then -1 * abs(am.burden_cum * am.std_quantity)
					when ga.LedgerAccount = am.other_debit + am.product_line_gl_segment then abs(am.other_cum * am.std_quantity)
					when ga.LedgerAccount = am.other_credit + am.product_line_gl_segment then -1 * abs(am.other_cum * am.std_quantity)
				end
		,	document_amount =
				case
					when ga.LedgerAccount = am.material_debit + am.product_line_gl_segment then abs(am.material_cum * am.std_quantity)
					when ga.LedgerAccount = am.material_credit + am.product_line_gl_segment then -1 * abs(am.material_cum * am.std_quantity)
					when ga.LedgerAccount = am.labor_debit + am.product_line_gl_segment then abs(am.labor_cum * am.std_quantity)
					when ga.LedgerAccount = am.labor_credit + am.product_line_gl_segment then -1 * abs(am.labor_cum * am.std_quantity)
					when ga.LedgerAccount = am.burden_debit + am.product_line_gl_segment then abs(am.burden_cum * am.std_quantity)
					when ga.LedgerAccount = am.burden_credit + am.product_line_gl_segment then -1 * abs(am.burden_cum * am.std_quantity)
					when ga.LedgerAccount = am.other_debit + am.product_line_gl_segment then abs(am.other_cum * am.std_quantity)
					when ga.LedgerAccount = am.other_credit + am.product_line_gl_segment then -1 * abs(am.other_cum * am.std_quantity)
				end
		,	document_currency = @currency
		,	exchange_date = FT.fn_TruncDate('day', am.date_stamp) --pull from exahnage rate table.
		,	exchange_rate = 1.000000 --pull from exahnage rate table.
		,	document_reference1 = am.part
		,	document_reference2 = am.description
		,	document_remarks = convert(varchar, am.serial) + ' ' + convert(char(10), am.date_stamp, 101) + ' ' + convert(char(12), am.date_stamp, 114) + ' ' + am.remarks
		,	application = @application
		,	quantity = am.std_quantity
		,	unit_of_measure = ''
		,	user_defined_text = '0'
		,	user_defined_number = 0.000000
		,	user_defined_date = {d '1900-01-01' }
		,	changed_date = @TranDT
		,	changed_user_id = @User
		,	update_balances = 'Y'
		into
			tempdb.dbo.Insert_gl_cost_transactions
		from
			@glAccounts ga
			cross join @atMia am
		where
			1 = 0
	end

	insert
		tempdb.dbo.Insert_gl_cost_transactions
	select 
		document_type = @documentType
	,	document_id1 = convert(varchar, am.serial)
	,	document_id2 = convert(char(10), am.date_stamp, 101) + ' ' + convert(char(12), am.date_stamp, 114)
	,	document_id3 = am.type
	,	document_line = ga.DocumentLine
	,	ledger_account = ga.LedgerAccount
	,	contract_id = ''
	,	contract_account_id = ''
	,	costrevenue_type_id = ''
	,	fiscal_year = @fiscalYear
	,	ledger = @Ledger
	,	gl_entry = @glEntry
	,	period = @period
	,	transaction_date = FT.fn_TruncDate('day', am.date_stamp)
	,	amount =
			case
				when ga.LedgerAccount = am.material_debit + am.product_line_gl_segment then abs(am.material_cum * am.std_quantity)
				when ga.LedgerAccount = am.material_credit + am.product_line_gl_segment then -1 * abs(am.material_cum * am.std_quantity)
				when ga.LedgerAccount = am.labor_debit + am.product_line_gl_segment then abs(am.labor_cum * am.std_quantity)
				when ga.LedgerAccount = am.labor_credit + am.product_line_gl_segment then -1 * abs(am.labor_cum * am.std_quantity)
				when ga.LedgerAccount = am.burden_debit + am.product_line_gl_segment then abs(am.burden_cum * am.std_quantity)
				when ga.LedgerAccount = am.burden_credit + am.product_line_gl_segment then -1 * abs(am.burden_cum * am.std_quantity)
				when ga.LedgerAccount = am.other_debit + am.product_line_gl_segment then abs(am.other_cum * am.std_quantity)
				when ga.LedgerAccount = am.other_credit + am.product_line_gl_segment then -1 * abs(am.other_cum * am.std_quantity)
			end
	,	document_amount =
			case
				when ga.LedgerAccount = am.material_debit + am.product_line_gl_segment then abs(am.material_cum * am.std_quantity)
				when ga.LedgerAccount = am.material_credit + am.product_line_gl_segment then -1 * abs(am.material_cum * am.std_quantity)
				when ga.LedgerAccount = am.labor_debit + am.product_line_gl_segment then abs(am.labor_cum * am.std_quantity)
				when ga.LedgerAccount = am.labor_credit + am.product_line_gl_segment then -1 * abs(am.labor_cum * am.std_quantity)
				when ga.LedgerAccount = am.burden_debit + am.product_line_gl_segment then abs(am.burden_cum * am.std_quantity)
				when ga.LedgerAccount = am.burden_credit + am.product_line_gl_segment then -1 * abs(am.burden_cum * am.std_quantity)
				when ga.LedgerAccount = am.other_debit + am.product_line_gl_segment then abs(am.other_cum * am.std_quantity)
				when ga.LedgerAccount = am.other_credit + am.product_line_gl_segment then -1 * abs(am.other_cum * am.std_quantity)
			end
	,	document_currency = @currency
	,	exchange_date = FT.fn_TruncDate('day', am.date_stamp) --pull from exahnage rate table.
	,	exchange_rate = 1.000000 --pull from exahnage rate table.
	,	document_reference1 = am.part
	,	document_reference2 = am.description
	,	document_remarks = convert(varchar, am.serial) + ' ' + convert(char(10), am.date_stamp, 101) + ' ' + convert(char(12), am.date_stamp, 114) + ' ' + am.remarks
	,	application = @application
	,	quantity = am.std_quantity
	,	unit_of_measure = ''
	,	user_defined_text = '0'
	,	user_defined_number = 0.000000
	,	user_defined_date = {d '1900-01-01' }
	,	changed_date = @TranDT
	,	changed_user_id = @User
	,	update_balances = 'Y'
	from
		@glAccounts ga
		cross join @atMia am
	where
		am.id = @amID

	insert
		dbo.gl_cost_transactions
	(	document_type
	,	document_id1
	,	document_id2
	,	document_id3
	,	document_line
	,	ledger_account
	,	contract_id
	,	contract_account_id
	,	costrevenue_type_id
	,	fiscal_year
	,	ledger
	,	gl_entry
	,	period
	,	transaction_date
	,	amount
	,	document_amount
	,	document_currency
	,	exchange_date
	,	exchange_rate
	,	document_reference1
	,	document_reference2
	,	document_remarks
	,	application
	,	quantity
	,	unit_of_measure
	,	user_defined_text
	,	user_defined_number
	,	user_defined_date
	,	changed_date
	,	changed_user_id
	,	update_balances 
	)
	select 
		document_type = @documentType
	,	document_id1 = convert(varchar, am.serial)
	,	document_id2 = convert(char(10), am.date_stamp, 101) + ' ' + convert(char(12), am.date_stamp, 114)
	,	document_id3 = am.type
	,	document_line = ga.DocumentLine
	,	ledger_account = ga.LedgerAccount
	,	contract_id = ''
	,	contract_account_id = ''
	,	costrevenue_type_id = ''
	,	fiscal_year = @fiscalYear
	,	ledger = @Ledger
	,	gl_entry = @glEntry
	,	period = @period
	,	transaction_date = FT.fn_TruncDate('day', am.date_stamp)
	,	amount =
			case
				when ga.LedgerAccount = am.material_debit + am.product_line_gl_segment then abs(am.material_cum * am.std_quantity)
				when ga.LedgerAccount = am.material_credit + am.product_line_gl_segment then -1 * abs(am.material_cum * am.std_quantity)
				when ga.LedgerAccount = am.labor_debit + am.product_line_gl_segment then abs(am.labor_cum * am.std_quantity)
				when ga.LedgerAccount = am.labor_credit + am.product_line_gl_segment then -1 * abs(am.labor_cum * am.std_quantity)
				when ga.LedgerAccount = am.burden_debit + am.product_line_gl_segment then abs(am.burden_cum * am.std_quantity)
				when ga.LedgerAccount = am.burden_credit + am.product_line_gl_segment then -1 * abs(am.burden_cum * am.std_quantity)
				when ga.LedgerAccount = am.other_debit + am.product_line_gl_segment then abs(am.other_cum * am.std_quantity)
				when ga.LedgerAccount = am.other_credit + am.product_line_gl_segment then -1 * abs(am.other_cum * am.std_quantity)
			end
	,	document_amount =
			case
				when ga.LedgerAccount = am.material_debit + am.product_line_gl_segment then abs(am.material_cum * am.std_quantity)
				when ga.LedgerAccount = am.material_credit + am.product_line_gl_segment then -1 * abs(am.material_cum * am.std_quantity)
				when ga.LedgerAccount = am.labor_debit + am.product_line_gl_segment then abs(am.labor_cum * am.std_quantity)
				when ga.LedgerAccount = am.labor_credit + am.product_line_gl_segment then -1 * abs(am.labor_cum * am.std_quantity)
				when ga.LedgerAccount = am.burden_debit + am.product_line_gl_segment then abs(am.burden_cum * am.std_quantity)
				when ga.LedgerAccount = am.burden_credit + am.product_line_gl_segment then -1 * abs(am.burden_cum * am.std_quantity)
				when ga.LedgerAccount = am.other_debit + am.product_line_gl_segment then abs(am.other_cum * am.std_quantity)
				when ga.LedgerAccount = am.other_credit + am.product_line_gl_segment then -1 * abs(am.other_cum * am.std_quantity)
			end
	,	document_currency = @currency
	,	exchange_date = FT.fn_TruncDate('day', am.date_stamp) --pull from exahnage rate table.
	,	exchange_rate = 1.000000 --pull from exahnage rate table.
	,	document_reference1 = am.part
	,	document_reference2 = am.description
	,	document_remarks = convert(varchar, am.serial) + ' ' + convert(char(10), am.date_stamp, 101) + ' ' + convert(char(12), am.date_stamp, 114) + ' ' + am.remarks
	,	application = @application
	,	quantity = am.std_quantity
	,	unit_of_measure = ''
	,	user_defined_text = '0'
	,	user_defined_number = 0.000000
	,	user_defined_date = {d '1900-01-01' }
	,	changed_date = @TranDT
	,	changed_user_id = @User
	,	update_balances = 'Y'
	from
		@glAccounts ga
		cross join @atMia am
	where
		am.id = @amID

	--insert
	--	dbo.gl_cost_transactions
	--(	document_type
	--,	document_id1
	--,	document_id2
	--,	document_id3
	--,	document_line
	--,	ledger_account
	--,	contract_id
	--,	contract_account_id
	--,	costrevenue_type_id
	--,	fiscal_year
	--,	ledger
	--,	gl_entry
	--,	period
	--,	transaction_date
	--,	amount
	--,	document_amount
	--,	document_currency
	--,	exchange_date
	--,	exchange_rate
	--,	document_reference1
	--,	document_reference2
	--,	document_remarks
	--,	application
	--,	quantity
	--,	unit_of_measure
	--,	user_defined_text
	--,	user_defined_number
	--,	user_defined_date
	--,	changed_date
	--,	changed_user_id
	--,	update_balances 
	--)
	--select 
	--	document_type = 'MON INV'
	--,	document_id1 = '20909579'
	--,	document_id2 = '07/19/2013 10:36:41.860'
	--,	document_id3 = 'M'
	--,	document_line = 1
	--,	ledger_account = '152512'
	--,	contract_id = ''
	--,	contract_account_id = ''
	--,	costrevenue_type_id = ''
	--,	fiscal_year = '2013'
	--,	ledger = 'HONDURAS'
	--,	gl_entry = 'MINV20130719'
	--,	period = 7
	--,	transaction_date = {d '2013-07-19' }
	--,	amount = 0.180000
	--,	document_amount = 0.180000
	--,	document_currency = 'USD'
	--,	exchange_date = {d '2013-07-19' }
	--,	exchange_rate = 1.000000
	--,	document_reference1 = '16531733-WA00'
	--,	document_reference2 = 'W3 socket cavity plug, white'
	--,	document_remarks = '20909579 07/19/2013 10:36:41.860 Mat Issue WIP'
	--,	application = 'MONITOR'
	--,	quantity = 69.000000
	--,	unit_of_measure = ''
	--,	user_defined_text = '0'
	--,	user_defined_number = 0.000000
	--,	user_defined_date = {d '1900-01-01' }
	--,	changed_date = {ts '2013-07-29 09:58:06.441'}
	--,	changed_user_id = 'DAN'
	--,	update_balances = 'Y'
	--from
	--	@atMia am
	--where
	--	am.id = @amID

	commit transaction TransactionPosting
	--rollback transaction TransactionPosting
end

close
	atMia

deallocate
	atMia
GO
