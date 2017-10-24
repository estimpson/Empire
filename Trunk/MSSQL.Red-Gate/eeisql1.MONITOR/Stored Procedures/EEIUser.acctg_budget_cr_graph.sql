SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [EEIUser].[acctg_budget_cr_graph] (@budget_id varchar(100),@fiscal_year varchar(5),@ledger_account varchar(50))
as



select	isnull(a.ledger_account,b.ledger_account) as ledger_account, 
		convert(char(2),isnull(a.period,b.period))+'/'+isnull(a.fiscal_year, b.fiscal_year) as date, 
		isnull(a.fiscal_year, b.fiscal_year) as fiscal_year, 
		isnull(a.period,b.period) as period, 
		isnull(a.period_amount,0) as actual_amount, 
		isnull(b.period_amount,0) as budget_amount 
from	
	(select		ledger_account, 
				fiscal_year, 
				period, 
				period_amount as period_amount 
	from		ledger_balances 
	where		balance_name = 'Actual' 
				and fiscal_year = @fiscal_year
				and ledger_account = @ledger_account )a
full outer join
	(select		ledger_account, 
				fiscal_year, 
				period, 
				sum(period_amount) as period_amount 
	from		eeiuser.acctg_budget 
	where		budget_id = @budget_id
				and fiscal_year = @fiscal_year 
				and ledger_account = @ledger_account
	group by	ledger_account, fiscal_year, period) b
on	a.ledger_account = b.ledger_account 
	and a.period = b.period 
	and a.fiscal_year = b.fiscal_year
GO
