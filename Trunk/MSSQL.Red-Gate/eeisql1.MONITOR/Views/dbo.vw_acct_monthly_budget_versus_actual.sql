SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_acct_monthly_budget_versus_actual]

as

SELECT right(ledger_account,2) AS 'organization', left(ledger_account,4) AS 'base_account', ledger_balances.ledger_account, ledger_balances.fiscal_year, ledger_balances.period, ledger_balances.period_amount
FROM MONITOR.dbo.ledger_balances ledger_balances
WHERE (ledger_balances.balance_name='ACTUAL') AND (ledger_balances.fiscal_year In ('2008','2009')) AND (len(ledger_account)=6) AND (ledger_balances.ledger_account>='401011')
GO
