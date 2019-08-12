SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO










CREATE procedure [EEIUser].[OBSacctg_csm_sp_select_empire_factor] 
  @base_part varchar(30),
  @release_id varchar(30)
as

--exec [EEIUser].[acctg_csm_sp_select_empire_factor_dw] 'NOR0015', '2015-06'


declare @actual table (
base_part varchar(25),
jan_15 decimal(19,0),
feb_15 decimal(19,0),
mar_15 decimal(19,0),
apr_15 decimal(19,0),
may_15 decimal(19,0),
jun_15 decimal(19,0),
Jul_15 decimal(19,0),
Aug_15 decimal(19,0),
Sep_15 decimal(19,0),
Oct_15 decimal(19,0),
Nov_15 decimal(19,0),
Dec_15 decimal(19,0),
Total_2015 decimal(19,0),

jan_16 decimal(19,0),
feb_16 decimal(19,0),
mar_16 decimal(19,0),
apr_16 decimal(19,0),
may_16 decimal(19,0),
jun_16 decimal(19,0),
Jul_16 decimal(19,0),
Aug_16 decimal(19,0),
Sep_16 decimal(19,0),
Oct_16 decimal(19,0),
Nov_16 decimal(19,0),
Dec_16 decimal(19,0),
Total_2016 decimal(19,0),

jan_17 decimal(19,0),
feb_17 decimal(19,0),
mar_17 decimal(19,0),
apr_17 decimal(19,0),
may_17 decimal(19,0),
jun_17 decimal(19,0),
Jul_17 decimal(19,0),
Aug_17 decimal(19,0),
Sep_17 decimal(19,0),
Oct_17 decimal(19,0),
Nov_17 decimal(19,0),
Dec_17 decimal(19,0),
Total_2017 decimal(19,0),

jan_18 decimal(19,0),
feb_18 decimal(19,0),
mar_18 decimal(19,0),
apr_18 decimal(19,0),
may_18 decimal(19,0),
jun_18 decimal(19,0),
Jul_18 decimal(19,0),
Aug_18 decimal(19,0),
Sep_18 decimal(19,0),
Oct_18 decimal(19,0),
Nov_18 decimal(19,0),
Dec_18 decimal(19,0),
Total_2018 decimal(19,0),

Total_2019 decimal(19,0),
Total_2020 decimal(19,0))

insert into @actual
select 
@base_part,
sum([Jan 2015]) as [Jan 2015],
sum([Feb 2015]) as [Feb 2015],
sum([Mar 2015]) as [Mar 2015],
sum([Apr 2015]) as [Apr 2015],
sum([May 2015]) as [May 2015],
sum([Jun 2015]) as [Jun 2015],
sum([Jul 2015]) as [Jul 2015],
sum([Aug 2015]) as [Aug 2015],
sum([Sep 2015]) as [Sep 2015],
sum([Oct 2015]) as [Oct 2015],
sum([Nov 2015]) as [Nov 2015],
sum([Dec 2015]) as [Dec 2015],
sum([total_2015]) as [total_2015],

sum([Jan 2016]) as [Jan 2016],
sum([Feb 2016]) as [Feb 2016],
sum([Mar 2016]) as [Mar 2016],
sum([Apr 2016]) as [Apr 2016],
sum([May 2016]) as [May 2016],
sum([Jun 2016]) as [Jun 2016],
sum([Jul 2016]) as [Jul 2016],
sum([Aug 2016]) as [Aug 2016],
sum([Sep 2016]) as [Sep 2016],
sum([Oct 2016]) as [Oct 2016],
sum([Nov 2016]) as [Oct 2016],
sum([Dec 2016]) as [Dec 2016],
sum([total_2016]) as [total_2016],

sum([Jan 2017]) as [Jan 2017],
sum([Feb 2017]) as [Feb 2017],
sum([Mar 2017]) as [Mar 2017],
sum([Apr 2017]) as [Apr 2017],
sum([May 2017]) as [May 2017],
sum([Jun 2017]) as [Jun 2017],
sum([Jul 2017]) as [Jul 2017],
sum([Aug 2017]) as [Aug 2017],
sum([Sep 2017]) as [Sep 2017],
sum([Oct 2017]) as [Oct 2017],
sum([Nov 2017]) as [Oct 2017],
sum([Dec 2017]) as [Dec 2017],
sum([total_2017]) as [total_2017],

