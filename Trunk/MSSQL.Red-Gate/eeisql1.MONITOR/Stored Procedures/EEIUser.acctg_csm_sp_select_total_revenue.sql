SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







/**		Created By:		Dan West								
		Created Date:	8/1/2007                                 
		Used By:		evision/empireweb/salesforecast.aspx                       
**/
/**     Change Log
		2013-11-19; Dan West; Renamed sp from acctg_csm_sp_select_total_revenue and deleted all other versions of the sp
**/

CREATE procedure [EEIUser].[acctg_csm_sp_select_total_revenue]
  @base_part varchar(30),
  @release_id varchar(30)
as

select
@base_part as [base_part],
'Total Revenue' as description,
((CC.[Jan2015]+YY.[Jan2015])*ZZ.[Jan2015]) as [Jan 2015],
((CC.[Feb2015]+YY.[Feb2015])*ZZ.[Feb2015]) as [Feb 2015],
((CC.[Mar2015]+YY.[Mar2015])*ZZ.[Mar2015]) as [Mar 2015],
((CC.[Apr2015]+YY.[Apr2015])*ZZ.[Apr2015]) as [Apr 2015],
((CC.[May2015]+YY.[May2015])*ZZ.[May2015]) as [May 2015],
((CC.[Jun2015]+YY.[Jun2015])*ZZ.[Jun2015]) as [Jun 2015],
((CC.[Jul2015]+YY.[Jul2015])*ZZ.[Jul2015]) as [Jul 2015],
((CC.[Aug2015]+YY.[Aug2015])*ZZ.[Aug2015]) as [Aug 2015],
((CC.[Sep2015]+YY.[Sep2015])*ZZ.[Sep2015]) as [Sep 2015],
((CC.[Oct2015]+YY.[Oct2015])*ZZ.[Oct2015]) as [Oct 2015],
((CC.[Nov2015]+YY.[Nov2015])*ZZ.[Nov2015]) as [Nov 2015],
((CC.[Dec2015]+YY.[Dec2015])*ZZ.[Dec2015]) as [Dec 2015],

(((CC.[Jan2015]+YY.[Jan2015])*ZZ.[Jan2015]) +
((CC.[Feb2015]+YY.[Feb2015])*ZZ.[Feb2015]) +
((CC.[Mar2015]+YY.[Mar2015])*ZZ.[Mar2015]) +
((CC.[Apr2015]+YY.[Apr2015])*ZZ.[Apr2015]) +
((CC.[May2015]+YY.[May2015])*ZZ.[May2015]) +
((CC.[Jun2015]+YY.[Jun2015])*ZZ.[Jun2015]) +
((CC.[Jul2015]+YY.[Jul2015])*ZZ.[Jul2015]) +
((CC.[Aug2015]+YY.[Aug2015])*ZZ.[Aug2015]) +
((CC.[Sep2015]+YY.[Sep2015])*ZZ.[Sep2015]) +
((CC.[Oct2015]+YY.[Oct2015])*ZZ.[Oct2015]) +
((CC.[Nov2015]+YY.[Nov2015])*ZZ.[Nov2015]) +
((CC.[Dec2015]+YY.[Dec2015])*ZZ.[Dec2015])) as [Total_2015],

((CC.[Jan2016]+YY.[Jan2016])*ZZ.[Jan2016]) as [Jan 2016],
((CC.[Feb2016]+YY.[Feb2016])*ZZ.[Feb2016]) as [Feb 2016],
((CC.[Mar2016]+YY.[Mar2016])*ZZ.[Mar2016]) as [Mar 2016],
((CC.[Apr2016]+YY.[Apr2016])*ZZ.[Apr2016]) as [Apr 2016],
((CC.[May2016]+YY.[May2016])*ZZ.[May2016]) as [May 2016],
((CC.[Jun2016]+YY.[Jun2016])*ZZ.[Jun2016]) as [Jun 2016],
((CC.[Jul2016]+YY.[Jul2016])*ZZ.[Jul2016]) as [Jul 2016],
((CC.[Aug2016]+YY.[Aug2016])*ZZ.[Aug2016]) as [Aug 2016],
((CC.[Sep2016]+YY.[Sep2016])*ZZ.[Sep2016]) as [Sep 2016],
((CC.[Oct2016]+YY.[Oct2016])*ZZ.[Oct2016]) as [Oct 2016],
((CC.[Nov2016]+YY.[Nov2016])*ZZ.[Nov2016]) as [Nov 2016],
((CC.[Dec2016]+YY.[Dec2016])*ZZ.[Dec2016]) as [Dec 2016],

