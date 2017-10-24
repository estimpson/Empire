SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[acctg_csm_sp_select_suggested_take_rate] (@base_part2 varchar(15), @release_id2 varchar(15))

as
declare @actual_demand table 
	(	 description varchar(200)

		,jan_15 decimal(18,6)
		,feb_15 decimal(18,6)
		,mar_15 decimal(18,6)
		,apr_15 decimal(18,6)
		,may_15 decimal(18,6)
		,jun_15 decimal(18,6)
		,jul_15 decimal(18,6)
		,aug_15 decimal(18,6)
		,sep_15 decimal(18,6)
		,oct_15 decimal(18,6)
		,nov_15 decimal(18,6)
		,dec_15 decimal(18,6)
		,total_2015 decimal(18,6)

		,jan_16 decimal(18,6)
		,feb_16 decimal(18,6)
		,mar_16 decimal(18,6)
		,apr_16 decimal(18,6)
		,may_16 decimal(18,6)
		,jun_16 decimal(18,6)
		,jul_16 decimal(18,6)
		,aug_16 decimal(18,6)
		,sep_16 decimal(18,6)
		,oct_16 decimal(18,6)
		,nov_16 decimal(18,6)
		,dec_16 decimal(18,6)
		,total_2016 decimal(18,6)
				
		,jan_17 decimal(18,6)
		,feb_17 decimal(18,6)
		,mar_17 decimal(18,6)
		,apr_17 decimal(18,6)
		,may_17 decimal(18,6)
		,jun_17 decimal(18,6)
		,jul_17 decimal(18,6)
		,aug_17 decimal(18,6)
		,sep_17 decimal(18,6)
		,oct_17 decimal(18,6)
		,nov_17 decimal(18,6)
		,dec_17 decimal(18,6)		
		,total_2017 decimal(18,6)

		,jan_18 decimal(18,6)
		,feb_18 decimal(18,6)
		,mar_18 decimal(18,6)
		,apr_18 decimal(18,6)
		,may_18 decimal(18,6)
		,jun_18 decimal(18,6)
		,jul_18 decimal(18,6)
		,aug_18 decimal(18,6)
		,sep_18 decimal(18,6)
		,oct_18 decimal(18,6)
		,nov_18 decimal(18,6)
		,dec_18 decimal(18,6)		
		,total_2018 decimal(18,6)

		,total_2019 decimal(18,6)
	)
	
insert into @actual_demand
exec eeiuser.acctg_csm_sp_select_total_planner_demand_3yr_dw @base_part2


declare @adjusted_csm_demand table 
	(	base_part varchar(12) 
		,description varchar(200)

		,jan_15 decimal(18,6)
		,feb_15 decimal(18,6)
		,mar_15 decimal(18,6)
		,apr_15 decimal(18,6)
		,may_15 decimal(18,6)
		,jun_15 decimal(18,6)
		,jul_15 decimal(18,6)
		,aug_15 decimal(18,6)
		,sep_15 decimal(18,6)
		,oct_15 decimal(18,6)
		,nov_15 decimal(18,6)
		,dec_15 decimal(18,6)
		,total_2015 decimal(18,6)

		,jan_16 decimal(18,6)
		,feb_16 decimal(18,6)
		,mar_16 decimal(18,6)
		,apr_16 decimal(18,6)
		,may_16 decimal(18,6)
		,jun_16 decimal(18,6)
		,jul_16 decimal(18,6)
		,aug_16 decimal(18,6)
		,sep_16 decimal(18,6)
		,oct_16 decimal(18,6)
		,nov_16 decimal(18,6)
		,dec_16 decimal(18,6)		
		,total_2016 decimal(18,6)

		,jan_17 decimal(18,6)
		,feb_17 decimal(18,6)
		,mar_17 decimal(18,6)
		,apr_17 decimal(18,6)
		,may_17 decimal(18,6)
		,jun_17 decimal(18,6)
		,jul_17 decimal(18,6)
		,aug_17 decimal(18,6)
		,sep_17 decimal(18,6)
		,oct_17 decimal(18,6)
		,nov_17 decimal(18,6)
		,dec_17 decimal(18,6)
		,total_2017 decimal(18,6)

		,total_2018 decimal(18,6)
		,total_2019 decimal(18,6)
	)
	
insert into @adjusted_csm_demand
exec eeiuser.acctg_csm_sp_select_total_demand_9yr_dw @base_part2, @release_id2


select	a.total_2015 as total_2015_adjusted_csm
		,b.total_2015 as total_2015_actual_demand
		,a.total_2016 as total_2016_adjusted_csm
		, b.total_2016 as total_2016_actual_demand 
		,(case when a.total_2015 = 0 then 0 else b.total_2015/a.total_2015 end) as ratio_2015
		,(case when a.total_2016 = 0 then 0 else b.total_2016/a.total_2016 end) as ratio_2016 
		,qty_per
		,take_rate
		,family_allocation
		,(case when a.total_2016 = 0 then 0 else b.total_2016/a.total_2016 end)*take_rate as suggested_take_rate
from
			(select base_part, sum(total_2015) as total_2015, sum(total_2016) as total_2016 from @adjusted_csm_demand group by base_part) a
		join 
			(select @base_part2 as base_part, sum(total_2015) as total_2015	,sum(total_2016) as total_2016 from @actual_demand) b 
		on a.base_part = b.base_part
		
		join
			(select base_part, avg(qty_per) as qty_per, avg(take_rate) as take_rate, avg(family_allocation) as family_allocation, avg(take_rate)*avg(family_allocation) as adjusted_take_rate from eeiuser.acctg_csm_base_part_mnemonic where base_part = @base_part2 group by base_part) c
		on a.base_part = c.base_part











GO