sum([Jan 2018]) as [Jan 2018],
sum([Feb 2018]) as [Feb 2018],
sum([Mar 2018]) as [Mar 2018],
sum([Apr 2018]) as [Apr 2018],
sum([May 2018]) as [May 2018],
sum([Jun 2018]) as [Jun 2018],
sum([Jul 2018]) as [Jul 2018],
sum([Aug 2018]) as [Aug 2018],
sum([Sep 2018]) as [Sep 2018],
sum([Oct 2018]) as [Oct 2018],
sum([Nov 2018]) as [Oct 2018],
sum([Dec 2018]) as [Dec 2018],
sum([total_2018]) as [total_2018],

sum([total_2019]) as [total_2019],
sum([total_2020]) as [total_2020]
from (
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

sum(0) as total_2019,
sum(0) as total_2020
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
(case when (datepart(mm,due_date) = 12 and datepart(yyyy,due_date) = 2018) then sum(eeiqty) else 0 end) as dec_18

from order_detail
where datepart(yyyy,due_date) in ('2015','2016','2017','2018')
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

sum(0) as total_2019,
sum(0) as total_2020

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
(case when (datepart(mm,shipper.date_shipped) = 12 and datepart(yyyy,shipper.date_shipped) = '2018') then sum(qty_packed) else 0 end) as dec_18

from shipper_detail, shipper
where shipper.id = shipper_detail.shipper and
datepart(yyyy,shipper.date_shipped) in ('2015','2016','2017','2018')
and isnull(shipper.type,'S')<>'T'
and left(part_original,7)=@base_part
group by shipper.date_shipped) b
) a

---------------------------------------------
--CSM DEMAND---------------------------------

declare @forecast table (
base_part varchar(25),
jan_15 decimal(19,0),
feb_15 decimal(19,0),
mar_15 decimal(19,0),
apr_15 decimal(19,0),
may_15 decimal(19,0),
jun_15 decimal(19,0),
Jul_15 decimal(19,0),
Aug_15 decimal(19,0),
Sep_15 decimal(19,0),
Oct_15 decimal(19,0),
Nov_15 decimal(19,0),
Dec_15 decimal(19,0),
Total_2015 decimal(19,0),

jan_16 decimal(19,0),
feb_16 decimal(19,0),
mar_16 decimal(19,0),
apr_16 decimal(19,0),
may_16 decimal(19,0),
jun_16 decimal(19,0),
Jul_16 decimal(19,0),
Aug_16 decimal(19,0),
Sep_16 decimal(19,0),
Oct_16 decimal(19,0),
Nov_16 decimal(19,0),
Dec_16 decimal(19,0),
Total_2016 decimal(19,0),

jan_17 decimal(19,0),
feb_17 decimal(19,0),
mar_17 decimal(19,0),
apr_17 decimal(19,0),
may_17 decimal(19,0),
jun_17 decimal(19,0),
Jul_17 decimal(19,0),
Aug_17 decimal(19,0),
Sep_17 decimal(19,0),
Oct_17 decimal(19,0),
Nov_17 decimal(19,0),
Dec_17 decimal(19,0),
Total_2017 decimal(19,0),

jan_18 decimal(19,0),
feb_18 decimal(19,0),
mar_18 decimal(19,0),
apr_18 decimal(19,0),
may_18 decimal(19,0),
jun_18 decimal(19,0),
Jul_18 decimal(19,0),
Aug_18 decimal(19,0),
Sep_18 decimal(19,0),
Oct_18 decimal(19,0),
Nov_18 decimal(19,0),
Dec_18 decimal(19,0),
Total_2018 decimal(19,0),

Total_2019 decimal(19,0),
Total_2020 decimal(19,0))

