SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [EEIUser].[acctg_budget_cr_total_graph] (@budget_id varchar(100),@fiscal_year varchar(5),@organization varchar(3))
as

create table #organization (organization varchar(3))

if @organization = 'all' 
  begin 
	insert into #organization 
	select '11'
	insert into #organization
	select '12'
	insert into #organization
	select '21'
	insert into #organization
	select '60'
   end 
 else
	insert into #organization
	select @organization


select	convert(char(2),isnull(a.period,b.period))+'/'+isnull(a.fiscal_year, b.fiscal_year) as date, 
		isnull(a.fiscal_year, b.fiscal_year) as fiscal_year, 
		isnull(a.period,b.period) as period, 
		isnull(a.period_amount,0) as actual_amount, 
		isnull(b.period_amount,0) as budget_amount 
from	
	(select		fiscal_year, 
				period, 
				sum(period_amount) as period_amount 
	from		ledger_balances 
	where		balance_name = 'Actual'
				and ledger_account not in ('801011','404021')
				and left(ledger_account,4) > '5019' 
				and fiscal_year = @fiscal_year
				and len(ledger_account)=6
				and right(ledger_account,2) in (select organization from #organization)
	group by	fiscal_year, period) a
full outer join
	(select		fiscal_year, 
				period, 
				sum(period_amount) as period_amount 
	from		eeiuser.acctg_budget 
	where		budget_id = @budget_id
				and fiscal_year = @fiscal_year
				and ledger_account not in ('801011','404021')
				and left(ledger_account,4) > '5019'
				and len(ledger_account)=6 
				and right(ledger_account,2) in (select organization from #organization)
	group by	fiscal_year, period) b
on	a.fiscal_year = b.fiscal_year
and a.period = b.period
GO
