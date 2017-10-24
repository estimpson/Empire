SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EEIUser].[acctg_csm_sp_select_material_dw]
  @checkbox1 bit,
  @base_part varchar(30),
  @release_id varchar(30)
as

--exec [EEIUser].[acctg_csm_sp_select_material_dw] 1, 'NAL0264', '2012-03'
select
'Total Material' as description,
e.version,
e.inclusion,
e.row_id,

[djan 2015]*[jan 2015] as [jan 2015],
[dfeb 2015]*[feb 2015] as [feb 2015],
[dmar 2015]*[mar 2015] as [mar 2015],
[dapr 2015]*[apr 2015] as [apr 2015],
[dmay 2015]*[may 2015] as [may 2015],
[djun 2015]*[jun 2015] as [jun 2015],
[djul 2015]*[jul 2015] as [jul 2015],
[daug 2015]*[aug 2015] as [aug 2015],
[dsep 2015]*[sep 2015] as [sep 2015],
[doct 2015]*[oct 2015] as [oct 2015],
[dnov 2015]*[nov 2015] as [nov 2015],
[ddec 2015]*[dec 2015] as [dec 2015],
([djan 2015]*[jan 2015])+([dfeb 2015]*[feb 2015])+([dmar 2015]*[mar 2015])+([dapr 2015]*[apr 2015])+([dmay 2015]*[may 2015])+([djun 2015]*[jun 2015])+([djul 2015]*[jul 2015])+([daug 2015]*[aug 2015])+([dsep 2015]*[sep 2015])+([doct 2015]*[oct 2015])+([dnov 2015]*[nov 2015])+([ddec 2015]*[dec 2015]) as total_2015,

[djan 2016]*[jan 2016] as [jan 2016],
[dfeb 2016]*[feb 2016] as [feb 2016],
[dmar 2016]*[mar 2016] as [mar 2016],
[dapr 2016]*[apr 2016] as [apr 2016],
[dmay 2016]*[may 2016] as [may 2016],
[djun 2016]*[jun 2016] as [jun 2016],
[djul 2016]*[jul 2016] as [jul 2016],
[daug 2016]*[aug 2016] as [aug 2016],
[dsep 2016]*[sep 2016] as [sep 2016],
[doct 2016]*[oct 2016] as [oct 2016],
[dnov 2016]*[nov 2016] as [nov 2016],
[ddec 2016]*[dec 2016] as [dec 2016],
([djan 2016]*[jan 2016])+([dfeb 2016]*[feb 2016])+([dmar 2016]*[mar 2016])+([dapr 2016]*[apr 2016])+([dmay 2016]*[may 2016])+([djun 2016]*[jun 2016])+([djul 2016]*[jul 2016])+([daug 2016]*[aug 2016])+([dsep 2016]*[sep 2016])+([doct 2016]*[oct 2016])+([dnov 2016]*[nov 2016])+([ddec 2016]*[dec 2016]) as total_2016,

[djan 2017]*[jan 2017] as [jan 2017],
[dfeb 2017]*[feb 2017] as [feb 2017],
[dmar 2017]*[mar 2017] as [mar 2017],
[dapr 2017]*[apr 2017] as [apr 2017],
[dmay 2017]*[may 2017] as [may 2017],
[djun 2017]*[jun 2017] as [jun 2017],
[djul 2017]*[jul 2017] as [jul 2017],
[daug 2017]*[aug 2017] as [aug 2017],
[dsep 2017]*[sep 2017] as [sep 2017],
[doct 2017]*[oct 2017] as [oct 2017],
[dnov 2017]*[nov 2017] as [nov 2017],
[ddec 2017]*[dec 2017] as [dec 2017],
([djan 2017]*[jan 2017])+([dfeb 2017]*[feb 2017])+([dmar 2017]*[mar 2017])+([dapr 2017]*[apr 2017])+([dmay 2017]*[may 2017])+([djun 2017]*[jun 2017])+([djul 2017]*[jul 2017])+([daug 2017]*[aug 2017])+([dsep 2017]*[sep 2017])+([doct 2017]*[oct 2017])+([dnov 2017]*[nov 2017])+([ddec 2017]*[dec 2017]) as total_2017


