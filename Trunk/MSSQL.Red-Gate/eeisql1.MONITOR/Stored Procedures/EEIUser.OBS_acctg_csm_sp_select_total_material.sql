SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[OBS_acctg_csm_sp_select_total_material]
  @checkbox1 bit,
  @base_part varchar(30),
  @release_id varchar(30)
as
select 
'Total Material Cost' as description,
sum(jan_08) as jan_08,
sum(feb_08) as feb_08,
sum(mar_08) as mar_08,
sum(apr_08) as apr_08,
sum(may_08) as may_08,
sum(jun_08) as jun_08,
sum(jul_08) as jul_08,
sum(aug_08) as aug_08,
sum(sep_08) as sep_08,
sum(oct_08) as oct_08,
sum(nov_08) as nov_08,
sum(dec_08) as dec_08,
sum(jan_08+feb_08+mar_08+apr_08+may_08+jun_08+jul_08+aug_08+sep_08+oct_08+nov_08+dec_08) as total_2008,
sum(jan_09) as jan_09,
sum(feb_09) as feb_09,
sum(mar_09) as mar_09,
sum(apr_09) as apr_09,
sum(may_09) as may_09,
sum(jun_09) as jun_09,
sum(jul_09) as jul_09,
sum(aug_09) as aug_09,
sum(sep_09) as sep_09,
sum(oct_09) as oct_09,
sum(nov_09) as nov_09,
sum(dec_09) as dec_09,
sum(jan_09+feb_09+mar_09+apr_09+may_09+jun_09+jul_09+aug_09+sep_09+oct_09+nov_09+dec_09) as total_2009
from(


select
djan_08*jan_08 as jan_08,
dfeb_08*feb_08 as feb_08,
dmar_08*mar_08 as mar_08,
dapr_08*apr_08 as apr_08,
dmay_08*may_08 as may_08,
djun_08*jun_08 as jun_08,
djul_08*jul_08 as jul_08,
daug_08*aug_08 as aug_08,
dsep_08*sep_08 as sep_08,
doct_08*oct_08 as oct_08,
dnov_08*nov_08 as nov_08,
ddec_08*dec_08 as dec_08,
(djan_08*jan_08)+(dfeb_08*feb_08)+(dmar_08*mar_08)+(dapr_08*apr_08)+(dmay_08*may_08)+(djun_08*jun_08)+(djul_08*jul_08)+(daug_08*aug_08)+(dsep_08*sep_08)+(doct_08*oct_08)+(dnov_08*nov_08)+(ddec_08*dec_08) as total_2008,
djan_09*jan_09 as jan_09,
dfeb_09*feb_09 as feb_09,
dmar_09*mar_09 as mar_09,
dapr_09*apr_09 as apr_09,
dmay_09*may_09 as may_09,
djun_09*jun_09 as jun_09,
djul_09*jul_09 as jul_09,
daug_09*aug_09 as aug_09,
dsep_09*sep_09 as sep_09,
doct_09*oct_09 as oct_09,
dnov_09*nov_09 as nov_09,
ddec_09*dec_09 as dec_09,
(djan_09*jan_09)+(dfeb_09*feb_09)+(dmar_09*mar_09)+(dapr_09*apr_09)+(dmay_09*may_09)+(djun_09*jun_09)+(djul_09*jul_09)+(daug_09*aug_09)+(dsep_09*sep_09)+(doct_09*oct_09)+(dnov_09*nov_09)+(ddec_09*dec_09) as total_2009
from
(select @base_part as base_part, 
sum(c.jan_08) as djan_08,
sum(c.feb_08) as dfeb_08,
sum(c.mar_08) as dmar_08,
sum(c.apr_08) as dapr_08,
sum(c.may_08) as dmay_08,
sum(c.jun_08) as djun_08,
sum(c.jul_08) as djul_08,
sum(c.aug_08) as daug_08,
sum(c.sep_08) as dsep_08,
sum(c.oct_08) as doct_08,
sum(c.nov_08) as dnov_08,
sum(c.dec_08) as ddec_08,
sum(c.jan_09) as djan_09,
sum(c.feb_09) as dfeb_09,
sum(c.mar_09) as dmar_09,
sum(c.apr_09) as dapr_09,
sum(c.may_09) as dmay_09,
sum(c.jun_09) as djun_09,
sum(c.jul_09) as djul_09,
sum(c.aug_09) as daug_09,
sum(c.sep_09) as dsep_09,
sum(c.oct_09) as doct_09,
sum(c.nov_09) as dnov_09,
sum(c.dec_09) as ddec_09
from 
(
select a.base_part,
b.version, 
b.mnemonic, 
b.platform, 
b.program, 
b.badge+' '+b.nameplate as vehicle, 
b.assembly_plant, 
b.sop, 
b.eop,  
a.qty_per, 
a.take_rate, 
a.family_allocation, 
(case b.version when 'Empire' then ISNULL(b.jan_08,0) else a.qty_per*a.take_rate*a.family_allocation*b.jan_08 end) as jan_08, 
(case b.version when 'Empire' then ISNULL(b.feb_08,0) else a.qty_per*a.take_rate*a.family_allocation*b.feb_08 end) as feb_08, 
(case b.version when 'Empire' then ISNULL(b.mar_08,0) else a.qty_per*a.take_rate*a.family_allocation*b.mar_08 end) as mar_08, 
(case b.version when 'Empire' then ISNULL(b.apr_08,0) else a.qty_per*a.take_rate*a.family_allocation*b.apr_08 end) as apr_08, 
(case b.version when 'Empire' then ISNULL(b.may_08,0) else a.qty_per*a.take_rate*a.family_allocation*b.may_08 end) as may_08, 
(case b.version when 'Empire' then ISNULL(b.jun_08,0) else a.qty_per*a.take_rate*a.family_allocation*b.jun_08 end) as jun_08, 
(case b.version when 'Empire' then ISNULL(b.jul_08,0) else a.qty_per*a.take_rate*a.family_allocation*b.jul_08 end) as jul_08, 
(case b.version when 'Empire' then ISNULL(b.aug_08,0) else a.qty_per*a.take_rate*a.family_allocation*b.aug_08 end) as aug_08, 
(case b.version when 'Empire' then ISNULL(b.sep_08,0) else a.qty_per*a.take_rate*a.family_allocation*b.sep_08 end) as sep_08, 
(case b.version when 'Empire' then ISNULL(b.oct_08,0) else a.qty_per*a.take_rate*a.family_allocation*b.oct_08 end) as oct_08, 
(case b.version when 'Empire' then ISNULL(b.nov_08,0) else a.qty_per*a.take_rate*a.family_allocation*b.nov_08 end) as nov_08, 
(case b.version when 'Empire' then ISNULL(b.dec_08,0) else a.qty_per*a.take_rate*a.family_allocation*b.dec_08 end) as dec_08, 
(case when b.version='Empire' then (ISNULL(b.jan_08,0)+ISNULL(b.feb_08,0)+ISNULL(b.mar_08,0)+ISNULL(b.apr_08,0)+ISNULL(b.may_08,0)+ISNULL(b.jun_08,0)+ISNULL(b.jul_08,0)+ISNULL(b.aug_08,0)+ISNULL(b.sep_08,0)+ISNULL(b.oct_08,0)+ISNULL(b.nov_08,0)+ISNULL(b.dec_08,0)) else a.qty_per*a.take_rate*a.family_allocation*(ISNULL(b.jan_08,0)+ISNULL(b.feb_08,0)+ISNULL(b.mar_08,0)+ISNULL(b.apr_08,0)+ISNULL(b.may_08,0)+ISNULL(b.jun_08,0)+ISNULL(b.jul_08,0)+ISNULL(b.aug_08,0)+ISNULL(b.sep_08,0)+ISNULL(b.oct_08,0)+ISNULL(b.nov_08,0)+ISNULL(b.dec_08,0)) end) as total_2008,
(case b.version when 'Empire' then ISNULL(b.jan_09,0) else a.qty_per*a.take_rate*a.family_allocation*b.jan_09 end) as jan_09, 
(case b.version when 'Empire' then ISNULL(b.feb_09,0) else a.qty_per*a.take_rate*a.family_allocation*b.feb_09 end) as feb_09, 
(case b.version when 'Empire' then ISNULL(b.mar_09,0) else a.qty_per*a.take_rate*a.family_allocation*b.mar_09 end) as mar_09, 
(case b.version when 'Empire' then ISNULL(b.apr_09,0) else a.qty_per*a.take_rate*a.family_allocation*b.apr_09 end) as apr_09, 
(case b.version when 'Empire' then ISNULL(b.may_09,0) else a.qty_per*a.take_rate*a.family_allocation*b.may_09 end) as may_09, 
(case b.version when 'Empire' then ISNULL(b.jun_09,0) else a.qty_per*a.take_rate*a.family_allocation*b.jun_09 end) as jun_09, 
(case b.version when 'Empire' then ISNULL(b.jul_09,0) else a.qty_per*a.take_rate*a.family_allocation*b.jul_09 end) as jul_09, 
(case b.version when 'Empire' then ISNULL(b.aug_09,0) else a.qty_per*a.take_rate*a.family_allocation*b.aug_09 end) as aug_09, 
(case b.version when 'Empire' then ISNULL(b.sep_09,0) else a.qty_per*a.take_rate*a.family_allocation*b.sep_09 end) as sep_09, 
(case b.version when 'Empire' then ISNULL(b.oct_09,0) else a.qty_per*a.take_rate*a.family_allocation*b.oct_09 end) as oct_09, 
(case b.version when 'Empire' then ISNULL(b.nov_09,0) else a.qty_per*a.take_rate*a.family_allocation*b.nov_09 end) as nov_09, 
(case b.version when 'Empire' then ISNULL(b.dec_09,0) else a.qty_per*a.take_rate*a.family_allocation*b.dec_09 end) as dec_09, 
(case when b.version='Empire' then (ISNULL(b.jan_09,0)+ISNULL(b.feb_09,0)+ISNULL(b.mar_09,0)+ISNULL(b.apr_09,0)+ISNULL(b.may_09,0)+ISNULL(b.jun_09,0)+ISNULL(b.jul_09,0)+ISNULL(b.aug_09,0)+ISNULL(b.sep_09,0)+ISNULL(b.oct_09,0)+ISNULL(b.nov_09,0)+ISNULL(b.dec_09,0)) else a.qty_per*a.take_rate*a.family_allocation*(ISNULL(b.jan_09,0)+ISNULL(b.feb_09,0)+ISNULL(b.mar_09,0)+ISNULL(b.apr_09,0)+ISNULL(b.may_09,0)+ISNULL(b.jun_09,0)+ISNULL(b.jul_09,0)+ISNULL(b.aug_09,0)+ISNULL(b.sep_09,0)+ISNULL(b.oct_09,0)+ISNULL(b.nov_09,0)+ISNULL(b.dec_09,0)) end) as total_2009
from 
(select * from eeiuser.acctg_csm_base_part_mnemonic) a 
left outer join 
(select * from eeiuser.acctg_csm_NACSM where release_id = @release_id union select * from eeiuser.acctg_csm_NACSM where version = 'Empire') b 
on b.mnemonic = a.mnemonic 
where a.base_part = @base_part 
and b.mnemonic is not null
and (case when b.version='Empire' then (ISNULL(b.jan_08,0)+ISNULL(b.feb_08,0)+ISNULL(b.mar_08,0)+ISNULL(b.apr_08,0)+ISNULL(b.may_08,0)+ISNULL(b.jun_08,0)+ISNULL(b.jul_08,0)+ISNULL(b.aug_08,0)+ISNULL(b.sep_08,0)+ISNULL(b.oct_08,0)+ISNULL(b.nov_08,0)+ISNULL(b.dec_08,0)+ISNULL(b.jan_09,0)+ISNULL(b.feb_09,0)+ISNULL(b.mar_09,0)+ISNULL(b.apr_09,0)+ISNULL(b.may_09,0)+ISNULL(b.jun_09,0)+ISNULL(b.jul_09,0)+ISNULL(b.aug_09,0)+ISNULL(b.sep_09,0)+ISNULL(b.oct_09,0)+ISNULL(b.nov_09,0)+ISNULL(b.dec_09,0)) else a.qty_per*a.take_rate*a.family_allocation*(ISNULL(b.jan_08,0)+ISNULL(b.feb_08,0)+ISNULL(b.mar_08,0)+ISNULL(b.apr_08,0)+ISNULL(b.may_08,0)+ISNULL(b.jun_08,0)+ISNULL(b.jul_08,0)+ISNULL(b.aug_08,0)+ISNULL(b.sep_08,0)+ISNULL(b.oct_08,0)+ISNULL(b.nov_08,0)+ISNULL(b.dec_08,0)+ISNULL(b.jan_09,0)+ISNULL(b.feb_09,0)+ISNULL(b.mar_09,0)+ISNULL(b.apr_09,0)+ISNULL(b.may_09,0)+ISNULL(b.jun_09,0)+ISNULL(b.jul_09,0)+ISNULL(b.aug_09,0)+ISNULL(b.sep_09,0)+ISNULL(b.oct_09,0)+ISNULL(b.nov_09,0)+ISNULL(b.dec_09,0)) end) <> (case @checkbox1 when 0 then 0 else -.0003 end) 
) c ) d
left outer join
(select base_part, ISNULL(jan_08,0) as jan_08, ISNULL(feb_08,0) as feb_08, ISNULL(mar_08,0) as mar_08, ISNULL(apr_08,0) as apr_08, ISNULL(may_08,0) as may_08, ISNULL(jun_08,0) as jun_08, ISNULL(jul_08,0) as jul_08, ISNULL(aug_08,0) as aug_08, ISNULL(sep_08,0) as sep_08, ISNULL(oct_08,0) as oct_08, ISNULL(nov_08,0) as nov_08, ISNULL(dec_08,0) as dec_08, ISNULL(jan_09,0) as jan_09, ISNULL(feb_09,0) as feb_09, ISNULL(mar_09,0) as mar_09, ISNULL(apr_09,0) as apr_09, ISNULL(may_09,0) as may_09, ISNULL(jun_09,0) as jun_09, ISNULL(jul_09,0) as jul_09, ISNULL(aug_09,0) as aug_09, ISNULL(sep_09,0) as sep_09, ISNULL(oct_09,0) as oct_09, ISNULL(nov_09,0) as nov_09, ISNULL(dec_09,0) as dec_09 from eeiuser.acctg_csm_material_cost_tabular) e
on d.base_part = e.base_part ) z
GO
