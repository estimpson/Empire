SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--Select* from [EEIUser].[acctg_csm_vw_select_total_demand_grouped_by_BP]
CREATE VIEW [EEIUser].[OBS_acctg_csm_vw_select_total_demand_grouped_by_BP]
as
select
f.base_part as base_part,
max(Empire_EOP) EmpireEOP,
sum(f.jan_08) as jan_08,
sum(f.feb_08) as feb_08,
sum(f.mar_08) as mar_08,
sum(f.apr_08) as apr_08,
sum(f.may_08) as may_08,
sum(f.jun_08) as jun_08,
sum(f.jul_08) as jul_08,
sum(f.aug_08) as aug_08,
sum(f.sep_08) as sep_08,
sum(f.oct_08) as oct_08,
sum(f.nov_08) as nov_08,
sum(f.dec_08) as dec_08,
sum(f.total_2008) as total_2008,
sum(f.jan_09) as jan_09,
sum(f.feb_09) as feb_09,
sum(f.mar_09) as mar_09,
sum(f.apr_09) as apr_09,
sum(f.may_09) as may_09,
sum(f.jun_09) as jun_09,
sum(f.jul_09) as jul_09,
sum(f.aug_09) as aug_09,
sum(f.sep_09) as sep_09,
sum(f.oct_09) as oct_09,
sum(f.nov_09) as nov_09,
sum(f.dec_09) as dec_09,
sum(f.total_2009) as total_2009,
sum(f.jan_10) as jan_10,
sum(f.feb_10) as feb_10,
sum(f.mar_10) as mar_10,
sum(f.apr_10) as apr_10,
sum(f.may_10) as may_10,
sum(f.jun_10) as jun_10,
sum(f.jul_10) as jul_10,
sum(f.aug_10) as aug_10,
sum(f.sep_10) as sep_10,
sum(f.oct_10) as oct_10,
sum(f.nov_10) as nov_10,
sum(f.dec_10) as dec_10,
sum(f.total_2010) as total_2010,
sum(f.jan_11) as jan_11,
sum(f.feb_11) as feb_11,
sum(f.mar_11) as mar_11,
sum(f.apr_11) as apr_11,
sum(f.may_11) as may_11,
sum(f.jun_11) as jun_11,
sum(f.jul_11) as jul_11,
sum(f.aug_11) as aug_11,
sum(f.sep_11) as sep_11,
sum(f.oct_11) as oct_11,
sum(f.nov_11) as nov_11,
sum(f.dec_11) as dec_11,
sum(f.total_2011) as total_2011
from 
(	select 
	a.base_part, a.empire_market_segment, NamePlate, badge, Assembly_Plant, a.Empire_EOP, b.sales_parent,
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
(case when b.version='Empire' then (ISNULL(b.jan_10,0)+ISNULL(b.feb_10,0)+ISNULL(b.mar_10,0)+ISNULL(b.apr_10,0)+ISNULL(b.may_10,0)+ISNULL(b.jun_10,0)+ISNULL(b.jul_10,0)+ISNULL(b.aug_10,0)+ISNULL(b.sep_10,0)+ISNULL(b.oct_10,0)+ISNULL(b.nov_10,0)+ISNULL(b.dec_10,0)) else a.qty_per*a.take_rate*a.family_allocation*(b.jan_10+b.feb_10+b.mar_10+b.apr_10+b.may_10+b.jun_10+b.jul_10+b.aug_10+b.sep_10+b.oct_10+b.nov_10+b.dec_10) end) as total_2010,
(case b.version when 'Empire' then ISNULL(b.jan_11,0) else a.qty_per*a.take_rate*a.family_allocation*b.jan_11 end) as jan_11, 
(case b.version when 'Empire' then ISNULL(b.feb_11,0) else a.qty_per*a.take_rate*a.family_allocation*b.feb_11 end) as feb_11, 
(case b.version when 'Empire' then ISNULL(b.mar_11,0) else a.qty_per*a.take_rate*a.family_allocation*b.mar_11 end) as mar_11, 
(case b.version when 'Empire' then ISNULL(b.apr_11,0) else a.qty_per*a.take_rate*a.family_allocation*b.apr_11 end) as apr_11, 
(case b.version when 'Empire' then ISNULL(b.may_11,0) else a.qty_per*a.take_rate*a.family_allocation*b.may_11 end) as may_11, 
(case b.version when 'Empire' then ISNULL(b.jun_11,0) else a.qty_per*a.take_rate*a.family_allocation*b.jun_11 end) as jun_11, 
(case b.version when 'Empire' then ISNULL(b.jul_11,0) else a.qty_per*a.take_rate*a.family_allocation*b.jul_11 end) as jul_11, 
(case b.version when 'Empire' then ISNULL(b.aug_11,0) else a.qty_per*a.take_rate*a.family_allocation*b.aug_11 end) as aug_11, 
(case b.version when 'Empire' then ISNULL(b.sep_11,0) else a.qty_per*a.take_rate*a.family_allocation*b.sep_11 end) as sep_11, 
(case b.version when 'Empire' then ISNULL(b.oct_11,0) else a.qty_per*a.take_rate*a.family_allocation*b.oct_11 end) as oct_11, 
(case b.version when 'Empire' then ISNULL(b.nov_11,0) else a.qty_per*a.take_rate*a.family_allocation*b.nov_11 end) as nov_11, 
(case b.version when 'Empire' then ISNULL(b.dec_11,0) else a.qty_per*a.take_rate*a.family_allocation*b.dec_11 end) as dec_11, 
(case when b.version='Empire' then (ISNULL(b.jan_11,0)+ISNULL(b.feb_11,0)+ISNULL(b.mar_11,0)+ISNULL(b.apr_11,0)+ISNULL(b.may_11,0)+ISNULL(b.jun_11,0)+ISNULL(b.jul_11,0)+ISNULL(b.aug_11,0)+ISNULL(b.sep_11,0)+ISNULL(b.oct_11,0)+ISNULL(b.nov_11,0)+ISNULL(b.dec_11,0)) else a.qty_per*a.take_rate*a.family_allocation*(b.jan_11+b.feb_11+b.mar_11+b.apr_11+b.may_11+b.jun_11+b.jul_11+b.aug_11+b.sep_11+b.oct_11+b.nov_11+b.dec_11) end) as total_2011
from 
(select * from eeiuser.acctg_csm_base_part_mnemonic) a 
left outer join 
-- 7/16/2008 DW CHANGE BEGIN
-- REPLACED
-- (select * from eeiuser.acctg_csm_NACSM where release_id = '2008-07' union select * from eeiuser.acctg_csm_NACSM where version = 'Empire') b 
-- WITH
(	select * 
	from eeiuser.acctg_csm_NACSM 
	where  release_id = (Select	[dbo].[fn_ReturnLatestCSMRelease] ('CSM') ) and version = 'CSM'  
	and (	ISNULL( jan_10,0)+
			ISNULL( feb_10,0)+
			ISNULL( mar_10,0)+
			ISNULL( apr_10,0)+
			ISNULL( may_10,0)+
			ISNULL( jun_10,0)+
			ISNULL( jul_10,0)+
			ISNULL( aug_10,0)+
			ISNULL( sep_10,0)+
			ISNULL( oct_10,0)+
			ISNULL( nov_10,0)+
			ISNULL( dec_10,0)+
			ISNULL( jan_11,0)+
			ISNULL( feb_11,0)+
			ISNULL( mar_11,0)+
			ISNULL( apr_11,0)+
			ISNULL( may_11,0)+
			ISNULL( jun_11,0)+
			ISNULL( jul_11,0)+
			ISNULL( aug_11,0)+
			ISNULL( sep_11,0)+
			ISNULL( oct_11,0)+
			ISNULL( nov_11,0)+
			ISNULL( dec_11,0))>0) b on b.mnemonic = a.mnemonic 
			where b.mnemonic is not NULL and base_part not in (	'ALC0162',
								'VPP0074',
								'VPP0259',
								'VPP0260',
								'VSL0123',
								'VSL0124',
								'VSL0134',
								'VSL0170',
								'VSL0172',
								'VSL0173',
								'TRW0317',
								'TRW0318',
								'TRW0319',
								'TRW0320',
								'TRW0321')
								and (	case when b.version='Empire' 
					then (	ISNULL(b.jan_09,0)+
							ISNULL(b.feb_09,0)+
							ISNULL(b.mar_09,0)+
							ISNULL(b.apr_09,0)+
							ISNULL(b.may_09,0)+
							ISNULL(b.jun_09,0)+
							ISNULL(b.jul_09,0)+
							ISNULL(b.aug_09,0)+
							ISNULL(b.sep_09,0)+
							ISNULL(b.oct_09,0)+
							ISNULL(b.nov_09,0)+
							ISNULL(b.dec_09,0)+
							ISNULL(b.jan_10,0)+
							ISNULL(b.feb_10,0)+
							ISNULL(b.mar_10,0)+
							ISNULL(b.apr_10,0)+
							ISNULL(b.may_10,0)+
							ISNULL(b.jun_10,0)+
							ISNULL(b.jul_10,0)+
							ISNULL(b.aug_10,0)+
							ISNULL(b.sep_10,0)+
							ISNULL(b.oct_10,0)+
							ISNULL(b.nov_10,0)+
							ISNULL(b.dec_10,0)+
							ISNULL(b.jan_11,0)+
							ISNULL(b.feb_11,0)+
							ISNULL(b.mar_11,0)+
							ISNULL(b.apr_11,0)+
							ISNULL(b.may_11,0)+
							ISNULL(b.jun_11,0)+
							ISNULL(b.jul_11,0)+
							ISNULL(b.aug_11,0)+
							ISNULL(b.sep_11,0)+
							ISNULL(b.oct_11,0)+
							ISNULL(b.nov_11,0)+
							ISNULL(b.dec_11,0)) 
							else	a.qty_per*
									a.take_rate*
									a.family_allocation*
									(	ISNULL(b.jan_09,0)+
										ISNULL(b.feb_09,0)+
										ISNULL(b.mar_09,0)+
										ISNULL(b.apr_09,0)+
										ISNULL(b.may_09,0)+
										ISNULL(b.jun_09,0)+
										ISNULL(b.jul_09,0)+
										ISNULL(b.aug_09,0)+
										ISNULL(b.sep_09,0)+
										ISNULL(b.oct_09,0)+
										ISNULL(b.nov_09,0)+
										ISNULL(b.dec_09,0)+
										ISNULL(b.jan_10,0)+
										ISNULL(b.feb_10,0)+
										ISNULL(b.mar_10,0)+
										ISNULL(b.apr_10,0)+
										ISNULL(b.may_10,0)+
										ISNULL(b.jun_10,0)+
										ISNULL(b.jul_10,0)+
										ISNULL(b.aug_10,0)+
										ISNULL(b.sep_10,0)+
										ISNULL(b.oct_10,0)+
										ISNULL(b.nov_10,0)+
										ISNULL(b.dec_10,0)+
										ISNULL(b.jan_11,0)+
										ISNULL(b.feb_11,0)+
										ISNULL(b.mar_11,0)+
										ISNULL(b.apr_11,0)+
										ISNULL(b.may_11,0)+
										ISNULL(b.jun_11,0)+
										ISNULL(b.jul_11,0)+
										ISNULL(b.aug_11,0)+
										ISNULL(b.sep_11,0)+
										ISNULL(b.oct_11,0)+
										ISNULL(b.nov_11,0)+
										ISNULL(b.dec_11,0)) end) <> ( -.0003)) f

group by  base_part
having (abs(sum(f.total_2010)) +abs(sum(f.total_2011)))>0
GO
