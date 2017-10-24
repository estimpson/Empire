SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[eeisp_rpt_csm_basepart_demand]
  @checkbox1 bit,
  @release_id varchar(30)

--[EEIUser].[acctg_csm_sp_select_total_demand] 0,  '2009-02'

as
select BasePart, 
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
sum(total_2008) as total_2008,
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
sum(total_2009) as total_2009,
sum(jan_10) as jan_10,
sum(feb_10) as feb_10,
sum(mar_10) as mar_10,
sum(apr_10) as apr_10,
sum(may_10) as may_10,
sum(jun_10) as jun_10,
sum(jul_10) as jul_10,
sum(aug_10) as aug_10,
sum(sep_10) as sep_10,
sum(oct_10) as oct_10,
sum(nov_10) as nov_10,
sum(dec_10) as dec_10,
sum(total_2010) as total_2010
from 
(
select
a.base_part Basepart,
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
(case when b.version='Empire' then (ISNULL(b.jan_08,0)+ISNULL(b.feb_08,0)+ISNULL(b.mar_08,0)+ISNULL(b.apr_08,0)+ISNULL(b.may_08,0)+ISNULL(b.jun_08,0)+ISNULL(b.jul_08,0)+ISNULL(b.aug_08,0)+ISNULL(b.sep_08,0)+ISNULL(b.oct_08,0)+ISNULL(b.nov_08,0)+ISNULL(b.dec_08,0)) else a.qty_per*a.take_rate*a.family_allocation*(b.jan_08+b.feb_08+b.mar_08+b.apr_08+b.may_08+b.jun_08+b.jul_08+b.aug_08+b.sep_08+b.oct_08+b.nov_08+b.dec_08) end) as total_2008,
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
(case when b.version='Empire' then (ISNULL(b.jan_09,0)+ISNULL(b.feb_09,0)+ISNULL(b.mar_09,0)+ISNULL(b.apr_09,0)+ISNULL(b.may_09,0)+ISNULL(b.jun_09,0)+ISNULL(b.jul_09,0)+ISNULL(b.aug_09,0)+ISNULL(b.sep_09,0)+ISNULL(b.oct_09,0)+ISNULL(b.nov_09,0)+ISNULL(b.dec_09,0)) else a.qty_per*a.take_rate*a.family_allocation*(b.jan_09+b.feb_09+b.mar_09+b.apr_09+b.may_09+b.jun_09+b.jul_09+b.aug_09+b.sep_09+b.oct_09+b.nov_09+b.dec_09) end) as total_2009,
(case b.version when 'Empire' then ISNULL(b.jan_10,0) else a.qty_per*a.take_rate*a.family_allocation*b.jan_10 end) as jan_10, 
(case b.version when 'Empire' then ISNULL(b.feb_10,0) else a.qty_per*a.take_rate*a.family_allocation*b.feb_10 end) as feb_10, 
(case b.version when 'Empire' then ISNULL(b.mar_10,0) else a.qty_per*a.take_rate*a.family_allocation*b.mar_10 end) as mar_10, 
(case b.version when 'Empire' then ISNULL(b.apr_10,0) else a.qty_per*a.take_rate*a.family_allocation*b.apr_10 end) as apr_10, 
(case b.version when 'Empire' then ISNULL(b.may_10,0) else a.qty_per*a.take_rate*a.family_allocation*b.may_10 end) as may_10, 
(case b.version when 'Empire' then ISNULL(b.jun_10,0) else a.qty_per*a.take_rate*a.family_allocation*b.jun_10 end) as jun_10, 
(case b.version when 'Empire' then ISNULL(b.jul_10,0) else a.qty_per*a.take_rate*a.family_allocation*b.jul_10 end) as jul_10, 
(case b.version when 'Empire' then ISNULL(b.aug_10,0) else a.qty_per*a.take_rate*a.family_allocation*b.aug_10 end) as aug_10, 
(case b.version when 'Empire' then ISNULL(b.sep_10,0) else a.qty_per*a.take_rate*a.family_allocation*b.sep_10 end) as sep_10, 
(case b.version when 'Empire' then ISNULL(b.oct_10,0) else a.qty_per*a.take_rate*a.family_allocation*b.oct_10 end) as oct_10, 
(case b.version when 'Empire' then ISNULL(b.nov_10,0) else a.qty_per*a.take_rate*a.family_allocation*b.nov_10 end) as nov_10, 
(case b.version when 'Empire' then ISNULL(b.dec_10,0) else a.qty_per*a.take_rate*a.family_allocation*b.dec_10 end) as dec_10, 
(case when b.version='Empire' then (ISNULL(b.jan_10,0)+ISNULL(b.feb_10,0)+ISNULL(b.mar_10,0)+ISNULL(b.apr_10,0)+ISNULL(b.may_10,0)+ISNULL(b.jun_10,0)+ISNULL(b.jul_10,0)+ISNULL(b.aug_10,0)+ISNULL(b.sep_10,0)+ISNULL(b.oct_10,0)+ISNULL(b.nov_10,0)+ISNULL(b.dec_10,0)) else a.qty_per*a.take_rate*a.family_allocation*(b.jan_10+b.feb_10+b.mar_10+b.apr_10+b.may_10+b.jun_10+b.jul_10+b.aug_10+b.sep_10+b.oct_10+b.nov_10+b.dec_10) end) as total_2010
from 
(select * from eeiuser.acctg_csm_base_part_mnemonic) a 
left outer join 
-- 7/16/2008 DW CHANGE BEGIN
-- REPLACED
--(select * from eeiuser.acctg_csm_NACSM where release_id = @release_id union select * from eeiuser.acctg_csm_NACSM where version = 'Empire') b 
-- WITH
(select * from eeiuser.acctg_csm_NACSM where release_id = @release_id) b
-- 7/16/2008 DW CHANGE END
on b.mnemonic = a.mnemonic 
where b.mnemonic is not null
and (case when b.version='Empire' then (ISNULL(b.jan_08,0)+ISNULL(b.feb_08,0)+ISNULL(b.mar_08,0)+ISNULL(b.apr_08,0)+ISNULL(b.may_08,0)+ISNULL(b.jun_08,0)+ISNULL(b.jul_08,0)+ISNULL(b.aug_08,0)+ISNULL(b.sep_08,0)+ISNULL(b.oct_08,0)+ISNULL(b.nov_08,0)+ISNULL(b.dec_08,0)+ISNULL(b.jan_09,0)+ISNULL(b.feb_09,0)+ISNULL(b.mar_09,0)+ISNULL(b.apr_09,0)+ISNULL(b.may_09,0)+ISNULL(b.jun_09,0)+ISNULL(b.jul_09,0)+ISNULL(b.aug_09,0)+ISNULL(b.sep_09,0)+ISNULL(b.oct_09,0)+ISNULL(b.nov_09,0)+ISNULL(b.dec_09,0)) else a.qty_per*a.take_rate*a.family_allocation*(b.jan_08+b.feb_08+b.mar_08+b.apr_08+b.may_08+b.jun_08+b.jul_08+b.aug_08+b.sep_08+b.oct_08+b.nov_08+b.dec_08+b.jan_09+b.feb_09+b.mar_09+b.apr_09+b.may_09+b.jun_09+b.jul_09+b.aug_09+b.sep_09+b.oct_09+b.nov_09+b.dec_09) end) <> (case @checkbox1 when 0 then 0 else -.0003 end) 
) a
group by BasePart

GO
