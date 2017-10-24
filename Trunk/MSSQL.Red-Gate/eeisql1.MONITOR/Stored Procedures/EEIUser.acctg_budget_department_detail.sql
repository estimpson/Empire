SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [EEIUser].[acctg_budget_department_detail]
(	@month varchar(50),
	@fiscal_year varchar(4),
	@month_part varchar(3)) 
as
set	nocount on

--declare @month varchar(50);
--declare @fiscal_year varchar(4);
declare @FirstofMonth datetime;
declare @MidofMonth datetime;
declare @EndOfMonth datetime;
--select @month = 'April';
--select @fiscal_year = '2008';
select @FirstofMonth = @fiscal_year + '-' + @month + '-01'
select @MidofMonth = dateadd (s, -1, dateadd (day, 15, @FirstofMonth))
select @EndOfMonth = dateadd (s, -1, dateadd (month, 1, @FirstofMonth))

declare	@PeriodBeginDT datetime,
	@PeriodEndDT datetime,
	@BudgetWeight numeric (2,1)

if	(@month_part = '1H') begin
	--code for '1H'
	select	@PeriodBeginDT = @FirstofMonth,
		@PeriodEndDT = @MidofMonth,
		@BudgetWeight = 0.5
end
else if	(@month_part = '2H') begin
	--code for '2H'
	select	@PeriodBeginDT = dateadd (s, 1, @MidofMonth),
		@PeriodEndDT = @EndOfMonth,
		@BudgetWeight = 0.5
end
else if	(@month_part = 'MTD') begin
	--code for 'MTD'
	select	@PeriodBeginDT = @FirstofMonth,
		@PeriodEndDT = @EndOfMonth,
		@BudgetWeight = 1.0
end

--	Return results.
select	isnull (mtd1.mtd_ledger_account, ytd1.ytd_ledger_account) as ledger_account,
	mtd1.mtd_budget,
	mtd1.mtd_actual,
	mtd1.mtd_variance,
	mtd1.mtd_vpercentage,
	ytd1.ytd_budget,
	ytd1.ytd_actual,
	ytd1.ytd_variance,
	ytd1.ytd_vpercentage
from	(	select	isnull (a1.ledger_account, a2.ledger_account) as mtd_ledger_account,
			isnull (a2.mtd_budget, 0) as mtd_budget,
			isnull (a1.mtd_actual, 0) as mtd_actual,
			isnull (a2.mtd_budget, 0) - isnull (a1.mtd_actual,0) as mtd_variance,
			(isnull (a2.mtd_budget, 0) - isnull (a1.mtd_actual, 0)) / nullif (a2.mtd_budget, 0) as mtd_vpercentage
		from	(	select	sum (isnull (amount, 0)) as mtd_actual,
					ledger_account
				from	gl_cost_transactions
				where	fiscal_year = @fiscal_year and
					transaction_date >= @PeriodBeginDT and
					transaction_date <= @PeriodEndDT and
					update_balances = 'Y' and
					ledger_account in ('503011')
				group by
					ledger_account) a1
			full join
			(	select	budget_id as ledger_account,
					@BudgetWeight * sum (isnull (period_amount, 0)) as mtd_budget
				from	eeiuser.acctg_budget
				where	fiscal_year = @fiscal_year and
					period = datepart (m, @FirstofMonth) and
					budget_id in ('503011') and
					budget_line = '2008 Official Budget'
				group by
					budget_id) a2 on a1.ledger_account = a2.ledger_account) mtd1
	full join
	(	select	isnull (b1.ledger_account, b2.ledger_account) as ytd_ledger_account,
			isnull (b2.ytd_budget,0) as ytd_budget,
			isnull (b1.ytd_actual,0) as ytd_actual,
			isnull (b2.ytd_budget,0) - isnull (b1.ytd_actual,0) as ytd_variance,
			(isnull (b2.ytd_budget, 0) - isnull (b1.ytd_actual, 0)) / nullif (b2.ytd_budget, 0) as ytd_vpercentage
		from	(	select	ledger_account,
					ytd_actual = sum (isnull (amount, 0))
				from	gl_cost_transactions
				where	fiscal_year = @fiscal_year and
					transaction_date >= '2008-01-01' and
					transaction_date <= @PeriodEndDT and
					update_balances = 'Y' and
					ledger_account in ('503011')
				group by
					ledger_account) b1
			full join
			(	select	budget_id as ledger_account,
					sum (isnull (period_amount, 0)) as ytd_budget
				from	eeiuser.acctg_budget
				where	fiscal_year = @fiscal_year and
					period <= datepart (m, @FirstofMonth) and
					budget_id in ('503011') and
					budget_line = '2008 Official Budget'
				group by
					budget_id) b2 on b1.ledger_account = b2.ledger_account) ytd1 on mtd1.mtd_ledger_account = ytd1.ytd_ledger_account
GO
