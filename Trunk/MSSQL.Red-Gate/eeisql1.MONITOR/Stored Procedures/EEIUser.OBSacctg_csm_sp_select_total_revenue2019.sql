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

create procedure [EEIUser].[OBSacctg_csm_sp_select_total_revenue2019]
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

((CC.[Jan2019]+YY.[Jan2019])*ZZ.[Jan2019]) as [Jan 2019],
((CC.[Feb2019]+YY.[Feb2019])*ZZ.[Feb2019]) as [Feb 2019],
((CC.[Mar2019]+YY.[Mar2019])*ZZ.[Mar2019]) as [Mar 2019],
((CC.[Apr2019]+YY.[Apr2019])*ZZ.[Apr2019]) as [Apr 2019],
((CC.[May2019]+YY.[May2019])*ZZ.[May2019]) as [May 2019],
((CC.[Jun2019]+YY.[Jun2019])*ZZ.[Jun2019]) as [Jun 2019],
((CC.[Jul2019]+YY.[Jul2019])*ZZ.[Jul2019]) as [Jul 2019],
((CC.[Aug2019]+YY.[Aug2019])*ZZ.[Aug2019]) as [Aug 2019],
((CC.[Sep2019]+YY.[Sep2019])*ZZ.[Sep2019]) as [Sep 2019],
((CC.[Oct2019]+YY.[Oct2019])*ZZ.[Oct2019]) as [Oct 2019],
((CC.[Nov2019]+YY.[Nov2019])*ZZ.[Nov2019]) as [Nov 2019],
((CC.[Dec2019]+YY.[Dec2019])*ZZ.[Dec2019]) as [Dec 2019],

(((CC.[Jan2019]+YY.[Jan2019])*ZZ.[Jan2019]) +
((CC.[Feb2019]+YY.[Feb2019])*ZZ.[Feb2019]) +
((CC.[Mar2019]+YY.[Mar2019])*ZZ.[Mar2019]) +
((CC.[Apr2019]+YY.[Apr2019])*ZZ.[Apr2019]) +
((CC.[May2019]+YY.[May2019])*ZZ.[May2019]) +
((CC.[Jun2019]+YY.[Jun2019])*ZZ.[Jun2019]) +
((CC.[Jul2019]+YY.[Jul2019])*ZZ.[Jul2019]) +
((CC.[Aug2019]+YY.[Aug2019])*ZZ.[Aug2019]) +
((CC.[Sep2019]+YY.[Sep2019])*ZZ.[Sep2019]) +
((CC.[Oct2019]+YY.[Oct2019])*ZZ.[Oct2019]) +
((CC.[Nov2019]+YY.[Nov2019])*ZZ.[Nov2019]) +
((CC.[Dec2019]+YY.[Dec2019])*ZZ.[Dec2019])) as [Total_2019],

((CC.[Jan2020]+YY.[Jan2020])*ZZ.[Jan2020]) as [Jan 2020],
((CC.[Feb2020]+YY.[Feb2020])*ZZ.[Feb2020]) as [Feb 2020],
((CC.[Mar2020]+YY.[Mar2020])*ZZ.[Mar2020]) as [Mar 2020],
((CC.[Apr2020]+YY.[Apr2020])*ZZ.[Apr2020]) as [Apr 2020],
((CC.[May2020]+YY.[May2020])*ZZ.[May2020]) as [May 2020],
((CC.[Jun2020]+YY.[Jun2020])*ZZ.[Jun2020]) as [Jun 2020],
((CC.[Jul2020]+YY.[Jul2020])*ZZ.[Jul2020]) as [Jul 2020],
((CC.[Aug2020]+YY.[Aug2020])*ZZ.[Aug2020]) as [Aug 2020],
((CC.[Sep2020]+YY.[Sep2020])*ZZ.[Sep2020]) as [Sep 2020],
((CC.[Oct2020]+YY.[Oct2020])*ZZ.[Oct2020]) as [Oct 2020],
((CC.[Nov2020]+YY.[Nov2020])*ZZ.[Nov2020]) as [Nov 2020],
((CC.[Dec2020]+YY.[Dec2020])*ZZ.[Dec2020]) as [Dec 2020],

