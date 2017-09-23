SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [EEIUser].[acctg_budget_annual_excel_query] (@fiscal_year varchar(4), @beginning_period int, @ending_period int, @authorized_user varchar(15), @budget_id varchar(50))
as
begin
select * from gl_cost_transactions
where ledger = 'EMPIRE' 
and fiscal_year = @fiscal_year
and period >= @beginning_period
and period <= @ending_period
and update_balances = 'Y'
and ledger_account in
(select distinct(ledger_account) from eeiuser.acctg_budget_groups where authorized_user = @authorized_user and budget_id = @budget_id)
end
GO
