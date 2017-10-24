use EEH
go

begin transaction
go

/*Line 3*/
select
	user_secured_columns.secured_column_name
,	user_secured_columns.valid_values
,	secured_columns.security_enabled
from
	user_secured_columns
,	secured_columns
where
	(user_secured_columns.secured_column_name = secured_columns.secured_column_name)
	and (
		 (user_secured_columns.security_id = 'DAN')
		 and (secured_columns.security_enabled = 'Y')
		)
order by
	user_secured_columns.secured_column_name asc  

/*Line 15*/
select
	count(*)
from
	calendar_periods
where
	fiscal_year = '2013'

/*Line 22*/
select
	posting_consolidating
from
	ledger_definition
where
	fiscal_year = '2013'
	and ledger = 'HONDURAS' 

/*Line 29*/
select
	balancing_required
from
	balance_definition
where
	fiscal_year = '2013'
	and balance_name = 'ACTUAL' 

/*Line 44*/
select
	calendar_periods.period
from
	calendar_periods
where
	calendar_periods.fiscal_year = '2013'
	and calendar_periods.calendar = 'JAN - DEC'
	and calendar_periods.period_start_date <= '2013-07-19'
	and calendar_periods.period_end_date >= '2013-07-19'
	and charindex('close', lower(calendar_periods.period_name)) = 0
	and charindex('closing', lower(calendar_periods.period_name)) = 0
	and charindex('begin', lower(calendar_periods.period_name)) = 0
	and charindex('open', lower(calendar_periods.period_name)) = 0

/*Line 50*/
select
	ledger_definition.calendar
from
	ledger_definition
where
	ledger_definition.fiscal_year = '2013'
	and ledger_definition.ledger = 'HONDURAS'

/*Line 59*/
select
	ap_closed
,	ar_closed
,	ba_closed
,	fa_closed
,	gl_closed
,	iv_closed
,	py_closed
,	po_closed
,	so_closed
,	cv_closed
,	co_closed
from
	ledger_periods
where
	ledger_periods.fiscal_year = '2013'
	and ledger_periods.ledger = 'HONDURAS'
	and ledger_periods.period = 7

/*Line 64*/
select
	monitor_audit_trail_types.audit_trail_type
,	monitor_audit_trail_types.audit_trail_type_description
from
	monitor_audit_trail_types
order by
	monitor_audit_trail_types.audit_trail_type asc
  
/*Line 71*/
select
	monitor_inventory_accounts.fiscal_year
,	monitor_inventory_accounts.ledger
,	monitor_inventory_accounts.product_line
,	monitor_inventory_accounts.audit_trail_type
,	monitor_inventory_accounts.part_type
,	monitor_inventory_accounts.sort_line
,	monitor_inventory_accounts.empower_interface
,	monitor_inventory_accounts.material_debit
,	monitor_inventory_accounts.material_credit
,	monitor_inventory_accounts.material_variance
,	monitor_inventory_accounts.labor_debit
,	monitor_inventory_accounts.labor_credit
,	monitor_inventory_accounts.burden_debit
,	monitor_inventory_accounts.burden_credit
,	monitor_inventory_accounts.other_debit
,	monitor_inventory_accounts.other_credit
from
	monitor_inventory_accounts
where
	(monitor_inventory_accounts.fiscal_year = '2013')
	and (monitor_inventory_accounts.ledger = 'HONDURAS')
	and (
		 monitor_inventory_accounts.product_line = '**all**'
		 or ('**all**' = '**all**')
		)
order by
	monitor_inventory_accounts.product_line asc
,	monitor_inventory_accounts.sort_line asc

/*Line 80*/
select
	audit_trail.serial
,	audit_trail.date_stamp
,	audit_trail.type
,	audit_trail.part
,	isnull(remarks, type) remarks
,	isnull(plant, '') plant
,	isnull(cost, 0) cost
,	isnull(to_loc, '') to_loc
,	isnull(po_number, '') po_number
,	isnull(price, 0) price
,	isnull(std_quantity, quantity) std_quantity
,	isnull(quantity, 0) quantity
,	audit_trail.parent_serial
from
	audit_trail
where
	(audit_trail.date_stamp between {ts '2013-07-19 00:00:00.000'}
							and		{ts '2013-07-19 23:59:59.990'})
	and (
		 posted is null
		 or (posted <> 'Y')
		)
