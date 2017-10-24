SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [EEIUser].[OBS_acctg_csm_vw_select_total_demand_grouped_by_BP_EmpireAdjust]
as
select
f.base_part as base_part,
max(Empire_EOP) EmpireEOP,
isNull(sum(f.jan_08),0) as jan_08,
isNull(sum(f.feb_08),0) as feb_08,
isNull(sum(f.mar_08),0) as mar_08,
isNull(sum(f.apr_08),0) as apr_08,
isNull(sum(f.may_08),0) as may_08,
isNull(sum(f.jun_08),0) as jun_08,
isNull(sum(f.jul_08),0) as jul_08,
isNull(sum(f.aug_08),0) as aug_08,
isNull(sum(f.sep_08),0) as sep_08,
isNull(sum(f.oct_08),0) as oct_08,
isNull(sum(f.nov_08),0) as nov_08,
isNull(sum(f.dec_08),0) as dec_08,
isNull(sum(f.total_2008),0) as total_2008,
isNull(sum(f.jan_09),0) as jan_09,
isNull(sum(f.feb_09),0) as feb_09,
isNull(sum(f.mar_09),0) as mar_09,
isNull(sum(f.apr_09),0)as apr_09,
isNull(sum(f.may_09),0) as may_09,
isNull(sum(f.jun_09),0) as jun_09,
isNull(sum(f.jul_09),0) as jul_09,
isNull(sum(f.aug_09),0) as aug_09,
isNull(sum(f.sep_09),0) as sep_09,
isNull(sum(f.oct_09),0) as oct_09,
isNull(sum(f.nov_09),0) as nov_09,
isNull(sum(f.dec_09),0) as dec_09,
isNull(sum(f.total_2009),0) as total_2009,
isNull(sum(f.jan_10),0) as jan_10,
isNull(sum(f.feb_10),0) as feb_10,
isNull(sum(f.mar_10),0) as mar_10,
isNull(sum(f.apr_10),0) as apr_10,
isNull(sum(f.may_10),0) as may_10,
isNull(sum(f.jun_10),0) as jun_10,
isNull(sum(f.jul_10),0) as jul_10,
isNull(sum(f.aug_10),0) as aug_10,
isNULL(sum(f.sep_10),0) as sep_10,
isNull(sum(f.oct_10),0) as oct_10,
isNULL(sum(f.nov_10),0) as nov_10,
isNULL(sum(f.dec_10),0) as dec_10,
isNULL(sum(f.total_2010),0) as total_2010
from 
(select 
a.base_part, a.empire_market_segment, program, a.Empire_EOP,
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
-- (select * from eeiuser.acctg_csm_NACSM where release_id = '2008-07' union select * from eeiuser.acctg_csm_NACSM where version = 'Empire') b 
-- WITH
(select * from eeiuser.acctg_csm_NACSM where  release_id = (Select	[dbo].[fn_ReturnLatestCSMRelease] ('Empire') ) and version = 'Empire') b
-- 7/16/2008 DW CHANGE COMPLETE
on b.mnemonic = a.mnemonic 
where b.mnemonic is not null 
and (case when b.version='Empire' then (ISNULL(b.jan_08,0)+ISNULL(b.feb_08,0)+ISNULL(b.mar_08,0)+ISNULL(b.apr_08,0)+ISNULL(b.may_08,0)+ISNULL(b.jun_08,0)+ISNULL(b.jul_08,0)+ISNULL(b.aug_08,0)+ISNULL(b.sep_08,0)+ISNULL(b.oct_08,0)+ISNULL(b.nov_08,0)+ISNULL(b.dec_08,0)+ISNULL(b.jan_09,0)+ISNULL(b.feb_09,0)+ISNULL(b.mar_09,0)+ISNULL(b.apr_09,0)+ISNULL(b.may_09,0)+ISNULL(b.jun_09,0)+ISNULL(b.jul_09,0)+ISNULL(b.aug_09,0)+ISNULL(b.sep_09,0)+ISNULL(b.oct_09,0)+ISNULL(b.nov_09,0)+ISNULL(b.dec_09,0)+ISNULL(b.jan_10,0)+ISNULL(b.feb_10,0)+ISNULL(b.mar_10,0)+ISNULL(b.apr_10,0)+ISNULL(b.may_10,0)+ISNULL(b.jun_10,0)+ISNULL(b.jul_10,0)+ISNULL(b.aug_10,0)+ISNULL(b.sep_10,0)+ISNULL(b.oct_10,0)+ISNULL(b.nov_10,0)+ISNULL(b.dec_10,0)) else a.qty_per*a.take_rate*a.family_allocation*(b.jan_08+b.feb_08+b.mar_08+b.apr_08+b.may_08+b.jun_08+b.jul_08+b.aug_08+b.sep_08+b.oct_08+b.nov_08+b.dec_08+b.jan_09+b.feb_09+b.mar_09+b.apr_09+b.may_09+b.jun_09+b.jul_09+b.aug_09+b.sep_09+b.oct_09+b.nov_09+b.dec_09+b.jan_10+b.feb_10+b.mar_10+b.apr_10+b.may_10+b.jun_10+b.jul_10+b.aug_10+b.sep_10+b.oct_10+b.nov_10+b.dec_10) end) <> ( -.0003)) f
group by base_part
having (isnull(abs(sum(f.total_2009)),0) +isNull(abs(sum(f.total_2010)),0))>0

GO
