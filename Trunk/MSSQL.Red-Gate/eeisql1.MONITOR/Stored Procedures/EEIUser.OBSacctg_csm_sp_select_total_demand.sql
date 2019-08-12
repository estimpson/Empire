SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







--exec  [EEIUser].[acctg_csm_sp_select_total_demand] 'LTK0025',   '2015-06'


CREATE procedure [EEIUser].[OBSacctg_csm_sp_select_total_demand]
	@base_part varchar(30),
	@release_id varchar(30)
as

select	@base_part as [BasePart],
		'Adj CSM Demand' as [version], 
	    XX.[Jan2015]+YY.[Jan2015] as [Jan2015],
		XX.[Feb2015]+YY.[Feb2015] as [Feb2015],
		XX.[Mar2015]+YY.[Mar2015] as [Mar2015],
		XX.[Apr2015]+YY.[Apr2015] as [Apr2015],
		XX.[May2015]+YY.[May2015] as [May2015],
		XX.[Jun2015]+YY.[Jun2015] as [Jun2015],
		XX.[Jul2015]+YY.[Jul2015] as [Jul2015],
		XX.[Aug2015]+YY.[Aug2015] as [Aug2015],
		XX.[Sep2015]+YY.[Sep2015] as [Sep2015],
		XX.[Oct2015]+YY.[Oct2015] as [Oct2015],
		XX.[Nov2015]+YY.[Nov2015] as [Nov2015],
		XX.[Dec2015]+YY.[Dec2015] as [Dec2015],
		((XX.[Jan2015]+YY.[Jan2015])+(XX.[Feb2015]+YY.[Feb2015])+(XX.[Mar2015]+YY.[Mar2015])+(XX.[Apr2015]+YY.[Apr2015])+(XX.[May2015]+YY.[May2015])+(XX.[Jun2015]+YY.[Jun2015])+(XX.[Jul2015]+YY.[Jul2015])+(XX.[Aug2015]+YY.[Aug2015])+(XX.[Sep2015]+YY.[Sep2015])+(XX.[Oct2015]+YY.[Oct2015])+(XX.[Nov2015]+YY.[Nov2015])+(XX.[Dec2015]+YY.[Dec2015])) as [Total_2015],

		XX.[Jan2016]+YY.[Jan2016] as [Jan2016],
		XX.[Feb2016]+YY.[Feb2016] as [Feb2016],
		XX.[Mar2016]+YY.[Mar2016] as [Mar2016],
		XX.[Apr2016]+YY.[Apr2016] as [Apr2016],
		XX.[May2016]+YY.[May2016] as [May2016],
		XX.[Jun2016]+YY.[Jun2016] as [Jun2016],
		XX.[Jul2016]+YY.[Jul2016] as [Jul2016],
		XX.[Aug2016]+YY.[Aug2016] as [Aug2016],
		XX.[Sep2016]+YY.[Sep2016] as [Sep2016],
		XX.[Oct2016]+YY.[Oct2016] as [Oct2016],
		XX.[Nov2016]+YY.[Nov2016] as [Nov2016],
		XX.[Dec2016]+YY.[Dec2016] as [Dec2016],
		((XX.[Jan2016]+YY.[Jan2016])+(XX.[Feb2016]+YY.[Feb2016])+(XX.[Mar2016]+YY.[Mar2016])+(XX.[Apr2016]+YY.[Apr2016])+(XX.[May2016]+YY.[May2016])+(XX.[Jun2016]+YY.[Jun2016])+(XX.[Jul2016]+YY.[Jul2016])+(XX.[Aug2016]+YY.[Aug2016])+(XX.[Sep2016]+YY.[Sep2016])+(XX.[Oct2016]+YY.[Oct2016])+(XX.[Nov2016]+YY.[Nov2016])+(XX.[Dec2016]+YY.[Dec2016])) as [Total_2016],

		XX.[Jan2017]+YY.[Jan2017] as [Jan2017],
		XX.[Feb2017]+YY.[Feb2017] as [Feb2017],
		XX.[Mar2017]+YY.[Mar2017] as [Mar2017],
		XX.[Apr2017]+YY.[Apr2017] as [Apr2017],
		XX.[May2017]+YY.[May2017] as [May2017],
		XX.[Jun2017]+YY.[Jun2017] as [Jun2017],
		XX.[Jul2017]+YY.[Jul2017] as [Jul2017],
		XX.[Aug2017]+YY.[Aug2017] as [Aug2017],
		XX.[Sep2017]+YY.[Sep2017] as [Sep2017],
		XX.[Oct2017]+YY.[Oct2017] as [Oct2017],
		XX.[Nov2017]+YY.[Nov2017] as [Nov2017],
		XX.[Dec2017]+YY.[Dec2017] as [Dec2017],
		((XX.[Jan2017]+YY.[Jan2017])+(XX.[Feb2017]+YY.[Feb2017])+(XX.[Mar2017]+YY.[Mar2017])+(XX.[Apr2017]+YY.[Apr2017])+(XX.[May2017]+YY.[May2017])+(XX.[Jun2017]+YY.[Jun2017])+(XX.[Jul2017]+YY.[Jul2017])+(XX.[Aug2017]+YY.[Aug2017])+(XX.[Sep2017]+YY.[Sep2017])+(XX.[Oct2017]+YY.[Oct2017])+(XX.[Nov2017]+YY.[Nov2017])+(XX.[Dec2017]+YY.[Dec2017])) as [Total_2017],

		XX.[Jan2018]+YY.[Jan2018] as [Jan2018],
		XX.[Feb2018]+YY.[Feb2018] as [Feb2018],
		XX.[Mar2018]+YY.[Mar2018] as [Mar2018],
		XX.[Apr2018]+YY.[Apr2018] as [Apr2018],
		XX.[May2018]+YY.[May2018] as [May2018],
		XX.[Jun2018]+YY.[Jun2018] as [Jun2018],
		XX.[Jul2018]+YY.[Jul2018] as [Jul2018],
		XX.[Aug2018]+YY.[Aug2018] as [Aug2018],
		XX.[Sep2018]+YY.[Sep2018] as [Sep2018],
		XX.[Oct2018]+YY.[Oct2018] as [Oct2018],
		XX.[Nov2018]+YY.[Nov2018] as [Nov2018],
		XX.[Dec2018]+YY.[Dec2018] as [Dec2018],
		((XX.[Jan2018]+YY.[Jan2018])+(XX.[Feb2018]+YY.[Feb2018])+(XX.[Mar2018]+YY.[Mar2018])+(XX.[Apr2018]+YY.[Apr2018])+(XX.[May2018]+YY.[May2018])+(XX.[Jun2018]+YY.[Jun2018])+(XX.[Jul2018]+YY.[Jul2018])+(XX.[Aug2018]+YY.[Aug2018])+(XX.[Sep2018]+YY.[Sep2018])+(XX.[Oct2018]+YY.[Oct2018])+(XX.[Nov2018]+YY.[Nov2018])+(XX.[Dec2018]+YY.[Dec2018])) as [Total_2018],

		XX.[total_2019]+YY.[total_2019] as [total_2019],
		XX.[total_2020]+YY.[total_2020] as [total_2020]

 from
(select	@base_part as [base_part],
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

		AA.[total_2019]*BB.[total_2019] as [total_2019],
		AA.[total_2020]*BB.[total_2020] as [total_2020]
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

					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[CY 2019]),0) as [total_2019], 
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[CY 2020]),0) as [total_2020]
					
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

					ISNULL(b.[CY 2019],0) as [total_2019], 
					ISNULL(b.[CY 2020],0) as [total_2020]
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
 
					ISNULL(b.[CY 2019],0) as [total_2019], 
					ISNULL(b.[CY 2020],0) as [total_2020]
			from 
					(	select	* 
						from	eeiuser.acctg_csm_base_part_mnemonic
					) a 
					join 
					(	select	* 
						from	eeiuser.acctg_csm_NAIHS 
						where	release_id = @release_id
							and VERSION = 'Empire Adjustment'
					) b
					on a.mnemonic = b.[Mnemonic-Vehicle/Plant]
					where	a.base_part = @base_part
		) YY 
on XX.base_part = YY.base_part







GO