order by
	audit_trail.part asc
,	audit_trail.type asc
,	audit_trail.serial asc
,	audit_trail.date_stamp asc

/*Line 93*/
select
	name
,	type
,	isnull(product_line, '')
from
	part
where
	part = '10-P5B883M16-6C'

/*Line 100*/
select
	isnull(cost_cum, 0)
,	isnull(material_cum, 0)
,	isnull(labor_cum, 0)
,	isnull(burden_cum, 0)
,	isnull(other_cum, 0)
from
	part_standard
where
	part = '10-P5B883M16-6C'

/*Line 107*/
select
	isnull(product_line.gl_segment, '')
from
	product_line
where
	id = 'PCB'

/*Line 114*/
select
	name
,	type
,	isnull(product_line, '')
from
	part
where
	part = '10-W305032TCPF1'

/*Line 121*/
select
	isnull(cost_cum, 0)
,	isnull(material_cum, 0)
,	isnull(labor_cum, 0)
,	isnull(burden_cum, 0)
,	isnull(other_cum, 0)
from
	part_standard
where
	part = '10-W305032TCPF1'

/*Line 128*/
select
	name
,	type
,	isnull(product_line, '')
from
	part
where
	part = '1302203'

/*Line 135*/
select
	isnull(cost_cum, 0)
,	isnull(material_cum, 0)
,	isnull(labor_cum, 0)
,	isnull(burden_cum, 0)
,	isnull(other_cum, 0)
from
	part_standard
where
	part = '1302203'

/*Line 142*/
select
	isnull(product_line.gl_segment, '')
from
	product_line
where
	id = 'WIRE HARN-EEH'

/*Line 149*/
--begin transaction

/*Line 151*/
--update
--	audit_trail
--set	
--	posted = 'Y'
--where
--	serial = 3392075
--	and date_stamp = {ts '2013-07-19 18:29:17.387'}

/*Line 159*/
select
	count(*)
from
	audit_trail
where
	serial = 3392075
	and date_stamp = {ts '2013-07-19 18:29:17.387'}

/*Line 167*/
--commit

/*Line 168*/
select
	name
,	type
,	isnull(product_line, '')
from
	part
where
	part = '16531733-WA00'

/*Line 175*/
select
	isnull(cost_cum, 0)
,	isnull(material_cum, 0)
,	isnull(labor_cum, 0)
,	isnull(burden_cum, 0)
,	isnull(other_cum, 0)
from
	part_standard
where
	part = '16531733-WA00'

/*Line 182*/
select
	isnull(destination.gl_segment, '')
from
	destination
where
	plant = 'EEH'
	and destination = 'EEH'

/*Line 189*/
select
	ledger_accounts.active_inactive
,	ledger_accounts.exchange_gain_ledger_account
,	ledger_accounts.exchange_loss_ledger_account
,	chart_of_accounts.account_description
,	chart_of_accounts.balance_profit
,	chart_of_accounts.debit_credit_stat
,	ledger_accounts.posting_reporting
,	ledger_accounts.cost_account_required
from
	ledger_accounts
,	chart_of_accounts
where
	(ledger_accounts.fiscal_year = chart_of_accounts.fiscal_year)
	and (ledger_accounts.coa = chart_of_accounts.coa)
	and (ledger_accounts.account = chart_of_accounts.account)
	and (ledger_accounts.fiscal_year = '2013')
	and (ledger_accounts.ledger = 'HONDURAS')
	and (ledger_accounts.ledger_account = '152512')

/*Line 196*/
select
	ledger_accounts.active_inactive
,	ledger_accounts.exchange_gain_ledger_account
,	ledger_accounts.exchange_loss_ledger_account
,	chart_of_accounts.account_description
,	chart_of_accounts.balance_profit
,	chart_of_accounts.debit_credit_stat
,	ledger_accounts.posting_reporting
,	ledger_accounts.cost_account_required
from
	ledger_accounts
,	chart_of_accounts
where
	(ledger_accounts.fiscal_year = chart_of_accounts.fiscal_year)
	and (ledger_accounts.coa = chart_of_accounts.coa)
	and (ledger_accounts.account = chart_of_accounts.account)
	and (ledger_accounts.fiscal_year = '2013')
	and (ledger_accounts.ledger = 'HONDURAS')
	and (ledger_accounts.ledger_account = '152112')

