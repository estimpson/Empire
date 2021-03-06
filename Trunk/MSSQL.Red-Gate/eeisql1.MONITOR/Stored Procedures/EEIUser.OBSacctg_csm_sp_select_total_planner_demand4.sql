SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- exec eeiuser.acctg_csm_sp_select_total_planner_demand 'NOR0015'


CREATE procedure [EEIUser].[OBSacctg_csm_sp_select_total_planner_demand4]
  @base_part varchar(30)
as
select
'Planner Demand' as description,
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

sum(jan_18) as [Jan 2018],
sum(feb_18) as [Feb 2018],
sum(mar_18) as [Mar 2018],
sum(apr_18) as [Apr 2018],
sum(may_18) as [May 2018],
sum(jun_18) as [Jun 2018],
sum(jul_18) as [Jul 2018],
sum(aug_18) as [Aug 2018],
sum(sep_18) as [Sep 2018],
sum(oct_18) as [Oct 2018],
sum(nov_18) as [Nov 2018],
sum(dec_18) as [Dec 2018],
(sum(jan_18)+sum(feb_18)+sum(mar_18)+sum(apr_18)+sum(may_18)+sum(jun_18)+sum(jul_18)+sum(aug_18)+sum(sep_18)+sum(oct_18)+sum(nov_18)+sum(dec_18)) as total_2018,

sum(jan_19) as [Jan 2019],
sum(feb_19) as [Feb 2019],
sum(mar_19) as [Mar 2019],
sum(apr_19) as [Apr 2019],
sum(may_19) as [May 2019],
sum(jun_19) as [Jun 2019],
sum(jul_19) as [Jul 2019],
sum(aug_19) as [Aug 2019],
sum(sep_19) as [Sep 2019],
sum(oct_19) as [Oct 2019],
sum(nov_19) as [Nov 2019],
sum(dec_19) as [Dec 2019],
(sum(jan_19)+sum(feb_19)+sum(mar_19)+sum(apr_19)+sum(may_19)+sum(jun_19)+sum(jul_19)+sum(aug_19)+sum(sep_19)+sum(oct_19)+sum(nov_19)+sum(dec_19)) as total_2019,

/*
sum(jan_20) as [Jan 2020],
sum(feb_20) as [Feb 2020],
sum(mar_20) as [Mar 2020],
sum(apr_20) as [Apr 2020],
sum(may_20) as [May 2020],
sum(jun_20) as [Jun 2020],
sum(jul_20) as [Jul 2020],
sum(aug_20) as [Aug 2020],
sum(sep_20) as [Sep 2020],
sum(oct_20) as [Oct 2020],
sum(nov_20) as [Nov 2020],
sum(dec_20) as [Dec 2020],
(sum(jan_20)+sum(feb_20)+sum(mar_20)+sum(apr_20)+sum(may_20)+sum(jun_20)+sum(jul_20)+sum(aug_20)+sum(sep_20)+sum(oct_20)+sum(nov_20)+sum(dec_20)) as total_2020,
*/

sum(0.0) as total_2020,
sum(0.0) as total_2021,
sum(0.0) as total_2022

