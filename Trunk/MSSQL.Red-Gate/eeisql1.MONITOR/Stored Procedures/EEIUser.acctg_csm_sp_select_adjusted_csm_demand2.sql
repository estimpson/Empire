SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





-- eeiuser.acctg_csm_sp_select_adjusted_csm_demand_dw 'NAL0040', '2012-08'


CREATE procedure [EEIUser].[acctg_csm_sp_select_adjusted_csm_demand2]
	@base_part varchar(30),
	@release_id varchar(30)
as

select	@base_part as [basepart],
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

		/*
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
		*/

		AA.[total_2020]*BB.[total_2020] as [total_2020],
		AA.[total_2021]*BB.[total_2021] as [total_2021],
		AA.[total_2022]*BB.[total_2022] as [total_2022]
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

					/*
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
					*/

					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[CY 2020]),0) as [total_2020], 
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[CY 2021]),0) as [total_2021], 
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[CY 2022]),0) as [total_2022]
					
			from 
					(	select	* 
						from	eeiuser.acctg_csm_base_part_mnemonic
					) a 
					left outer join 
					(	select	* 
						from	eeiuser.acctg_csm_NAIHS 
						where	release_id = @release_id
							and VERSION = 'CSM'
					) b
					on a.mnemonic = b.[Mnemonic-Vehicle/Plant] 
					where	a.base_part = @base_part 
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
					
					/*
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
					*/
					
					ISNULL(b.[CY 2020],0) as [total_2020], 
					ISNULL(b.[CY 2021],0) as [total_2021], 
					ISNULL(b.[CY 2022],0) as [total_2022]
			from 
					(	select	* 
						from	eeiuser.acctg_csm_base_part_mnemonic
					) a 
					join 
					(	select	* 
						from	eeiuser.acctg_csm_NAIHS 
						where	release_id = @release_id
							and VERSION = 'Empire Factor'
					) b
					on a.mnemonic = b.[Mnemonic-Vehicle/Plant]
					where	a.base_part = @base_part
		) BB
on AA.base_part = BB.base_part







GO
