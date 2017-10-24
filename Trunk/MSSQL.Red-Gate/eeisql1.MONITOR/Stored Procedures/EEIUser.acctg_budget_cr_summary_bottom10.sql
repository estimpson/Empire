SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[acctg_budget_cr_summary_bottom10]
(	@budget_id varchar(50),
    @organization varchar(3),	
	@fiscal_year varchar(4),
	@Period int,
    @month_part varchar(3),
    @user_id varchar(25)
) 
as
declare @FirstofMonth datetime;
declare @MidofMonth datetime;
declare @EndOfMonth datetime;
select @FirstofMonth = @fiscal_year + '-' + convert(varchar(2),@Period) + '-01 00:00:00'
select @MidofMonth = dateadd (s, -1, dateadd (day, 15, @FirstofMonth))
select @EndOfMonth = dateadd (s, -1, dateadd (month, 1, @FirstofMonth))

CREATE table #selected_organizations (organization varchar(3) NOT NULL);
if @organization = 'All'
begin 
insert into #selected_organizations
select 11
insert into #selected_organizations
select 12
insert into #selected_organizations
select 13
insert into #selected_organizations
select 14
insert into #selected_organizations
select 21
insert into #selected_organizations
select 22
insert into #selected_organizations
select 60
insert into #selected_organizations
select 61
end
else
begin
insert into #selected_organizations
select @organization
end




CREATE table #authorized_ledger_accounts(
    ledger_account varchar(50) NOT NULL);