from
(select 
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
(case when (datepart(mm,due_date) = 12 and datepart(yyyy,due_date) = 2017) then sum(eeiqty) else 0 end) as dec_17,

(case when (datepart(mm,due_date) = 1 and datepart(yyyy,due_date) = 2018) then sum(eeiqty) else 0 end) as jan_18,
(case when (datepart(mm,due_date) = 2 and datepart(yyyy,due_date) = 2018) then sum(eeiqty) else 0 end) as feb_18,
(case when (datepart(mm,due_date) = 3 and datepart(yyyy,due_date) = 2018) then sum(eeiqty) else 0 end) as mar_18,
(case when (datepart(mm,due_date) = 4 and datepart(yyyy,due_date) = 2018) then sum(eeiqty) else 0 end) as apr_18,
(case when (datepart(mm,due_date) = 5 and datepart(yyyy,due_date) = 2018) then sum(eeiqty) else 0 end) as may_18,
(case when (datepart(mm,due_date) = 6 and datepart(yyyy,due_date) = 2018) then sum(eeiqty) else 0 end) as jun_18,
(case when (datepart(mm,due_date) = 7 and datepart(yyyy,due_date) = 2018) then sum(eeiqty) else 0 end) as jul_18,
(case when (datepart(mm,due_date) = 8 and datepart(yyyy,due_date) = 2018) then sum(eeiqty) else 0 end) as aug_18,
(case when (datepart(mm,due_date) = 9 and datepart(yyyy,due_date) = 2018) then sum(eeiqty) else 0 end) as sep_18,
(case when (datepart(mm,due_date) = 10 and datepart(yyyy,due_date) = 2018) then sum(eeiqty) else 0 end) as oct_18,
(case when (datepart(mm,due_date) = 11 and datepart(yyyy,due_date) = 2018) then sum(eeiqty) else 0 end) as nov_18,
(case when (datepart(mm,due_date) = 12 and datepart(yyyy,due_date) = 2018) then sum(eeiqty) else 0 end) as dec_18,

(case when (datepart(mm,due_date) = 1 and datepart(yyyy,due_date) = 2019) then sum(eeiqty) else 0 end) as jan_19,
(case when (datepart(mm,due_date) = 2 and datepart(yyyy,due_date) = 2019) then sum(eeiqty) else 0 end) as feb_19,
(case when (datepart(mm,due_date) = 3 and datepart(yyyy,due_date) = 2019) then sum(eeiqty) else 0 end) as mar_19,
(case when (datepart(mm,due_date) = 4 and datepart(yyyy,due_date) = 2019) then sum(eeiqty) else 0 end) as apr_19,
(case when (datepart(mm,due_date) = 5 and datepart(yyyy,due_date) = 2019) then sum(eeiqty) else 0 end) as may_19,
(case when (datepart(mm,due_date) = 6 and datepart(yyyy,due_date) = 2019) then sum(eeiqty) else 0 end) as jun_19,
(case when (datepart(mm,due_date) = 7 and datepart(yyyy,due_date) = 2019) then sum(eeiqty) else 0 end) as jul_19,
(case when (datepart(mm,due_date) = 8 and datepart(yyyy,due_date) = 2019) then sum(eeiqty) else 0 end) as aug_19,
(case when (datepart(mm,due_date) = 9 and datepart(yyyy,due_date) = 2019) then sum(eeiqty) else 0 end) as sep_19,
(case when (datepart(mm,due_date) = 10 and datepart(yyyy,due_date) = 2019) then sum(eeiqty) else 0 end) as oct_19,
(case when (datepart(mm,due_date) = 11 and datepart(yyyy,due_date) = 2019) then sum(eeiqty) else 0 end) as nov_19,
(case when (datepart(mm,due_date) = 12 and datepart(yyyy,due_date) = 2019) then sum(eeiqty) else 0 end) as dec_19

/*
(case when (datepart(mm,due_date) = 1 and datepart(yyyy,due_date) = 2020) then sum(eeiqty) else 0 end) as jan_20,
(case when (datepart(mm,due_date) = 2 and datepart(yyyy,due_date) = 2020) then sum(eeiqty) else 0 end) as feb_20,
(case when (datepart(mm,due_date) = 3 and datepart(yyyy,due_date) = 2020) then sum(eeiqty) else 0 end) as mar_20,
(case when (datepart(mm,due_date) = 4 and datepart(yyyy,due_date) = 2020) then sum(eeiqty) else 0 end) as apr_20,
(case when (datepart(mm,due_date) = 5 and datepart(yyyy,due_date) = 2020) then sum(eeiqty) else 0 end) as may_20,
(case when (datepart(mm,due_date) = 6 and datepart(yyyy,due_date) = 2020) then sum(eeiqty) else 0 end) as jun_20,
(case when (datepart(mm,due_date) = 7 and datepart(yyyy,due_date) = 2020) then sum(eeiqty) else 0 end) as jul_20,
(case when (datepart(mm,due_date) = 8 and datepart(yyyy,due_date) = 2020) then sum(eeiqty) else 0 end) as aug_20,
(case when (datepart(mm,due_date) = 9 and datepart(yyyy,due_date) = 2020) then sum(eeiqty) else 0 end) as sep_20,
(case when (datepart(mm,due_date) = 10 and datepart(yyyy,due_date) = 2020) then sum(eeiqty) else 0 end) as oct_20,
(case when (datepart(mm,due_date) = 11 and datepart(yyyy,due_date) = 2020) then sum(eeiqty) else 0 end) as nov_20,
(case when (datepart(mm,due_date) = 12 and datepart(yyyy,due_date) = 2020) then sum(eeiqty) else 0 end) as dec_20
*/

from order_detail
where datepart(yyyy,due_date) in ('2015','2016','2017','2018','2019','2020')
and left(part_number,7) = @base_part
group by due_date) a
union
select
'Actual Shipouts' as description,
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

sum(b.jan_18) as [Jan 2018],
sum(b.feb_18) as [Feb 2018],
sum(b.mar_18) as [Mar 2018],
sum(b.apr_18) as [Apr 2018],
sum(b.may_18) as [May 2018],
sum(b.jun_18) as [Jun 2018],
sum(b.jul_18) as [Jul 2018],
sum(b.aug_18) as [Aug 2018],
sum(b.sep_18) as [Sep 2018],
sum(b.oct_18) as [Oct 2018],
sum(b.nov_18) as [Nov 2018],
sum(b.dec_18) as [Dec 2018],
(sum(b.jan_18)+sum(b.feb_18)+sum(b.mar_18)+sum(b.apr_18)+sum(b.may_18)+sum(b.jun_18)+sum(b.jul_18)+sum(b.aug_18)+sum(b.sep_18)+sum(b.oct_18)+sum(b.nov_18)+sum(b.dec_18)) as total_2018,

