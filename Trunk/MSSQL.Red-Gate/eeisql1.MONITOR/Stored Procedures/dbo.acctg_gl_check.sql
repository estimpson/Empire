SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 CREATE procedure [dbo].[acctg_gl_check] @fiscal_year varchar(4), @period int
 as
 -- declare @fiscal_year varchar(4);
 -- declare @period int;
 -- select @fiscal_year = '2014';
 -- select @period = 10
 
 -- COMBINED
 select coalesce(a.ledger_account,b.ledger_account,c.ledger_account) as ledger_account,
		coalesce(a.period, b.period, c.period) as period,
		a.amount as ledger_balances_amount,
		b.amount as gl_cost_transactions_amount,
		a.amount-b.amount as variance,
		c.amount as journal_entry_lines_amount,
		a.amount-c.amount as variance2 from
 (select distinct(ledger_account) as ledger_account, period, isnull(period_amount,0) as amount from ledger_balances where fiscal_year = @fiscal_year and period = @period and ledger = 'EMPIRE' and balance_name = 'ACTUAL' and LEN(ledger_account) = '5' and RIGHT(ledger_account,1) = '1')a
 full outer join
 (select period, ledger_account, SUM(isnull(amount,0)) as amount from gl_cost_transactions where fiscal_year = @fiscal_year and period = @period and ledger = 'EMPIRE' and update_balances = 'Y' and len(ledger_account) = '5' and RIGHT(ledger_account,1) = '1' group by ledger_account, period) b
 on a.ledger_account = b.ledger_account and a.period = b.period
 full outer join 
 (select period, ledger_account, SUM(isnull(amount,0)) as amount from journal_entry_lines where fiscal_year = @fiscal_year and period = @period and balance_name = 'ACTUAL' and len(ledger_account)=5 and RIGHT(ledger_account,1) = '1' group by ledger_account, period) c
 on coalesce(a.ledger_account,b.ledger_account)= c.ledger_account and coalesce(a.period, b.period) = c.period
 
UNION

-- 11
 select coalesce(a.ledger_account,b.ledger_account,c.ledger_account) as ledger_account,
		coalesce(a.period, b.period, c.period) as period,
		a.amount as ledger_balances_amount,
		b.amount as gl_cost_transactions_amount,
		a.amount-b.amount as variance,
		c.amount as journal_entry_lines_amount,
		a.amount-c.amount as variance2 from
 (select distinct(ledger_account) as ledger_account, period, isnull(period_amount,0) as amount from ledger_balances where fiscal_year = @fiscal_year and period = @period and ledger = 'EMPIRE' and balance_name = 'ACTUAL' and LEN(ledger_account) = '6' and RIGHT(ledger_account,2) = '11')a
 full outer join
 (select period, ledger_account, SUM(isnull(amount,0)) as amount from gl_cost_transactions where fiscal_year = @fiscal_year and period = @period and ledger = 'EMPIRE' and update_balances = 'Y' and len(ledger_account) = '6' and RIGHT(ledger_account,2) = '11' group by ledger_account, period) b
 on a.ledger_account = b.ledger_account and a.period = b.period
 full outer join 
 (select period, ledger_account, SUM(isnull(amount,0)) as amount from journal_entry_lines where fiscal_year = @fiscal_year and period = @period and balance_name = 'ACTUAL' and len(ledger_account)=6 and RIGHT(ledger_account,2) = '11' group by ledger_account, period) c
 on coalesce(a.ledger_account,b.ledger_account)= c.ledger_account and coalesce(a.period, b.period) = c.period
 -- order by coalesce(a.period, b.period, c.period),
	--		coalesce(a.ledger_account,b.ledger_account,c.ledger_account)

UNION

