SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE  [dbo].[Proc_CenterCostData]
(
	@Period	INT
)
WITH RECOMPILE

AS
BEGIN

	DECLARE @CenterCosts TABLE
	(
		posting_account VARCHAR(90),
		CenterCost	   VARCHAR(50),
		Amount		   DECIMAL(18,2),
		Period		   INT
	)

	
	
	INSERT INTO @CenterCosts(posting_account, CenterCost, Amount, Period)

	
	SELECT posting_account, CenterCost, Amount, period
FROM
(
SELECT posting_account, CenterCost = ISNULL(organization, 'Total'),
--Description = CASE WHEN organization IS NULL THEN ELSE organization END, 
 --Account, 
 --account_description,
 --Total =  CASE WHEN ISNULL(organization, 'Total') = 'Total' THEN SUM(TotalAmount) ELSE 0 END,
 Amount = SUM(TotalAmount), period
FROM 
(
SELECT lb.fiscal_year, lb.ledger, LEFT(lb.posting_account, 6) + ' - ' + coa.account_description AS posting_account,
	 (CASE LEN(lb.posting_account) WHEN 9 THEN RIGHT(lb.posting_account, 3) ELSE '' END) + ' - ' + lo.organization_description AS organization, LEFT(lb.posting_account, 6) AS Account, account_description,
	 lb.balance_name, lb.period, TotalAmount = lb.period_amount
FROM Monitor.dbo.ledger_balances lb 
	LEFT JOIN Monitor.dbo.ledger_organizations lo 
		on (case len(lb.posting_account) WHEN 9 then RIGHT(lb.posting_account, 3) ELSE '' END) = lo.organization 
			AND lb.fiscal_year = lo.fiscal_year 
			AND lb.ledger = lo.ledger
	LEFT JOIN monitor.dbo.chart_of_account_items coa
		ON LEFT(lb.posting_account,4) = coa.account
			AND lb.fiscal_year = coa.fiscal_year
			AND coa.coa = 'EEI MASTER'
WHERE lb.ledger = 'HONDURAS' AND lb.balance_name = 'ACTUAL' AND LEN(lb.posting_account) >= 6 AND lb.posting_account > 500000
) AS Datos
WHERE fiscal_year = 2016
		--AND posting_account like '%Direct Labor%'
		AND period = @Period
		--AND posting_account LIKE '%5571%'
		AND ISNULL(organization, 'Total') NOT LIKE '%8%'
GROUP BY fiscal_year, ledger, posting_account, organization, balance_name, Account, account_description, period
) AS Costs


INSERT INTO @CenterCosts(posting_account, CenterCost, Amount, Period)

SELECT posting_account, CenterCost = '001 - Unallocated', Amount = SUM(Amount), period = @period FROM 
(
SELECT posting_account, Amount = SUM(Amount), period 
FROM @CenterCosts
WHERE period = @Period
	AND CenterCost = 'Total'
GROUP BY posting_account, Period
UNION ALL
SELECT posting_account, Amount = -SUM(Amount), period 
FROM @CenterCosts
WHERE period = @Period
	AND CenterCost <> 'Total'
GROUP BY posting_account, Period
) AS Data
GROUP BY posting_account, period


SELECT * FROM @CenterCosts
WHERE CenterCost <> 'Total'


END



GO
GRANT EXECUTE ON  [dbo].[Proc_CenterCostData] TO [public]
GO
GRANT VIEW DEFINITION ON  [dbo].[Proc_CenterCostData] TO [public]
GO