/*Line 203*/
select
	ledger_accounts.active_inactive
,	ledger_accounts.exchange_gain_ledger_account
,	ledger_accounts.exchange_loss_ledger_account
,	chart_of_accounts.account_description
,	chart_of_accounts.balance_profit
,	chart_of_accounts.debit_credit_stat
,	ledger_accounts.posting_reporting
,	ledger_accounts.cost_account_required
from
	ledger_accounts
,	chart_of_accounts
where
	(ledger_accounts.fiscal_year = chart_of_accounts.fiscal_year)
	and (ledger_accounts.coa = chart_of_accounts.coa)
	and (ledger_accounts.account = chart_of_accounts.account)
	and (ledger_accounts.fiscal_year = '2013')
	and (ledger_accounts.ledger = 'HONDURAS')
	and (ledger_accounts.ledger_account = '509112')

/*Line 210*/
select
	ledger_accounts.active_inactive
,	ledger_accounts.exchange_gain_ledger_account
,	ledger_accounts.exchange_loss_ledger_account
,	chart_of_accounts.account_description
,	chart_of_accounts.balance_profit
,	chart_of_accounts.debit_credit_stat
,	ledger_accounts.posting_reporting
,	ledger_accounts.cost_account_required
from
	ledger_accounts
,	chart_of_accounts
where
	(ledger_accounts.fiscal_year = chart_of_accounts.fiscal_year)
	and (ledger_accounts.coa = chart_of_accounts.coa)
	and (ledger_accounts.account = chart_of_accounts.account)
	and (ledger_accounts.fiscal_year = '2013')
	and (ledger_accounts.ledger = 'HONDURAS')
	and (ledger_accounts.ledger_account = '152212')

/*Line 218*/
--begin transaction

select
	*
from
	dbo.audit_trail at
where
	serial = 20909579
	and date_stamp = {ts '2013-07-19 10:36:41.860'}

/*Line 224*/
--update
--	audit_trail
--set	
--	posted = 'Y'
--where
--	serial = 20909579
--	and date_stamp = {ts '2013-07-19 10:36:41.860'}

/*Line 227*/
select
	count(*)
from
	audit_trail
where
	serial = 20909579
	and date_stamp = {ts '2013-07-19 10:36:41.860'}

/*Line 234*/
select
	je_committed
from
	journal_entries
where
	fiscal_year = '2013'
	and ledger = 'HONDURAS'
	and gl_entry = 'MINV20130719'

/*Line 241*/
select
	count(*)
from
	calendar_periods
where
	calendar_periods.fiscal_year = '2013'

/*Line 248*/
select
	ledger_definition.calendar
,	ledger_definition.posting_consolidating
,	ledger_definition.currency
,	ledger_definition.profit_loss_ledger_account
from
	ledger_definition
where
	ledger_definition.fiscal_year = '2013'
	and ledger_definition.ledger = 'HONDURAS'

/*Line 255*/
select
	period_start_date
,	period_end_date
from
	calendar_periods
where
	calendar_periods.fiscal_year = '2013'
	and calendar_periods.calendar = 'JAN - DEC'
	and calendar_periods.period = 7

/*Line 262*/
select
	ap_closed
,	ar_closed
,	ba_closed
,	fa_closed
,	gl_closed
,	iv_closed
,	py_closed
,	po_closed
,	so_closed
,	cv_closed
,	co_closed
from
	ledger_periods
where
	ledger_periods.fiscal_year = '2013'
	and ledger_periods.ledger = 'HONDURAS'
	and ledger_periods.period = 7

/*Line 267*/
select
	count(*)
from
	balance_definition
where
	balance_definition.fiscal_year = '2013'
	and balance_definition.balance_name = 'ACTUAL'

/*Line 274*/
select
	exchange_rates.exchange_rate
from
	exchange_rates
where
	exchange_rates.currency = 'USD'
	and exchange_rates.effective_on_date <= {d '2013-07-19' }
	and exchange_rates.effective_off_date >= {d '2013-07-19' }

/*Line 281*/
select
	exchange_rates.exchange_rate
from
	exchange_rates
where
	exchange_rates.currency = 'USD'
	and exchange_rates.effective_on_date <= {d '2013-07-19' }
	and exchange_rates.effective_off_date >= {d '2013-07-19' }

/*Line 288*/
select
	ledger_accounts.active_inactive