insert into @forecast
select 
@base_part,
sum([jan 2015]) as [Jan 2015],
sum([feb 2015]) as [Feb 2015],
sum([Mar 2015]) as [Mar 2015],
sum([Apr 2015]) as [Apr 2015],
sum([May 2015]) as [May 2015],
sum([Jun 2015]) as [Jun 2015],
sum([Jul 2015]) as [Jul 2015],
sum([Aug 2015]) as [Aug 2015],
sum([Sep 2015]) as [Sep 2015],
sum([Oct 2015]) as [Oct 2015],
sum([Nov 2015]) as [Nov 2015],
sum([Dec 2015]) as [Dec 2015],
sum([total_2015]) as [total_2015],

sum([Jan 2016]) as [Jan 2016],
sum([Feb 2016]) as [Feb 2016],
sum([Mar 2016]) as [Mar 2016],
sum([Apr 2016]) as [Apr 2016],
sum([May 2016]) as [May 2016],
sum([Jun 2016]) as [Jun 2016],
sum([Jul 2016]) as [Jul 2016],
sum([Aug 2016]) as [Aug 2016],
sum([Sep 2016]) as [Sep 2016],
sum([Oct 2016]) as [Oct 2016],
sum([Nov 2016]) as [Oct 2016],
sum([Dec 2016]) as [Dec 2016],
sum([total_2016]) as [total_2016],

sum([Jan 2017]) as [Jan 2017],
sum([Feb 2017]) as [Feb 2017],
sum([Mar 2017]) as [Mar 2017],
sum([Apr 2017]) as [Apr 2017],
sum([May 2017]) as [May 2017],
sum([Jun 2017]) as [Jun 2017],
sum([Jul 2017]) as [Jul 2017],
sum([Aug 2017]) as [Aug 2017],
sum([Sep 2017]) as [Sep 2017],
sum([Oct 2017]) as [Oct 2017],
sum([Nov 2017]) as [Oct 2017],
sum([Dec 2017]) as [Dec 2017],
sum([total_2017]) as [total_2017],

sum([Jan 2018]) as [Jan 2018],
sum([Feb 2018]) as [Feb 2018],
sum([Mar 2018]) as [Mar 2018],
sum([Apr 2018]) as [Apr 2018],
sum([May 2018]) as [May 2018],
sum([Jun 2018]) as [Jun 2018],
sum([Jul 2018]) as [Jul 2018],
sum([Aug 2018]) as [Aug 2018],
sum([Sep 2018]) as [Sep 2018],
sum([Oct 2018]) as [Oct 2018],
sum([Nov 2018]) as [Oct 2018],
sum([Dec 2018]) as [Dec 2018],
sum([total_2018]) as [total_2018],