(((CC.[Jan2016]+YY.[Jan2016])*ZZ.[Jan2016]) +
((CC.[Feb2016]+YY.[Feb2016])*ZZ.[Feb2016]) +
((CC.[Mar2016]+YY.[Mar2016])*ZZ.[Mar2016]) +
((CC.[Apr2016]+YY.[Apr2016])*ZZ.[Apr2016]) +
((CC.[May2016]+YY.[May2016])*ZZ.[May2016]) +
((CC.[Jun2016]+YY.[Jun2016])*ZZ.[Jun2016]) +
((CC.[Jul2016]+YY.[Jul2016])*ZZ.[Jul2016]) +
((CC.[Aug2016]+YY.[Aug2016])*ZZ.[Aug2016]) +
((CC.[Sep2016]+YY.[Sep2016])*ZZ.[Sep2016]) +
((CC.[Oct2016]+YY.[Oct2016])*ZZ.[Oct2016]) +
((CC.[Nov2016]+YY.[Nov2016])*ZZ.[Nov2016]) +
((CC.[Dec2016]+YY.[Dec2016])*ZZ.[Dec2016])) as [Total_2016],

((CC.[Jan2017]+YY.[Jan2017])*ZZ.[Jan2017]) as [Jan 2017],
((CC.[Feb2017]+YY.[Feb2017])*ZZ.[Feb2017]) as [Feb 2017],
((CC.[Mar2017]+YY.[Mar2017])*ZZ.[Mar2017]) as [Mar 2017],
((CC.[Apr2017]+YY.[Apr2017])*ZZ.[Apr2017]) as [Apr 2017],
((CC.[May2017]+YY.[May2017])*ZZ.[May2017]) as [May 2017],
((CC.[Jun2017]+YY.[Jun2017])*ZZ.[Jun2017]) as [Jun 2017],
((CC.[Jul2017]+YY.[Jul2017])*ZZ.[Jul2017]) as [Jul 2017],
((CC.[Aug2017]+YY.[Aug2017])*ZZ.[Aug2017]) as [Aug 2017],
((CC.[Sep2017]+YY.[Sep2017])*ZZ.[Sep2017]) as [Sep 2017],
((CC.[Oct2017]+YY.[Oct2017])*ZZ.[Oct2017]) as [Oct 2017],
((CC.[Nov2017]+YY.[Nov2017])*ZZ.[Nov2017]) as [Nov 2017],
((CC.[Dec2017]+YY.[Dec2017])*ZZ.[Dec2017]) as [Dec 2017],

(((CC.[Jan2017]+YY.[Jan2017])*ZZ.[Jan2017]) +
((CC.[Feb2017]+YY.[Feb2017])*ZZ.[Feb2017]) +
((CC.[Mar2017]+YY.[Mar2017])*ZZ.[Mar2017]) +
((CC.[Apr2017]+YY.[Apr2017])*ZZ.[Apr2017]) +
((CC.[May2017]+YY.[May2017])*ZZ.[May2017]) +
((CC.[Jun2017]+YY.[Jun2017])*ZZ.[Jun2017]) +
((CC.[Jul2017]+YY.[Jul2017])*ZZ.[Jul2017]) +
((CC.[Aug2017]+YY.[Aug2017])*ZZ.[Aug2017]) +
((CC.[Sep2017]+YY.[Sep2017])*ZZ.[Sep2017]) +
((CC.[Oct2017]+YY.[Oct2017])*ZZ.[Oct2017]) +
((CC.[Nov2017]+YY.[Nov2017])*ZZ.[Nov2017]) +
((CC.[Dec2017]+YY.[Dec2017])*ZZ.[Dec2017])) as [Total_2017],

((CC.[Jan2018]+YY.[Jan2018])*ZZ.[Jan2018]) as [Jan 2018],
((CC.[Feb2018]+YY.[Feb2018])*ZZ.[Feb2018]) as [Feb 2018],
((CC.[Mar2018]+YY.[Mar2018])*ZZ.[Mar2018]) as [Mar 2018],
((CC.[Apr2018]+YY.[Apr2018])*ZZ.[Apr2018]) as [Apr 2018],
((CC.[May2018]+YY.[May2018])*ZZ.[May2018]) as [May 2018],
((CC.[Jun2018]+YY.[Jun2018])*ZZ.[Jun2018]) as [Jun 2018],
((CC.[Jul2018]+YY.[Jul2018])*ZZ.[Jul2018]) as [Jul 2018],
((CC.[Aug2018]+YY.[Aug2018])*ZZ.[Aug2018]) as [Aug 2018],
((CC.[Sep2018]+YY.[Sep2018])*ZZ.[Sep2018]) as [Sep 2018],
((CC.[Oct2018]+YY.[Oct2018])*ZZ.[Oct2018]) as [Oct 2018],
((CC.[Nov2018]+YY.[Nov2018])*ZZ.[Nov2018]) as [Nov 2018],
((CC.[Dec2018]+YY.[Dec2018])*ZZ.[Dec2018]) as [Dec 2018],

