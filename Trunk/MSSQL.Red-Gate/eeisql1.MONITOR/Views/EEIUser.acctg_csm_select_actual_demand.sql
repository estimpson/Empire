SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [EEIUser].[acctg_csm_select_actual_demand] 

as



select
base_part,
'Actual Demand' as description,
sum([jan 2012]) as [Jan 2012],
sum([feb 2012]) as [Feb 2012],
sum([mar 2012]) as [Mar 2012],
sum([apr 2012]) as [Apr 2012],
sum([may 2012]) as [May 2012],
sum([jun 2012]) as [Jun 2012],
sum([jul 2012]) as [Jul 2012],
sum([aug 2012]) as [Aug 2012],
sum([sep 2012]) as [Sep 2012],
sum([oct 2012]) as [Oct 2012],
sum([nov 2012]) as [Nov 2012],
sum([dec 2012]) as [Dec 2012],
sum([total_2012]) as [total_2012],
sum([jan 2013]) as [Jan 2013],
sum([feb 2013]) as [Feb 2013],
sum([mar 2013]) as [Mar 2013],
sum([apr 2013]) as [Apr 2013],
sum([may 2013]) as [May 2013],
sum([jun 2013]) as [Jun 2013],
sum([jul 2013]) as [Jul 2013],
sum([aug 2013]) as [Aug 2013],
sum([sep 2013]) as [Sep 2013],
sum([oct 2013]) as [Oct 2013],
sum([nov 2013]) as [Nov 2013],
sum([dec 2013]) as [Dec 2013],
sum([total_2013]) as [total_2013],
sum([jan 2014]) as [Jan 2014],
sum([feb 2014]) as [Feb 2014],
sum([mar 2014]) as [Mar 2014],
sum([apr 2014]) as [Apr 2014],
sum([may 2014]) as [May 2014],
sum([jun 2014]) as [Jun 2014],
sum([jul 2014]) as [Jul 2014],
sum([aug 2014]) as [Aug 2014],
sum([sep 2014]) as [Sep 2014],
sum([oct 2014]) as [Oct 2014],
sum([nov 2014]) as [Nov 2014],
sum([dec 2014]) as [Dec 2014],
sum([total_2014]) as [total_2014],
sum([jan 2015]) as [Jan 2015],
sum([feb 2015]) as [Feb 2015],
sum([mar 2015]) as [Mar 2015],
sum([apr 2015]) as [Apr 2015],
sum([may 2015]) as [May 2015],
sum([jun 2015]) as [Jun 2015],
sum([jul 2015]) as [Jul 2015],
sum([aug 2015]) as [Aug 2015],
sum([sep 2015]) as [Sep 2015],
sum([oct 2015]) as [Oct 2015],
sum([nov 2015]) as [Nov 2015],
sum([dec 2015]) as [Dec 2015],
sum([total_2015]) as [total_2015],
sum([jan 2016]) as [Jan 2016],
sum([feb 2016]) as [Feb 2016],
sum([mar 2016]) as [Mar 2016],
sum([apr 2016]) as [Apr 2016],
sum([may 2016]) as [May 2016],
sum([jun 2016]) as [Jun 2016],
sum([jul 2016]) as [Jul 2016],
sum([aug 2016]) as [Aug 2016],
sum([sep 2016]) as [Sep 2016],
sum([oct 2016]) as [Oct 2016],
sum([nov 2016]) as [Nov 2016],
sum([dec 2016]) as [Dec 2016],
sum([total_2016]) as [total_2016],
sum([jan 2017]) as [Jan 2017],
sum([feb 2017]) as [Feb 2017],
sum([mar 2017]) as [Mar 2017],
sum([apr 2017]) as [Apr 2017],
sum([may 2017]) as [May 2017],
sum([jun 2017]) as [Jun 2017],
sum([jul 2017]) as [Jul 2017],
sum([aug 2017]) as [Aug 2017],
sum([sep 2017]) as [Sep 2017],
sum([oct 2017]) as [Oct 2017],
sum([nov 2017]) as [Nov 2017],
sum([dec 2017]) as [Dec 2017],
sum([total_2017]) as [total_2017],
sum(0) as total_2018,
sum(0) as total_2019

