SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- exec eeiuser.acctg_csm_sp_update_take_rate 'NOR0014', '2014-06'


CREATE procedure [EEIUser].[acctg_csm_sp_update_take_rate]
  @base_part varchar(30),
  @release_id varchar(10)
as

declare @actual table (
base_part varchar(25),
jan_14 decimal(18,0),
feb_14 decimal(18,0),
mar_14 decimal(18,0),
apr_14 decimal(18,0),
may_14 decimal(18,0),
jun_14 decimal(18,0),
Jul_14 decimal(18,0),
Aug_14 decimal(18,0),
Sep_14 decimal(18,0),
Oct_14 decimal(18,0),
Nov_14 decimal(18,0),
Dec_14 decimal(18,0),
Total_2014 decimal(18,0),
jan_15 decimal(18,0),
feb_15 decimal(18,0),
mar_15 decimal(18,0),
apr_15 decimal(18,0),
may_15 decimal(18,0),
jun_15 decimal(18,0),
Jul_15 decimal(18,0),
Aug_15 decimal(18,0),
Sep_15 decimal(18,0),
Oct_15 decimal(18,0),
Nov_15 decimal(18,0),
Dec_15 decimal(18,0),
Total_2015 decimal(18,0),
Total_2016 decimal(18,0),
Total_2017 decimal(18,0),
Total_2018 decimal(18,0),
Total_2019 decimal(18,0))

insert into @actual
select 
@base_part,
sum([Jan 2014]) as [Jan 2014],
sum([Feb 2014]) as [Feb 2014],
sum([Mar 2014]) as [Mar 2014],
sum([Apr 2014]) as [Apr 2014],
sum([May 2014]) as [May 2014],
sum([Jun 2014]) as [Jun 2014],
sum([Jul 2014]) as [Jul 2014],
sum([Aug 2014]) as [Aug 2014],
sum([Sep 2014]) as [Sep 2014],
sum([Oct 2014]) as [Oct 2014],
sum([Nov 2014]) as [Nov 2014],
sum([Dec 2014]) as [Dec 2014],
sum([total_2014]) as [total_2014],
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
sum([Nov 2015]) as [Oct 2015],
sum([Dec 2015]) as [Dec 2015],
sum([total_2015]) as [total_2015],
sum([total_2016]) as [total_2015],
sum([total_2017]) as [total_2015],
sum([total_2018]) as [total_2018],
sum([total_2019]) as [total_2019]
from (
select
'Planner Demand' as description,
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
sum(0) as total_2016,
sum(0) as total_2017,
sum(0) as total_2018,
sum(0) as total_2019
from
(select 
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
(case when (datepart(mm,due_date) = 12 and datepart(yyyy,due_date) = 2015) then sum(eeiqty) else 0 end) as dec_15
from order_detail
where datepart(yyyy,due_date) in ('2014','2015')
and left(part_number,7) = @base_part
group by due_date) a
union
select
'Actual Shipouts' as description,
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
sum(0) as total_2016,
sum(0) as total_2017,
sum(0) as total_2018,
sum(0) as total_2019

from
(select
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
(case when (datepart(mm,shipper.date_shipped) = 12 and datepart(yyyy,shipper.date_shipped) = '2015') then sum(qty_packed) else 0 end) as dec_15
from shipper_detail, shipper
where shipper.id = shipper_detail.shipper and
datepart(yyyy,shipper.date_shipped) in ('2014','2015')
and isnull(shipper.type,'S')<>'T'
and left(part_original,7)=@base_part
group by shipper.date_shipped) b
) a

---------------------------------------------
--CSM DEMAND---------------------------------

