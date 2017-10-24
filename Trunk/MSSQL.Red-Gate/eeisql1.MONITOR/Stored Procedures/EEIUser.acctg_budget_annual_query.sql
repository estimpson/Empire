SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[acctg_budget_annual_query] (@budget_id varchar(50), @fiscal_year varchar(5), @user_id varchar(50), @ledger_account varchar(50))
as
declare @period1 int
,@period2 int
,@period3 int
,@period4 int
,@period5 int
,@period6 int
,@period7 int
,@period8 int
,@period9 int
,@period10 int
,@period11 int
,@period12 int
,@period1_label varchar(10)
,@period2_label varchar(10)
,@period3_label varchar(10)
,@period4_label varchar(10)
,@period5_label varchar(10)
,@period6_label varchar(10)
,@period7_label varchar(10)
,@period8_label varchar(10)
,@period9_label varchar(10)
,@period10_label varchar(10)
,@period11_label varchar(10)
,@period12_label varchar(10)
;
select @period1 = 1
,@period2 = 2
,@period3 = 3
,@period4 = 4
,@period5 = 5
,@period6 = 6
,@period7 = 7
,@period8 = 8
,@period9 = 9
,@period10 = 10
,@period11 = 11
,@period12 = 12
,@period1_label = 'Jan-'+@fiscal_year
,@period2_label = 'Feb-'+@fiscal_year
,@period3_label = 'Mar-'+@fiscal_year
,@period4_label = 'Apr-'+@fiscal_year
,@period5_label = 'May-'+@fiscal_year
,@period6_label = 'Jun-'+@fiscal_year
,@period7_label = 'Jul-'+@fiscal_year
,@period8_label = 'Aug-'+@fiscal_year
,@period9_label = 'Sep-'+@fiscal_year
,@period10_label = 'Oct-'+@fiscal_year
,@period11_label = 'Nov-'+@fiscal_year
,@period12_label = 'Dec-'+@fiscal_year

create table #a ( 
budget_id varchar(50), 
ledger_account varchar(50),
ledger_description varchar(50), 
budget_line varchar(50), 
cashflow varchar(50), 
budget_description varchar(250),  
period1 varchar(10), 
budget1 decimal(18,2),
actual1 decimal(18,2), 
period2 varchar(10), 
budget2 decimal(18,2),
actual2 decimal(18,2),
period3 varchar(10), 
budget3 decimal(18,2),
actual3 decimal(18,2), 
period4 varchar(10), 
budget4 decimal(18,2),
actual4 decimal(18,2),
period5 varchar(10), 
budget5 decimal(18,2), 
actual5 decimal(18,2),
period6 varchar(10), 
budget6 decimal(18,2),
actual6 decimal(18,2),
period7 varchar(10), 
budget7 decimal(18,2), 
actual7 decimal(18,2),
period8 varchar(10), 
budget8 decimal(18,2),
actual8 decimal(18,2),
period9 varchar(10), 
budget9 decimal(18,2), 
actual9 decimal(18,2),
period10 varchar(10), 
budget10 decimal(18,2),
actual10 decimal(18,2),
period11 varchar(10), 
budget11 decimal(18,2), 
actual11 decimal(18,2),
period12 varchar(10), 
budget12 decimal(18,2),
actual12 decimal(18,2),
total_label varchar(10),
total_budget decimal(18,2),
total_actual decimal(18,2)
)


