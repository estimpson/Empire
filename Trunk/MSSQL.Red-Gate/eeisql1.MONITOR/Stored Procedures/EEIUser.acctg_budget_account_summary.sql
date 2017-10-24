SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [EEIUser].[acctg_budget_account_summary]
(	@month varchar(50),
	@fiscal_year varchar(4),
	@month_part varchar(3),
    @user_id varchar(25)) 
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


CREATE table #authorized_ledger_accounts(
    ledger_account varchar(50) NOT NULL);

if @user_id in ('Dan','Ken','Chris')
begin
insert into #authorized_ledger_accounts
select ledger_account from eeiuser.acctg_budget where budget_id = '2008 Official Budget'
end
else
begin
insert into #authorized_ledger_accounts
select ledger_account from eeiuser.acctg_budget_groups where authorized_user = @user_id and budget_id = '2008 Official Budget'
end

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
			isnull (a1.mtd_actual, 0) - isnull (a2.mtd_budget,0) as mtd_variance,
			(isnull (a1.mtd_actual, 0) - isnull (a2.mtd_budget, 0)) / nullif (a2.mtd_budget, 0) as mtd_vpercentage
		from	(	select	sum (isnull (amount, 0)) as mtd_actual,
					ledger_account
				from	gl_cost_transactions
				where	fiscal_year = @fiscal_year and
					transaction_date >= @PeriodBeginDT and
					transaction_date <= @PeriodEndDT and
					update_balances = 'Y' and
					len(ledger_account) = 6 and
                    right(ledger_account,2) = '11' and
					left(ledger_account,4) >= '5020' and
					ledger_account in (select ledger_account from #authorized_ledger_accounts)
				group by
					ledger_account) a1
			full join
			(	select	ledger_account as ledger_account,
					@BudgetWeight * sum (isnull (period_amount, 0)) as mtd_budget
				from	eeiuser.acctg_budget
				where	fiscal_year = @fiscal_year and
					period = datepart (m, @FirstofMonth) and
					len(ledger_account) = 6 and
					right(ledger_account,2) = '11' and
					left(ledger_account,4) >= '5020' and
					budget_id = '2008 Official Budget' and
					ledger_account in (select ledger_account from #authorized_ledger_accounts)
				group by
					ledger_account) a2 on a1.ledger_account = a2.ledger_account) mtd1
	full join
	(	select	isnull (b1.ledger_account, b2.ledger_account) as ytd_ledger_account,
			isnull (b2.ytd_budget,0) as ytd_budget,
			isnull (b1.ytd_actual,0) as ytd_actual,
			isnull (b1.ytd_actual,0) - isnull (b2.ytd_budget,0) as ytd_variance,
			(isnull (b1.ytd_actual, 0) - isnull (b2.ytd_budget,0)) / nullif (b2.ytd_budget, 0) as ytd_vpercentage
		from	(	select	ledger_account,
					ytd_actual = sum (isnull (amount, 0))
				from	gl_cost_transactions
				where	fiscal_year = @fiscal_year and
					transaction_date >= '2008-01-01' and
					transaction_date <= @PeriodEndDT and
					update_balances = 'Y' and
					len(ledger_account) = 6 and
					right(ledger_account,2) = '11' and
					left(ledger_account,4) >= '5020' and
					ledger_account in (select ledger_account from #authorized_ledger_accounts)
				group by
					ledger_account) b1
			full join
			(	select	ledger_account as ledger_account,
					sum (isnull (period_amount, 0)) as ytd_budget
				from	eeiuser.acctg_budget
				where	fiscal_year = @fiscal_year and
					period <= datepart (m, @FirstofMonth) and
					len(ledger_account) = 6 and
					right(ledger_account,2) = '11' and
					left(ledger_account,4) >= '5020' and
					budget_id = '2008 Official Budget' and
					ledger_account in (select ledger_account from #authorized_ledger_accounts)
				group by
					ledger_account) b2 on b1.ledger_account = b2.ledger_account) ytd1 on mtd1.mtd_ledger_account = ytd1.ytd_ledger_account
GO
