SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EEIUser].[OBS_acctg_csm_sp_select_material_cost_3yr_dw]
  @base_part varchar(30),
  @release_id varchar(30)
as

--exec [EEIUser].[acctg_csm_sp_select_material_cost_3yr_dw] 'ALC0134', '2012-04'

select	'Material Cost ' as description, 
		row_id as row_id,
		version as version,
		inclusion as inclusion,
		partusedforcost as current_part,
		effective_date as effective_date,
	
		ISNULL(jan_15,0) as jan_15,
		ISNULL(feb_15,0) as feb_15,
		ISNULL(mar_15,0) as mar_15,
		ISNULL(apr_15,0) as apr_15,
		ISNULL(may_15,0) as may_15,
		ISNULL(jun_15,0) as jun_15,
		ISNULL(jul_15,0) as jul_15,
		ISNULL(aug_15,0) as aug_15,
		ISNULL(sep_15,0) as sep_15,
		ISNULL(oct_15,0) as oct_15,
		ISNULL(nov_15,0) as nov_15,
		ISNULL(dec_15,0) as dec_15,
		0 as Total_2015,

		ISNULL(jan_16,0) as jan_16,
		ISNULL(feb_16,0) as feb_16,
		ISNULL(mar_16,0) as mar_16,
		ISNULL(apr_16,0) as apr_16,
		ISNULL(may_16,0) as may_16,
		ISNULL(jun_16,0) as jun_16,
		ISNULL(jul_16,0) as jul_16,
		ISNULL(aug_16,0) as aug_16,
		ISNULL(sep_16,0) as sep_16,
		ISNULL(oct_16,0) as oct_16,
		ISNULL(nov_16,0) as nov_16,
		ISNULL(dec_16,0) as dec_16,
		0 as Total_2016,

		ISNULL(jan_17,0) as jan_17,
		ISNULL(feb_17,0) as feb_17,
		ISNULL(mar_17,0) as mar_17,
		ISNULL(apr_17,0) as apr_17,
		ISNULL(may_17,0) as may_17,
		ISNULL(jun_17,0) as jun_17,
		ISNULL(jul_17,0) as jul_17,
		ISNULL(aug_17,0) as aug_17,
		ISNULL(sep_17,0) as sep_17,
		ISNULL(oct_17,0) as oct_17,
		ISNULL(nov_17,0) as nov_17,
		ISNULL(dec_17,0) as dec_17,
		0 as Total_2017




from	eeiuser.acctg_csm_material_cost_tabular 

where	base_part = @base_part 
		and release_id = @release_id

order by effective_date, row_id


GO
