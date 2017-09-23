SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[acctg_budget_authorized_ledger_accounts] (@user_id varchar(50), @budget_id varchar(50), @organization varchar(3), @fiscal_year varchar(4))
as
if @user_id in ('Dan','Ken','Chris','Ed','Cara')
begin
	if @organization = 'all'
	begin
	select distinct(ab1.ledger_account), ab1.ledger_account+'   '+ISNULL(coa.account_description,'not defined') as account_description from eeiuser.acctg_budget ab1 left join chart_of_accounts coa on left(ab1.ledger_account,4) = coa.account where ab1.budget_id = @budget_id and ab1.fiscal_year = @fiscal_year and coa.fiscal_year = @fiscal_year
	union
	select distinct(gct.ledger_account), gct.ledger_account+'   '+ISNULL(coa.account_description,'not defined') as account_description from gl_cost_transactions gct left join chart_of_accounts coa on left(gct.ledger_account,4) = coa.account where gct.ledger = 'EMPIRE' and coa.fiscal_year = @fiscal_year and gct.fiscal_year = @fiscal_year and gct.update_balances = 'Y' and len(gct.ledger_account)=6 and gct.ledger_account > '501911'
	order by ledger_account
	end
	else
	select distinct(ab.ledger_account) as ledger_account, ab.ledger_account+'   '+ISNULL(coa.account_description,'not defined') as account_description  from eeiuser.acctg_budget ab left join chart_of_accounts coa on left(ab.ledger_account,4) = coa.account where ab.budget_id = @budget_id and ab.fiscal_year = @fiscal_year and coa.fiscal_year = @fiscal_year and right(ab.ledger_account,2) = @organization
	union
	select distinct(gct.ledger_account) as ledger_account, gct.ledger_account+'   '+ISNULL(coa.account_description,'not defined') as account_description  from gl_cost_transactions gct left join chart_of_accounts coa on left(gct.ledger_account,4) = coa.account where gct.ledger = 'EMPIRE' and gct.fiscal_year = @fiscal_year and coa.fiscal_year = @fiscal_year and gct.update_balances = 'Y' and len(gct.ledger_account)=6 and right(gct.ledger_account,2) = @organization and gct.ledger_account > '501911'
	order by ledger_account
end
else
	if @organization = 'all'
	begin
	select distinct(abg.ledger_account), abg.ledger_account+'   '+coa.account_description as account_description  from eeiuser.acctg_budget_groups abg left join chart_of_accounts coa on left(abg.ledger_account,4) = coa.account where abg.authorized_user = @user_id and abg.budget_id = @budget_id and coa.fiscal_year = @fiscal_year order by abg.ledger_account
	end
	else
	select distinct(abg.ledger_account), abg.ledger_account+'   '+coa.account_description as account_description  from eeiuser.acctg_budget_groups abg left join chart_of_accounts coa on left(abg.ledger_account,4) = coa.account where abg.authorized_user = @user_id and abg.budget_id = @budget_id and right(abg.ledger_account,2) = @organization and coa.fiscal_year = @fiscal_year order by abg.ledger_account
GO