(((CC.[Jan2020]+YY.[Jan2020])*ZZ.[Jan2020]) +
((CC.[Feb2020]+YY.[Feb2020])*ZZ.[Feb2020]) +
((CC.[Mar2020]+YY.[Mar2020])*ZZ.[Mar2020]) +
((CC.[Apr2020]+YY.[Apr2020])*ZZ.[Apr2020]) +
((CC.[May2020]+YY.[May2020])*ZZ.[May2020]) +
((CC.[Jun2020]+YY.[Jun2020])*ZZ.[Jun2020]) +
((CC.[Jul2020]+YY.[Jul2020])*ZZ.[Jul2020]) +
((CC.[Aug2020]+YY.[Aug2020])*ZZ.[Aug2020]) +
((CC.[Sep2020]+YY.[Sep2020])*ZZ.[Sep2020]) +
((CC.[Oct2020]+YY.[Oct2020])*ZZ.[Oct2020]) +
((CC.[Nov2020]+YY.[Nov2020])*ZZ.[Nov2020]) +
((CC.[Dec2020]+YY.[Dec2020])*ZZ.[Dec2020])) as [Total_2020],

((CC.[Jan2021]+YY.[Jan2021])*ZZ.[Jan2021]) as [Jan 2021],
((CC.[Feb2021]+YY.[Feb2021])*ZZ.[Feb2021]) as [Feb 2021],
((CC.[Mar2021]+YY.[Mar2021])*ZZ.[Mar2021]) as [Mar 2021],
((CC.[Apr2021]+YY.[Apr2021])*ZZ.[Apr2021]) as [Apr 2021],
((CC.[May2021]+YY.[May2021])*ZZ.[May2021]) as [May 2021],
((CC.[Jun2021]+YY.[Jun2021])*ZZ.[Jun2021]) as [Jun 2021],
((CC.[Jul2021]+YY.[Jul2021])*ZZ.[Jul2021]) as [Jul 2021],
((CC.[Aug2021]+YY.[Aug2021])*ZZ.[Aug2021]) as [Aug 2021],
((CC.[Sep2021]+YY.[Sep2021])*ZZ.[Sep2021]) as [Sep 2021],
((CC.[Oct2021]+YY.[Oct2021])*ZZ.[Oct2021]) as [Oct 2021],
((CC.[Nov2021]+YY.[Nov2021])*ZZ.[Nov2021]) as [Nov 2021],
((CC.[Dec2021]+YY.[Dec2021])*ZZ.[Dec2021]) as [Dec 2021],

(((CC.[Jan2021]+YY.[Jan2021])*ZZ.[Jan2021]) +
((CC.[Feb2021]+YY.[Feb2021])*ZZ.[Feb2021]) +
((CC.[Mar2021]+YY.[Mar2021])*ZZ.[Mar2021]) +
((CC.[Apr2021]+YY.[Apr2021])*ZZ.[Apr2021]) +
((CC.[May2021]+YY.[May2021])*ZZ.[May2021]) +
((CC.[Jun2021]+YY.[Jun2021])*ZZ.[Jun2021]) +
((CC.[Jul2021]+YY.[Jul2021])*ZZ.[Jul2021]) +
((CC.[Aug2021]+YY.[Aug2021])*ZZ.[Aug2021]) +
((CC.[Sep2021]+YY.[Sep2021])*ZZ.[Sep2021]) +
((CC.[Oct2021]+YY.[Oct2021])*ZZ.[Oct2021]) +
((CC.[Nov2021]+YY.[Nov2021])*ZZ.[Nov2021]) +
((CC.[Dec2021]+YY.[Dec2021])*ZZ.[Dec2021])) as [Total_2021],

