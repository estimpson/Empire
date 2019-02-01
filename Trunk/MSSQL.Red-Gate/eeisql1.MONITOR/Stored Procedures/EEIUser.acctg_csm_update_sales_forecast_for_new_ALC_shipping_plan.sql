SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [EEIUser].[acctg_csm_update_sales_forecast_for_new_ALC_shipping_plan] (@release_id varchar(25))
as


declare @factorresults table 
(
[base_part] varchar(25) NULL,
[sop] date NULL,
[Jan 2019] [decimal](18,2) NULL,
[Feb 2019] [decimal](18,2) NULL,
[Mar 2019] [decimal](18,2) NULL,
[Apr 2019] [decimal](18,2) NULL,
[May 2019] [decimal](18,2) NULL,
[Jun 2019] [decimal](18,2) NULL,
[Jul 2019] [decimal](18,2) NULL,
[Aug 2019] [decimal](18,2) NULL,
[Sep 2019] [decimal](18,2) NULL,
[Oct 2019] [decimal](18,2) NULL,
[Nov 2019] [decimal](18,2) NULL,
[Dec 2019] [decimal](18,2) NULL,

[IHS Jan2019] [decimal](18,2) NULL,
[IHS Feb2019] [decimal](18,2) NULL,
[IHS Mar2019] [decimal](18,2) NULL,
[IHS Apr2019] [decimal](18,2) NULL,
[IHS May2019] [decimal](18,2) NULL,
[IHS Jun2019] [decimal](18,2) NULL,
[IHS Jul2019] [decimal](18,2) NULL,
[IHS Aug2019] [decimal](18,2) NULL,
[IHS Sep2019] [decimal](18,2) NULL,
[IHS Oct2019] [decimal](18,2) NULL,
[IHS Nov2019] [decimal](18,2) NULL,
[IHS Dec2019] [decimal](18,2) NULL,

[Jan 2019 Factor] [decimal](18,2) NULL,
[Feb 2019 Factor] [decimal](18,2) NULL,
[Mar 2019 Factor] [decimal](18,2) NULL,
[Apr 2019 Factor] [decimal](18,2) NULL,
[May 2019 Factor] [decimal](18,2) NULL,
[Jun 2019 Factor] [decimal](18,2) NULL,
[Jul 2019 Factor] [decimal](18,2) NULL,
[Aug 2019 Factor] [decimal](18,2) NULL,
[Sep 2019 Factor] [decimal](18,2) NULL,
[Oct 2019 Factor] [decimal](18,2) NULL,
[Nov 2019 Factor] [decimal](18,2) NULL,
[Dec 2019 Factor] [decimal](18,2) NULL
)

insert @factorresults
select
part,
sop,
[Jan 2019],
[Feb 2019],
[Mar 2019],
[Apr 2019],
[May 2019],
[Jun 2019],
[Jul 2019],
[Aug 2019],
[Sep 2019],
[Oct 2019],
[Nov 2019],
[Dec 2019],
[Jan2019] as [IHS Jan2019],
[Feb2019] as [IHS Feb2019],
[Mar2019] as [IHS Mar2019],
[Apr2019] as [IHS Apr2019],
[May2019] as [IHS May2019],
[Jun2019] as [IHS Jun2019],
[Jul2019] as [IHS Jul2019],
[Aug2019] as [IHS Aug2019],
[Sep2019] as [IHS Sep2019],
[Oct2019] as [IHS Oct2019],
[Nov2019] as [IHS Nov2019],
[Dec2019] as [IHS Dec2019],
[Jan 2019 Factor] = (case when isnull(Jan2019,0)=0 then 0 else round(isnull([Jan 2019],0)/Jan2019,2) end),		
[Feb 2019 Factor] = (case when isnull(Feb2019,0)=0 then 0 else round(isnull([Feb 2019],0)/Feb2019,2) end),		
[Mar 2019 Factor] = (case when isnull(Mar2019,0)=0 then 0 else round(isnull([Mar 2019],0)/Mar2019,2) end),												
[Apr 2019 Factor] = (case when isnull(Apr2019,0)=0 then 0 else round(isnull([Apr 2019],0)/Apr2019,2) end),										
[May 2019 Factor] = (case when isnull(May2019,0)=0 then 0 else round(isnull([May 2019],0)/May2019,2) end),										
[Jun 2019 Factor] = (case when isnull(Jun2019,0)=0 then 0 else round(isnull([Jun 2019],0)/Jun2019,2) end),									
[Jul 2019 Factor] = (case when isnull(Jul2019,0)=0 then 0 else round(isnull([Jul 2019],0)/Jul2019,2) end),										
[Aug 2019 Factor] = (case when isnull(Aug2019,0)=0 then 0 else round(isnull([Aug 2019],0)/Aug2019,2) end),									
[Sep 2019 Factor] = (case when isnull(Sep2019,0)=0 then 0 else round(isnull([Sep 2019],0)/Sep2019,2) end),									
[Oct 2019 Factor] = (case when isnull(Oct2019,0)=0 then 0 else round(isnull([Oct 2019],0)/Oct2019,2) end),									
[Nov 2019 Factor] = (case when isnull(Nov2019,0)=0 then 0 else round(isnull([Nov 2019],0)/Nov2019,2) end),										
[Dec 2019 Factor] = (case when isnull(Dec2019,0)=0 then 0 else round(isnull([Dec 2019],0)/Dec2019,2) end)							
																				