sum([total_2019]) as [total_2019],
sum([total_2020]) as [total_2020]
from (
select	@base_part as [base_part],
		b.version,
		b.release_id, 
		b.[Mnemonic-Vehicle/Plant] as MnemonicVehiclePlant, 
		b.platform, 
		b.program, 
		b.brand+' '+b.nameplate as [vehicle], 
		b.plant, 
		b.sop, 
		b.eop,  
		ISNULL(a.qty_per,0) as [qty_per],
		ISNULL(a.take_rate,0) as [take_rate], 
		ISNULL(a.family_allocation,0) as [family_allocation],
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2015] end),0) as [jan 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2015] end),0) as [feb 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2015] end),0) as [mar 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2015] end),0) as [apr 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2015] end),0) as [may 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2015] end),0) as [jun 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2015] end),0) as [jul 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2015] end),0) as [aug 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2015] end),0) as [sep 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2015] end),0) as [oct 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2015] end),0) as [nov 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2015] end),0) as [dec 2015], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2015],0)+ISNULL(b.[Feb 2015],0)+ISNULL(b.[Mar 2015],0)+ISNULL(b.[Apr 2015],0)+ISNULL(b.[May 2015],0)+ISNULL(b.[Jun 2015],0)+ISNULL(b.[Jul 2015],0)+ISNULL(b.[Aug 2015],0)+ISNULL(b.[Sep 2015],0)+ISNULL(b.[Oct 2015],0)+ISNULL(b.[Nov 2015],0)+ISNULL(b.[Dec 2015],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2015]+b.[Feb 2015]+b.[Mar 2015]+b.[Apr 2015]+b.[May 2015]+b.[Jun 2015]+b.[Jul 2015]+b.[Aug 2015]+b.[Sep 2015]+b.[Oct 2015]+b.[Nov 2015]+b.[Dec 2015]) end),0) as [total_2015],

		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2016] end),0) as [jan 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2016] end),0) as [feb 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2016] end),0) as [mar 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2016] end),0) as [apr 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2016] end),0) as [may 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2016] end),0) as [jun 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2016] end),0) as [jul 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2016] end),0) as [aug 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2016] end),0) as [sep 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2016] end),0) as [oct 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2016] end),0) as [nov 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2016] end),0) as [dec 2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2016],0)+ISNULL(b.[Feb 2016],0)+ISNULL(b.[Mar 2016],0)+ISNULL(b.[Apr 2016],0)+ISNULL(b.[May 2016],0)+ISNULL(b.[Jun 2016],0)+ISNULL(b.[Jul 2016],0)+ISNULL(b.[Aug 2016],0)+ISNULL(b.[Sep 2016],0)+ISNULL(b.[Oct 2016],0)+ISNULL(b.[Nov 2016],0)+ISNULL(b.[Dec 2016],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2016]+b.[Feb 2016]+b.[Mar 2016]+b.[Apr 2016]+b.[May 2016]+b.[Jun 2016]+b.[Jul 2016]+b.[Aug 2016]+b.[Sep 2016]+b.[Oct 2016]+b.[Nov 2016]+b.[Dec 2016]) end),0) as [total_2016],

        ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2017] end),0) as [jan 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2017] end),0) as [feb 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2017] end),0) as [mar 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2017] end),0) as [apr 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2017] end),0) as [may 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2017] end),0) as [jun 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2017] end),0) as [jul 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2017] end),0) as [aug 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2017] end),0) as [sep 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2017] end),0) as [oct 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2017] end),0) as [nov 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2017] end),0) as [dec 2017], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2017],0)+ISNULL(b.[Feb 2017],0)+ISNULL(b.[Mar 2017],0)+ISNULL(b.[Apr 2017],0)+ISNULL(b.[May 2017],0)+ISNULL(b.[Jun 2017],0)+ISNULL(b.[Jul 2017],0)+ISNULL(b.[Aug 2017],0)+ISNULL(b.[Sep 2017],0)+ISNULL(b.[Oct 2017],0)+ISNULL(b.[Nov 2017],0)+ISNULL(b.[Dec 2017],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2017]+b.[Feb 2017]+b.[Mar 2017]+b.[Apr 2017]+b.[May 2017]+b.[Jun 2017]+b.[Jul 2017]+b.[Aug 2017]+b.[Sep 2017]+b.[Oct 2017]+b.[Nov 2017]+b.[Dec 2017]) end),0) as [total_2017],
        
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2018] end),0) as [jan 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2018] end),0) as [feb 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2018] end),0) as [mar 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2018] end),0) as [apr 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2018] end),0) as [may 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2018] end),0) as [jun 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2018] end),0) as [jul 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2018] end),0) as [aug 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2018] end),0) as [sep 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2018] end),0) as [oct 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2018] end),0) as [nov 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2018] end),0) as [dec 2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2018],0)+ISNULL(b.[Feb 2018],0)+ISNULL(b.[Mar 2018],0)+ISNULL(b.[Apr 2018],0)+ISNULL(b.[May 2018],0)+ISNULL(b.[Jun 2018],0)+ISNULL(b.[Jul 2018],0)+ISNULL(b.[Aug 2018],0)+ISNULL(b.[Sep 2018],0)+ISNULL(b.[Oct 2018],0)+ISNULL(b.[Nov 2018],0)+ISNULL(b.[Dec 2018],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2018]+b.[Feb 2018]+b.[Mar 2018]+b.[Apr 2018]+b.[May 2018]+b.[Jun 2018]+b.[Jul 2018]+b.[Aug 2018]+b.[Sep 2018]+b.[Oct 2018]+b.[Nov 2018]+b.[Dec 2018]) end),0) as [total_2018],

		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[CY 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[CY 2019] end),0) as [total_2019], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[CY 2020],0) else a.qty_per*a.take_rate*a.family_allocation*b.[CY 2020] end),0) as [total_2020]