,	ledger_accounts.exchange_gain_ledger_account
,	ledger_accounts.exchange_loss_ledger_account
,	chart_of_accounts.account_description
,	chart_of_accounts.balance_profit
,	chart_of_accounts.debit_credit_stat
,	ledger_accounts.posting_reporting
,	ledger_accounts.cost_account_required
from
	ledger_accounts
,	chart_of_accounts
where
	(ledger_accounts.fiscal_year = chart_of_accounts.fiscal_year)
	and (ledger_accounts.coa = chart_of_accounts.coa)
	and (ledger_accounts.account = chart_of_accounts.account)
	and (ledger_accounts.fiscal_year = '2013')
	and (ledger_accounts.ledger = 'HONDURAS')
	and (ledger_accounts.ledger_account = '152512')

/*Line 295*/
select
	ledger_accounts.active_inactive
,	ledger_accounts.exchange_gain_ledger_account
,	ledger_accounts.exchange_loss_ledger_account
,	chart_of_accounts.account_description
,	chart_of_accounts.balance_profit
,	chart_of_accounts.debit_credit_stat
,	ledger_accounts.posting_reporting
,	ledger_accounts.cost_account_required
from
	ledger_accounts
,	chart_of_accounts
where
	(ledger_accounts.fiscal_year = chart_of_accounts.fiscal_year)
	and (ledger_accounts.coa = chart_of_accounts.coa)
	and (ledger_accounts.account = chart_of_accounts.account)
	and (ledger_accounts.fiscal_year = '2013')
	and (ledger_accounts.ledger = 'HONDURAS')
	and (ledger_accounts.ledger_account = '152112')

/*Line 302*/
select
	ledger_accounts.active_inactive
,	ledger_accounts.exchange_gain_ledger_account
,	ledger_accounts.exchange_loss_ledger_account
,	chart_of_accounts.account_description
,	chart_of_accounts.balance_profit
,	chart_of_accounts.debit_credit_stat
,	ledger_accounts.posting_reporting
,	ledger_accounts.cost_account_required
from
	ledger_accounts
,	chart_of_accounts
where
	(ledger_accounts.fiscal_year = chart_of_accounts.fiscal_year)
	and (ledger_accounts.coa = chart_of_accounts.coa)
	and (ledger_accounts.account = chart_of_accounts.account)
	and (ledger_accounts.fiscal_year = '2013')
	and (ledger_accounts.ledger = 'HONDURAS')
	and (ledger_accounts.ledger_account = '509112')

/*Line 309*/
select
	ledger_accounts.active_inactive
,	ledger_accounts.exchange_gain_ledger_account
,	ledger_accounts.exchange_loss_ledger_account
,	chart_of_accounts.account_description
,	chart_of_accounts.balance_profit
,	chart_of_accounts.debit_credit_stat
,	ledger_accounts.posting_reporting
,	ledger_accounts.cost_account_required
from
	ledger_accounts
,	chart_of_accounts
where
	(ledger_accounts.fiscal_year = chart_of_accounts.fiscal_year)
	and (ledger_accounts.coa = chart_of_accounts.coa)
	and (ledger_accounts.account = chart_of_accounts.account)
	and (ledger_accounts.fiscal_year = '2013')
	and (ledger_accounts.ledger = 'HONDURAS')
	and (ledger_accounts.ledger_account = '152212')

/*Line 316*/
select
	balance_definition.balancing_required
from
	balance_definition
where
	balance_definition.fiscal_year = '2013'
	and balance_definition.balance_name = 'ACTUAL'

/*Line 323*/
select
	sum(gl_cost_transactions.amount) * -1
,	max(period)
,	max(gl_cost_transactions.fiscal_year)
,	max(gl_cost_transactions.ledger)
,	count(*)
from
	gl_cost_transactions
,	ledger_accounts
,	chart_of_accounts
where
	document_type = 'MON INV'
	and document_id1 = '20909579'
	and document_id2 = '07/19/2013 10:36:41.860'
	and document_id3 = 'M'
	and ledger_accounts.fiscal_year = gl_cost_transactions.fiscal_year
	and ledger_accounts.ledger = gl_cost_transactions.ledger
	and ledger_accounts.ledger_account = gl_cost_transactions.ledger_account
	and chart_of_accounts.fiscal_year = ledger_accounts.fiscal_year
	and chart_of_accounts.coa = ledger_accounts.coa
	and chart_of_accounts.account = ledger_accounts.account
	and chart_of_accounts.balance_profit = 'P'
	and chart_of_accounts.debit_credit_stat <> 'S'
	and (
		 gl_cost_transactions.update_balances = 'Y'
		 or gl_cost_transactions.update_balances is null
		)

