SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE  [dbo].[Proc_CenterCostDataByYearPCB]
(
	@Period	INT
)
WITH RECOMPILE

AS
BEGIN

	DECLARE @CenterCosts TABLE
	(
		posting_account		VARCHAR(90),
		CenterCost			VARCHAR(50),
		--Amount				DECIMAL(18,2),
		--Period		    INT
		January				DECIMAL(18,2),
		February			DECIMAL(18,2),
		March				DECIMAL(18,2),
		April				DECIMAL(18,2),
		May					DECIMAL(18,2),
		June				DECIMAL(18,2),
		July				DECIMAL(18,2),
		August			    DECIMAL(18,2),
		September		    DECIMAL(18,2),
		October			    DECIMAL(18,2),
		November		    DECIMAL(18,2),
		December		    DECIMAL(18,2)
	)

	
	
	INSERT INTO @CenterCosts(posting_account, CenterCost, January, February, March, April, May, June, July, August,
							 September, October, November, December)

	

	SELECT posting_account, CenterCost, January = SUM(January),
February = SUM(February),
March = SUM(March),
April = SUM(April),
May = SUM(May),
June = SUM(June),
July = SUM(July),
August = SUM(August),
September = SUM(September),
October = SUM(October),
November = SUM(November),
December = SUM(December)
 FROM
(
	SELECT posting_account, CenterCost, 
	January = CASE WHEN period = 1 THEN Amount ELSE 0 END,
	February = CASE WHEN period = 2 THEN Amount ELSE 0 END,
	March = CASE WHEN period = 3 THEN Amount ELSE 0 END,
	April = CASE WHEN period = 4 THEN Amount ELSE 0 END,
	May = CASE WHEN period = 5 THEN Amount ELSE 0 END,
	June = CASE WHEN period = 6 THEN Amount ELSE 0 END,
	July = CASE WHEN period = 7 THEN Amount ELSE 0 END,
	August = CASE WHEN period = 8 THEN Amount ELSE 0 END,
	September = CASE WHEN period = 9 THEN Amount ELSE 0 END,
	October = CASE WHEN period = 10 THEN Amount ELSE 0 END,
	November = CASE WHEN period = 11 THEN Amount ELSE 0 END,
	December = CASE WHEN period = 12 THEN Amount ELSE 0 END
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
WHERE lb.ledger = 'HONDURAS' AND lb.balance_name = 'ACTUAL' AND LEN(lb.posting_account) >= 6 AND lb.posting_account > '400000'
) AS Datos
WHERE fiscal_year = @period
		--AND posting_account like '%Direct Labor%'
	--	AND period = @Period
		--AND posting_account LIKE '%5571%'
		--AND ISNULL(organization, 'Total') NOT LIKE '%8%'
			AND RIGHT( LEFT(  posting_account , 6), 1) = '8'
GROUP BY fiscal_year, ledger, posting_account, organization, balance_name, Account, account_description, period
) AS Costs
) AS YearData
GROUP BY posting_account, CenterCost




--INSERT INTO @CenterCosts(posting_account, CenterCost, Amount, Period)
INSERT INTO @CenterCosts(posting_account, CenterCost, January, February, March, April, May, June, July, August,
							 September, October, November, December)

/*
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

*/


SELECT posting_account, CenterCost = '001 - Unallocated',
-- Amount = SUM(Amount), period = @period 
January = SUM(January),
February = SUM(February),
March = SUM(March),
April = SUM(April),
May = SUM(May),
June = SUM(June),
July = SUM(July),
August = SUM(August),
September = SUM(September),
October = SUM(October),
November = SUM(November),
December = SUM(December)
FROM 
(
SELECT posting_account,
-- Amount = SUM(Amount), period 
January = SUM(January),
February = SUM(February),
March = SUM(March),
April = SUM(April),
May = SUM(May),
June = SUM(June),
July = SUM(July),
August = SUM(August),
September = SUM(September),
October = SUM(October),
November = SUM(November),
December = SUM(December)
FROM @CenterCosts
WHERE --period = @Period	AND
 CenterCost = 'Total'
GROUP BY posting_account
--, Period
UNION ALL

SELECT posting_account,
-- Amount = -SUM(Amount), period 
January = -SUM(January),
February = -SUM(February),
March = -SUM(March),
April = -SUM(April),
May = -SUM(May),
June = -SUM(June),
July = -SUM(July),
August = -SUM(August),
September = -SUM(September),
October = -SUM(October),
November = -SUM(November),
December = -SUM(December)
FROM @CenterCosts
WHERE --period = @Period	AND 
CenterCost <> 'Total'
GROUP BY posting_account
--, Period
) AS Data
GROUP BY posting_account
--, period



SELECT * FROM @CenterCosts
WHERE CenterCost <> 'Total'


END



GO