from
(select
base_part,
'Planner Demand' as description,
sum(jan_12) as [Jan 2012],
sum(feb_12) as [Feb 2012],
sum(mar_12) as [Mar 2012],
sum(apr_12) as [Apr 2012],
sum(may_12) as [May 2012],
sum(jun_12) as [Jun 2012],
sum(jul_12) as [Jul 2012],
sum(aug_12) as [Aug 2012],
sum(sep_12) as [Sep 2012],
sum(oct_12) as [Oct 2012],
sum(nov_12) as [Nov 2012],
sum(dec_12) as [Dec 2012],
(sum(jan_12)+sum(feb_12)+sum(mar_12)+sum(apr_12)+sum(may_12)+sum(jun_12)+sum(jul_12)+sum(aug_12)+sum(sep_12)+sum(oct_12)+sum(nov_12)+sum(dec_12)) as total_2012,
sum(jan_13) as [Jan 2013],
sum(feb_13) as [Feb 2013],
sum(mar_13) as [Mar 2013],
sum(apr_13) as [Apr 2013],
sum(may_13) as [May 2013],
sum(jun_13) as [Jun 2013],
sum(jul_13) as [Jul 2013],
sum(aug_13) as [Aug 2013],
sum(sep_13) as [Sep 2013],
sum(oct_13) as [Oct 2013],
sum(nov_13) as [Nov 2013],
sum(dec_13) as [Dec 2013],
(sum(jan_13)+sum(feb_13)+sum(mar_13)+sum(apr_13)+sum(may_13)+sum(jun_13)+sum(jul_13)+sum(aug_13)+sum(sep_13)+sum(oct_13)+sum(nov_13)+sum(dec_13)) as total_2013,
sum(jan_14) as [Jan 2014],
sum(feb_14) as [Feb 2014],
sum(mar_14) as [Mar 2014],
sum(apr_14) as [Apr 2014],
sum(may_14) as [May 2014],
sum(jun_14) as [Jun 2014],
sum(jul_14) as [Jul 2014],
sum(aug_14) as [Aug 2014],
sum(sep_14) as [Sep 2014],
sum(oct_14) as [Oct 2014],
sum(nov_14) as [Nov 2014],
sum(dec_14) as [Dec 2014],
(sum(jan_14)+sum(feb_14)+sum(mar_14)+sum(apr_14)+sum(may_14)+sum(jun_14)+sum(jul_14)+sum(aug_14)+sum(sep_14)+sum(oct_14)+sum(nov_14)+sum(dec_14)) as total_2014,
sum(jan_15) as [Jan 2015],
sum(feb_15) as [Feb 2015],
sum(mar_15) as [Mar 2015],
sum(apr_15) as [Apr 2015],
sum(may_15) as [May 2015],
sum(jun_15) as [Jun 2015],
sum(jul_15) as [Jul 2015],
sum(aug_15) as [Aug 2015],
sum(sep_15) as [Sep 2015],
sum(oct_15) as [Oct 2015],
sum(nov_15) as [Nov 2015],
sum(dec_15) as [Dec 2015],
(sum(jan_15)+sum(feb_15)+sum(mar_15)+sum(apr_15)+sum(may_15)+sum(jun_15)+sum(jul_15)+sum(aug_15)+sum(sep_15)+sum(oct_15)+sum(nov_15)+sum(dec_15)) as total_2015,
sum(jan_16) as [Jan 2016],
sum(feb_16) as [Feb 2016],
sum(mar_16) as [Mar 2016],
sum(apr_16) as [Apr 2016],
sum(may_16) as [May 2016],
sum(jun_16) as [Jun 2016],
sum(jul_16) as [Jul 2016],
sum(aug_16) as [Aug 2016],
sum(sep_16) as [Sep 2016],
sum(oct_16) as [Oct 2016],
sum(nov_16) as [Nov 2016],
sum(dec_16) as [Dec 2016],
(sum(jan_16)+sum(feb_16)+sum(mar_16)+sum(apr_16)+sum(may_16)+sum(jun_16)+sum(jul_16)+sum(aug_16)+sum(sep_16)+sum(oct_16)+sum(nov_16)+sum(dec_16)) as total_2016,
sum(jan_17) as [Jan 2017],
sum(feb_17) as [Feb 2017],
sum(mar_17) as [Mar 2017],
sum(apr_17) as [Apr 2017],
sum(may_17) as [May 2017],
sum(jun_17) as [Jun 2017],
sum(jul_17) as [Jul 2017],
sum(aug_17) as [Aug 2017],
sum(sep_17) as [Sep 2017],
sum(oct_17) as [Oct 2017],
sum(nov_17) as [Nov 2017],
sum(dec_17) as [Dec 2017],
(sum(jan_17)+sum(feb_17)+sum(mar_17)+sum(apr_17)+sum(may_17)+sum(jun_17)+sum(jul_17)+sum(aug_17)+sum(sep_17)+sum(oct_17)+sum(nov_17)+sum(dec_17)) as total_2017,
sum(0) as total_2018,
sum(0) as total_2019
from
(select left(part_number,7) as base_part,
(case when (datepart(mm,due_date) = 1 and datepart(yyyy,due_date) = 2012) then sum(eeiqty) else 0 end) as jan_12,
(case when (datepart(mm,due_date) = 2 and datepart(yyyy,due_date) = 2012) then sum(eeiqty) else 0 end) as feb_12,
(case when (datepart(mm,due_date) = 3 and datepart(yyyy,due_date) = 2012) then sum(eeiqty) else 0 end) as mar_12,
(case when (datepart(mm,due_date) = 4 and datepart(yyyy,due_date) = 2012) then sum(eeiqty) else 0 end) as apr_12,
(case when (datepart(mm,due_date) = 5 and datepart(yyyy,due_date) = 2012) then sum(eeiqty) else 0 end) as may_12,
(case when (datepart(mm,due_date) = 6 and datepart(yyyy,due_date) = 2012) then sum(eeiqty) else 0 end) as jun_12,
(case when (datepart(mm,due_date) = 7 and datepart(yyyy,due_date) = 2012) then sum(eeiqty) else 0 end) as jul_12,
(case when (datepart(mm,due_date) = 8 and datepart(yyyy,due_date) = 2012) then sum(eeiqty) else 0 end) as aug_12,
(case when (datepart(mm,due_date) = 9 and datepart(yyyy,due_date) = 2012) then sum(eeiqty) else 0 end) as sep_12,
(case when (datepart(mm,due_date) = 10 and datepart(yyyy,due_date) = 2012) then sum(eeiqty) else 0 end) as oct_12,
(case when (datepart(mm,due_date) = 11 and datepart(yyyy,due_date) = 2012) then sum(eeiqty) else 0 end) as nov_12,
(case when (datepart(mm,due_date) = 12 and datepart(yyyy,due_date) = 2012) then sum(eeiqty) else 0 end) as dec_12,
(case when (datepart(mm,due_date) = 1 and datepart(yyyy,due_date) = 2013) then sum(eeiqty) else 0 end) as jan_13,
(case when (datepart(mm,due_date) = 2 and datepart(yyyy,due_date) = 2013) then sum(eeiqty) else 0 end) as feb_13,
(case when (datepart(mm,due_date) = 3 and datepart(yyyy,due_date) = 2013) then sum(eeiqty) else 0 end) as mar_13,
(case when (datepart(mm,due_date) = 4 and datepart(yyyy,due_date) = 2013) then sum(eeiqty) else 0 end) as apr_13,
(case when (datepart(mm,due_date) = 5 and datepart(yyyy,due_date) = 2013) then sum(eeiqty) else 0 end) as may_13,
(case when (datepart(mm,due_date) = 6 and datepart(yyyy,due_date) = 2013) then sum(eeiqty) else 0 end) as jun_13,
(case when (datepart(mm,due_date) = 7 and datepart(yyyy,due_date) = 2013) then sum(eeiqty) else 0 end) as jul_13,
(case when (datepart(mm,due_date) = 8 and datepart(yyyy,due_date) = 2013) then sum(eeiqty) else 0 end) as aug_13,
(case when (datepart(mm,due_date) = 9 and datepart(yyyy,due_date) = 2013) then sum(eeiqty) else 0 end) as sep_13,
(case when (datepart(mm,due_date) = 10 and datepart(yyyy,due_date) = 2013) then sum(eeiqty) else 0 end) as oct_13,
(case when (datepart(mm,due_date) = 11 and datepart(yyyy,due_date) = 2013) then sum(eeiqty) else 0 end) as nov_13,
(case when (datepart(mm,due_date) = 12 and datepart(yyyy,due_date) = 2013) then sum(eeiqty) else 0 end) as dec_13,
(case when (datepart(mm,due_date) = 1 and datepart(yyyy,due_date) = 2014) then sum(eeiqty) else 0 end) as jan_14,
(case when (datepart(mm,due_date) = 2 and datepart(yyyy,due_date) = 2014) then sum(eeiqty) else 0 end) as feb_14,
(case when (datepart(mm,due_date) = 3 and datepart(yyyy,due_date) = 2014) then sum(eeiqty) else 0 end) as mar_14,
(case when (datepart(mm,due_date) = 4 and datepart(yyyy,due_date) = 2014) then sum(eeiqty) else 0 end) as apr_14,
(case when (datepart(mm,due_date) = 5 and datepart(yyyy,due_date) = 2014) then sum(eeiqty) else 0 end) as may_14,
(case when (datepart(mm,due_date) = 6 and datepart(yyyy,due_date) = 2014) then sum(eeiqty) else 0 end) as jun_14,
(case when (datepart(mm,due_date) = 7 and datepart(yyyy,due_date) = 2014) then sum(eeiqty) else 0 end) as jul_14,
(case when (datepart(mm,due_date) = 8 and datepart(yyyy,due_date) = 2014) then sum(eeiqty) else 0 end) as aug_14,
(case when (datepart(mm,due_date) = 9 and datepart(yyyy,due_date) = 2014) then sum(eeiqty) else 0 end) as sep_14,
(case when (datepart(mm,due_date) = 10 and datepart(yyyy,due_date) = 2014) then sum(eeiqty) else 0 end) as oct_14,
(case when (datepart(mm,due_date) = 11 and datepart(yyyy,due_date) = 2014) then sum(eeiqty) else 0 end) as nov_14,
(case when (datepart(mm,due_date) = 12 and datepart(yyyy,due_date) = 2014) then sum(eeiqty) else 0 end) as dec_14,
(case when (datepart(mm,due_date) = 1 and datepart(yyyy,due_date) = 2015) then sum(eeiqty) else 0 end) as jan_15,
(case when (datepart(mm,due_date) = 2 and datepart(yyyy,due_date) = 2015) then sum(eeiqty) else 0 end) as feb_15,
(case when (datepart(mm,due_date) = 3 and datepart(yyyy,due_date) = 2015) then sum(eeiqty) else 0 end) as mar_15,
(case when (datepart(mm,due_date) = 4 and datepart(yyyy,due_date) = 2015) then sum(eeiqty) else 0 end) as apr_15,
(case when (datepart(mm,due_date) = 5 and datepart(yyyy,due_date) = 2015) then sum(eeiqty) else 0 end) as may_15,
(case when (datepart(mm,due_date) = 6 and datepart(yyyy,due_date) = 2015) then sum(eeiqty) else 0 end) as jun_15,
(case when (datepart(mm,due_date) = 7 and datepart(yyyy,due_date) = 2015) then sum(eeiqty) else 0 end) as jul_15,
(case when (datepart(mm,due_date) = 8 and datepart(yyyy,due_date) = 2015) then sum(eeiqty) else 0 end) as aug_15,
(case when (datepart(mm,due_date) = 9 and datepart(yyyy,due_date) = 2015) then sum(eeiqty) else 0 end) as sep_15,
(case when (datepart(mm,due_date) = 10 and datepart(yyyy,due_date) = 2015) then sum(eeiqty) else 0 end) as oct_15,
(case when (datepart(mm,due_date) = 11 and datepart(yyyy,due_date) = 2015) then sum(eeiqty) else 0 end) as nov_15,
(case when (datepart(mm,due_date) = 12 and datepart(yyyy,due_date) = 2015) then sum(eeiqty) else 0 end) as dec_15,
(case when (datepart(mm,due_date) = 1 and datepart(yyyy,due_date) = 2016) then sum(eeiqty) else 0 end) as jan_16,
(case when (datepart(mm,due_date) = 2 and datepart(yyyy,due_date) = 2016) then sum(eeiqty) else 0 end) as feb_16,
(case when (datepart(mm,due_date) = 3 and datepart(yyyy,due_date) = 2016) then sum(eeiqty) else 0 end) as mar_16,
(case when (datepart(mm,due_date) = 4 and datepart(yyyy,due_date) = 2016) then sum(eeiqty) else 0 end) as apr_16,
(case when (datepart(mm,due_date) = 5 and datepart(yyyy,due_date) = 2016) then sum(eeiqty) else 0 end) as may_16,
(case when (datepart(mm,due_date) = 6 and datepart(yyyy,due_date) = 2016) then sum(eeiqty) else 0 end) as jun_16,
(case when (datepart(mm,due_date) = 7 and datepart(yyyy,due_date) = 2016) then sum(eeiqty) else 0 end) as jul_16,
(case when (datepart(mm,due_date) = 8 and datepart(yyyy,due_date) = 2016) then sum(eeiqty) else 0 end) as aug_16,
(case when (datepart(mm,due_date) = 9 and datepart(yyyy,due_date) = 2016) then sum(eeiqty) else 0 end) as sep_16,
(case when (datepart(mm,due_date) = 10 and datepart(yyyy,due_date) = 2016) then sum(eeiqty) else 0 end) as oct_16,
(case when (datepart(mm,due_date) = 11 and datepart(yyyy,due_date) = 2016) then sum(eeiqty) else 0 end) as nov_16,
(case when (datepart(mm,due_date) = 12 and datepart(yyyy,due_date) = 2016) then sum(eeiqty) else 0 end) as dec_16,
(case when (datepart(mm,due_date) = 1 and datepart(yyyy,due_date) = 2017) then sum(eeiqty) else 0 end) as jan_17,
(case when (datepart(mm,due_date) = 2 and datepart(yyyy,due_date) = 2017) then sum(eeiqty) else 0 end) as feb_17,
(case when (datepart(mm,due_date) = 3 and datepart(yyyy,due_date) = 2017) then sum(eeiqty) else 0 end) as mar_17,
(case when (datepart(mm,due_date) = 4 and datepart(yyyy,due_date) = 2017) then sum(eeiqty) else 0 end) as apr_17,
(case when (datepart(mm,due_date) = 5 and datepart(yyyy,due_date) = 2017) then sum(eeiqty) else 0 end) as may_17,
(case when (datepart(mm,due_date) = 6 and datepart(yyyy,due_date) = 2017) then sum(eeiqty) else 0 end) as jun_17,
(case when (datepart(mm,due_date) = 7 and datepart(yyyy,due_date) = 2017) then sum(eeiqty) else 0 end) as jul_17,
(case when (datepart(mm,due_date) = 8 and datepart(yyyy,due_date) = 2017) then sum(eeiqty) else 0 end) as aug_17,
(case when (datepart(mm,due_date) = 9 and datepart(yyyy,due_date) = 2017) then sum(eeiqty) else 0 end) as sep_17,
(case when (datepart(mm,due_date) = 10 and datepart(yyyy,due_date) = 2017) then sum(eeiqty) else 0 end) as oct_17,
(case when (datepart(mm,due_date) = 11 and datepart(yyyy,due_date) = 2017) then sum(eeiqty) else 0 end) as nov_17,
(case when (datepart(mm,due_date) = 12 and datepart(yyyy,due_date) = 2017) then sum(eeiqty) else 0 end) as dec_17

from order_detail
where datepart(yyyy,due_date) in ('2012','2013','2014','2015','2016','2017')
group by left(part_number,7), due_date) a group by base_part
union
select
base_part,
'Actual Shipouts' as description,
sum(b.jan_12) as [Jan 2012],
sum(b.feb_12) as [Feb 2012],
sum(b.mar_12) as [Mar 2012],
sum(b.apr_12) as [Apr 2012],
sum(b.may_12) as [May 2012],
sum(b.jun_12) as [Jun 2012],
sum(b.jul_12) as [Jul 2012],
sum(b.aug_12) as [Aug 2012],
sum(b.sep_12) as [Sep 2012],
sum(b.oct_12) as [Oct 2012],
sum(b.nov_12) as [Nov 2012],
sum(b.dec_12) as [Dec 2012],
(sum(b.jan_12)+sum(b.feb_12)+sum(b.mar_12)+sum(b.apr_12)+sum(b.may_12)+sum(b.jun_12)+sum(b.jul_12)+sum(b.aug_12)+sum(b.sep_12)+sum(b.oct_12)+sum(b.nov_12)+sum(b.dec_12)) as total_2012,
sum(b.jan_13) as [Jan 2013],
sum(b.feb_13) as [Feb 2013],
sum(b.mar_13) as [Mar 2013],
sum(b.apr_13) as [Apr 2013],
sum(b.may_13) as [May 2013],
sum(b.jun_13) as [Jun 2013],
sum(b.jul_13) as [Jul 2013],
sum(b.aug_13) as [Aug 2013],
sum(b.sep_13) as [Sep 2013],
sum(b.oct_13) as [Oct 2013],
sum(b.nov_13) as [Nov 2013],
sum(b.dec_13) as [Dec 2013],
(sum(b.jan_13)+sum(b.feb_13)+sum(b.mar_13)+sum(b.apr_13)+sum(b.may_13)+sum(b.jun_13)+sum(b.jul_13)+sum(b.aug_13)+sum(b.sep_13)+sum(b.oct_13)+sum(b.nov_13)+sum(b.dec_13)) as total_2013,
sum(b.jan_14) as [Jan 2014],
sum(b.feb_14) as [Feb 2014],
sum(b.mar_14) as [Mar 2014],
sum(b.apr_14) as [Apr 2014],
sum(b.may_14) as [May 2014],
sum(b.jun_14) as [Jun 2014],
sum(b.jul_14) as [Jul 2014],
sum(b.aug_14) as [Aug 2014],
sum(b.sep_14) as [Sep 2014],
sum(b.oct_14) as [Oct 2014],
sum(b.nov_14) as [Nov 2014],
sum(b.dec_14) as [Dec 2014],
(sum(b.jan_14)+sum(b.feb_14)+sum(b.mar_14)+sum(b.apr_14)+sum(b.may_14)+sum(b.jun_14)+sum(b.jul_14)+sum(b.aug_14)+sum(b.sep_14)+sum(b.oct_14)+sum(b.nov_14)+sum(b.dec_14)) as total_2014,
sum(b.jan_15) as [Jan 2015],
sum(b.feb_15) as [Feb 2015],
sum(b.mar_15) as [Mar 2015],
sum(b.apr_15) as [Apr 2015],
sum(b.may_15) as [May 2015],
sum(b.jun_15) as [Jun 2015],
sum(b.jul_15) as [Jul 2015],
sum(b.aug_15) as [Aug 2015],
sum(b.sep_15) as [Sep 2015],
sum(b.oct_15) as [Oct 2015],
sum(b.nov_15) as [Nov 2015],
sum(b.dec_15) as [Dec 2015],
(sum(b.jan_15)+sum(b.feb_15)+sum(b.mar_15)+sum(b.apr_15)+sum(b.may_15)+sum(b.jun_15)+sum(b.jul_15)+sum(b.aug_15)+sum(b.sep_15)+sum(b.oct_15)+sum(b.nov_15)+sum(b.dec_15)) as total_2015,
sum(b.jan_16) as [Jan 2016],
sum(b.feb_16) as [Feb 2016],
sum(b.mar_16) as [Mar 2016],
sum(b.apr_16) as [Apr 2016],
sum(b.may_16) as [May 2016],
sum(b.jun_16) as [Jun 2016],
sum(b.jul_16) as [Jul 2016],
sum(b.aug_16) as [Aug 2016],
sum(b.sep_16) as [Sep 2016],
sum(b.oct_16) as [Oct 2016],
sum(b.nov_16) as [Nov 2016],
sum(b.dec_16) as [Dec 2016],
(sum(b.jan_16)+sum(b.feb_16)+sum(b.mar_16)+sum(b.apr_16)+sum(b.may_16)+sum(b.jun_16)+sum(b.jul_16)+sum(b.aug_16)+sum(b.sep_16)+sum(b.oct_16)+sum(b.nov_16)+sum(b.dec_16)) as total_2016,
sum(b.jan_17) as [Jan 2017],
sum(b.feb_17) as [Feb 2017],
sum(b.mar_17) as [Mar 2017],
sum(b.apr_17) as [Apr 2017],
sum(b.may_17) as [May 2017],
sum(b.jun_17) as [Jun 2017],
sum(b.jul_17) as [Jul 2017],
sum(b.aug_17) as [Aug 2017],
sum(b.sep_17) as [Sep 2017],
sum(b.oct_17) as [Oct 2017],
sum(b.nov_17) as [Nov 2017],
sum(b.dec_17) as [Dec 2017],
(sum(b.jan_17)+sum(b.feb_17)+sum(b.mar_17)+sum(b.apr_17)+sum(b.may_17)+sum(b.jun_17)+sum(b.jul_17)+sum(b.aug_17)+sum(b.sep_17)+sum(b.oct_17)+sum(b.nov_17)+sum(b.dec_17)) as total_2017,
sum(0) as total_2018,
sum(0) as total_2019

from
(select
LEFT(part_original,7) as base_part,
(case when (datepart(mm,shipper.date_shipped) = 1 and datepart(yyyy,shipper.date_shipped) = '2012') then sum(qty_packed) else 0 end) as jan_12,
(case when (datepart(mm,shipper.date_shipped) = 2 and datepart(yyyy,shipper.date_shipped) = '2012') then sum(qty_packed) else 0 end) as feb_12,
(case when (datepart(mm,shipper.date_shipped) = 3 and datepart(yyyy,shipper.date_shipped) = '2012') then sum(qty_packed) else 0 end) as mar_12,
(case when (datepart(mm,shipper.date_shipped) = 4 and datepart(yyyy,shipper.date_shipped) = '2012') then sum(qty_packed) else 0 end) as apr_12,
(case when (datepart(mm,shipper.date_shipped) = 5 and datepart(yyyy,shipper.date_shipped) = '2012') then sum(qty_packed) else 0 end) as may_12,
(case when (datepart(mm,shipper.date_shipped) = 6 and datepart(yyyy,shipper.date_shipped) = '2012') then sum(qty_packed) else 0 end) as jun_12,
(case when (datepart(mm,shipper.date_shipped) = 7 and datepart(yyyy,shipper.date_shipped) = '2012') then sum(qty_packed) else 0 end) as jul_12,
(case when (datepart(mm,shipper.date_shipped) = 8 and datepart(yyyy,shipper.date_shipped) = '2012') then sum(qty_packed) else 0 end) as aug_12,
(case when (datepart(mm,shipper.date_shipped) = 9 and datepart(yyyy,shipper.date_shipped) = '2012') then sum(qty_packed) else 0 end) as sep_12,
(case when (datepart(mm,shipper.date_shipped) = 10 and datepart(yyyy,shipper.date_shipped) = '2012') then sum(qty_packed) else 0 end) as oct_12,
(case when (datepart(mm,shipper.date_shipped) = 11 and datepart(yyyy,shipper.date_shipped) = '2012') then sum(qty_packed) else 0 end) as nov_12,
(case when (datepart(mm,shipper.date_shipped) = 12 and datepart(yyyy,shipper.date_shipped) = '2012') then sum(qty_packed) else 0 end) as dec_12,
(case when (datepart(mm,shipper.date_shipped) = 1 and datepart(yyyy,shipper.date_shipped) = '2013') then sum(qty_packed) else 0 end) as jan_13,
(case when (datepart(mm,shipper.date_shipped) = 2 and datepart(yyyy,shipper.date_shipped) = '2013') then sum(qty_packed) else 0 end) as feb_13,
(case when (datepart(mm,shipper.date_shipped) = 3 and datepart(yyyy,shipper.date_shipped) = '2013') then sum(qty_packed) else 0 end) as mar_13,
(case when (datepart(mm,shipper.date_shipped) = 4 and datepart(yyyy,shipper.date_shipped) = '2013') then sum(qty_packed) else 0 end) as apr_13,
(case when (datepart(mm,shipper.date_shipped) = 5 and datepart(yyyy,shipper.date_shipped) = '2013') then sum(qty_packed) else 0 end) as may_13,
(case when (datepart(mm,shipper.date_shipped) = 6 and datepart(yyyy,shipper.date_shipped) = '2013') then sum(qty_packed) else 0 end) as jun_13,
(case when (datepart(mm,shipper.date_shipped) = 7 and datepart(yyyy,shipper.date_shipped) = '2013') then sum(qty_packed) else 0 end) as jul_13,
(case when (datepart(mm,shipper.date_shipped) = 8 and datepart(yyyy,shipper.date_shipped) = '2013') then sum(qty_packed) else 0 end) as aug_13,
(case when (datepart(mm,shipper.date_shipped) = 9 and datepart(yyyy,shipper.date_shipped) = '2013') then sum(qty_packed) else 0 end) as sep_13,
(case when (datepart(mm,shipper.date_shipped) = 10 and datepart(yyyy,shipper.date_shipped) = '2013') then sum(qty_packed) else 0 end) as oct_13,
(case when (datepart(mm,shipper.date_shipped) = 11 and datepart(yyyy,shipper.date_shipped) = '2013') then sum(qty_packed) else 0 end) as nov_13,
(case when (datepart(mm,shipper.date_shipped) = 12 and datepart(yyyy,shipper.date_shipped) = '2013') then sum(qty_packed) else 0 end) as dec_13,
(case when (datepart(mm,shipper.date_shipped) = 1 and datepart(yyyy,shipper.date_shipped) = '2014') then sum(qty_packed) else 0 end) as jan_14,
(case when (datepart(mm,shipper.date_shipped) = 2 and datepart(yyyy,shipper.date_shipped) = '2014') then sum(qty_packed) else 0 end) as feb_14,
(case when (datepart(mm,shipper.date_shipped) = 3 and datepart(yyyy,shipper.date_shipped) = '2014') then sum(qty_packed) else 0 end) as mar_14,
(case when (datepart(mm,shipper.date_shipped) = 4 and datepart(yyyy,shipper.date_shipped) = '2014') then sum(qty_packed) else 0 end) as apr_14,
(case when (datepart(mm,shipper.date_shipped) = 5 and datepart(yyyy,shipper.date_shipped) = '2014') then sum(qty_packed) else 0 end) as may_14,
(case when (datepart(mm,shipper.date_shipped) = 6 and datepart(yyyy,shipper.date_shipped) = '2014') then sum(qty_packed) else 0 end) as jun_14,
(case when (datepart(mm,shipper.date_shipped) = 7 and datepart(yyyy,shipper.date_shipped) = '2014') then sum(qty_packed) else 0 end) as jul_14,
(case when (datepart(mm,shipper.date_shipped) = 8 and datepart(yyyy,shipper.date_shipped) = '2014') then sum(qty_packed) else 0 end) as aug_14,
(case when (datepart(mm,shipper.date_shipped) = 9 and datepart(yyyy,shipper.date_shipped) = '2014') then sum(qty_packed) else 0 end) as sep_14,
(case when (datepart(mm,shipper.date_shipped) = 10 and datepart(yyyy,shipper.date_shipped) = '2014') then sum(qty_packed) else 0 end) as oct_14,
(case when (datepart(mm,shipper.date_shipped) = 11 and datepart(yyyy,shipper.date_shipped) = '2014') then sum(qty_packed) else 0 end) as nov_14,
(case when (datepart(mm,shipper.date_shipped) = 12 and datepart(yyyy,shipper.date_shipped) = '2014') then sum(qty_packed) else 0 end) as dec_14,
(case when (datepart(mm,shipper.date_shipped) = 1 and datepart(yyyy,shipper.date_shipped) = '2015') then sum(qty_packed) else 0 end) as jan_15,
(case when (datepart(mm,shipper.date_shipped) = 2 and datepart(yyyy,shipper.date_shipped) = '2015') then sum(qty_packed) else 0 end) as feb_15,
(case when (datepart(mm,shipper.date_shipped) = 3 and datepart(yyyy,shipper.date_shipped) = '2015') then sum(qty_packed) else 0 end) as mar_15,
(case when (datepart(mm,shipper.date_shipped) = 4 and datepart(yyyy,shipper.date_shipped) = '2015') then sum(qty_packed) else 0 end) as apr_15,
(case when (datepart(mm,shipper.date_shipped) = 5 and datepart(yyyy,shipper.date_shipped) = '2015') then sum(qty_packed) else 0 end) as may_15,
(case when (datepart(mm,shipper.date_shipped) = 6 and datepart(yyyy,shipper.date_shipped) = '2015') then sum(qty_packed) else 0 end) as jun_15,
(case when (datepart(mm,shipper.date_shipped) = 7 and datepart(yyyy,shipper.date_shipped) = '2015') then sum(qty_packed) else 0 end) as jul_15,
(case when (datepart(mm,shipper.date_shipped) = 8 and datepart(yyyy,shipper.date_shipped) = '2015') then sum(qty_packed) else 0 end) as aug_15,
(case when (datepart(mm,shipper.date_shipped) = 9 and datepart(yyyy,shipper.date_shipped) = '2015') then sum(qty_packed) else 0 end) as sep_15,
(case when (datepart(mm,shipper.date_shipped) = 10 and datepart(yyyy,shipper.date_shipped) = '2015') then sum(qty_packed) else 0 end) as oct_15,
(case when (datepart(mm,shipper.date_shipped) = 11 and datepart(yyyy,shipper.date_shipped) = '2015') then sum(qty_packed) else 0 end) as nov_15,
(case when (datepart(mm,shipper.date_shipped) = 12 and datepart(yyyy,shipper.date_shipped) = '2015') then sum(qty_packed) else 0 end) as dec_15,
(case when (datepart(mm,shipper.date_shipped) = 1 and datepart(yyyy,shipper.date_shipped) = '2016') then sum(qty_packed) else 0 end) as jan_16,
(case when (datepart(mm,shipper.date_shipped) = 2 and datepart(yyyy,shipper.date_shipped) = '2016') then sum(qty_packed) else 0 end) as feb_16,
(case when (datepart(mm,shipper.date_shipped) = 3 and datepart(yyyy,shipper.date_shipped) = '2016') then sum(qty_packed) else 0 end) as mar_16,
(case when (datepart(mm,shipper.date_shipped) = 4 and datepart(yyyy,shipper.date_shipped) = '2016') then sum(qty_packed) else 0 end) as apr_16,
(case when (datepart(mm,shipper.date_shipped) = 5 and datepart(yyyy,shipper.date_shipped) = '2016') then sum(qty_packed) else 0 end) as may_16,
(case when (datepart(mm,shipper.date_shipped) = 6 and datepart(yyyy,shipper.date_shipped) = '2016') then sum(qty_packed) else 0 end) as jun_16,
(case when (datepart(mm,shipper.date_shipped) = 7 and datepart(yyyy,shipper.date_shipped) = '2016') then sum(qty_packed) else 0 end) as jul_16,
(case when (datepart(mm,shipper.date_shipped) = 8 and datepart(yyyy,shipper.date_shipped) = '2016') then sum(qty_packed) else 0 end) as aug_16,
(case when (datepart(mm,shipper.date_shipped) = 9 and datepart(yyyy,shipper.date_shipped) = '2016') then sum(qty_packed) else 0 end) as sep_16,
(case when (datepart(mm,shipper.date_shipped) = 10 and datepart(yyyy,shipper.date_shipped) = '2016') then sum(qty_packed) else 0 end) as oct_16,
(case when (datepart(mm,shipper.date_shipped) = 11 and datepart(yyyy,shipper.date_shipped) = '2016') then sum(qty_packed) else 0 end) as nov_16,
(case when (datepart(mm,shipper.date_shipped) = 12 and datepart(yyyy,shipper.date_shipped) = '2016') then sum(qty_packed) else 0 end) as dec_16,
(case when (datepart(mm,shipper.date_shipped) = 1 and datepart(yyyy,shipper.date_shipped) = '2017') then sum(qty_packed) else 0 end) as jan_17,
(case when (datepart(mm,shipper.date_shipped) = 2 and datepart(yyyy,shipper.date_shipped) = '2017') then sum(qty_packed) else 0 end) as feb_17,
(case when (datepart(mm,shipper.date_shipped) = 3 and datepart(yyyy,shipper.date_shipped) = '2017') then sum(qty_packed) else 0 end) as mar_17,
(case when (datepart(mm,shipper.date_shipped) = 4 and datepart(yyyy,shipper.date_shipped) = '2017') then sum(qty_packed) else 0 end) as apr_17,
(case when (datepart(mm,shipper.date_shipped) = 5 and datepart(yyyy,shipper.date_shipped) = '2017') then sum(qty_packed) else 0 end) as may_17,
(case when (datepart(mm,shipper.date_shipped) = 6 and datepart(yyyy,shipper.date_shipped) = '2017') then sum(qty_packed) else 0 end) as jun_17,
(case when (datepart(mm,shipper.date_shipped) = 7 and datepart(yyyy,shipper.date_shipped) = '2017') then sum(qty_packed) else 0 end) as jul_17,
(case when (datepart(mm,shipper.date_shipped) = 8 and datepart(yyyy,shipper.date_shipped) = '2017') then sum(qty_packed) else 0 end) as aug_17,
(case when (datepart(mm,shipper.date_shipped) = 9 and datepart(yyyy,shipper.date_shipped) = '2017') then sum(qty_packed) else 0 end) as sep_17,
(case when (datepart(mm,shipper.date_shipped) = 10 and datepart(yyyy,shipper.date_shipped) = '2017') then sum(qty_packed) else 0 end) as oct_17,
(case when (datepart(mm,shipper.date_shipped) = 11 and datepart(yyyy,shipper.date_shipped) = '2017') then sum(qty_packed) else 0 end) as nov_17,
(case when (datepart(mm,shipper.date_shipped) = 12 and datepart(yyyy,shipper.date_shipped) = '2017') then sum(qty_packed) else 0 end) as dec_17
from shipper_detail, shipper
where shipper.id = shipper_detail.shipper and
datepart(yyyy,shipper.date_shipped) in ('2012','2013','2014','2015','2016','2017')
and isnull(shipper.type,'S')<>'T'
group by left(part_original,7), shipper.date_shipped) b group by base_part) xx

group by base_part


--select * from order_detail where part_number like 'FNG0088%' order by due_date





GO