insert into #a (budget_line, budget_id, ledger_account, cashflow, budget_description) 
select distinct(budget_line),budget_id, ledger_account, cashflow, budget_description from eeiuser.acctg_budget where budget_id = @budget_id and ledger_account = @ledger_account and fiscal_year = @fiscal_year
insert into #a (ledger_account, budget_line, budget_id, cashflow, budget_description)
select distinct(ledger_account), ledger_account+'-9999', @budget_id, '?', 'Unbudgeted' from gl_cost_transactions where ledger = 'EMPIRE' and fiscal_year = @fiscal_year and update_balances = 'Y' and ledger_account = @ledger_account and (ledger_account+'-9999') not in (select distinct(budget_line) from #a)

update #a set ledger_description = account_description from #a, chart_of_accounts where account = left(ledger_account,4) and chart_of_accounts.fiscal_year = @fiscal_year
update #a set period1 = @period1_label, budget1 = isnull((select period_amount from eeiuser.acctg_budget where budget_id = @budget_id and budget_line = #a.budget_line and fiscal_year = @fiscal_year and period = @period1),0) from #a
update #a set period2 = @period2_label, budget2 = isnull((select period_amount from eeiuser.acctg_budget where budget_id = @budget_id and budget_line = #a.budget_line and fiscal_year = @fiscal_year and period = @period2),0) from #a
update #a set period3 = @period3_label, budget3 = isnull((select period_amount from eeiuser.acctg_budget where budget_id = @budget_id and budget_line = #a.budget_line and fiscal_year = @fiscal_year and period = @period3),0) from #a
update #a set period4 = @period4_label, budget4 = isnull((select period_amount from eeiuser.acctg_budget where budget_id = @budget_id and budget_line = #a.budget_line and fiscal_year = @fiscal_year and period = @period4),0) from #a
update #a set period5 = @period5_label, budget5 = isnull((select period_amount from eeiuser.acctg_budget where budget_id = @budget_id and budget_line = #a.budget_line and fiscal_year = @fiscal_year and period = @period5),0) from #a
update #a set period6 = @period6_label, budget6 = isnull((select period_amount from eeiuser.acctg_budget where budget_id = @budget_id and budget_line = #a.budget_line and fiscal_year = @fiscal_year and period = @period6),0) from #a
update #a set period7 = @period7_label, budget7 = isnull((select period_amount from eeiuser.acctg_budget where budget_id = @budget_id and budget_line = #a.budget_line and fiscal_year = @fiscal_year and period = @period7),0) from #a
update #a set period8 = @period8_label, budget8 = isnull((select period_amount from eeiuser.acctg_budget where budget_id = @budget_id and budget_line = #a.budget_line and fiscal_year = @fiscal_year and period = @period8),0) from #a
update #a set period9 = @period9_label, budget9 = isnull((select period_amount from eeiuser.acctg_budget where budget_id = @budget_id and budget_line = #a.budget_line and fiscal_year = @fiscal_year and period = @period9),0) from #a
update #a set period10 = @period10_label, budget10 = isnull((select period_amount from eeiuser.acctg_budget where budget_id = @budget_id and budget_line = #a.budget_line and fiscal_year = @fiscal_year and period = @period10),0) from #a
update #a set period11 = @period11_label, budget11 = isnull((select period_amount from eeiuser.acctg_budget where budget_id = @budget_id and budget_line = #a.budget_line and fiscal_year = @fiscal_year and period = @period11),0) from #a
update #a set period12 = @period12_label, budget12 = isnull((select period_amount from eeiuser.acctg_budget where budget_id = @budget_id and budget_line = #a.budget_line and fiscal_year = @fiscal_year and period = @period12),0) from #a
update #a set total_label = 'Total '+@fiscal_year, total_budget = (isnull(budget1,0)+isnull(budget2,0)+isnull(budget3,0)+isnull(budget4,0)+isnull(budget5,0)+isnull(budget6,0)+isnull(budget7,0)+isnull(budget8,0)+isnull(budget9,0)+isnull(budget10,0)+isnull(budget11,0)+isnull(budget12,0)) from #a
update #a set actual1 = isnull((select sum(amount) from gl_cost_transactions where ledger = 'EMPIRE' and update_balances = 'Y' and fiscal_year = @fiscal_year and period = @period1 and ledger_account = #a.ledger_account and (case when isnull(contract_account_id,'') = '' then ledger_account+'-9999' else contract_account_id end) = #a.budget_line),0) from #a
update #a set actual2 = isnull((select sum(amount) from gl_cost_transactions where ledger = 'EMPIRE' and update_balances = 'Y' and fiscal_year = @fiscal_year and period = @period2 and ledger_account = #a.ledger_account and (case when isnull(contract_account_id,'') = '' then ledger_account+'-9999' else contract_account_id end) = #a.budget_line),0) from #a
update #a set actual3 = isnull((select sum(amount) from gl_cost_transactions where ledger = 'EMPIRE' and update_balances = 'Y' and fiscal_year = @fiscal_year and period = @period3 and ledger_account = #a.ledger_account and (case when isnull(contract_account_id,'') = '' then ledger_account+'-9999' else contract_account_id end) = #a.budget_line),0) from #a
update #a set actual4 = isnull((select sum(amount) from gl_cost_transactions where ledger = 'EMPIRE' and update_balances = 'Y' and fiscal_year = @fiscal_year and period = @period4 and ledger_account = #a.ledger_account and (case when isnull(contract_account_id,'') = '' then ledger_account+'-9999' else contract_account_id end) = #a.budget_line),0) from #a
update #a set actual5 = isnull((select sum(amount) from gl_cost_transactions where ledger = 'EMPIRE' and update_balances = 'Y' and fiscal_year = @fiscal_year and period = @period5 and ledger_account = #a.ledger_account and (case when isnull(contract_account_id,'') = '' then ledger_account+'-9999' else contract_account_id end) = #a.budget_line),0) from #a
update #a set actual6 = isnull((select sum(amount) from gl_cost_transactions where ledger = 'EMPIRE' and update_balances = 'Y' and fiscal_year = @fiscal_year and period = @period6 and ledger_account = #a.ledger_account and (case when isnull(contract_account_id,'') = '' then ledger_account+'-9999' else contract_account_id end) = #a.budget_line),0) from #a
update #a set actual7 = isnull((select sum(amount) from gl_cost_transactions where ledger = 'EMPIRE' and update_balances = 'Y' and fiscal_year = @fiscal_year and period = @period7 and ledger_account = #a.ledger_account and (case when isnull(contract_account_id,'') = '' then ledger_account+'-9999' else contract_account_id end) = #a.budget_line),0) from #a
update #a set actual8 = isnull((select sum(amount) from gl_cost_transactions where ledger = 'EMPIRE' and update_balances = 'Y' and fiscal_year = @fiscal_year and period = @period8 and ledger_account = #a.ledger_account and (case when isnull(contract_account_id,'') = '' then ledger_account+'-9999' else contract_account_id end) = #a.budget_line),0) from #a
update #a set actual9 = isnull((select sum(amount) from gl_cost_transactions where ledger = 'EMPIRE' and update_balances = 'Y' and fiscal_year = @fiscal_year and period = @period9 and ledger_account = #a.ledger_account and (case when isnull(contract_account_id,'') = '' then ledger_account+'-9999' else contract_account_id end) = #a.budget_line),0) from #a
update #a set actual10 = isnull((select sum(amount) from gl_cost_transactions where ledger = 'EMPIRE' and update_balances = 'Y' and fiscal_year = @fiscal_year and period = @period10 and ledger_account = #a.ledger_account and (case when isnull(contract_account_id,'') = '' then ledger_account+'-9999' else contract_account_id end) = #a.budget_line),0) from #a
update #a set actual11 = isnull((select sum(amount) from gl_cost_transactions where ledger = 'EMPIRE' and update_balances = 'Y' and fiscal_year = @fiscal_year and period = @period11 and ledger_account = #a.ledger_account and (case when isnull(contract_account_id,'') = '' then ledger_account+'-9999' else contract_account_id end) = #a.budget_line),0) from #a
update #a set actual12 = isnull((select sum(amount) from gl_cost_transactions where ledger = 'EMPIRE' and update_balances = 'Y' and fiscal_year = @fiscal_year and period = @period12 and ledger_account = #a.ledger_account and (case when isnull(contract_account_id,'') = '' then ledger_account+'-9999' else contract_account_id end) = #a.budget_line),0) from #a
update #a set total_actual = (isnull(actual1,0)+isnull(actual2,0)+isnull(actual3,0)+isnull(actual4,0)+isnull(actual5,0)+isnull(actual6,0)+isnull(actual7,0)+isnull(actual8,0)+isnull(actual9,0)+isnull(actual10,0)+isnull(actual11,0)+isnull(actual12,0)) from #a


select *, 
actual1-budget1 as variance1, 
actual2-budget2 as variance2, 
actual3-budget3 as variance3,
actual4-budget4 as variance4, 
actual5-budget5 as variance5, 
actual6-budget6 as variance6, 
actual7-budget7 as variance7, 
actual8-budget8 as variance8, 
actual9-budget9 as variance9, 
actual10-budget10 as variance10, 
actual11-budget11 as variance11, 
actual12-budget12 as variance12,
total_actual-total_budget as total_variance
from #a order by ledger_account, budget_line
GO