sum(b.jan_19) as [Jan 2019],
sum(b.feb_19) as [Feb 2019],
sum(b.mar_19) as [Mar 2019],
sum(b.apr_19) as [Apr 2019],
sum(b.may_19) as [May 2019],
sum(b.jun_19) as [Jun 2019],
sum(b.jul_19) as [Jul 2019],
sum(b.aug_19) as [Aug 2019],
sum(b.sep_19) as [Sep 2019],
sum(b.oct_19) as [Oct 2019],
sum(b.nov_19) as [Nov 2019],
sum(b.dec_19) as [Dec 2019],
(sum(b.jan_19)+sum(b.feb_19)+sum(b.mar_19)+sum(b.apr_19)+sum(b.may_19)+sum(b.jun_19)+sum(b.jul_19)+sum(b.aug_19)+sum(b.sep_19)+sum(b.oct_19)+sum(b.nov_19)+sum(b.dec_19)) as total_2019,

/*
sum(b.jan_20) as [Jan 2020],
sum(b.feb_20) as [Feb 2020],
sum(b.mar_20) as [Mar 2020],
sum(b.apr_20) as [Apr 2020],
sum(b.may_20) as [May 2020],
sum(b.jun_20) as [Jun 2020],
sum(b.jul_20) as [Jul 2020],
sum(b.aug_20) as [Aug 2020],
sum(b.sep_20) as [Sep 2020],
sum(b.oct_20) as [Oct 2020],
sum(b.nov_20) as [Nov 2020],
sum(b.dec_20) as [Dec 2020],
(sum(b.jan_20)+sum(b.feb_20)+sum(b.mar_20)+sum(b.apr_20)+sum(b.may_20)+sum(b.jun_20)+sum(b.jul_20)+sum(b.aug_20)+sum(b.sep_20)+sum(b.oct_20)+sum(b.nov_20)+sum(b.dec_20)) as total_2020,
*/

sum(0.0) as total_2020,
sum(0.0) as total_2021,
sum(0.0) as total_2022

