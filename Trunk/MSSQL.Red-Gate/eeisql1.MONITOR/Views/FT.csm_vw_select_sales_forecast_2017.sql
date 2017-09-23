SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 Create view [FT].[csm_vw_select_sales_forecast_2017]
 as
 SELECT   Base_Part, Period, TotalDemand_Monthly 
FROM eeiuser.acctg_csm_vw_select_sales_forecast
UNPIVOT
(
       TotalDemand_Monthly
       FOR [Period] IN ([Jan_17_TOTALDEMAND] ,[Feb_17_TOTALDEMAND],[Mar_17_TOTALDEMAND],[Apr_17_TOTALDEMAND],[May_17_TOTALDEMAND],[Jun_17_TOTALDEMAND],[Jul_17_TOTALDEMAND],[Aug_17_TOTALDEMAND], [Sep_17_TOTALDEMAND],[Oct_17_TOTALDEMAND],[Nov_17_TOTALDEMAND],[dec_17_TOTALDEMAND])
) AS P
GO