/*Line 334*/
--delete from
--	gl_cost_transactions
--where
--	document_type = 'MON INV'
--	and document_id1 = '20909579'
--	and document_id2 = '07/19/2013 10:36:41.860'
--	and document_id3 = 'M'

/*Line 341*/
--declare	@p3 nvarchar(12)
--set @p3 = N'MINV20130719'
--exec WriteJournalEntry 
--	N'2013'
--,	N'HONDURAS'
--,	@p3 output
--,	N'Monitor Inv'
--,	N'ACTUAL'
--,	N'2013-07-19'
--,	N'GL'
--,	N''
--,	N'DAN'
--,	7
--,	N'Y'
--,	N'USD'
--select
--	@p3

/*Line 388*/
--insert	into gl_cost_transactions
--		(
--		 document_type
--		,document_id1
--		,document_id2
--		,document_id3
--		,document_line
--		,ledger_account
--		,contract_id
--		,contract_account_id
--		,costrevenue_type_id
--		,fiscal_year
--		,ledger
--		,gl_entry
--		,period
--		,transaction_date
--		,amount
--		,document_amount
--		,document_currency
--		,exchange_date
--		,exchange_rate
--		,document_reference1
--		,document_reference2
--		,document_remarks
--		,application
--		,quantity
--		,unit_of_measure
--		,user_defined_text
--		,user_defined_number
--		,user_defined_date
--		,changed_date
--		,changed_user_id
--		,update_balances 
--		)
--values
--		(
--		 'MON INV'
--		,'20909579'
--		,'07/19/2013 10:36:41.860'
--		,'M'
--		,1
--		,'152512'
--		,''
--		,''
--		,''
--		,'2013'
--		,'HONDURAS'
--		,'MINV20130719'
--		,7
--		,{d '2013-07-19' }
--		,0.180000
--		,0.180000
--		,'USD'
--		,{d '2013-07-19' }
--		,1.000000
--		,'16531733-WA00'
--		,'W3 socket cavity plug, white'
--		,'20909579 07/19/2013 10:36:41.860 Mat Issue WIP'
--		,'MONITOR'
--		,69.000000
--		,''
--		,'0'
--		,0.000000
--		,{d '1900-01-01' }
--		,{ts '2013-07-29 09:58:06.441'}
--		,'DAN'
--		,'Y' 
--		)

/*Line 437*/
--insert	into gl_cost_transactions
--		(
--		 document_type
--		,document_id1
--		,document_id2
--		,document_id3
--		,document_line
--		,ledger_account
--		,contract_id
--		,contract_account_id
--		,costrevenue_type_id
--		,fiscal_year
--		,ledger
--		,gl_entry
--		,period
--		,transaction_date
--		,amount
--		,document_amount
--		,document_currency
--		,exchange_date
--		,exchange_rate
--		,document_reference1
--		,document_reference2
--		,document_remarks
--		,application
--		,quantity
--		,unit_of_measure
--		,user_defined_text
--		,user_defined_number
--		,user_defined_date
--		,changed_date
--		,changed_user_id
--		,update_balances 
--		)
--values
--		(
--		 'MON INV'
--		,'20909579'
--		,'07/19/2013 10:36:41.860'
--		,'M'
--		,2
--		,'152112'
--		,''
--		,''
--		,''
--		,'2013'
--		,'HONDURAS'
--		,'MINV20130719'
--		,7
--		,{d '2013-07-19' }
--		,-0.180000
--		,-0.180000
--		,'USD'
--		,{d '2013-07-19' }
--		,1.000000
--		,'16531733-WA00'
--		,'W3 socket cavity plug, white'
--		,'20909579 07/19/2013 10:36:41.860 Mat Issue WIP'
--		,'MONITOR'
--		,69.000000
--		,''
--		,'0'
--		,0.000000
--		,{d '1900-01-01' }
--		,{ts '2013-07-29 09:58:06.503'}
--		,'DAN'
--		,'Y' 
--		)