from
(select
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
(case when (datepart(mm,shipper.date_shipped) = 12 and datepart(yyyy,shipper.date_shipped) = '2017') then sum(qty_packed) else 0 end) as dec_17,

(case when (datepart(mm,shipper.date_shipped) = 1 and datepart(yyyy,shipper.date_shipped) = '2018') then sum(qty_packed) else 0 end) as jan_18,
(case when (datepart(mm,shipper.date_shipped) = 2 and datepart(yyyy,shipper.date_shipped) = '2018') then sum(qty_packed) else 0 end) as feb_18,
(case when (datepart(mm,shipper.date_shipped) = 3 and datepart(yyyy,shipper.date_shipped) = '2018') then sum(qty_packed) else 0 end) as mar_18,
(case when (datepart(mm,shipper.date_shipped) = 4 and datepart(yyyy,shipper.date_shipped) = '2018') then sum(qty_packed) else 0 end) as apr_18,
(case when (datepart(mm,shipper.date_shipped) = 5 and datepart(yyyy,shipper.date_shipped) = '2018') then sum(qty_packed) else 0 end) as may_18,
(case when (datepart(mm,shipper.date_shipped) = 6 and datepart(yyyy,shipper.date_shipped) = '2018') then sum(qty_packed) else 0 end) as jun_18,
(case when (datepart(mm,shipper.date_shipped) = 7 and datepart(yyyy,shipper.date_shipped) = '2018') then sum(qty_packed) else 0 end) as jul_18,
(case when (datepart(mm,shipper.date_shipped) = 8 and datepart(yyyy,shipper.date_shipped) = '2018') then sum(qty_packed) else 0 end) as aug_18,
(case when (datepart(mm,shipper.date_shipped) = 9 and datepart(yyyy,shipper.date_shipped) = '2018') then sum(qty_packed) else 0 end) as sep_18,
(case when (datepart(mm,shipper.date_shipped) = 10 and datepart(yyyy,shipper.date_shipped) = '2018') then sum(qty_packed) else 0 end) as oct_18,
(case when (datepart(mm,shipper.date_shipped) = 11 and datepart(yyyy,shipper.date_shipped) = '2018') then sum(qty_packed) else 0 end) as nov_18,
(case when (datepart(mm,shipper.date_shipped) = 12 and datepart(yyyy,shipper.date_shipped) = '2018') then sum(qty_packed) else 0 end) as dec_18,

(case when (datepart(mm,shipper.date_shipped) = 1 and datepart(yyyy,shipper.date_shipped) = '2019') then sum(qty_packed) else 0 end) as jan_19,
(case when (datepart(mm,shipper.date_shipped) = 2 and datepart(yyyy,shipper.date_shipped) = '2019') then sum(qty_packed) else 0 end) as feb_19,
(case when (datepart(mm,shipper.date_shipped) = 3 and datepart(yyyy,shipper.date_shipped) = '2019') then sum(qty_packed) else 0 end) as mar_19,
(case when (datepart(mm,shipper.date_shipped) = 4 and datepart(yyyy,shipper.date_shipped) = '2019') then sum(qty_packed) else 0 end) as apr_19,
(case when (datepart(mm,shipper.date_shipped) = 5 and datepart(yyyy,shipper.date_shipped) = '2019') then sum(qty_packed) else 0 end) as may_19,
(case when (datepart(mm,shipper.date_shipped) = 6 and datepart(yyyy,shipper.date_shipped) = '2019') then sum(qty_packed) else 0 end) as jun_19,
(case when (datepart(mm,shipper.date_shipped) = 7 and datepart(yyyy,shipper.date_shipped) = '2019') then sum(qty_packed) else 0 end) as jul_19,
(case when (datepart(mm,shipper.date_shipped) = 8 and datepart(yyyy,shipper.date_shipped) = '2019') then sum(qty_packed) else 0 end) as aug_19,
(case when (datepart(mm,shipper.date_shipped) = 9 and datepart(yyyy,shipper.date_shipped) = '2019') then sum(qty_packed) else 0 end) as sep_19,
(case when (datepart(mm,shipper.date_shipped) = 10 and datepart(yyyy,shipper.date_shipped) = '2019') then sum(qty_packed) else 0 end) as oct_19,
(case when (datepart(mm,shipper.date_shipped) = 11 and datepart(yyyy,shipper.date_shipped) = '2019') then sum(qty_packed) else 0 end) as nov_19,
(case when (datepart(mm,shipper.date_shipped) = 12 and datepart(yyyy,shipper.date_shipped) = '2019') then sum(qty_packed) else 0 end) as dec_19

/*
(case when (datepart(mm,shipper.date_shipped) = 1 and datepart(yyyy,shipper.date_shipped) = '2020') then sum(qty_packed) else 0 end) as jan_20,
(case when (datepart(mm,shipper.date_shipped) = 2 and datepart(yyyy,shipper.date_shipped) = '2020') then sum(qty_packed) else 0 end) as feb_20,
(case when (datepart(mm,shipper.date_shipped) = 3 and datepart(yyyy,shipper.date_shipped) = '2020') then sum(qty_packed) else 0 end) as mar_20,
(case when (datepart(mm,shipper.date_shipped) = 4 and datepart(yyyy,shipper.date_shipped) = '2020') then sum(qty_packed) else 0 end) as apr_20,
(case when (datepart(mm,shipper.date_shipped) = 5 and datepart(yyyy,shipper.date_shipped) = '2020') then sum(qty_packed) else 0 end) as may_20,
(case when (datepart(mm,shipper.date_shipped) = 6 and datepart(yyyy,shipper.date_shipped) = '2020') then sum(qty_packed) else 0 end) as jun_20,
(case when (datepart(mm,shipper.date_shipped) = 7 and datepart(yyyy,shipper.date_shipped) = '2020') then sum(qty_packed) else 0 end) as jul_20,
(case when (datepart(mm,shipper.date_shipped) = 8 and datepart(yyyy,shipper.date_shipped) = '2020') then sum(qty_packed) else 0 end) as aug_20,
(case when (datepart(mm,shipper.date_shipped) = 9 and datepart(yyyy,shipper.date_shipped) = '2020') then sum(qty_packed) else 0 end) as sep_20,
(case when (datepart(mm,shipper.date_shipped) = 10 and datepart(yyyy,shipper.date_shipped) = '2020') then sum(qty_packed) else 0 end) as oct_20,
(case when (datepart(mm,shipper.date_shipped) = 11 and datepart(yyyy,shipper.date_shipped) = '2020') then sum(qty_packed) else 0 end) as nov_20,
(case when (datepart(mm,shipper.date_shipped) = 12 and datepart(yyyy,shipper.date_shipped) = '2020') then sum(qty_packed) else 0 end) as dec_20
*/

from shipper_detail, shipper
where shipper.id = shipper_detail.shipper and
datepart(yyyy,shipper.date_shipped) in ('2015','2016','2017','2018','2019','2020')
and isnull(shipper.type,'S')<>'T'
and left(part_original,7)=@base_part
group by shipper.date_shipped) b








GO