from
(select @base_part as base_part,

sum(c.[jan 2015]) as [djan 2015],
sum(c.[feb 2015]) as [dfeb 2015],
sum(c.[mar 2015]) as [dmar 2015],
sum(c.[apr 2015]) as [dapr 2015],
sum(c.[may 2015]) as [dmay 2015],
sum(c.[jun 2015]) as [djun 2015],
sum(c.[jul 2015]) as [djul 2015],
sum(c.[aug 2015]) as [daug 2015],
sum(c.[sep 2015]) as [dsep 2015],
sum(c.[oct 2015]) as [doct 2015],
sum(c.[nov 2015]) as [dnov 2015],
sum(c.[dec 2015]) as [ddec 2015],
sum(c.[jan 2016]) as [djan 2016],
sum(c.[feb 2016]) as [dfeb 2016],
sum(c.[mar 2016]) as [dmar 2016],
sum(c.[apr 2016]) as [dapr 2016],
sum(c.[may 2016]) as [dmay 2016],
sum(c.[jun 2016]) as [djun 2016],
sum(c.[jul 2016]) as [djul 2016],
sum(c.[aug 2016]) as [daug 2016],
sum(c.[sep 2016]) as [dsep 2016],
sum(c.[oct 2016]) as [doct 2016],
sum(c.[nov 2016]) as [dnov 2016],
sum(c.[dec 2016]) as [ddec 2016],
sum(c.[jan 2017]) as [djan 2017],
sum(c.[feb 2017]) as [dfeb 2017],
sum(c.[mar 2017]) as [dmar 2017],
sum(c.[apr 2017]) as [dapr 2017],
sum(c.[may 2017]) as [dmay 2017],
sum(c.[jun 2017]) as [djun 2017],
sum(c.[jul 2017]) as [djul 2017],
sum(c.[aug 2017]) as [daug 2017],
sum(c.[sep 2017]) as [dsep 2017],
sum(c.[oct 2017]) as [doct 2017],
sum(c.[nov 2017]) as [dnov 2017],
sum(c.[dec 2017]) as [ddec 2017]
from 
(
select a.base_part,
b.version, 
b.[Mnemonic-Vehicle/Plant], 
b.platform, 
b.program, 
b.brand+' '+b.nameplate as vehicle, 
b.plant, 
b.sop, 
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
(case when b.version='Empire' then (ISNULL(b.[jan 2012],0)+ISNULL(b.[feb 2012],0)+ISNULL(b.[mar 2012],0)+ISNULL(b.[apr 2012],0)+ISNULL(b.[may 2012],0)+ISNULL(b.[jun 2012],0)+ISNULL(b.[jul 2012],0)+ISNULL(b.[aug 2012],0)+ISNULL(b.[sep 2012],0)+ISNULL(b.[oct 2012],0)+ISNULL(b.[nov 2012],0)+ISNULL(b.[dec 2012],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[jan 2012]+b.[feb 2012]+b.[mar 2012]+b.[apr 2012]+b.[may 2012]+b.[jun 2012]+b.[jul 2012]+b.[aug 2012]+b.[sep 2012]+b.[oct 2012]+b.[nov 2012]+b.[dec 2012]) end) as total_2012,

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
(case when b.version='Empire' then (ISNULL(b.[jan 2013],0)+ISNULL(b.[feb 2013],0)+ISNULL(b.[mar 2013],0)+ISNULL(b.[apr 2013],0)+ISNULL(b.[may 2013],0)+ISNULL(b.[jun 2013],0)+ISNULL(b.[jul 2013],0)+ISNULL(b.[aug 2013],0)+ISNULL(b.[sep 2013],0)+ISNULL(b.[oct 2013],0)+ISNULL(b.[nov 2013],0)+ISNULL(b.[dec 2013],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[jan 2013]+b.[feb 2013]+b.[mar 2013]+b.[apr 2013]+b.[may 2013]+b.[jun 2013]+b.[jul 2013]+b.[aug 2013]+b.[sep 2013]+b.[oct 2013]+b.[nov 2013]+b.[dec 2013]) end) as total_2013,

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
(case when b.version='Empire' then (ISNULL(b.[jan 2014],0)+ISNULL(b.[feb 2014],0)+ISNULL(b.[mar 2014],0)+ISNULL(b.[apr 2014],0)+ISNULL(b.[may 2014],0)+ISNULL(b.[jun 2014],0)+ISNULL(b.[jul 2014],0)+ISNULL(b.[aug 2014],0)+ISNULL(b.[sep 2014],0)+ISNULL(b.[oct 2014],0)+ISNULL(b.[nov 2014],0)+ISNULL(b.[dec 2014],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[jan 2014]+b.[feb 2014]+b.[mar 2014]+b.[apr 2014]+b.[may 2014]+b.[jun 2014]+b.[jul 2014]+b.[aug 2014]+b.[sep 2014]+b.[oct 2014]+b.[nov 2014]+b.[dec 2014]) end) as total_2014,

(case b.version when 'Empire' then ISNULL(b.[jan 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[jan 2015] end) as [jan 2015], 
(case b.version when 'Empire' then ISNULL(b.[feb 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[feb 2015] end) as [feb 2015], 
(case b.version when 'Empire' then ISNULL(b.[mar 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[mar 2015] end) as [mar 2015], 
(case b.version when 'Empire' then ISNULL(b.[apr 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[apr 2015] end) as [apr 2015], 
(case b.version when 'Empire' then ISNULL(b.[may 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[may 2015] end) as [may 2015], 
(case b.version when 'Empire' then ISNULL(b.[jun 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[jun 2015] end) as [jun 2015], 
(case b.version when 'Empire' then ISNULL(b.[jul 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[jul 2015] end) as [jul 2015], 
(case b.version when 'Empire' then ISNULL(b.[aug 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[aug 2015] end) as [aug 2015], 
(case b.version when 'Empire' then ISNULL(b.[sep 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[sep 2015] end) as [sep 2015], 
(case b.version when 'Empire' then ISNULL(b.[oct 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[oct 2015] end) as [oct 2015], 
(case b.version when 'Empire' then ISNULL(b.[nov 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[nov 2015] end) as [nov 2015], 
(case b.version when 'Empire' then ISNULL(b.[dec 2015],0) else a.qty_per*a.take_rate*a.family_allocation*b.[dec 2015] end) as [dec 2015], 
(case when b.version='Empire' then (ISNULL(b.[jan 2015],0)+ISNULL(b.[feb 2015],0)+ISNULL(b.[mar 2015],0)+ISNULL(b.[apr 2015],0)+ISNULL(b.[may 2015],0)+ISNULL(b.[jun 2015],0)+ISNULL(b.[jul 2015],0)+ISNULL(b.[aug 2015],0)+ISNULL(b.[sep 2015],0)+ISNULL(b.[oct 2015],0)+ISNULL(b.[nov 2015],0)+ISNULL(b.[dec 2015],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[jan 2015]+b.[feb 2015]+b.[mar 2015]+b.[apr 2015]+b.[may 2015]+b.[jun 2015]+b.[jul 2015]+b.[aug 2015]+b.[sep 2015]+b.[oct 2015]+b.[nov 2015]+b.[dec 2015]) end) as total_2015,

(case b.version when 'Empire' then ISNULL(b.[jan 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[jan 2016] end) as [jan 2016], 
(case b.version when 'Empire' then ISNULL(b.[feb 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[feb 2016] end) as [feb 2016], 
(case b.version when 'Empire' then ISNULL(b.[mar 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[mar 2016] end) as [mar 2016], 
(case b.version when 'Empire' then ISNULL(b.[apr 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[apr 2016] end) as [apr 2016], 
(case b.version when 'Empire' then ISNULL(b.[may 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[may 2016] end) as [may 2016], 
(case b.version when 'Empire' then ISNULL(b.[jun 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[jun 2016] end) as [jun 2016], 
(case b.version when 'Empire' then ISNULL(b.[jul 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[jul 2016] end) as [jul 2016], 
(case b.version when 'Empire' then ISNULL(b.[aug 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[aug 2016] end) as [aug 2016], 
(case b.version when 'Empire' then ISNULL(b.[sep 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[sep 2016] end) as [sep 2016], 
(case b.version when 'Empire' then ISNULL(b.[oct 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[oct 2016] end) as [oct 2016], 
(case b.version when 'Empire' then ISNULL(b.[nov 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[nov 2016] end) as [nov 2016], 
(case b.version when 'Empire' then ISNULL(b.[dec 2016],0) else a.qty_per*a.take_rate*a.family_allocation*b.[dec 2016] end) as [dec 2016], 
(case when b.version='Empire' then (ISNULL(b.[jan 2016],0)+ISNULL(b.[feb 2016],0)+ISNULL(b.[mar 2016],0)+ISNULL(b.[apr 2016],0)+ISNULL(b.[may 2016],0)+ISNULL(b.[jun 2016],0)+ISNULL(b.[jul 2016],0)+ISNULL(b.[aug 2016],0)+ISNULL(b.[sep 2016],0)+ISNULL(b.[oct 2016],0)+ISNULL(b.[nov 2016],0)+ISNULL(b.[dec 2016],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[jan 2016]+b.[feb 2016]+b.[mar 2016]+b.[apr 2016]+b.[may 2016]+b.[jun 2016]+b.[jul 2016]+b.[aug 2016]+b.[sep 2016]+b.[oct 2016]+b.[nov 2016]+b.[dec 2016]) end) as total_2016,

(case b.version when 'Empire' then ISNULL(b.[jan 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[jan 2017] end) as [jan 2017], 
(case b.version when 'Empire' then ISNULL(b.[feb 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[feb 2017] end) as [feb 2017], 
(case b.version when 'Empire' then ISNULL(b.[mar 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[mar 2017] end) as [mar 2017], 
(case b.version when 'Empire' then ISNULL(b.[apr 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[apr 2017] end) as [apr 2017], 
(case b.version when 'Empire' then ISNULL(b.[may 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[may 2017] end) as [may 2017], 
(case b.version when 'Empire' then ISNULL(b.[jun 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[jun 2017] end) as [jun 2017], 
(case b.version when 'Empire' then ISNULL(b.[jul 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[jul 2017] end) as [jul 2017], 
(case b.version when 'Empire' then ISNULL(b.[aug 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[aug 2017] end) as [aug 2017], 
(case b.version when 'Empire' then ISNULL(b.[sep 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[sep 2017] end) as [sep 2017], 
(case b.version when 'Empire' then ISNULL(b.[oct 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[oct 2017] end) as [oct 2017], 
(case b.version when 'Empire' then ISNULL(b.[nov 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[nov 2017] end) as [nov 2017], 
(case b.version when 'Empire' then ISNULL(b.[dec 2017],0) else a.qty_per*a.take_rate*a.family_allocation*b.[dec 2017] end) as [dec 2017], 
(case when b.version='Empire' then (ISNULL(b.[jan 2017],0)+ISNULL(b.[feb 2017],0)+ISNULL(b.[mar 2017],0)+ISNULL(b.[apr 2017],0)+ISNULL(b.[may 2017],0)+ISNULL(b.[jun 2017],0)+ISNULL(b.[jul 2017],0)+ISNULL(b.[aug 2017],0)+ISNULL(b.[sep 2017],0)+ISNULL(b.[oct 2017],0)+ISNULL(b.[nov 2017],0)+ISNULL(b.[dec 2017],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[jan 2017]+b.[feb 2017]+b.[mar 2017]+b.[apr 2017]+b.[may 2017]+b.[jun 2017]+b.[jul 2017]+b.[aug 2017]+b.[sep 2017]+b.[oct 2017]+b.[nov 2017]+b.[dec 2017]) end) as total_2017

from 
(select * from eeiuser.acctg_csm_base_part_mnemonic) a 
left outer join 
-- 7/16/2008 DW CHANGE BEGIN
-- REPLACED
--(select * from eeiuser.acctg_csm_NACSM where release_id = @release_id union select * from eeiuser.acctg_csm_NACSM where version = 'Empire') b 
--WITH
(select * from eeiuser.acctg_csm_NAIHS where release_id = @release_id) b
-- 7/16/2008 DW CHANGE END
on b.[Mnemonic-Vehicle/Plant] = a.mnemonic 
where a.base_part = @base_part 
and b.[Mnemonic-Vehicle/Plant] is not null
and (case when b.version='Empire' then (ISNULL(b.[jan 2016],0)+ISNULL(b.[feb 2016],0)+ISNULL(b.[mar 2016],0)+ISNULL(b.[apr 2016],0)+ISNULL(b.[may 2016],0)+ISNULL(b.[jun 2016],0)+ISNULL(b.[jul 2016],0)+ISNULL(b.[aug 2016],0)+ISNULL(b.[sep 2016],0)+ISNULL(b.[oct 2016],0)+ISNULL(b.[nov 2016],0)+ISNULL(b.[dec 2016],0)+ISNULL(b.[jan 2017],0)+ISNULL(b.[feb 2017],0)+ISNULL(b.[mar 2017],0)+ISNULL(b.[apr 2017],0)+ISNULL(b.[may 2017],0)+ISNULL(b.[jun 2017],0)+ISNULL(b.[jul 2017],0)+ISNULL(b.[aug 2017],0)+ISNULL(b.[sep 2017],0)+ISNULL(b.[oct 2017],0)+ISNULL(b.[nov 2017],0)+ISNULL(b.[dec 2017],0)) else a.qty_per*a.take_rate*a.family_allocation*(b.[jan 2016]+b.[feb 2016]+b.[mar 2016]+b.[apr 2016]+b.[may 2016]+b.[jun 2016]+b.[jul 2016]+b.[aug 2016]+b.[sep 2016]+b.[oct 2016]+b.[nov 2016]+b.[dec 2016]+b.[jan 2017]+b.[feb 2017]+b.[mar 2017]+b.[apr 2017]+b.[may 2017]+b.[jun 2017]+b.[jul 2017]+b.[aug 2017]+b.[sep 2017]+b.[oct 2017]+b.[nov 2017]+b.[dec 2017]) end) <> (case @checkbox1 when 0 then 0 else -.0003 end) 
) c ) d
left outer join
(select base_part, row_id, version, inclusion, partusedforcost, effective_date, isnull([jan_16],0) as [jan 2016], isnull([feb_16],0) as [feb 2016], isnull([mar_16],0) as [mar 2016], isnull([apr_16],0) as [apr 2016], isnull([may_16],0) as [may 2016], isnull([jun_16],0) as [jun 2016], isnull([jul_16],0) as [jul 2016], isnull([aug_16],0) as [aug 2016], isnull([sep_16],0) as [sep 2016], isnull([oct_16],0) as [oct 2016], isnull([nov_16],0) as [nov 2016], isnull([dec_16],0) as [dec 2016], isnull([jan_15],0) as [jan 2015], isnull([feb_15],0) as [feb 2015], isnull([mar_15],0) as [mar 2015], isnull([apr_15],0) as [apr 2015], isnull([may_15],0) as [may 2015], isnull([jun_15],0) as [jun 2015], isnull([jul_15],0) as [jul 2015], isnull([aug_15],0) as [aug 2015], isnull([sep_15],0) as [sep 2015], isnull([oct_15],0) as [oct 2015], isnull([nov_15],0) as [nov 2015], isnull([dec_15],0) as [dec 2015],  isnull([jan_17],0) as [jan 2017], isnull([feb_17],0) as [feb 2017], isnull([mar_17],0) as [mar 2017], isnull([apr_17],0) as [apr 2017], isnull([may_17],0) as [may 2017], isnull([jun_17],0) as [jun 2017], isnull([jul_17],0) as [jul 2017], isnull([aug_17],0) as [aug 2017], isnull([sep_17],0) as [sep 2017], isnull([oct_17],0) as [oct 2017], isnull([nov_17],0) as [nov 2017], isnull([dec_17],0) as [dec 2017] from eeiuser.acctg_csm_material_cost_tabular where release_id = @release_id) e
on d.base_part = e.base_part
order by e.effective_date, e.row_id


GO