-- 21 
 select coalesce(a.ledger_account,b.ledger_account,c.ledger_account) as ledger_account,
		coalesce(a.period, b.period, c.period) as period,
		a.amount as ledger_balances_amount,
		b.amount as gl_cost_transactions_amount,
		a.amount-b.amount as variance,
		c.amount as journal_entry_lines_amount,
		a.amount-c.amount as variance2 from
 (select distinct(ledger_account) as ledger_account, period, isnull(period_amount,0) as amount from ledger_balances where fiscal_year = @fiscal_year and period = @period and ledger = 'EMPIRE' and balance_name = 'ACTUAL' and LEN(ledger_account) = '6' and RIGHT(ledger_account,2) = '21')a
 full outer join
 (select period, ledger_account, SUM(isnull(amount,0)) as amount from gl_cost_transactions where fiscal_year = @fiscal_year and period = @period and ledger = 'EMPIRE' and update_balances = 'Y' and len(ledger_account) = '6' and RIGHT(ledger_account,2) = '21' group by ledger_account, period) b
 on a.ledger_account = b.ledger_account and a.period = b.period
 full outer join 
 (select period, ledger_account, SUM(isnull(amount,0)) as amount from journal_entry_lines where fiscal_year = @fiscal_year and period = @period and balance_name = 'ACTUAL' and len(ledger_account)=6 and RIGHT(ledger_account,2) = '21' group by ledger_account, period) c
 on coalesce(a.ledger_account,b.ledger_account)= c.ledger_account and coalesce(a.period, b.period) = c.period
 -- order by coalesce(a.period, b.period, c.period),
	--		coalesce(a.ledger_account,b.ledger_account,c.ledger_account)
 
 UNION
 
 -- 60
  select coalesce(a.ledger_account,b.ledger_account,c.ledger_account) as ledger_account,
		coalesce(a.period, b.period, c.period) as period,
		a.amount as ledger_balances_amount,
		b.amount as gl_cost_transactions_amount,
		a.amount-b.amount as variance,
		c.amount as journal_entry_lines_amount,
		a.amount-c.amount as variance2 from
 (select distinct(ledger_account) as ledger_account, period, isnull(period_amount,0) as amount from ledger_balances where fiscal_year = @fiscal_year and period = @period and ledger = 'EMPIRE' and balance_name = 'ACTUAL' and LEN(ledger_account) = '6' and RIGHT(ledger_account,2) = '60')a
 full outer join
 (select period, ledger_account, SUM(isnull(amount,0)) as amount from gl_cost_transactions where fiscal_year = @fiscal_year and period = @period and ledger = 'EMPIRE' and update_balances = 'Y' and len(ledger_account) = '6' and RIGHT(ledger_account,2) = '60' group by ledger_account, period) b
 on a.ledger_account = b.ledger_account and a.period = b.period
 full outer join 
 (select period, ledger_account, SUM(isnull(amount,0)) as amount from journal_entry_lines where fiscal_year = @fiscal_year and period = @period and balance_name = 'ACTUAL' and len(ledger_account)=6 and RIGHT(ledger_account,2) = '60' group by ledger_account, period) c
 on coalesce(a.ledger_account,b.ledger_account)= c.ledger_account and coalesce(a.period, b.period) = c.period
  --order by coalesce(a.period, b.period, c.period),
	--		coalesce(a.ledger_account,b.ledger_account,c.ledger_account)
 
 UNION

 -- 08
  select coalesce(a.ledger_account,b.ledger_account,c.ledger_account) as ledger_account,
		coalesce(a.period, b.period, c.period) as period,
		a.amount as ledger_balances_amount,
		b.amount as gl_cost_transactions_amount,
		a.amount-b.amount as variance,
		c.amount as journal_entry_lines_amount,
		a.amount-c.amount as variance2 from
 (select distinct(ledger_account) as ledger_account, period, isnull(period_amount,0) as amount from ledger_balances where fiscal_year = @fiscal_year and period = @period and ledger = 'EMPIRE' and balance_name = 'ACTUAL' and LEN(ledger_account) = '6' and RIGHT(ledger_account,2) = '08')a
 full outer join
 (select period, ledger_account, SUM(isnull(amount,0)) as amount from gl_cost_transactions where fiscal_year = @fiscal_year and period = @period and ledger = 'EMPIRE' and update_balances = 'Y' and len(ledger_account) = '6' and RIGHT(ledger_account,2) = '08' group by ledger_account, period) b
 on a.ledger_account = b.ledger_account and a.period = b.period
 full outer join 
 (select period, ledger_account, SUM(isnull(amount,0)) as amount from journal_entry_lines where fiscal_year = @fiscal_year and period = @period and balance_name = 'ACTUAL' and len(ledger_account)=6 and RIGHT(ledger_account,2) = '08' group by ledger_account, period) c
 on coalesce(a.ledger_account,b.ledger_account)= c.ledger_account and coalesce(a.period, b.period) = c.period
  --order by coalesce(a.period, b.period, c.period),
	--		coalesce(a.ledger_account,b.ledger_account,c.ledger_account)
 
 UNION
 
 -- 12
   select coalesce(a.ledger_account,b.ledger_account,c.ledger_account) as ledger_account,
		coalesce(a.period, b.period, c.period) as period,
		a.amount as ledger_balances_amount,
		b.amount as gl_cost_transactions_amount,
		a.amount-b.amount as variance,
		c.amount as journal_entry_lines_amount,
		a.amount-c.amount as variance2 from
 (select distinct(ledger_account) as ledger_account, period, isnull(period_amount,0) as amount from ledger_balances where fiscal_year = @fiscal_year and period = @period and ledger = 'EMPIRE' and balance_name = 'ACTUAL' and LEN(ledger_account) = '6' and RIGHT(ledger_account,2) = '12')a
 full outer join
 (select period, ledger_account, SUM(isnull(amount,0)) as amount from gl_cost_transactions where fiscal_year = @fiscal_year and period = @period and ledger = 'EMPIRE' and update_balances = 'Y' and len(ledger_account) = '6' and RIGHT(ledger_account,2) = '12' group by ledger_account, period) b
 on a.ledger_account = b.ledger_account and a.period = b.period
 full outer join 
 (select period, ledger_account, SUM(isnull(amount,0)) as amount from journal_entry_lines where fiscal_year = @fiscal_year and period = @period and balance_name = 'ACTUAL' and len(ledger_account)=6 and RIGHT(ledger_account,2) = '12' group by ledger_account, period) c
 on coalesce(a.ledger_account,b.ledger_account)= c.ledger_account and coalesce(a.period, b.period) = c.period
  --order by coalesce(a.period, b.period, c.period),
	--		coalesce(a.ledger_account,b.ledger_account,c.ledger_account)
 
 UNION

 --09
 select coalesce(a.ledger_account,b.ledger_account,c.ledger_account) as ledger_account,
		coalesce(a.period, b.period, c.period) as period,
		a.amount as ledger_balances_amount,
		b.amount as gl_cost_transactions_amount,
		a.amount-b.amount as variance,
		c.amount as journal_entry_lines_amount,
		a.amount-c.amount as variance2 from
 (select distinct(ledger_account) as ledger_account, period, isnull(period_amount,0) as amount from ledger_balances where fiscal_year = @fiscal_year and period = @period and ledger = 'EMPIRE' and balance_name = 'ACTUAL' and LEN(ledger_account) = '6' and RIGHT(ledger_account,2) = '09')a
 full outer join
 (select period, ledger_account, SUM(isnull(amount,0)) as amount from gl_cost_transactions where fiscal_year = @fiscal_year and period = @period and ledger = 'EMPIRE' and update_balances = 'Y' and len(ledger_account) = '6' and RIGHT(ledger_account,2) = '09' group by ledger_account, period) b
 on a.ledger_account = b.ledger_account and a.period = b.period
 full outer join 
 (select period, ledger_account, SUM(isnull(amount,0)) as amount from journal_entry_lines where fiscal_year = @fiscal_year and period = @period and balance_name = 'ACTUAL' and len(ledger_account)=6 and RIGHT(ledger_account,2) = '09' group by ledger_account, period) c
 on coalesce(a.ledger_account,b.ledger_account)= c.ledger_account and coalesce(a.period, b.period) = c.period
  --order by coalesce(a.period, b.period, c.period),
	--		coalesce(a.ledger_account,b.ledger_account,c.ledger_account)
 
 UNION
 
 --13
    select coalesce(a.ledger_account,b.ledger_account,c.ledger_account) as ledger_account,
		coalesce(a.period, b.period, c.period) as period,
		a.amount as ledger_balances_amount,
		b.amount as gl_cost_transactions_amount,
		a.amount-b.amount as variance,
		c.amount as journal_entry_lines_amount,
		a.amount-c.amount as variance2 from
 (select distinct(ledger_account) as ledger_account, period, isnull(period_amount,0) as amount from ledger_balances where fiscal_year = @fiscal_year and period = @period and ledger = 'EMPIRE' and balance_name = 'ACTUAL' and LEN(ledger_account) = '6' and RIGHT(ledger_account,2) = '13')a
 full outer join
 (select period, ledger_account, SUM(isnull(amount,0)) as amount from gl_cost_transactions where fiscal_year = @fiscal_year and period = @period and ledger = 'EMPIRE' and update_balances = 'Y' and len(ledger_account) = '6' and RIGHT(ledger_account,2) = '13' group by ledger_account, period) b
 on a.ledger_account = b.ledger_account and a.period = b.period
 full outer join 
 (select period, ledger_account, SUM(isnull(amount,0)) as amount from journal_entry_lines where fiscal_year = @fiscal_year and period = @period and balance_name = 'ACTUAL' and len(ledger_account)=6 and RIGHT(ledger_account,2) = '13' group by ledger_account, period) c
 on coalesce(a.ledger_account,b.ledger_account)= c.ledger_account and coalesce(a.period, b.period) = c.period
  order by coalesce(a.period, b.period, c.period),
		coalesce(a.ledger_account,b.ledger_account,c.ledger_account)
 



 /*
 select coalesce(a.ledger_account, b.ledger_account) as ledger_account,
 coalesce(a.period, b.period) as period,
 a.amount as combined_ledger_amount,
 b.amount as individual_ledgers_amount,
 a.amount-b.amount as variance 
 from 
 ( select left(ledger_account,4) as ledger_account, period, isnull(sum(period_amount),0) as amount from ledger_balances where fiscal_year = @fiscal_year and period = @period and ledger = 'EMPIRE' and balance_name = 'ACTUAL' and len(ledger_account) = '5' and right(ledger_account,1) = '1' group by left(ledger_account,4), period) a
 full outer join
 (select left(ledger_account,4) as ledger_account, period, isnull(sum(period_amount),0) as amount from ledger_balances where fiscal_year = @fiscal_year and period = @period and ledger = 'EMPIRE' and balance_name = 'ACTUAL' and len(ledger_account) = '6' and right(ledger_account,2) in ('08','09','10','11','12','13','14','21','22','51','52','60','61') group by left(ledger_account,4), period)b
 on a.ledger_account = b.ledger_account and a.period = b.period
*/

 -- update ledger_balances set period_amount =   -695056.270000  where fiscal_year = '2014' and period = 4 and ledger_account  = '11201'