/*
((CC.[Jan2022]+YY.[Jan2022])*ZZ.[Jan2022]) as [Jan 2022],
((CC.[Feb2022]+YY.[Feb2022])*ZZ.[Feb2022]) as [Feb 2022],
((CC.[Mar2022]+YY.[Mar2022])*ZZ.[Mar2022]) as [Mar 2022],
((CC.[Apr2022]+YY.[Apr2022])*ZZ.[Apr2022]) as [Apr 2022],
((CC.[May2022]+YY.[May2022])*ZZ.[May2022]) as [May 2022],
((CC.[Jun2022]+YY.[Jun2022])*ZZ.[Jun2022]) as [Jun 2022],
((CC.[Jul2022]+YY.[Jul2022])*ZZ.[Jul2022]) as [Jul 2022],
((CC.[Aug2022]+YY.[Aug2022])*ZZ.[Aug2022]) as [Aug 2022],
((CC.[Sep2022]+YY.[Sep2022])*ZZ.[Sep2022]) as [Sep 2022],
((CC.[Oct2022]+YY.[Oct2022])*ZZ.[Oct2022]) as [Oct 2022],
((CC.[Nov2022]+YY.[Nov2022])*ZZ.[Nov2022]) as [Nov 2022],
((CC.[Dec2022]+YY.[Dec2022])*ZZ.[Dec2022]) as [Dec 2022],

(((CC.[Jan2022]+YY.[Jan2022])*ZZ.[Jan2022]) +
((CC.[Feb2022]+YY.[Feb2022])*ZZ.[Feb2022]) +
((CC.[Mar2022]+YY.[Mar2022])*ZZ.[Mar2022]) +
((CC.[Apr2022]+YY.[Apr2022])*ZZ.[Apr2022]) +
((CC.[May2022]+YY.[May2022])*ZZ.[May2022]) +
((CC.[Jun2022]+YY.[Jun2022])*ZZ.[Jun2022]) +
((CC.[Jul2022]+YY.[Jul2022])*ZZ.[Jul2022]) +
((CC.[Aug2022]+YY.[Aug2022])*ZZ.[Aug2022]) +
((CC.[Sep2022]+YY.[Sep2022])*ZZ.[Sep2022]) +
((CC.[Oct2022]+YY.[Oct2022])*ZZ.[Oct2022]) +
((CC.[Nov2022]+YY.[Nov2022])*ZZ.[Nov2022]) +
((CC.[Dec2022]+YY.[Dec2022])*ZZ.[Dec2022])) as [Total_2022],
*/