from 
		(	select	* 
			from	eeiuser.acctg_csm_base_part_mnemonic
		) a 
		left outer join 
		(	select	* 
			from	eeiuser.acctg_csm_NAIHS 
			where	release_id = @release_id
		) b
		on b.[Mnemonic-Vehicle/Plant] = a.mnemonic 
		where	a.base_part = @base_part 
			and b.[Mnemonic-Vehicle/Plant] is not null
			and b.Version = 'CSM')a

declare @suggested_take_rate decimal(19,2)
select @suggested_take_rate = (select (case b.total_2015 when 0 then 0 else round(a.total_2015/b.total_2015,2) end)*(select avg(take_rate) from eeiuser.acctg_csm_base_part_mnemonic c where  c.base_part = a.base_part and c.forecast_id = 'C') from @actual a join @forecast b on a.base_part = b.base_part )



select	@base_part as base_part,
		b.version,
		b.release_id, 
		b.[Mnemonic-Vehicle/Plant] as [MnemonicVehiclePlant], 
		b.platform, 
		b.program, 
		b.brand+' '+b.[nameplate] as [vehicle], 
		b.plant, 
		b.[sop], 
		b.[eop],
		@suggested_take_rate as suggested_take_rate,  
		ISNULL(a.qty_per,0) as [qty_per],
		ISNULL(a.take_rate,0) as [take_rate], 
		ISNULL(a.family_allocation,0) as [family_allocation],
        ISNULL(b.[jan 2015],0) as [jan2015], 
		ISNULL(b.[feb 2015],0) as [feb2015], 
		ISNULL(b.[mar 2015],0) as [mar2015], 
		ISNULL(b.[apr 2015],0) as [apr2015], 
		ISNULL(b.[may 2015],0) as [may2015], 
		ISNULL(b.[jun 2015],0) as [jun2015], 
		ISNULL(b.[jul 2015],0) as [jul2015], 
		ISNULL(b.[aug 2015],0) as [aug2015], 
		ISNULL(b.[sep 2015],0) as [sep2015], 
		ISNULL(b.[oct 2015],0) as [oct2015], 
		ISNULL(b.[nov 2015],0) as [nov2015], 
		ISNULL(b.[dec 2015],0) as [dec2015], 
		(ISNULL(b.[jan 2015],0)+ISNULL(b.[feb 2015],0)+ISNULL(b.[mar 2015],0)+ISNULL(b.[apr 2015],0)+ISNULL(b.[may 2015],0)+ISNULL(b.[jun 2015],0)+ISNULL(b.[jul 2015],0)+ISNULL(b.[aug 2015],0)+ISNULL(b.[sep 2015],0)+ISNULL(b.[oct 2015],0)+ISNULL(b.[nov 2015],0)+ISNULL(b.[dec 2015],0)) as [total_2015],

		ISNULL(b.[jan 2016],0) as [jan2016], 
		ISNULL(b.[feb 2016],0) as [feb2016], 
		ISNULL(b.[mar 2016],0) as [mar2016], 
		ISNULL(b.[apr 2016],0) as [apr2016], 
		ISNULL(b.[may 2016],0) as [may2016], 
		ISNULL(b.[jun 2016],0) as [jun2016], 
		ISNULL(b.[jul 2016],0) as [jul2016], 
		ISNULL(b.[aug 2016],0) as [aug2016], 
		ISNULL(b.[sep 2016],0) as [sep2016], 
		ISNULL(b.[oct 2016],0) as [oct2016], 
		ISNULL(b.[nov 2016],0) as [nov2016], 
		ISNULL(b.[dec 2016],0) as [dec2016], 
		(ISNULL(b.[jan 2016],0)+ISNULL(b.[feb 2016],0)+ISNULL(b.[mar 2016],0)+ISNULL(b.[apr 2016],0)+ISNULL(b.[may 2016],0)+ISNULL(b.[jun 2016],0)+ISNULL(b.[jul 2016],0)+ISNULL(b.[aug 2016],0)+ISNULL(b.[sep 2016],0)+ISNULL(b.[oct 2016],0)+ISNULL(b.[nov 2016],0)+ISNULL(b.[dec 2016],0)) as [total_2016],

		ISNULL(b.[jan 2017],0) as [jan2017], 
		ISNULL(b.[feb 2017],0) as [feb2017], 
		ISNULL(b.[mar 2017],0) as [mar2017], 
		ISNULL(b.[apr 2017],0) as [apr2017], 
		ISNULL(b.[may 2017],0) as [may2017], 
		ISNULL(b.[jun 2017],0) as [jun2017], 
		ISNULL(b.[jul 2017],0) as [jul2017], 
		ISNULL(b.[aug 2017],0) as [aug2017], 
		ISNULL(b.[sep 2017],0) as [sep2017], 
		ISNULL(b.[oct 2017],0) as [oct2017], 
		ISNULL(b.[nov 2017],0) as [nov2017], 
		ISNULL(b.[dec 2017],0) as [dec2017], 
		(ISNULL(b.[jan 2017],0)+ISNULL(b.[feb 2017],0)+ISNULL(b.[mar 2017],0)+ISNULL(b.[apr 2017],0)+ISNULL(b.[may 2017],0)+ISNULL(b.[jun 2017],0)+ISNULL(b.[jul 2017],0)+ISNULL(b.[aug 2017],0)+ISNULL(b.[sep 2017],0)+ISNULL(b.[oct 2017],0)+ISNULL(b.[nov 2017],0)+ISNULL(b.[dec 2017],0)) as [total_2017],
		 
		ISNULL(b.[jan 2018],0) as [jan2018], 
		ISNULL(b.[feb 2018],0) as [feb2018], 
		ISNULL(b.[mar 2018],0) as [mar2018], 
		ISNULL(b.[apr 2018],0) as [apr2018], 
		ISNULL(b.[may 2018],0) as [may2018], 
		ISNULL(b.[jun 2018],0) as [jun2018], 
		ISNULL(b.[jul 2018],0) as [jul2018], 
		ISNULL(b.[aug 2018],0) as [aug2018], 
		ISNULL(b.[sep 2018],0) as [sep2018], 
		ISNULL(b.[oct 2018],0) as [oct2018], 
		ISNULL(b.[nov 2018],0) as [nov2018], 
		ISNULL(b.[dec 2018],0) as [dec2018], 
		(ISNULL(b.[jan 2018],0)+ISNULL(b.[feb 2018],0)+ISNULL(b.[mar 2018],0)+ISNULL(b.[apr 2018],0)+ISNULL(b.[may 2018],0)+ISNULL(b.[jun 2018],0)+ISNULL(b.[jul 2018],0)+ISNULL(b.[aug 2018],0)+ISNULL(b.[sep 2018],0)+ISNULL(b.[oct 2018],0)+ISNULL(b.[nov 2018],0)+ISNULL(b.[dec 2018],0)) as [total_2018],
		
		ISNULL(b.[CY 2019] ,0) as [total_2019], 
		ISNULL(b.[CY 2020] ,0) as [total_2020]
from 
		(	select	* 
			from	eeiuser.acctg_csm_base_part_mnemonic
		) a 
		left outer join 
		(	select	* 
			from	eeiuser.acctg_csm_NAIHS 
			where	release_id = @release_id
		) b
		on b.[Mnemonic-Vehicle/Plant] = a.mnemonic
		where	a.base_part = @base_part 
			and b.[Mnemonic-Vehicle/Plant] is not null
			and b.VERSION = 'Empire Factor'
 





GO