/*
select a.gl_entry as gl_cost_transactions_gl_entry, b.gl_entry as journal_entry_line_gl_entry, a.amount as gl_cost_transactions_amount, b.amount as gl_entry_amount from 
(select gl_entry, SUM(amount) as amount from gl_cost_transactions where fiscal_year = '2014' and period = 1 and ledger = 'EMPIRE' and update_balances = 'Y' and len(ledger_account) = '6' group by gl_entry) a
 full outer join
(select * from journal_entry_lines where fiscal_year = '2014' and period = 1 and balance_name = 'ACTUAL') b
on a.gl_entry = b.gl_entry 
 
 

 
 select gl_entry, right(ledger_account,2), sum(amount) from journal_entry_lines where fiscal_year = '2014' and period = 0 group by gl_entry, right(ledger_account,2) having sum(amount) <> 0 
 
 
 select coalesce(a.fiscal_year,b.fiscal_year) as fiscal_year, coalesce(a.period,b.period) as period, coalesce(a.base_ledger_account,b.base_ledger_account) as base_ledger_account, a.period_amount as combined_amount, b.period_amount as summed_amount, a.period_amount-b.period_amount as variance from
(select fiscal_year, period, LEFT(ledger_account,4) as base_ledger_account, period_amount from ledger_balances where LEN(ledger_account)=5 )a
full outer join
(select fiscal_year, period, LEFT(ledger_account,4) as base_ledger_account, SUM(period_amount) as period_amount from ledger_balances where len(ledger_account)=6 group by fiscal_year, period, LEFT(ledger_account,4))b
on a.fiscal_year = b.fiscal_year and a.period = b.period and a.base_ledger_account = b.base_ledger_account
where a.fiscal_year = '2014'
order by fiscal_year, period, base_ledger_account

select coalesce(a.fiscal_year, b.fiscal_year) as fiscal_year, coalesce(a.period, b.period) as period, coalesce(a.ledger_account, b.ledger_account) as ledger_account, coalesce(a.org,b.org) as org, ISNULL(a.period_amount,0) as eeh_period_amount, ISNULL(b.period_amount,0) as eei_period_amount, ISNULL(a.period_amount,0)-ISNULL(b.period_amount,0) as variance from
(select fiscal_year, period, ledger_account, RIGHT(ledger_account,2) as org, period_amount from [eehsql1].monitor.dbo.ledger_balances where fiscal_year = '2014' and LEN(ledger_account)=6)a
full outer join 
(select fiscal_year, period, ledger_account, RIGHT(ledger_account,2) as org, period_amount from ledger_balances where fiscal_year = '2014' and LEN(ledger_account)=6 and RIGHT(ledger_account,2) in ('08','12'))b
on a.fiscal_year = b.fiscal_year and a.period = b.period and a.ledger_account = b.ledger_account
order by fiscal_year, period, org, ledger_account


update ledger_balances set period_amount = -427285.55 where fiscal_year = '2014' and ledger = 'EMPIRE' and ledger_account = '303011' and balance_name = 'ACTUAL' and period = 1


select * from ledger_balances where ledger_account like '3030%' and fiscal_year = '2014' and balance_name = 'ACTUAL'

*/
 
 
 
GO