((CC.[Total_2022]+YY.[Total_2022])*ZZ.[Total_2022]) as [Total_2022],
((CC.[Total_2023]+YY.[Total_2023])*ZZ.[Total_2023]) as [Total_2023],
((CC.[Total_2024]+YY.[Total_2024])*ZZ.[Total_2024]) as [Total_2024],
((CC.[Total_2025]+YY.[Total_2025])*ZZ.[Total_2025]) as [Total_2025],
((CC.[Total_2026]+YY.[Total_2026])*ZZ.[Total_2026]) as [Total_2026]
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

		/*
		AA.[Jan 2022]*BB.[Jan 2022] as [Jan2022],
		AA.[Feb 2022]*BB.[Feb 2022] as [Feb2022],
		AA.[Mar 2022]*BB.[Mar 2022] as [Mar2022],
		AA.[Apr 2022]*BB.[Apr 2022] as [Apr2022],
		(AA.[May 2022]*BB.[May 2022]) as [May2022],
		(AA.[Jun 2022]*BB.[Jun 2022]) as [Jun2022],
		(AA.[Jul 2022]*BB.[Jul 2022]) as [Jul2022],
		(AA.[Aug 2022]*BB.[Aug 2022]) as [Aug2022],
		(AA.[Sep 2022]*BB.[Sep 2022]) as [Sep2022],
		(AA.[Oct 2022]*BB.[Oct 2022]) as [Oct2022],
		(AA.[Nov 2022]*BB.[Nov 2022]) as [Nov2022],
		(AA.[Dec 2022]*BB.[Dec 2022]) as [Dec2022],
		((AA.[Jan 2022]*BB.[Jan 2022])+(AA.[Feb 2022]*BB.[Feb 2022])+(AA.[Mar 2022]*BB.[Mar 2022])+(AA.[Apr 2022]*BB.[Apr 2022])+(AA.[May 2022]*BB.[May 2022])+(AA.[Jun 2022]*BB.[Jun 2022])+(AA.[Jul 2022]*BB.[Jul 2022])+(AA.[Aug 2022]*BB.[Aug 2022])+(AA.[Sep 2022]*BB.[Sep 2022])+(AA.[Oct 2022]*BB.[Oct 2022])+(AA.[Nov 2022]*BB.[Nov 2022])+(AA.[Dec 2022]*BB.[Dec 2022])) as [Total_2022],
		*/
		
		AA.[total_2022]*BB.[total_2022] as [total_2022],
		AA.[total_2023]*BB.[total_2023] as [total_2023],
		AA.[total_2024]*BB.[total_2024] as [total_2024],
		AA.[total_2025]*BB.[total_2025] as [total_2025],
		AA.[total_2026]*BB.[total_2026] as [total_2026]

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

					/*
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2022]),0) as [jan 2022], 
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2022]),0) as [feb 2022], 
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2022]),0) as [mar 2022], 
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2022]),0) as [apr 2022], 
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[May 2022]),0) as [may 2022], 
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2022]),0) as [jun 2022], 
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2022]),0) as [jul 2022], 
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2022]),0) as [aug 2022], 
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2022]),0) as [sep 2022], 
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2022]),0) as [oct 2022], 
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2022]),0) as [nov 2022], 
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2022]),0) as [dec 2022], 
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2022]+b.[Feb 2022]+b.[Mar 2022]+b.[Apr 2022]+b.[May 2022]+b.[Jun 2022]+b.[Jul 2022]+b.[Aug 2022]+b.[Sep 2022]+b.[Oct 2022]+b.[Nov 2022]+b.[Dec 2022])),0) as [total_2022],
					*/
					
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[CY 2022]),0) as [total_2022],
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[CY 2023]),0) as [total_2023],
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[CY 2024]),0) as [total_2024],
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[CY 2025]),0) as [total_2025],
					ISNULL(sum(a.qty_per*a.take_rate*a.family_allocation*b.[CY 2026]),0) as [total_2026] 


			from 
					(	select	* 
						from	eeiuser.acctg_csm_base_part_mnemonic
						where	release_id = @release_id
					) a 
					left outer join 
					(	select	* 
						from	eeiuser.acctg_csm_NAIHS 
						where	release_id = @release_id
							and VERSION = 'CSM'
					) b
					on a.mnemonic = b.[Mnemonic-Vehicle/Plant] 
					and a.release_id = b.release_id
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
					
					/*
					ISNULL(b.[Jan 2022],0) as [jan 2022], 
					ISNULL(b.[Feb 2022],0) as [feb 2022], 
					ISNULL(b.[Mar 2022],0) as [mar 2022], 
					ISNULL(b.[Apr 2022],0) as [apr 2022], 
					ISNULL(b.[May 2022],0) as [may 2022], 
					ISNULL(b.[Jun 2022],0) as [jun 2022], 
					ISNULL(b.[Jul 2022],0) as [jul 2022], 
					ISNULL(b.[Aug 2022],0) as [aug 2022], 
					ISNULL(b.[Sep 2022],0) as [sep 2022], 
					ISNULL(b.[Oct 2022],0) as [oct 2022], 
					ISNULL(b.[Nov 2022],0) as [nov 2022], 
					ISNULL(b.[Dec 2022],0) as [dec 2022], 
					ISNULL((b.[Jan 2022]+b.[Feb 2022]+b.[Mar 2022]+b.[Apr 2022]+b.[May 2022]+b.[Jun 2022]+b.[Jul 2022]+b.[Aug 2022]+b.[Sep 2022]+b.[Oct 2022]+b.[Nov 2022]+b.[Dec 2022]),0) as [total_2022],
					*/

					ISNULL(b.[CY 2022],0) as [total_2022],
					ISNULL(b.[CY 2023],0) as [total_2023],
					ISNULL(b.[CY 2024],0) as [total_2024],
					ISNULL(b.[CY 2025],0) as [total_2025],
					ISNULL(b.[CY 2026],0) as [total_2026]
			from 
					(	select	* 
						from	eeiuser.acctg_csm_base_part_mnemonic
						where	release_id = @release_id
					) a 
					join 
					(	select	* 
						from	eeiuser.acctg_csm_NAIHS 
						where	release_id = @release_id
							and VERSION = 'Empire Factor'
					) b
					on a.mnemonic = b.[Mnemonic-Vehicle/Plant]
					and a.release_id = b.release_id
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

					/*
					ISNULL(b.[Jan 2022],0) as [jan2022], 
					ISNULL(b.[Feb 2022],0) as [feb2022], 
					ISNULL(b.[Mar 2022],0) as [mar2022], 
					ISNULL(b.[Apr 2022],0) as [apr2022], 
					ISNULL(b.[May 2022],0) as [may2022], 
					ISNULL(b.[Jun 2022],0) as [jun2022], 
					ISNULL(b.[Jul 2022],0) as [jul2022], 
					ISNULL(b.[Aug 2022],0) as [aug2022], 
					ISNULL(b.[Sep 2022],0) as [sep2022], 
					ISNULL(b.[Oct 2022],0) as [oct2022], 
					ISNULL(b.[Nov 2022],0) as [nov2022], 
					ISNULL(b.[Dec 2022],0) as [dec2022], 
					ISNULL((b.[Jan 2022]+b.[Feb 2022]+b.[Mar 2022]+b.[Apr 2022]+b.[May 2022]+b.[Jun 2022]+b.[Jul 2022]+b.[Aug 2022]+b.[Sep 2022]+b.[Oct 2022]+b.[Nov 2022]+b.[Dec 2022]),0) as [total_2022],
					*/
					
					ISNULL(b.[CY 2022],0) as [total_2022],
					ISNULL(b.[CY 2023],0) as [total_2023],
					ISNULL(b.[CY 2024],0) as [total_2024],
					ISNULL(b.[CY 2025],0) as [total_2025],
					ISNULL(b.[CY 2026],0) as [total_2026]
			from 
					(	select	* 
						from	eeiuser.acctg_csm_base_part_mnemonic
						where	release_id = @release_id
					) a 
					join 
					(	select	* 
						from	eeiuser.acctg_csm_NAIHS 
						where	release_id = @release_id
							and VERSION = 'Empire Adjustment'
					) b
					on a.mnemonic = b.[Mnemonic-Vehicle/Plant]
					and a.release_id = b.release_id
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
		
		ISNULL(jan_19,0) as [Jan2019],
		ISNULL(feb_19,0) as [Feb2019],
		ISNULL(mar_19,0) as [Mar2019],
		ISNULL(apr_19,0) as [Apr2019],
		ISNULL(may_19,0) as [May2019],
		ISNULL(jun_19,0) as [Jun2019],
		ISNULL(jul_19,0) as [Jul2019],
		ISNULL(aug_19,0) as [Aug2019],
		ISNULL(sep_19,0) as [Sep2019],
		ISNULL(oct_19,0) as [Oct2019],
		ISNULL(nov_19,0) as [Nov2019],
		ISNULL(dec_19,0) as [Dec2019],
		'' as Total_2019,

		ISNULL(jan_20,0) as [Jan2020],
		ISNULL(feb_20,0) as [Feb2020],
		ISNULL(mar_20,0) as [Mar2020],
		ISNULL(apr_20,0) as [Apr2020],
		ISNULL(may_20,0) as [May2020],
		ISNULL(jun_20,0) as [Jun2020],
		ISNULL(jul_20,0) as [Jul2020],
		ISNULL(aug_20,0) as [Aug2020],
		ISNULL(sep_20,0) as [Sep2020],
		ISNULL(oct_20,0) as [Oct2020],
		ISNULL(nov_20,0) as [Nov2020],
		ISNULL(dec_20,0) as [Dec2020],
		'' as Total_2020,
		
		ISNULL(jan_21,0) as [Jan2021],
		ISNULL(feb_21,0) as [Feb2021],
		ISNULL(mar_21,0) as [Mar2021],
		ISNULL(apr_21,0) as [Apr2021],
		ISNULL(may_21,0) as [May2021],
		ISNULL(jun_21,0) as [Jun2021],
		ISNULL(jul_21,0) as [Jul2021],
		ISNULL(aug_21,0) as [Aug2021],
		ISNULL(sep_21,0) as [Sep2021],
		ISNULL(oct_21,0) as [Oct2021],
		ISNULL(nov_21,0) as [Nov2021],
		ISNULL(dec_21,0) as [Dec2021],
		'' as Total_2021,

		/*
		ISNULL(jan_22,0) as [Jan2022],
		ISNULL(feb_22,0) as [Feb2022],
		ISNULL(mar_22,0) as [Mar2022],
		ISNULL(apr_22,0) as [Apr2022],
		ISNULL(may_22,0) as [May2022],
		ISNULL(jun_22,0) as [Jun2022],
		ISNULL(jul_22,0) as [Jul2022],
		ISNULL(aug_22,0) as [Aug2022],
		ISNULL(sep_22,0) as [Sep2022],
		ISNULL(oct_22,0) as [Oct2022],
		ISNULL(nov_22,0) as [Nov2022],
		ISNULL(dec_22,0) as [Dec2022],
		'' as Total_2022,
		*/
		
		ISNULL(dec_22,0) as [Total_2022],
		ISNULL(dec_23,0) as [Total_2023],
		ISNULL(dec_24,0) as [Total_2024],
		ISNULL(dec_25,0) as [Total_2025],
		ISNULL(dec_26,0) as [Total_2026]

from eeiuser.acctg_csm_selling_prices_tabular 
where BASE_PART = @base_part 
and release_id = @release_id) ZZ
on YY.base_part = ZZ.base_part









GO
