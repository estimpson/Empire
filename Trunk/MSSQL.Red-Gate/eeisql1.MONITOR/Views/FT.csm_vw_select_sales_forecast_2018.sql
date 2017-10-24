SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 Create view [FT].[csm_vw_select_sales_forecast_2018]
 as
 SELECT   Base_Part, Period, TotalDemand_Monthly 
FROM eeiuser.acctg_csm_vw_select_sales_forecast
UNPIVOT
(
       TotalDemand_Monthly
       FOR [Period] IN ([Jan_18_TOTALDEMAND] ,[Feb_18_TOTALDEMAND],[Mar_18_TOTALDEMAND],[Apr_18_TOTALDEMAND],[May_18_TOTALDEMAND],[Jun_18_TOTALDEMAND],[Jul_18_TOTALDEMAND],[Aug_18_TOTALDEMAND], [Sep_18_TOTALDEMAND],[Oct_18_TOTALDEMAND],[Nov_18_TOTALDEMAND],[dec_18_TOTALDEMAND])
) AS P
GO