declare @forecast table (
base_part varchar(25),
jan_14 decimal(18,0),
feb_14 decimal(18,0),
mar_14 decimal(18,0),
apr_14 decimal(18,0),
may_14 decimal(18,0),
jun_14 decimal(18,0),
Jul_14 decimal(18,0),
Aug_14 decimal(18,0),
Sep_14 decimal(18,0),
Oct_14 decimal(18,0),
Nov_14 decimal(18,0),
Dec_14 decimal(18,0),
Total_2014 decimal(18,0),
jan_15 decimal(18,0),
feb_15 decimal(18,0),
mar_15 decimal(18,0),
apr_15 decimal(18,0),
may_15 decimal(18,0),
jun_15 decimal(18,0),
Jul_15 decimal(18,0),
Aug_15 decimal(18,0),
Sep_15 decimal(18,0),
Oct_15 decimal(18,0),
Nov_15 decimal(18,0),
Dec_15 decimal(18,0),
Total_2015 decimal(18,0),
Total_2016 decimal(18,0),
Total_2017 decimal(18,0),
Total_2018 decimal(18,0),
Total_2019 decimal(18,0))

insert into @forecast
select 
@base_part,
sum([jan 2014]) as [Jan 2014],
sum([feb 2014]) as [Feb 2014],
sum([Mar 2014]) as [Mar 2014],
sum([Apr 2014]) as [Apr 2014],
sum([May 2014]) as [May 2014],
sum([Jun 2014]) as [Jun 2014],
sum([Jul 2014]) as [Jul 2014],
sum([Aug 2014]) as [Aug 2014],
sum([Sep 2014]) as [Sep 2014],
sum([Oct 2014]) as [Oct 2014],
sum([Nov 2014]) as [Nov 2014],
sum([Dec 2014]) as [Dec 2014],
sum([total_2014]) as [total_2014],
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
sum([Nov 2015]) as [Oct 2015],
sum([Dec 2015]) as [Dec 2015],
sum([total_2015]) as [total_2015],
sum([total_2016]) as [total_2015],
sum([total_2017]) as [total_2015],
sum([total_2018]) as [total_2018],
sum([total_2019]) as [total_2019]
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
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jan 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jan 2014] end),0) as [jan 2014], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Feb 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Feb 2014] end),0) as [feb 2014], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Mar 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Mar 2014] end),0) as [mar 2014], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Apr 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Apr 2014] end),0) as [apr 2014], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[May 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[May 2014] end),0) as [may 2014], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jun 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jun 2014] end),0) as [jun 2014], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Jul 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Jul 2014] end),0) as [jul 2014], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Aug 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Aug 2014] end),0) as [aug 2014], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Sep 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Sep 2014] end),0) as [sep 2014], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Oct 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Oct 2014] end),0) as [oct 2014], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Nov 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Nov 2014] end),0) as [nov 2014], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[Dec 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[Dec 2014] end),0) as [dec 2014], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then (ISNULL(b.[Jan 2014],0)+ISNULL(b.[Feb 2014],0)+ISNULL(b.[Mar 2014],0)+ISNULL(b.[Apr 2014],0)+ISNULL(b.[May 2014],0)+ISNULL(b.[Jun 2014],0)+ISNULL(b.[Jul 2014],0)+ISNULL(b.[Aug 2014],0)+ISNULL(b.[Sep 2014],0)+ISNULL(b.[Oct 2014],0)+ISNULL(b.[Nov 2014],0)+ISNULL(b.[Dec 2014],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[Jan 2014]+b.[Feb 2014]+b.[Mar 2014]+b.[Apr 2014]+b.[May 2014]+b.[Jun 2014]+b.[Jul 2014]+b.[Aug 2014]+b.[Sep 2014]+b.[Oct 2014]+b.[Nov 2014]+b.[Dec 2014]) end),0) as [total_2014],
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
        ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[CY 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[CY 2016] end),0) as [total_2016], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[CY 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[CY 2017] end),0) as [total_2017],
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[CY 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[CY 2018] end),0) as [total_2018], 
		ISNULL((case when b.version in ('Empire Factor','Empire Adjustment') then ISNULL(b.[CY 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[CY 2019] end),0) as [total_2019]
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

declare @suggested_take_rate decimal(18,2)
select @suggested_take_rate = (select round(a.total_2016/b.total_2016,2) from @actual a join @forecast b on a.base_part = b.base_part)

update eeiuser.acctg_csm_base_part_mnemonic set take_rate = take_rate*@suggested_take_rate where base_part = @base_part and forecast_id = 'C'


GO