(((CC.[Jan2018]+YY.[Jan2018])*ZZ.[Jan2018]) +
((CC.[Feb2018]+YY.[Feb2018])*ZZ.[Feb2018]) +
((CC.[Mar2018]+YY.[Mar2018])*ZZ.[Mar2018]) +
((CC.[Apr2018]+YY.[Apr2018])*ZZ.[Apr2018]) +
((CC.[May2018]+YY.[May2018])*ZZ.[May2018]) +
((CC.[Jun2018]+YY.[Jun2018])*ZZ.[Jun2018]) +
((CC.[Jul2018]+YY.[Jul2018])*ZZ.[Jul2018]) +
((CC.[Aug2018]+YY.[Aug2018])*ZZ.[Aug2018]) +
((CC.[Sep2018]+YY.[Sep2018])*ZZ.[Sep2018]) +
((CC.[Oct2018]+YY.[Oct2018])*ZZ.[Oct2018]) +
((CC.[Nov2018]+YY.[Nov2018])*ZZ.[Nov2018]) +
((CC.[Dec2018]+YY.[Dec2018])*ZZ.[Dec2018])) as [Total_2018],

((CC.[Total_2019]+YY.[Total_2019])*ZZ.[Total_2019]) as [Total_2019],
((CC.[Total_2020]+YY.[Total_2020])*ZZ.[Total_2020]) as [Total_2020]
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
on AA.base_part = BB.base_part) YY
left outer join
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
		) CC
on YY.base_part = CC.base_part
left outer join
(select @base_part as [base_part],
		'Selling Price ' as description, 
		version as version,
		inclusion as inclusion,
		row_id as row_id,
		ISNULL(jan_15,0) as [Jan2015],
		ISNULL(feb_15,0) as [Feb2015],
		ISNULL(mar_15,0) as [Mar2015],
		ISNULL(apr_15,0) as [Apr2015],
		ISNULL(may_15,0) as [May2015],
		ISNULL(jun_15,0) as [Jun2015],
		ISNULL(jul_15,0) as [Jul2015],
		ISNULL(aug_15,0) as [Aug2015],
		ISNULL(sep_15,0) as [Sep2015],
		ISNULL(oct_15,0) as [Oct2015],
		ISNULL(nov_15,0) as [Nov2015],
		ISNULL(dec_15,0) as [Dec2015],
		'' as Total_2015,

		ISNULL(jan_16,0) as [Jan2016],
		ISNULL(feb_16,0) as [Feb2016],
		ISNULL(mar_16,0) as [Mar2016],
		ISNULL(apr_16,0) as [Apr2016],
		ISNULL(may_16,0) as [May2016],
		ISNULL(jun_16,0) as [Jun2016],
		ISNULL(jul_16,0) as [Jul2016],
		ISNULL(aug_16,0) as [Aug2016],
		ISNULL(sep_16,0) as [Sep2016],
		ISNULL(oct_16,0) as [Oct2016],
		ISNULL(nov_16,0) as [Nov2016],
		ISNULL(dec_16,0) as [Dec2016],
		'' as Total_2016,

		ISNULL(jan_17,0) as [Jan2017],
		ISNULL(feb_17,0) as [Feb2017],
		ISNULL(mar_17,0) as [Mar2017],
		ISNULL(apr_17,0) as [Apr2017],
		ISNULL(may_17,0) as [May2017],
		ISNULL(jun_17,0) as [Jun2017],
		ISNULL(jul_17,0) as [Jul2017],
		ISNULL(aug_17,0) as [Aug2017],
		ISNULL(sep_17,0) as [Sep2017],
		ISNULL(oct_17,0) as [Oct2017],
		ISNULL(nov_17,0) as [Nov2017],
		ISNULL(dec_17,0) as [Dec2017],
		'' as Total_2017,

		ISNULL(jan_18,0) as [Jan2018],
		ISNULL(feb_18,0) as [Feb2018],
		ISNULL(mar_18,0) as [Mar2018],
		ISNULL(apr_18,0) as [Apr2018],
		ISNULL(may_18,0) as [May2018],
		ISNULL(jun_18,0) as [Jun2018],
		ISNULL(jul_18,0) as [Jul2018],
		ISNULL(aug_18,0) as [Aug2018],
		ISNULL(sep_18,0) as [Sep2018],
		ISNULL(oct_18,0) as [Oct2018],
		ISNULL(nov_18,0) as [Nov2018],
		ISNULL(dec_18,0) as [Dec2018],
		'' as Total_2018,

		ISNULL(dec_19,0) as [Total_2019],
		ISNULL(dec_19,0) as [Total_2020]
from eeiuser.acctg_csm_selling_prices_tabular 
where BASE_PART = @base_part 
and release_id = @release_id) ZZ
on YY.base_part = ZZ.base_part








GO
