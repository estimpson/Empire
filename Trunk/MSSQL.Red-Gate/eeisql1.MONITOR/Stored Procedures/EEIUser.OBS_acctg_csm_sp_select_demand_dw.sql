SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EEIUser].[OBS_acctg_csm_sp_select_demand_dw]
  @checkbox1 bit,
  @base_part varchar(30),
  @release_id varchar(30)
as

--exec [EEIUser].[acctg_csm_sp_select_demand_dw] 1, 'ALC0134', '2012-04'

select 
b.version, 
b.[Mnemonic-Vehicle/Plant], 
b.platform, 
b.program, 
b.brand+' '+b.[nameplate] as [vehicle], 
b.plant, 
b.[sop],
b.eop,  
a.qty_per, 
a.take_rate, 
a.family_allocation, 
(case b.version when 'Empire' then ISNULL(b.[jan 2012],0) else a.qty_per*a.take_rate*a.family_allocation*b.[jan 2012] end) as [jan 2012], 
(case b.version when 'Empire' then ISNULL(b.[feb 2012],0) else a.qty_per*a.take_rate*a.family_allocation*b.[feb 2012] end) as [feb 2012], 
(case b.version when 'Empire' then ISNULL(b.[mar 2012],0) else a.qty_per*a.take_rate*a.family_allocation*b.[mar 2012] end) as [mar 2012], 
(case b.version when 'Empire' then ISNULL(b.[apr 2012],0) else a.qty_per*a.take_rate*a.family_allocation*b.[apr 2012] end) as [apr 2012], 
(case b.version when 'Empire' then ISNULL(b.[may 2012],0) else a.qty_per*a.take_rate*a.family_allocation*b.[may 2012] end) as [may 2012], 
(case b.version when 'Empire' then ISNULL(b.[jun 2012],0) else a.qty_per*a.take_rate*a.family_allocation*b.[jun 2012] end) as [jun 2012], 
(case b.version when 'Empire' then ISNULL(b.[jul 2012],0) else a.qty_per*a.take_rate*a.family_allocation*b.[jul 2012] end) as [jul 2012], 
(case b.version when 'Empire' then ISNULL(b.[aug 2012],0) else a.qty_per*a.take_rate*a.family_allocation*b.[aug 2012] end) as [aug 2012], 
(case b.version when 'Empire' then ISNULL(b.[sep 2012],0) else a.qty_per*a.take_rate*a.family_allocation*b.[sep 2012] end) as [sep 2012], 
(case b.version when 'Empire' then ISNULL(b.[oct 2012],0) else a.qty_per*a.take_rate*a.family_allocation*b.[oct 2012] end) as [oct 2012], 
(case b.version when 'Empire' then ISNULL(b.[nov 2012],0) else a.qty_per*a.take_rate*a.family_allocation*b.[nov 2012] end) as [nov 2012], 
(case b.version when 'Empire' then ISNULL(b.[dec 2012],0) else a.qty_per*a.take_rate*a.family_allocation*b.[dec 2012] end) as [dec 2012], 
(case when b.version='Empire' then (ISNULL(b.[jan 2012],0)+ISNULL(b.[feb 2012],0)+ISNULL(b.[mar 2012],0)+ISNULL(b.[apr 2012],0)+ISNULL(b.[may 2012],0)+ISNULL(b.[jun 2012],0)+ISNULL(b.[jul 2012],0)+ISNULL(b.[aug 2012],0)+ISNULL(b.[sep 2012],0)+ISNULL(b.[oct 2012],0)+ISNULL(b.[nov 2012],0)+ISNULL(b.[dec 2012],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[jan 2012]+b.[feb 2012]+b.[mar 2012]+b.[apr 2012]+b.[may 2012]+b.[jun 2012]+b.[jul 2012]+b.[aug 2012]+b.[sep 2012]+b.[oct 2012]+b.[nov 2012]+b.[dec 2012]) end) as [total_2012],
(case b.version when 'Empire' then ISNULL(b.[jan 2013],0) else a.qty_per*a.take_rate*a.family_allocation*b.[jan 2013] end) as [jan 2013], 
(case b.version when 'Empire' then ISNULL(b.[feb 2013],0) else a.qty_per*a.take_rate*a.family_allocation*b.[feb 2013] end) as [feb 2013], 
(case b.version when 'Empire' then ISNULL(b.[mar 2013],0) else a.qty_per*a.take_rate*a.family_allocation*b.[mar 2013] end) as [mar 2013], 
(case b.version when 'Empire' then ISNULL(b.[apr 2013],0) else a.qty_per*a.take_rate*a.family_allocation*b.[apr 2013] end) as [apr 2013], 
(case b.version when 'Empire' then ISNULL(b.[may 2013],0) else a.qty_per*a.take_rate*a.family_allocation*b.[may 2013] end) as [may 2013], 
(case b.version when 'Empire' then ISNULL(b.[jun 2013],0) else a.qty_per*a.take_rate*a.family_allocation*b.[jun 2013] end) as [jun 2013], 
(case b.version when 'Empire' then ISNULL(b.[jul 2013],0) else a.qty_per*a.take_rate*a.family_allocation*b.[jul 2013] end) as [jul 2013], 
(case b.version when 'Empire' then ISNULL(b.[aug 2013],0) else a.qty_per*a.take_rate*a.family_allocation*b.[aug 2013] end) as [aug 2013], 
(case b.version when 'Empire' then ISNULL(b.[sep 2013],0) else a.qty_per*a.take_rate*a.family_allocation*b.[sep 2013] end) as [sep 2013], 
(case b.version when 'Empire' then ISNULL(b.[oct 2013],0) else a.qty_per*a.take_rate*a.family_allocation*b.[oct 2013] end) as [oct 2013], 
(case b.version when 'Empire' then ISNULL(b.[nov 2013],0) else a.qty_per*a.take_rate*a.family_allocation*b.[nov 2013] end) as [nov 2013], 
(case b.version when 'Empire' then ISNULL(b.[dec 2013],0) else a.qty_per*a.take_rate*a.family_allocation*b.[dec 2013] end) as [dec 2013], 
(case when b.version='Empire' then (ISNULL(b.[jan 2013],0)+ISNULL(b.[feb 2013],0)+ISNULL(b.[mar 2013],0)+ISNULL(b.[apr 2013],0)+ISNULL(b.[may 2013],0)+ISNULL(b.[jun 2013],0)+ISNULL(b.[jul 2013],0)+ISNULL(b.[aug 2013],0)+ISNULL(b.[sep 2013],0)+ISNULL(b.[oct 2013],0)+ISNULL(b.[nov 2013],0)+ISNULL(b.[dec 2013],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[jan 2013]+b.[feb 2013]+b.[mar 2013]+b.[apr 2013]+b.[may 2013]+b.[jun 2013]+b.[jul 2013]+b.[aug 2013]+b.[sep 2013]+b.[oct 2013]+b.[nov 2013]+b.[dec 2013]) end) as [total_2013],
(case b.version when 'Empire' then ISNULL(b.[jan 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[jan 2014] end) as [jan 2014], 
(case b.version when 'Empire' then ISNULL(b.[feb 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[feb 2014] end) as [feb 2014], 
(case b.version when 'Empire' then ISNULL(b.[mar 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[mar 2014] end) as [mar 2014], 
(case b.version when 'Empire' then ISNULL(b.[apr 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[apr 2014] end) as [apr 2014], 
(case b.version when 'Empire' then ISNULL(b.[may 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[may 2014] end) as [may 2014], 
(case b.version when 'Empire' then ISNULL(b.[jun 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[jun 2014] end) as [jun 2014], 
(case b.version when 'Empire' then ISNULL(b.[jul 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[jul 2014] end) as [jul 2014], 
(case b.version when 'Empire' then ISNULL(b.[aug 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[aug 2014] end) as [aug 2014], 
(case b.version when 'Empire' then ISNULL(b.[sep 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[sep 2014] end) as [sep 2014], 
(case b.version when 'Empire' then ISNULL(b.[oct 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[oct 2014] end) as [oct 2014], 
(case b.version when 'Empire' then ISNULL(b.[nov 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[nov 2014] end) as [nov 2014], 
(case b.version when 'Empire' then ISNULL(b.[dec 2014],0) else a.qty_per*a.take_rate*a.family_allocation*b.[dec 2014] end) as [dec 2014], 
(case when b.version='Empire' then (ISNULL(b.[jan 2014],0)+ISNULL(b.[feb 2014],0)+ISNULL(b.[mar 2014],0)+ISNULL(b.[apr 2014],0)+ISNULL(b.[may 2014],0)+ISNULL(b.[jun 2014],0)+ISNULL(b.[jul 2014],0)+ISNULL(b.[aug 2014],0)+ISNULL(b.[sep 2014],0)+ISNULL(b.[oct 2014],0)+ISNULL(b.[nov 2014],0)+ISNULL(b.[dec 2014],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[jan 2014]+b.[feb 2014]+b.[mar 2014]+b.[apr 2014]+b.[may 2014]+b.[jun 2014]+b.[jul 2014]+b.[aug 2014]+b.[sep 2014]+b.[oct 2014]+b.[nov 2014]+b.[dec 2014]) end) as [total_2014],
ISNULL((case b.version when 'Empire' then ISNULL(b.[CY 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[CY 2015] end),0) as [total_2015], 
ISNULL((case b.version when 'Empire' then ISNULL(b.[CY 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[CY 2016] end),0) as [total_2016], 
ISNULL((case b.version when 'Empire' then ISNULL(b.[CY 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[CY 2017] end),0) as [total_2017],
ISNULL((case b.version when 'Empire' then ISNULL(b.[CY 2018],0) else a.qty_per*a.take_rate*a.family_allocation*b.[CY 2018] end),0) as [total_2018], 
ISNULL((case b.version when 'Empire' then ISNULL(b.[CY 2019],0) else a.qty_per*a.take_rate*a.family_allocation*b.[CY 2019] end),0) as [total_2019]
from 
(select * from eeiuser.acctg_csm_base_part_mnemonic) a 
left outer join 
-- 7/16/2012 DW CHANGE BEGIN
-- REPLACED
--(select * from eeiuser.acctg_csm_NAIHSwhere release_id = @release_id union select * from eeiuser.acctg_csm_NAIHSwhere version = 'Empire') b
-- WITH
(select * from eeiuser.acctg_csm_NAIHS where release_id = @release_id) b
-- 7/16/2012 DW CHANGE END
on b.[Mnemonic-Vehicle/Plant] = a.mnemonic
where a.base_part = @base_part 
and b.[Mnemonic-Vehicle/Plant] is not null
and (case when b.version='Empire' then (ISNULL(b.[jan 2012],0)+ISNULL(b.[feb 2012],0)+ISNULL(b.[mar 2012],0)+ISNULL(b.[apr 2012],0)+ISNULL(b.[may 2012],0)+ISNULL(b.[jun 2012],0)+ISNULL(b.[jul 2012],0)+ISNULL(b.[aug 2012],0)+ISNULL(b.[sep 2012],0)+ISNULL(b.[oct 2012],0)+ISNULL(b.[nov 2012],0)+ISNULL(b.[dec 2012],0)+ISNULL(b.[jan 2013],0)+ISNULL(b.[feb 2013],0)+ISNULL(b.[mar 2013],0)+ISNULL(b.[apr 2013],0)+ISNULL(b.[may 2013],0)+ISNULL(b.[jun 2013],0)+ISNULL(b.[jul 2013],0)+ISNULL(b.[aug 2013],0)+ISNULL(b.[sep 2013],0)+ISNULL(b.[oct 2013],0)+ISNULL(b.[nov 2013],0)+ISNULL(b.[dec 2013],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[jan 2012]+b.[feb 2012]+b.[mar 2012]+b.[apr 2012]+b.[may 2012]+b.[jun 2012]+b.[jul 2012]+b.[aug 2012]+b.[sep 2012]+b.[oct 2012]+b.[nov 2012]+b.[dec 2012]+b.[jan 2013]+b.[feb 2013]+b.[mar 2013]+b.[apr 2013]+b.[may 2013]+b.[jun 2013]+b.[jul 2013]+b.[aug 2013]+b.[sep 2013]+b.[oct 2013]+b.[nov 2013]+b.[dec 2013]) end) <> (case @checkbox1 when 0 then 0 else -.0003 end) 
order by b.vehicle desc


GO