/*Line 486*/
--insert	into gl_cost_transactions
--		(
--		 document_type
--		,document_id1
--		,document_id2
--		,document_id3
--		,document_line
--		,ledger_account
--		,contract_id
--		,contract_account_id
--		,costrevenue_type_id
--		,fiscal_year
--		,ledger
--		,gl_entry
--		,period
--		,transaction_date
--		,amount
--		,document_amount
--		,document_currency
--		,exchange_date
--		,exchange_rate
--		,document_reference1
--		,document_reference2
--		,document_remarks
--		,application
--		,quantity
--		,unit_of_measure
--		,user_defined_text
--		,user_defined_number
--		,user_defined_date
--		,changed_date
--		,changed_user_id
--		,update_balances 
--		)
--values
--		(
--		 'MON INV'
--		,'20909579'
--		,'07/19/2013 10:36:41.860'
--		,'M'
--		,3
--		,'509112'
--		,''
--		,''
--		,''
--		,'2013'
--		,'HONDURAS'
--		,'MINV20130719'
--		,7
--		,{d '2013-07-19' }
--		,0.110000
--		,0.110000
--		,'USD'
--		,{d '2013-07-19' }
--		,1.000000
--		,'16531733-WA00'
--		,'W3 socket cavity plug, white'
--		,'20909579 07/19/2013 10:36:41.860 Mat Issue WIP'
--		,'MONITOR'
--		,69.000000
--		,''
--		,'0'
--		,0.000000
--		,{d '1900-01-01' }
--		,{ts '2013-07-29 09:58:06.550'}
--		,'DAN'
--		,'Y' 
--		)

/*Line 535*/
--insert	into gl_cost_transactions
--		(
--		 document_type
--		,document_id1
--		,document_id2
--		,document_id3
--		,document_line
--		,ledger_account
--		,contract_id
--		,contract_account_id
--		,costrevenue_type_id
--		,fiscal_year
--		,ledger
--		,gl_entry
--		,period
--		,transaction_date
--		,amount
--		,document_amount
--		,document_currency
--		,exchange_date
--		,exchange_rate
--		,document_reference1
--		,document_reference2
--		,document_remarks
--		,application
--		,quantity
--		,unit_of_measure
--		,user_defined_text
--		,user_defined_number
--		,user_defined_date
--		,changed_date
--		,changed_user_id
--		,update_balances 
--		)
--values
--		(
--		 'MON INV'
--		,'20909579'
--		,'07/19/2013 10:36:41.860'
--		,'M'
--		,4
--		,'152212'
--		,''
--		,''
--		,''
--		,'2013'
--		,'HONDURAS'
--		,'MINV20130719'
--		,7
--		,{d '2013-07-19' }
--		,-0.110000
--		,-0.110000
--		,'USD'
--		,{d '2013-07-19' }
--		,1.000000
--		,'16531733-WA00'
--		,'W3 socket cavity plug, white'
--		,'20909579 07/19/2013 10:36:41.860 Mat Issue WIP'
--		,'MONITOR'
--		,69.000000
--		,''
--		,'0'
--		,0.000000
--		,{d '1900-01-01' }
--		,{ts '2013-07-29 09:58:06.581'}
--		,'DAN'
--		,'Y' 
--		)

/*Line 538*/
select
	ledger_accounts.active_inactive
,	ledger_accounts.exchange_gain_ledger_account
,	ledger_accounts.exchange_loss_ledger_account
,	chart_of_accounts.account_description
,	chart_of_accounts.balance_profit
,	chart_of_accounts.debit_credit_stat
,	ledger_accounts.posting_reporting
,	ledger_accounts.cost_account_required
from
	ledger_accounts
,	chart_of_accounts
where
	(ledger_accounts.fiscal_year = chart_of_accounts.fiscal_year)
	and (ledger_accounts.coa = chart_of_accounts.coa)
	and (ledger_accounts.account = chart_of_accounts.account)
	and (ledger_accounts.fiscal_year = '2013')
	and (ledger_accounts.ledger = 'HONDURAS')
	and (ledger_accounts.ledger_account = '303012')

/*Line 570*/
--exec UpdateAccountBalance 
--	N'2013'
--,	N'HONDURAS'
--,	N'303012'
--,	N'ACTUAL'
--,	N'DAN'
--,	7
--,	0.110000

/*Line 572*/
--commit

go

rollback
go