from temp_alc_shipping_plan_20181218 XYZ join 										
										
										
(select	ISNULL(XX.base_part, YY.base_part) as [BasePart],									
		'Adj CSM Demand' as [version], 								
										
		XX.[Jan2019]+YY.[Jan2019] as [Jan2019],								
		XX.[Feb2019]+YY.[Feb2019] as [Feb2019],								
		XX.[Mar2019]+YY.[Mar2019] as [Mar2019],								
		XX.[Apr2019]+YY.[Apr2019] as [Apr2019],								
		XX.[May2019]+YY.[May2019] as [May2019],								
		XX.[Jun2019]+YY.[Jun2019] as [Jun2019],								
		XX.[Jul2019]+YY.[Jul2019] as [Jul2019],								
		XX.[Aug2019]+YY.[Aug2019] as [Aug2019],								
		XX.[Sep2019]+YY.[Sep2019] as [Sep2019],								
		XX.[Oct2019]+YY.[Oct2019] as [Oct2019],								
		XX.[Nov2019]+YY.[Nov2019] as [Nov2019],								
		XX.[Dec2019]+YY.[Dec2019] as [Dec2019],								
		((XX.[Jan2019]+YY.[Jan2019])+(XX.[Feb2019]+YY.[Feb2019])+(XX.[Mar2019]+YY.[Mar2019])+(XX.[Apr2019]+YY.[Apr2019])+(XX.[May2019]+YY.[May2019])+(XX.[Jun2019]+YY.[Jun2019])+(XX.[Jul2019]+YY.[Jul2019])+(XX.[Aug2019]+YY.[Aug2019])+(XX.[Sep2019]+YY.[Sep2019])+(XX.[Oct2019]+YY.[Oct2019])+(XX.[Nov2019]+YY.[Nov2019])+(XX.[Dec2019]+YY.[Dec2019])) as [Total_2019],								
										
		/*								
		XX.[Jan2020]+YY.[Jan2020] as [Jan2020],								
		XX.[Feb2020]+YY.[Feb2020] as [Feb2020],								
		XX.[Mar2020]+YY.[Mar2020] as [Mar2020],								
		XX.[Apr2020]+YY.[Apr2020] as [Apr2020],								
		XX.[May2020]+YY.[May2020] as [May2020],								
		XX.[Jun2020]+YY.[Jun2020] as [Jun2020],								
		XX.[Jul2020]+YY.[Jul2020] as [Jul2020],								
		XX.[Aug2020]+YY.[Aug2020] as [Aug2020],								
		XX.[Sep2020]+YY.[Sep2020] as [Sep2020],								
		XX.[Oct2020]+YY.[Oct2020] as [Oct2020],								
		XX.[Nov2020]+YY.[Nov2020] as [Nov2020],								
		XX.[Dec2020]+YY.[Dec2020] as [Dec2020],								
		((XX.[Jan2020]+YY.[Jan2020])+(XX.[Feb2020]+YY.[Feb2020])+(XX.[Mar2020]+YY.[Mar2020])+(XX.[Apr2020]+YY.[Apr2020])+(XX.[May2020]+YY.[May2020])+(XX.[Jun2020]+YY.[Jun2020])+(XX.[Jul2020]+YY.[Jul2020])+(XX.[Aug2020]+YY.[Aug2020])+(XX.[Sep2020]+YY.[Sep2020])+(XX.[Oct2020]+YY.[Oct2020])+(XX.[Nov2020]+YY.[Nov2020])+(XX.[Dec2020]+YY.[Dec2020])) as [Total_2020],								
										
		XX.[Jan2021]+YY.[Jan2021] as [Jan2021],								
		XX.[Feb2021]+YY.[Feb2021] as [Feb2021],								
		XX.[Mar2021]+YY.[Mar2021] as [Mar2021],								
		XX.[Apr2021]+YY.[Apr2021] as [Apr2021],								
		XX.[May2021]+YY.[May2021] as [May2021],								
		XX.[Jun2021]+YY.[Jun2021] as [Jun2021],								
		XX.[Jul2021]+YY.[Jul2021] as [Jul2021],								
		XX.[Aug2021]+YY.[Aug2021] as [Aug2021],								
		XX.[Sep2021]+YY.[Sep2021] as [Sep2021],								
		XX.[Oct2021]+YY.[Oct2021] as [Oct2021],								
		XX.[Nov2021]+YY.[Nov2021] as [Nov2021],								
		XX.[Dec2021]+YY.[Dec2021] as [Dec2021],								
		((XX.[Jan2021]+YY.[Jan2021])+(XX.[Feb2021]+YY.[Feb2021])+(XX.[Mar2021]+YY.[Mar2021])+(XX.[Apr2021]+YY.[Apr2021])+(XX.[May2021]+YY.[May2021])+(XX.[Jun2021]+YY.[Jun2021])+(XX.[Jul2021]+YY.[Jul2021])+(XX.[Aug2021]+YY.[Aug2021])+(XX.[Sep2021]+YY.[Sep2021])+(XX.[Oct2021]+YY.[Oct2021])+(XX.[Nov2021]+YY.[Nov2021])+(XX.[Dec2021]+YY.[Dec2021])) as [Total_2021],								
		*/								
										
		XX.[total_2021]+YY.[total_2021] as [total_2021],								
		XX.[total_2022]+YY.[total_2022] as [total_2022],								
		XX.[total_2023]+YY.[total_2023] as [total_2023],								
		XX.[total_2024]+YY.[total_2024] as [total_2024],								
		XX.[total_2025]+YY.[total_2025] as [total_2025]								
										
 from										
(select	ISNULL(AA.base_part, BB.base_part) as [base_part],									
		'Adj CSM Demand' as [version], 								
	    AA.[Jan 2015]*BB.[Jan 2015] as [Jan2015],									
		AA.[Feb 2015]*BB.[Feb 2015] as [Feb2015],								
		AA.[Mar 2015]*BB.[Mar 2015] as [Mar2015],								
		AA.[Apr 2015]*BB.[Apr 2015] as [Apr2015],								
		AA.[May 2015]*BB.[May 2015] as [May2015],								
		AA.[Jun 2015]*BB.[Jun 2015] as [Jun2015],								
		AA.[Jul 2015]*BB.[Jul 2015] as [Jul2015],								
		AA.[Aug 2015]*BB.[Aug 2015] as [Aug2015],								
		AA.[Sep 2015]*BB.[Sep 2015] as [Sep2015],								
		AA.[Oct 2015]*BB.[Oct 2015] as [Oct2015],								
		AA.[Nov 2015]*BB.[Nov 2015] as [Nov2015],								
		AA.[Dec 2015]*BB.[Dec 2015] as [Dec2015],								
		((AA.[Jan 2015]*BB.[Jan 2015])+(AA.[Feb 2015]*BB.[Feb 2015])+(AA.[Mar 2015]*BB.[Mar 2015])+(AA.[Apr 2015]*BB.[Apr 2015])+(AA.[May 2015]*BB.[May 2015])+(AA.[Jun 2015]*BB.[Jun 2015])+(AA.[Jul 2015]*BB.[Jul 2015])+(AA.[Aug 2015]*BB.[Aug 2015])+(AA.[Sep 2015]*BB.[Sep 2015])+(AA.[Oct 2015]*BB.[Oct 2015])+(AA.[Nov 2015]*BB.[Nov 2015])+(AA.[Dec 2015]*BB.[Dec 2015])) as [Total_2015],								
										
		AA.[Jan 2016]*BB.[Jan 2016] as [Jan2016],								
		AA.[Feb 2016]*BB.[Feb 2016] as [Feb2016],								
		AA.[Mar 2016]*BB.[Mar 2016] as [Mar2016],								
		AA.[Apr 2016]*BB.[Apr 2016] as [Apr2016],								
		(AA.[May 2016]*BB.[May 2016]) as [May2016],								
		(AA.[Jun 2016]*BB.[Jun 2016]) as [Jun2016],								
		(AA.[Jul 2016]*BB.[Jul 2016]) as [Jul2016],								
		(AA.[Aug 2016]*BB.[Aug 2016]) as [Aug2016],								
		(AA.[Sep 2016]*BB.[Sep 2016]) as [Sep2016],								
		(AA.[Oct 2016]*BB.[Oct 2016]) as [Oct2016],								
		(AA.[Nov 2016]*BB.[Nov 2016]) as [Nov2016],								
		(AA.[Dec 2016]*BB.[Dec 2016]) as [Dec2016],								
		((AA.[Jan 2016]*BB.[Jan 2016])+(AA.[Feb 2016]*BB.[Feb 2016])+(AA.[Mar 2016]*BB.[Mar 2016])+(AA.[Apr 2016]*BB.[Apr 2016])+(AA.[May 2016]*BB.[May 2016])+(AA.[Jun 2016]*BB.[Jun 2016])+(AA.[Jul 2016]*BB.[Jul 2016])+(AA.[Aug 2016]*BB.[Aug 2016])+(AA.[Sep 2016]*BB.[Sep 2016])+(AA.[Oct 2016]*BB.[Oct 2016])+(AA.[Nov 2016]*BB.[Nov 2016])+(AA.[Dec 2016]*BB.[Dec 2016])) as [Total_2016],								
										
		AA.[Jan 2017]*BB.[Jan 2017] as [Jan2017],								
		AA.[Feb 2017]*BB.[Feb 2017] as [Feb2017],								
		AA.[Mar 2017]*BB.[Mar 2017] as [Mar2017],								
		AA.[Apr 2017]*BB.[Apr 2017] as [Apr2017],								
		(AA.[May 2017]*BB.[May 2017]) as [May2017],								
		(AA.[Jun 2017]*BB.[Jun 2017]) as [Jun2017],								
		(AA.[Jul 2017]*BB.[Jul 2017]) as [Jul2017],								
		(AA.[Aug 2017]*BB.[Aug 2017]) as [Aug2017],								
		(AA.[Sep 2017]*BB.[Sep 2017]) as [Sep2017],								
		(AA.[Oct 2017]*BB.[Oct 2017]) as [Oct2017],								
		(AA.[Nov 2017]*BB.[Nov 2017]) as [Nov2017],								
		(AA.[Dec 2017]*BB.[Dec 2017]) as [Dec2017],								
		((AA.[Jan 2017]*BB.[Jan 2017])+(AA.[Feb 2017]*BB.[Feb 2017])+(AA.[Mar 2017]*BB.[Mar 2017])+(AA.[Apr 2017]*BB.[Apr 2017])+(AA.[May 2017]*BB.[May 2017])+(AA.[Jun 2017]*BB.[Jun 2017])+(AA.[Jul 2017]*BB.[Jul 2017])+(AA.[Aug 2017]*BB.[Aug 2017])+(AA.[Sep 2017]*BB.[Sep 2017])+(AA.[Oct 2017]*BB.[Oct 2017])+(AA.[Nov 2017]*BB.[Nov 2017])+(AA.[Dec 2017]*BB.[Dec 2017])) as [Total_2017],								
										
		AA.[Jan 2018]*BB.[Jan 2018] as [Jan2018],								
		AA.[Feb 2018]*BB.[Feb 2018] as [Feb2018],								
		AA.[Mar 2018]*BB.[Mar 2018] as [Mar2018],								
		AA.[Apr 2018]*BB.[Apr 2018] as [Apr2018],								
		(AA.[May 2018]*BB.[May 2018]) as [May2018],								
		(AA.[Jun 2018]*BB.[Jun 2018]) as [Jun2018],								
		(AA.[Jul 2018]*BB.[Jul 2018]) as [Jul2018],								
		(AA.[Aug 2018]*BB.[Aug 2018]) as [Aug2018],								
		(AA.[Sep 2018]*BB.[Sep 2018]) as [Sep2018],								
		(AA.[Oct 2018]*BB.[Oct 2018]) as [Oct2018],								
		(AA.[Nov 2018]*BB.[Nov 2018]) as [Nov2018],								
		(AA.[Dec 2018]*BB.[Dec 2018]) as [Dec2018],								
		((AA.[Jan 2018]*BB.[Jan 2018])+(AA.[Feb 2018]*BB.[Feb 2018])+(AA.[Mar 2018]*BB.[Mar 2018])+(AA.[Apr 2018]*BB.[Apr 2018])+(AA.[May 2018]*BB.[May 2018])+(AA.[Jun 2018]*BB.[Jun 2018])+(AA.[Jul 2018]*BB.[Jul 2018])+(AA.[Aug 2018]*BB.[Aug 2018])+(AA.[Sep 2018]*BB.[Sep 2018])+(AA.[Oct 2018]*BB.[Oct 2018])+(AA.[Nov 2018]*BB.[Nov 2018])+(AA.[Dec 2018]*BB.[Dec 2018])) as [Total_2018],								
										
		AA.[Jan 2019]*BB.[Jan 2019] as [Jan2019],								
		AA.[Feb 2019]*BB.[Feb 2019] as [Feb2019],								
		AA.[Mar 2019]*BB.[Mar 2019] as [Mar2019],								
		AA.[Apr 2019]*BB.[Apr 2019] as [Apr2019],								
		(AA.[May 2019]*BB.[May 2019]) as [May2019],								
		(AA.[Jun 2019]*BB.[Jun 2019]) as [Jun2019],								
		(AA.[Jul 2019]*BB.[Jul 2019]) as [Jul2019],								
		(AA.[Aug 2019]*BB.[Aug 2019]) as [Aug2019],								
		(AA.[Sep 2019]*BB.[Sep 2019]) as [Sep2019],								
		(AA.[Oct 2019]*BB.[Oct 2019]) as [Oct2019],								
		(AA.[Nov 2019]*BB.[Nov 2019]) as [Nov2019],								
		(AA.[Dec 2019]*BB.[Dec 2019]) as [Dec2019],								
		((AA.[Jan 2019]*BB.[Jan 2019])+(AA.[Feb 2019]*BB.[Feb 2019])+(AA.[Mar 2019]*BB.[Mar 2019])+(AA.[Apr 2019]*BB.[Apr 2019])+(AA.[May 2019]*BB.[May 2019])+(AA.[Jun 2019]*BB.[Jun 2019])+(AA.[Jul 2019]*BB.[Jul 2019])+(AA.[Aug 2019]*BB.[Aug 2019])+(AA.[Sep 2019]*BB.[Sep 2019])+(AA.[Oct 2019]*BB.[Oct 2019])+(AA.[Nov 2019]*BB.[Nov 2019])+(AA.[Dec 2019]*BB.[Dec 2019])) as [Total_2019],								
										
		AA.[Jan 2020]*BB.[Jan 2020] as [Jan2020],								
		AA.[Feb 2020]*BB.[Feb 2020] as [Feb2020],								
		AA.[Mar 2020]*BB.[Mar 2020] as [Mar2020],								
		AA.[Apr 2020]*BB.[Apr 2020] as [Apr2020],								
		(AA.[May 2020]*BB.[May 2020]) as [May2020],								
		(AA.[Jun 2020]*BB.[Jun 2020]) as [Jun2020],								
		(AA.[Jul 2020]*BB.[Jul 2020]) as [Jul2020],								
		(AA.[Aug 2020]*BB.[Aug 2020]) as [Aug2020],								
		(AA.[Sep 2020]*BB.[Sep 2020]) as [Sep2020],								
		(AA.[Oct 2020]*BB.[Oct 2020]) as [Oct2020],								
		(AA.[Nov 2020]*BB.[Nov 2020]) as [Nov2020],								
		(AA.[Dec 2020]*BB.[Dec 2020]) as [Dec2020],								
		((AA.[Jan 2020]*BB.[Jan 2020])+(AA.[Feb 2020]*BB.[Feb 2020])+(AA.[Mar 2020]*BB.[Mar 2020])+(AA.[Apr 2020]*BB.[Apr 2020])+(AA.[May 2020]*BB.[May 2020])+(AA.[Jun 2020]*BB.[Jun 2020])+(AA.[Jul 2020]*BB.[Jul 2020])+(AA.[Aug 2020]*BB.[Aug 2020])+(AA.[Sep 2020]*BB.[Sep 2020])+(AA.[Oct 2020]*BB.[Oct 2020])+(AA.[Nov 2020]*BB.[Nov 2020])+(AA.[Dec 2020]*BB.[Dec 2020])) as [Total_2020],								
										
		/*								
		AA.[Jan 2021]*BB.[Jan 2021] as [Jan2021],								
		AA.[Feb 2021]*BB.[Feb 2021] as [Feb2021],								
		AA.[Mar 2021]*BB.[Mar 2021] as [Mar2021],								
		AA.[Apr 2021]*BB.[Apr 2021] as [Apr2021],								
		(AA.[May 2021]*BB.[May 2021]) as [May2021],								
		(AA.[Jun 2021]*BB.[Jun 2021]) as [Jun2021],								
		(AA.[Jul 2021]*BB.[Jul 2021]) as [Jul2021],								
		(AA.[Aug 2021]*BB.[Aug 2021]) as [Aug2021],								
		(AA.[Sep 2021]*BB.[Sep 2021]) as [Sep2021],								
		(AA.[Oct 2021]*BB.[Oct 2021]) as [Oct2021],								
		(AA.[Nov 2021]*BB.[Nov 2021]) as [Nov2021],								
		(AA.[Dec 2021]*BB.[Dec 2021]) as [Dec2021],								
		((AA.[Jan 2021]*BB.[Jan 2021])+(AA.[Feb 2021]*BB.[Feb 2021])+(AA.[Mar 2021]*BB.[Mar 2021])+(AA.[Apr 2021]*BB.[Apr 2021])+(AA.[May 2021]*BB.[May 2021])+(AA.[Jun 2021]*BB.[Jun 2021])+(AA.[Jul 2021]*BB.[Jul 2021])+(AA.[Aug 2021]*BB.[Aug 2021])+(AA.[Sep 2021]*BB.[Sep 2021])+(AA.[Oct 2021]*BB.[Oct 2021])+(AA.[Nov 2021]*BB.[Nov 2021])+(AA.[Dec 2021]*BB.[Dec 2021])) as [Total_2021],								
		*/								
										
		AA.[total_2021]*BB.[total_2021] as [total_2021],								
		AA.[total_2022]*BB.[total_2022] as [total_2022],								
		AA.[total_2023]*BB.[total_2023] as [total_2023],								
		AA.[total_2024]*BB.[total_2024] as [total_2024],								
		AA.[total_2025]*BB.[total_2025] as [total_2025]								
from 										
		(	select	a.BASE_PART, 						
				    ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2015]),0) as [jan 2015], 						
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2015]),0) as [feb 2015], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2015]),0) as [mar 2015], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2015]),0) as [apr 2015], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[May 2015]),0) as [may 2015], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2015]),0) as [jun 2015], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2015]),0) as [jul 2015], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2015]),0) as [aug 2015], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2015]),0) as [sep 2015], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2015]),0) as [oct 2015], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2015]),0) as [nov 2015], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2015]),0) as [dec 2015], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2015]+b.[Feb 2015]+b.[Mar 2015]+b.[Apr 2015]+b.[May 2015]+b.[Jun 2015]+b.[Jul 2015]+b.[Aug 2015]+b.[Sep 2015]+b.[Oct 2015]+b.[Nov 2015]+b.[Dec 2015])),0) as [total_2015],					
										
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2016]),0) as [jan 2016], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2016]),0) as [feb 2016], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2016]),0) as [mar 2016], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2016]),0) as [apr 2016], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[May 2016]),0) as [may 2016], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2016]),0) as [jun 2016], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2016]),0) as [jul 2016], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2016]),0) as [aug 2016], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2016]),0) as [sep 2016], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2016]),0) as [oct 2016], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2016]),0) as [nov 2016], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2016]),0) as [dec 2016], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2016]+b.[Feb 2016]+b.[Mar 2016]+b.[Apr 2016]+b.[May 2016]+b.[Jun 2016]+b.[Jul 2016]+b.[Aug 2016]+b.[Sep 2016]+b.[Oct 2016]+b.[Nov 2016]+b.[Dec 2016])),0) as [total_2016],					
										
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2017]),0) as [jan 2017], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2017]),0) as [feb 2017], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2017]),0) as [mar 2017], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2017]),0) as [apr 2017], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[May 2017]),0) as [may 2017], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2017]),0) as [jun 2017], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2017]),0) as [jul 2017], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2017]),0) as [aug 2017], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2017]),0) as [sep 2017], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2017]),0) as [oct 2017], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2017]),0) as [nov 2017], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2017]),0) as [dec 2017], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2017]+b.[Feb 2017]+b.[Mar 2017]+b.[Apr 2017]+b.[May 2017]+b.[Jun 2017]+b.[Jul 2017]+b.[Aug 2017]+b.[Sep 2017]+b.[Oct 2017]+b.[Nov 2017]+b.[Dec 2017])),0) as [total_2017],					
										
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2018]),0) as [jan 2018], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2018]),0) as [feb 2018], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2018]),0) as [mar 2018], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2018]),0) as [apr 2018], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[May 2018]),0) as [may 2018], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2018]),0) as [jun 2018], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2018]),0) as [jul 2018], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2018]),0) as [aug 2018], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2018]),0) as [sep 2018], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2018]),0) as [oct 2018], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2018]),0) as [nov 2018], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2018]),0) as [dec 2018], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2018]+b.[Feb 2018]+b.[Mar 2018]+b.[Apr 2018]+b.[May 2018]+b.[Jun 2018]+b.[Jul 2018]+b.[Aug 2018]+b.[Sep 2018]+b.[Oct 2018]+b.[Nov 2018]+b.[Dec 2018])),0) as [total_2018],					
										
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2019]),0) as [jan 2019], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2019]),0) as [feb 2019], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2019]),0) as [mar 2019], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2019]),0) as [apr 2019], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[May 2019]),0) as [may 2019], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2019]),0) as [jun 2019], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2019]),0) as [jul 2019], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2019]),0) as [aug 2019], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2019]),0) as [sep 2019], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2019]),0) as [oct 2019], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2019]),0) as [nov 2019], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2019]),0) as [dec 2019], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2019]+b.[Feb 2019]+b.[Mar 2019]+b.[Apr 2019]+b.[May 2019]+b.[Jun 2019]+b.[Jul 2019]+b.[Aug 2019]+b.[Sep 2019]+b.[Oct 2019]+b.[Nov 2019]+b.[Dec 2019])),0) as [total_2019],					
										
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2020]),0) as [jan 2020], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2020]),0) as [feb 2020], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2020]),0) as [mar 2020], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2020]),0) as [apr 2020], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[May 2020]),0) as [may 2020], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2020]),0) as [jun 2020], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2020]),0) as [jul 2020], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2020]),0) as [aug 2020], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2020]),0) as [sep 2020], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2020]),0) as [oct 2020], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2020]),0) as [nov 2020], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2020]),0) as [dec 2020], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2020]+b.[Feb 2020]+b.[Mar 2020]+b.[Apr 2020]+b.[May 2020]+b.[Jun 2020]+b.[Jul 2020]+b.[Aug 2020]+b.[Sep 2020]+b.[Oct 2020]+b.[Nov 2020]+b.[Dec 2020])),0) as [total_2020],					
										/*
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2021]),0) as [jan 2021], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2021]),0) as [feb 2021], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2021]),0) as [mar 2021], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2021]),0) as [apr 2021], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[May 2021]),0) as [may 2021], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2021]),0) as [jun 2021], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2021]),0) as [jul 2021], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2021]),0) as [aug 2021], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2021]),0) as [sep 2021], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2021]),0) as [oct 2021], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2021]),0) as [nov 2021], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2021]),0) as [dec 2021], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2021]+b.[Feb 2021]+b.[Mar 2021]+b.[Apr 2021]+b.[May 2021]+b.[Jun 2021]+b.[Jul 2021]+b.[Aug 2021]+b.[Sep 2021]+b.[Oct 2021]+b.[Nov 2021]+b.[Dec 2021])),0) as [total_2021],					
					*/					
										
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[CY 2021]),0) as [total_2021], 					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[CY 2022]),0) as [total_2022],					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[CY 2023]),0) as [total_2023],					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[CY 2024]),0) as [total_2024],					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[CY 2025]),0) as [total_2025]					
										
			from 							
					(	select	* 			
						from	eeiuser.acctg_csm_base_part_mnemonic			
						where	release_id =  @release_id			
					) a 					
					left outer join 					
					(	select	* 			
						from	eeiuser.acctg_csm_NAIHS 			
						where	release_id =  @release_id		
							and VERSION = 'CSM'			
					) b					
					on a.mnemonic = b.[Mnemonic-Vehicle/Plant] 					
					and a.release_id = b.release_id					
					where	a.base_part in (select part from temp_alc_shipping_plan_20181218)				
					group by base_part					
										
										
		) AA								
		join								
		(	select	a.base_part as [base_part],						
				    ISNULL(b.[Jan 2015],0) as [jan 2015], 						
					ISNULL(b.[Feb 2015],0) as [feb 2015], 					
					ISNULL(b.[Mar 2015],0) as [mar 2015], 					
					ISNULL(b.[Apr 2015],0) as [apr 2015], 					
					ISNULL(b.[May 2015],0) as [may 2015], 					
					ISNULL(b.[Jun 2015],0) as [jun 2015], 					
					ISNULL(b.[Jul 2015],0) as [jul 2015], 					
					ISNULL(b.[Aug 2015],0) as [aug 2015], 					
					ISNULL(b.[Sep 2015],0) as [sep 2015], 					
					ISNULL(b.[Oct 2015],0) as [oct 2015], 					
					ISNULL(b.[Nov 2015],0) as [nov 2015], 					
					ISNULL(b.[Dec 2015],0) as [dec 2015], 					
					ISNULL((b.[Jan 2015]+b.[Feb 2015]+b.[Mar 2015]+b.[Apr 2015]+b.[May 2015]+b.[Jun 2015]+b.[Jul 2015]+b.[Aug 2015]+b.[Sep 2015]+b.[Oct 2015]+b.[Nov 2015]+b.[Dec 2015]),0) as [total_2015],					
										
					ISNULL(b.[Jan 2016],0) as [jan 2016], 					
					ISNULL(b.[Feb 2016],0) as [feb 2016], 					
					ISNULL(b.[Mar 2016],0) as [mar 2016], 					
					ISNULL(b.[Apr 2016],0) as [apr 2016], 					
					ISNULL(b.[May 2016],0) as [may 2016], 					
					ISNULL(b.[Jun 2016],0) as [jun 2016], 					
					ISNULL(b.[Jul 2016],0) as [jul 2016], 					
					ISNULL(b.[Aug 2016],0) as [aug 2016], 					
					ISNULL(b.[Sep 2016],0) as [sep 2016], 					
					ISNULL(b.[Oct 2016],0) as [oct 2016], 					
					ISNULL(b.[Nov 2016],0) as [nov 2016], 					
					ISNULL(b.[Dec 2016],0) as [dec 2016], 					
					ISNULL((b.[Jan 2016]+b.[Feb 2016]+b.[Mar 2016]+b.[Apr 2016]+b.[May 2016]+b.[Jun 2016]+b.[Jul 2016]+b.[Aug 2016]+b.[Sep 2016]+b.[Oct 2016]+b.[Nov 2016]+b.[Dec 2016]),0) as [total_2016],					
										
					ISNULL(b.[Jan 2017],0) as [jan 2017], 					
					ISNULL(b.[Feb 2017],0) as [feb 2017], 					
					ISNULL(b.[Mar 2017],0) as [mar 2017], 					
					ISNULL(b.[Apr 2017],0) as [apr 2017], 					
					ISNULL(b.[May 2017],0) as [may 2017], 					
					ISNULL(b.[Jun 2017],0) as [jun 2017], 					
					ISNULL(b.[Jul 2017],0) as [jul 2017], 					
					ISNULL(b.[Aug 2017],0) as [aug 2017], 					
					ISNULL(b.[Sep 2017],0) as [sep 2017], 					
					ISNULL(b.[Oct 2017],0) as [oct 2017], 					
					ISNULL(b.[Nov 2017],0) as [nov 2017], 					
					ISNULL(b.[Dec 2017],0) as [dec 2017], 					
					ISNULL((b.[Jan 2017]+b.[Feb 2017]+b.[Mar 2017]+b.[Apr 2017]+b.[May 2017]+b.[Jun 2017]+b.[Jul 2017]+b.[Aug 2017]+b.[Sep 2017]+b.[Oct 2017]+b.[Nov 2017]+b.[Dec 2017]),0) as [total_2017],					
										
										
					ISNULL(b.[Jan 2018],0) as [jan 2018], 					
					ISNULL(b.[Feb 2018],0) as [feb 2018], 					
					ISNULL(b.[Mar 2018],0) as [mar 2018], 					
					ISNULL(b.[Apr 2018],0) as [apr 2018], 					
					ISNULL(b.[May 2018],0) as [may 2018], 					
					ISNULL(b.[Jun 2018],0) as [jun 2018], 					
					ISNULL(b.[Jul 2018],0) as [jul 2018], 					
					ISNULL(b.[Aug 2018],0) as [aug 2018], 					
					ISNULL(b.[Sep 2018],0) as [sep 2018], 					
					ISNULL(b.[Oct 2018],0) as [oct 2018], 					
					ISNULL(b.[Nov 2018],0) as [nov 2018], 					
					ISNULL(b.[Dec 2018],0) as [dec 2018], 					
					ISNULL((b.[Jan 2018]+b.[Feb 2018]+b.[Mar 2018]+b.[Apr 2018]+b.[May 2018]+b.[Jun 2018]+b.[Jul 2018]+b.[Aug 2018]+b.[Sep 2018]+b.[Oct 2018]+b.[Nov 2018]+b.[Dec 2018]),0) as [total_2018],					
										
					ISNULL(b.[Jan 2019],0) as [jan 2019], 					
					ISNULL(b.[Feb 2019],0) as [feb 2019], 					
					ISNULL(b.[Mar 2019],0) as [mar 2019], 					
					ISNULL(b.[Apr 2019],0) as [apr 2019], 					
					ISNULL(b.[May 2019],0) as [may 2019], 					
					ISNULL(b.[Jun 2019],0) as [jun 2019], 					
					ISNULL(b.[Jul 2019],0) as [jul 2019], 					
					ISNULL(b.[Aug 2019],0) as [aug 2019], 					
					ISNULL(b.[Sep 2019],0) as [sep 2019], 					
					ISNULL(b.[Oct 2019],0) as [oct 2019], 					
					ISNULL(b.[Nov 2019],0) as [nov 2019], 					
					ISNULL(b.[Dec 2019],0) as [dec 2019], 					
					ISNULL((b.[Jan 2019]+b.[Feb 2019]+b.[Mar 2019]+b.[Apr 2019]+b.[May 2019]+b.[Jun 2019]+b.[Jul 2019]+b.[Aug 2019]+b.[Sep 2019]+b.[Oct 2019]+b.[Nov 2019]+b.[Dec 2019]),0) as [total_2019],					
										
					ISNULL(b.[Jan 2020],0) as [jan 2020], 					
					ISNULL(b.[Feb 2020],0) as [feb 2020], 					
					ISNULL(b.[Mar 2020],0) as [mar 2020], 					
					ISNULL(b.[Apr 2020],0) as [apr 2020], 					
					ISNULL(b.[May 2020],0) as [may 2020], 					
					ISNULL(b.[Jun 2020],0) as [jun 2020], 					
					ISNULL(b.[Jul 2020],0) as [jul 2020], 					
					ISNULL(b.[Aug 2020],0) as [aug 2020], 					
					ISNULL(b.[Sep 2020],0) as [sep 2020], 					
					ISNULL(b.[Oct 2020],0) as [oct 2020], 					
					ISNULL(b.[Nov 2020],0) as [nov 2020], 					
					ISNULL(b.[Dec 2020],0) as [dec 2020], 					
					ISNULL((b.[Jan 2020]+b.[Feb 2020]+b.[Mar 2020]+b.[Apr 2020]+b.[May 2020]+b.[Jun 2020]+b.[Jul 2020]+b.[Aug 2020]+b.[Sep 2020]+b.[Oct 2020]+b.[Nov 2020]+b.[Dec 2020]),0) as [total_2020],					
										
					/*					
					ISNULL(b.[Jan 2021],0) as [jan 2021], 					
					ISNULL(b.[Feb 2021],0) as [feb 2021], 					
					ISNULL(b.[Mar 2021],0) as [mar 2021], 					
					ISNULL(b.[Apr 2021],0) as [apr 2021], 					
					ISNULL(b.[May 2021],0) as [may 2021], 					
					ISNULL(b.[Jun 2021],0) as [jun 2021], 					
					ISNULL(b.[Jul 2021],0) as [jul 2021], 					
					ISNULL(b.[Aug 2021],0) as [aug 2021], 					
					ISNULL(b.[Sep 2021],0) as [sep 2021], 					
					ISNULL(b.[Oct 2021],0) as [oct 2021], 					
					ISNULL(b.[Nov 2021],0) as [nov 2021], 					
					ISNULL(b.[Dec 2021],0) as [dec 2021], 					
					ISNULL((b.[Jan 2021]+b.[Feb 2021]+b.[Mar 2021]+b.[Apr 2021]+b.[May 2021]+b.[Jun 2021]+b.[Jul 2021]+b.[Aug 2021]+b.[Sep 2021]+b.[Oct 2021]+b.[Nov 2021]+b.[Dec 2021]),0) as [total_2021],					
					*/					
										
					ISNULL(b.[CY 2021],0) as [total_2021], 					
					ISNULL(b.[CY 2022],0) as [total_2022],					
					ISNULL(b.[CY 2023],0) as [total_2023],					
					ISNULL(b.[CY 2024],0) as [total_2024],					
					ISNULL(b.[CY 2025],0) as [total_2025]					
			from 							
					(	select	* 			
						from	eeiuser.acctg_csm_base_part_mnemonic			
						where	release_id =  @release_id	
					) a 					
					join 					
					(	select	* 			
						from	eeiuser.acctg_csm_NAIHS 			
						where	release_id =  @release_id	
							and VERSION = 'Empire Factor'			
					) b					
					on a.mnemonic = b.[Mnemonic-Vehicle/Plant]					
					and a.release_id = b.release_id					
					where	a.base_part in (select part from temp_alc_shipping_plan_20181218)				
		) BB								
