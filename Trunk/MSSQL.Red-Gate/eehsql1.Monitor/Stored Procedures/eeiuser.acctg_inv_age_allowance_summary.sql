SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [eeiuser].[acctg_inv_age_allowance_summary] @asofdate datetime

--exec eeiuser.acctg_inv_age_allowance_summary '2015-08-03 23:55:00.400'

as

SELECT	a.asofdate, 
		a.receivedfiscalyear, 
		a.receivedperiod, 
        SUM(CASE WHEN ISNULL(a.at_risk, 0) <> 1 THEN a.ext_material_cum - a.Net_RM_104_Wk_material ELSE 0 END)AS [Good (est consumed w/in 2 yrs)],		

        SUM(CASE WHEN ISNULL(a.at_risk, 0) = 1 THEN a.ext_material_cum ELSE 0 END)AS [Obsolete (marked at risk)],        
        - AVG(b.obsolete_allowance) AS [Allowance for Obsolete Inventory],
        - AVG(b.obsolete_allowance) - SUM(CASE WHEN a.at_risk = 1 THEN a.ext_material_cum ELSE 0 END) AS [Over/Under Accrued for Obsolete Inventory],                        
 
        SUM(CASE WHEN ISNULL(a.at_risk, 0) <> 1 THEN a.Net_RM_104_Wk_Material ELSE 0 END)AS [Excess (est value on hand after 2 yrs)], 
        - AVG(b.excess_allowance) AS [Allowance for Excess Inventory], 
        - AVG(b.excess_allowance) - SUM(CASE WHEN a.at_risk <> 1 THEN a.Net_RM_104_Wk_Material ELSE 0 END) AS [Over/Under Accrued for Excess Inventory],
     
        SUM(a.ext_material_cum) AS [Total Inventory on Hand]
 
FROM    EEIUser.acctg_inv_age_review AS a 
			LEFT OUTER JOIN
        EEIUser.acctg_inv_age_allowance AS b	
			ON	a.asofdate = b.asofdate 
			AND a.receivedfiscalyear = b.receivedfiscalyear 
			AND a.receivedperiod = b.receivedperiod
			
WHERE	a.asofdate = (select max(asofdate) from eeiuser.acctg_inv_age_review) -- @asofdate

GROUP BY	a.asofdate, 
			a.receivedfiscalyear, 
			a.receivedperiod
			
ORDER BY	a.receivedfiscalyear,
			a.receivedperiod
GO