if @user_id in ('Dan','Ken','Chris')
begin
insert into #authorized_ledger_accounts
select ab1.ledger_account from eeiuser.acctg_budget ab1 where ab1.budget_id = @budget_id and right(ab1.ledger_account,2) in (select organization from #selected_organizations)
union
select distinct(gct.ledger_account) from gl_cost_transactions gct where gct.ledger = 'EMPIRE' and gct.fiscal_year = @fiscal_year and gct.update_balances = 'Y' and len(gct.ledger_account)=6 and right(gct.ledger_account,2) in (select organization from #selected_organizations) and left(gct.ledger_account,4) > '5019'
end
else
begin
insert into #authorized_ledger_accounts
select abg1.ledger_account from eeiuser.acctg_budget_groups abg1 where abg1.authorized_user = @user_id and abg1.budget_id = @budget_id

end


create table #ledger_header(
	ledger_account varchar(50) NOT NULL,
	primary_manager varchar(50),
	secondary_manager varchar(50),
	champion varchar(50),
	department varchar(50));

insert into #ledger_header
select distinct(ledger_account), primary_manager, secondary_manager, champion, department from eeiuser.acctg_budget_groups where budget_id = @budget_id


declare	@PeriodBeginDate datetime,
	@PeriodEndDate datetime,
	@BudgetWeight numeric (2,1)

if	(@month_part = '1H') begin
	--code for '1H'
	select	@PeriodBeginDate = @FirstofMonth,
		@PeriodEndDate = @MidofMonth,
		@BudgetWeight = 0.5
end
else if	(@month_part = '2H') begin
	--code for '2H'
	select	@PeriodBeginDate = dateadd (s, 1, @MidofMonth),
		@PeriodEndDate = @EndOfMonth,
		@BudgetWeight = 0.5
end
else if	(@month_part = 'MTD') begin
	--code for 'MTD'
	select	@PeriodBeginDate = @FirstofMonth,
		@PeriodEndDate = @EndOfMonth,
		@BudgetWeight = 1.0
end

--	Return results.
select TOP 10 @FirstofMonth, @MidofMonth, @EndOfMonth, @PeriodBeginDate, @PeriodEndDate, @BudgetWeight, f1.ledger_account, lh.primary_manager, lh.champion, lh.department, account_description, budget_line, budget_description, mtd_budget, mtd_actual, mtd_variance, mtd_vpercentage,ytd_budget,ytd_actual,ytd_variance,ytd_vpercentage from(
select	isnull (mtd1.mtd_ledger_account, ytd1.ytd_ledger_account) as ledger_account,
    isnull(mtd1.mtd_budget_line, ytd1.ytd_budget_line) as budget_line,
	isnull(mtd1.mtd_budget_description, ytd1.ytd_budget_description) as budget_description,
    mtd1.mtd_budget,
	mtd1.mtd_actual,
	(mtd1.mtd_actual - mtd1.mtd_budget) as mtd_variance,
	(case when mtd1.mtd_budget = 0 then (case when (mtd1.mtd_actual-mtd1.mtd_budget) > 0 then 1 else (case when (mtd1.mtd_actual-mtd1.mtd_budget) < 0 then -1 else 0 end)end) else (mtd1.mtd_actual-mtd1.mtd_budget)/mtd1.mtd_budget end) as mtd_vpercentage,
	(isnull(ytd1.ytd_budget,0)+isnull(mtd1.mtd_budget,0)) as ytd_budget,
	(isnull(ytd1.ytd_actual,0)+isnull(mtd1.mtd_actual,0)) as ytd_actual,
	((isnull(ytd1.ytd_actual,0)+isnull(mtd1.mtd_actual,0))-(isnull(ytd1.ytd_budget,0)+isnull(mtd1.mtd_budget,0))) as ytd_variance,
	(case when isnull(ytd1.ytd_budget,0) = 0 then (case when ((isnull(ytd1.ytd_actual,0)+isnull(mtd1.mtd_actual,0))-(isnull(ytd1.ytd_budget,0)+isnull(mtd1.mtd_budget,0))) > 0 then 1 else (case when ((isnull(ytd1.ytd_actual,0)+isnull(mtd1.mtd_actual,0))-(isnull(ytd1.ytd_budget,0)+isnull(mtd1.mtd_budget,0))) < 0 then -1 else 0 end)end) else ((isnull(ytd1.ytd_actual,0)+isnull(mtd1.mtd_actual,0))-(isnull(ytd1.ytd_budget,0)+isnull(mtd1.mtd_budget,0)))/(isnull(ytd1.ytd_budget,0)+isnull(mtd1.mtd_budget,0)) end) as ytd_vpercentage
from	(	select	isnull (a1.ledger_account, a2.ledger_account) as mtd_ledger_account,
			isnull(a1.budget_line, a2.budget_line) as mtd_budget_line,
			a2.budget_description as mtd_budget_description,
			isnull (a2.mtd_budget, 0) as mtd_budget,
			isnull (a1.mtd_actual, 0) as mtd_actual
		from	(	select gct.ledger_account as ledger_account,
					(case when (gct.contract_account_id is null or gct.contract_account_id = '') then gct.ledger_account+'-9999' else gct.contract_account_id end) as budget_line,
					sum (isnull (gct.amount, 0)) as mtd_actual
				from	gl_cost_transactions gct
				where gct.fiscal_year = @Fiscal_Year and
					gct.transaction_date >= @PeriodBeginDate and
					gct.transaction_date <= @PeriodEndDate and
					gct.update_balances = 'Y' and
					len(gct.ledger_account) = 6 and
                    right(gct.ledger_account,2) in ('11','12','21') and
					left(gct.ledger_account,4) >= '5020' and
					gct.ledger_account in (select distinct(ala.ledger_account) from #authorized_ledger_accounts ala)
				group by
					gct.ledger_account, (case when (gct.contract_account_id is null or gct.contract_account_id = '') then gct.ledger_account+'-9999' else gct.contract_account_id end)) a1
			full join
			(	select	ab.ledger_account,
						budget_line,
						budget_description,
						sum (isnull (period_amount*@budgetweight, 0)) as mtd_budget
				from	eeiuser.acctg_budget ab
				where	ab.fiscal_year = @fiscal_year
						and ab.period = @Period
						and len(ab.ledger_account) = 6
						and right(ab.ledger_account,2) in ('11','12','21')
						and left(ab.ledger_account,4) >= '5020'
						and ab.budget_id = @budget_id
						and ab.ledger_account in (select distinct(ala.ledger_account) from #authorized_ledger_accounts ala)
				group by ab.ledger_account, ab.budget_line, ab.budget_description) a2 on a1.ledger_account = a2.ledger_account and a1.budget_line = a2.budget_line) mtd1
	full join
	(	select	isnull (b1.ledger_account, b2.ledger_account) as ytd_ledger_account,
			isnull(b1.budget_line, b2.budget_line) as ytd_budget_line,
			b2.budget_description as ytd_budget_description,
			isnull (b2.ytd_budget,0) as ytd_budget,
			isnull (b1.ytd_actual,0) as ytd_actual
		from	(	select gct.ledger_account as ledger_account,
					(case when (gct.contract_account_id is null or gct.contract_account_id = '') then gct.ledger_account+'-9999' else gct.contract_account_id end) as budget_line,
					sum (isnull (amount, 0)) as ytd_actual
				from	gl_cost_transactions gct
				where	gct.fiscal_year = @fiscal_year and
					gct.transaction_date >= '2008-01-01' and
					gct.transaction_date < @PeriodBeginDate and
					gct.update_balances = 'Y' and
					len(gct.ledger_account) = 6 and
					right(gct.ledger_account,2) in ('11','12','21') and
					left(gct.ledger_account,4) >= '5020' and
					gct.ledger_account in (select distinct(ala.ledger_account) from #authorized_ledger_accounts ala)
				group by gct.ledger_account, (case when (gct.contract_account_id is null or gct.contract_account_id = '') then gct.ledger_account+'-9999' else gct.contract_account_id end)) b1
			full join
			(	select  ab.ledger_account,
						budget_line,
						budget_description,
						sum (isnull (period_amount, 0)) as ytd_budget
				from	eeiuser.acctg_budget ab
				where	ab.fiscal_year = @fiscal_year
						and ab.period < @Period
						and len(ab.ledger_account) = 6
						and right(ab.ledger_account,2) in ('11','12','21')
						and left(ab.ledger_account,4) >= '5020'
						and ab.budget_id = @budget_id
						and ab.ledger_account in (select distinct(ala.ledger_account) from #authorized_ledger_accounts ala)
				group by ab.ledger_account, ab.budget_line, ab.budget_description) b2 on b1.ledger_account = b2.ledger_account and b1.budget_line = b2.budget_line) ytd1 
		on mtd1.mtd_ledger_account = ytd1.ytd_ledger_account and mtd1.mtd_budget_line = ytd1.ytd_budget_line) f1
left join
chart_of_accounts on chart_of_accounts.account = left(f1.ledger_account,4) and chart_of_accounts.fiscal_year = @fiscal_year
left outer join #ledger_header lh on convert(varchar(50),lh.ledger_account) = convert(varchar(50),f1.ledger_account)
order by mtd_variance desc
GO