on AA.base_part = BB.base_part ) XX										
										
left join										
		(	select	a.base_part as [base_part],						
				    ISNULL(b.[Jan 2015],0) as [jan2015], 						
					ISNULL(b.[Feb 2015],0) as [feb2015], 					
					ISNULL(b.[Mar 2015],0) as [mar2015], 					
					ISNULL(b.[Apr 2015],0) as [apr2015], 					
					ISNULL(b.[May 2015],0) as [may2015], 					
					ISNULL(b.[Jun 2015],0) as [jun2015], 					
					ISNULL(b.[Jul 2015],0) as [jul2015], 					
					ISNULL(b.[Aug 2015],0) as [aug2015], 					
					ISNULL(b.[Sep 2015],0) as [sep2015], 					
					ISNULL(b.[Oct 2015],0) as [oct2015], 					
					ISNULL(b.[Nov 2015],0) as [nov2015], 					
					ISNULL(b.[Dec 2015],0) as [dec2015], 					
					ISNULL((b.[Jan 2015]+b.[Feb 2015]+b.[Mar 2015]+b.[Apr 2015]+b.[May 2015]+b.[Jun 2015]+b.[Jul 2015]+b.[Aug 2015]+b.[Sep 2015]+b.[Oct 2015]+b.[Nov 2015]+b.[Dec 2015]),0) as [total_2015],					
										
					ISNULL(b.[Jan 2016],0) as [jan2016], 					
					ISNULL(b.[Feb 2016],0) as [feb2016], 					
					ISNULL(b.[Mar 2016],0) as [mar2016], 					
					ISNULL(b.[Apr 2016],0) as [apr2016], 					
					ISNULL(b.[May 2016],0) as [may2016], 					
					ISNULL(b.[Jun 2016],0) as [jun2016], 					
					ISNULL(b.[Jul 2016],0) as [jul2016], 					
					ISNULL(b.[Aug 2016],0) as [aug2016], 					
					ISNULL(b.[Sep 2016],0) as [sep2016], 					
					ISNULL(b.[Oct 2016],0) as [oct2016], 					
					ISNULL(b.[Nov 2016],0) as [nov2016], 					
					ISNULL(b.[Dec 2016],0) as [dec2016], 					
					ISNULL((b.[Jan 2016]+b.[Feb 2016]+b.[Mar 2016]+b.[Apr 2016]+b.[May 2016]+b.[Jun 2016]+b.[Jul 2016]+b.[Aug 2016]+b.[Sep 2016]+b.[Oct 2016]+b.[Nov 2016]+b.[Dec 2016]),0) as [total_2016],					
										
					ISNULL(b.[Jan 2017],0) as [jan2017], 					
					ISNULL(b.[Feb 2017],0) as [feb2017], 					
					ISNULL(b.[Mar 2017],0) as [mar2017], 					
					ISNULL(b.[Apr 2017],0) as [apr2017], 					
					ISNULL(b.[May 2017],0) as [may2017], 					
					ISNULL(b.[Jun 2017],0) as [jun2017], 					
					ISNULL(b.[Jul 2017],0) as [jul2017], 					
					ISNULL(b.[Aug 2017],0) as [aug2017], 					
					ISNULL(b.[Sep 2017],0) as [sep2017], 					
					ISNULL(b.[Oct 2017],0) as [oct2017], 					
					ISNULL(b.[Nov 2017],0) as [nov2017], 					
					ISNULL(b.[Dec 2017],0) as [dec2017], 					
					ISNULL((b.[Jan 2017]+b.[Feb 2017]+b.[Mar 2017]+b.[Apr 2017]+b.[May 2017]+b.[Jun 2017]+b.[Jul 2017]+b.[Aug 2017]+b.[Sep 2017]+b.[Oct 2017]+b.[Nov 2017]+b.[Dec 2017]),0) as [total_2017],					
 										
					ISNULL(b.[Jan 2018],0) as [jan2018], 					
					ISNULL(b.[Feb 2018],0) as [feb2018], 					
					ISNULL(b.[Mar 2018],0) as [mar2018], 					
					ISNULL(b.[Apr 2018],0) as [apr2018], 					
					ISNULL(b.[May 2018],0) as [may2018], 					
					ISNULL(b.[Jun 2018],0) as [jun2018], 					
					ISNULL(b.[Jul 2018],0) as [jul2018], 					
					ISNULL(b.[Aug 2018],0) as [aug2018], 					
					ISNULL(b.[Sep 2018],0) as [sep2018], 					
					ISNULL(b.[Oct 2018],0) as [oct2018], 					
					ISNULL(b.[Nov 2018],0) as [nov2018], 					
					ISNULL(b.[Dec 2018],0) as [dec2018], 					
					ISNULL((b.[Jan 2018]+b.[Feb 2018]+b.[Mar 2018]+b.[Apr 2018]+b.[May 2018]+b.[Jun 2018]+b.[Jul 2018]+b.[Aug 2018]+b.[Sep 2018]+b.[Oct 2018]+b.[Nov 2018]+b.[Dec 2018]),0) as [total_2018],					
 										
					ISNULL(b.[Jan 2019],0) as [jan2019], 					
					ISNULL(b.[Feb 2019],0) as [feb2019], 					
					ISNULL(b.[Mar 2019],0) as [mar2019], 					
					ISNULL(b.[Apr 2019],0) as [apr2019], 					
					ISNULL(b.[May 2019],0) as [may2019], 					
					ISNULL(b.[Jun 2019],0) as [jun2019], 					
					ISNULL(b.[Jul 2019],0) as [jul2019], 					
					ISNULL(b.[Aug 2019],0) as [aug2019], 					
					ISNULL(b.[Sep 2019],0) as [sep2019], 					
					ISNULL(b.[Oct 2019],0) as [oct2019], 					
					ISNULL(b.[Nov 2019],0) as [nov2019], 					
					ISNULL(b.[Dec 2019],0) as [dec2019], 					
					ISNULL((b.[Jan 2019]+b.[Feb 2019]+b.[Mar 2019]+b.[Apr 2019]+b.[May 2019]+b.[Jun 2019]+b.[Jul 2019]+b.[Aug 2019]+b.[Sep 2019]+b.[Oct 2019]+b.[Nov 2019]+b.[Dec 2019]),0) as [total_2019],					
										
					ISNULL(b.[Jan 2020],0) as [jan2020], 					
					ISNULL(b.[Feb 2020],0) as [feb2020], 					
					ISNULL(b.[Mar 2020],0) as [mar2020], 					
					ISNULL(b.[Apr 2020],0) as [apr2020], 					
					ISNULL(b.[May 2020],0) as [may2020], 					
					ISNULL(b.[Jun 2020],0) as [jun2020], 					
					ISNULL(b.[Jul 2020],0) as [jul2020], 					
					ISNULL(b.[Aug 2020],0) as [aug2020], 					
					ISNULL(b.[Sep 2020],0) as [sep2020], 					
					ISNULL(b.[Oct 2020],0) as [oct2020], 					
					ISNULL(b.[Nov 2020],0) as [nov2020], 					
					ISNULL(b.[Dec 2020],0) as [dec2020], 					
					ISNULL((b.[Jan 2020]+b.[Feb 2020]+b.[Mar 2020]+b.[Apr 2020]+b.[May 2020]+b.[Jun 2020]+b.[Jul 2020]+b.[Aug 2020]+b.[Sep 2020]+b.[Oct 2020]+b.[Nov 2020]+b.[Dec 2020]),0) as [total_2020],					
										
					/*					
					ISNULL(b.[Jan 2021],0) as [jan2021], 					
					ISNULL(b.[Feb 2021],0) as [feb2021], 					
					ISNULL(b.[Mar 2021],0) as [mar2021], 					
					ISNULL(b.[Apr 2021],0) as [apr2021], 					
					ISNULL(b.[May 2021],0) as [may2021], 					
					ISNULL(b.[Jun 2021],0) as [jun2021], 					
					ISNULL(b.[Jul 2021],0) as [jul2021], 					
					ISNULL(b.[Aug 2021],0) as [aug2021], 					
					ISNULL(b.[Sep 2021],0) as [sep2021], 					
					ISNULL(b.[Oct 2021],0) as [oct2021], 					
					ISNULL(b.[Nov 2021],0) as [nov2021], 					
					ISNULL(b.[Dec 2021],0) as [dec2021], 					
					ISNULL((b.[Jan 2021]+b.[Feb 2021]+b.[Mar 2021]+b.[Apr 2021]+b.[May 2021]+b.[Jun 2021]+b.[Jul 2021]+b.[Aug 2021]+b.[Sep 2021]+b.[Oct 2021]+b.[Nov 2021]+b.[Dec 2021]),0) as [total_2021],					
					*/					
										
					ISNULL(b.[CY 2021],0) as [total_2021], 					
					ISNULL(b.[CY 2022],0) as [total_2022],					
					ISNULL(b.[CY 2023],0) as [total_2023],					
					ISNULL(b.[CY 2024],0) as [total_2024],					
					ISNULL(b.[CY 2025],0) as [total_2025]					
			from 							
					(	select	* 			
						from	eeiuser.acctg_csm_base_part_mnemonic			
						where	release_id =  @release_id	
					) a 					
					join 					
					(	select	* 			
						from	eeiuser.acctg_csm_NAIHS 			
						where	release_id =  @release_id	
							and VERSION = 'Empire Adjustment'			
					) b					
					on a.mnemonic = b.[Mnemonic-Vehicle/Plant]					
					and a.release_id = b.release_id					
					where	a.base_part in (select part from temp_alc_shipping_plan_20181218)				
		) YY 								
on XX.base_part = YY.base_part ) ABC										
										
on part = ABC.basepart										

select * from @factorresults 

update a
	set a.[Jan 2019] = b.[Jan 2019 Factor],
		a.[Feb 2019] = b.[Feb 2019 Factor],
		a.[Mar 2019] = b.[Mar 2019 Factor],
		a.[Apr 2019] = b.[Apr 2019 Factor],
		a.[May 2019] = b.[May 2019 Factor],
		a.[Jun 2019] = b.[Jun 2019 Factor],
		a.[Jul 2019] = b.[Jul 2019 Factor],
		a.[Aug 2019] = b.[Aug 2019 Factor],
		a.[Sep 2019] = b.[Sep 2019 Factor],
		a.[Oct 2019] = b.[Oct 2019 Factor],
		a.[Nov 2019] = b.[Nov 2019 Factor],
		a.[Dec 2019] = b.[Dec 2019 Factor]
from eeiuser.acctg_csm_naihs a
join @factorresults b
on right(a.[mnemonic-vehicle/plant],7) = b.base_part
and a.release_id = @release_id
and a.version = 'Empire Factor'
GO
