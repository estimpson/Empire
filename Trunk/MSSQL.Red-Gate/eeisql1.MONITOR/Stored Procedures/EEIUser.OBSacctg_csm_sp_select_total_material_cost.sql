SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE procedure [EEIUser].[OBSacctg_csm_sp_select_total_material_cost]
  @base_part varchar(30),
  @release_id varchar(30)
as
select 'Material Cost ' as description, 
partusedforcost,
sum(ISNULL(jan_15,0)) as jan2015,
sum(ISNULL(feb_15,0)) as feb2015,
sum(ISNULL(mar_15,0)) as mar2015,
sum(ISNULL(apr_15,0)) as apr2015,
sum(ISNULL(may_15,0)) as may2015,
sum(ISNULL(jun_15,0)) as jun2015,
sum(ISNULL(jul_15,0)) as jul2015,
sum(ISNULL(aug_15,0)) as aug2015,
sum(ISNULL(sep_15,0)) as sep2015,
sum(ISNULL(oct_15,0)) as oct2015,
sum(ISNULL(nov_15,0)) as nov2015,
sum(ISNULL(dec_15,0)) as dec2015,
'' as Total_2015, 

sum(ISNULL(jan_16,0)) as jan2016,
sum(ISNULL(feb_16,0)) as feb2016,
sum(ISNULL(mar_16,0)) as mar2016,
sum(ISNULL(apr_16,0)) as apr2016,
sum(ISNULL(may_16,0)) as may2016,
sum(ISNULL(jun_16,0)) as jun2016,
sum(ISNULL(jul_16,0)) as jul2016,
sum(ISNULL(aug_16,0)) as aug2016,
sum(ISNULL(sep_16,0)) as sep2016,
sum(ISNULL(oct_16,0)) as oct2016,
sum(ISNULL(nov_16,0)) as nov2016,
sum(ISNULL(dec_16,0)) as dec2016,
'' as Total_2016, 

sum(ISNULL(jan_17,0)) as jan2017,
sum(ISNULL(feb_17,0)) as feb2017,
sum(ISNULL(mar_17,0)) as mar2017,
sum(ISNULL(apr_17,0)) as apr2017,
sum(ISNULL(may_17,0)) as may2017,
sum(ISNULL(jun_17,0)) as jun2017,
sum(ISNULL(jul_17,0)) as jul2017,
sum(ISNULL(aug_17,0)) as aug2017,
sum(ISNULL(sep_17,0)) as sep2017,
sum(ISNULL(oct_17,0)) as oct2017,
sum(ISNULL(nov_17,0)) as nov2017,
sum(ISNULL(dec_17,0)) as dec2017,
'' as Total_2017, 

sum(ISNULL(jan_18,0)) as jan2018,
sum(ISNULL(feb_18,0)) as feb2018,
sum(ISNULL(mar_18,0)) as mar2018,
sum(ISNULL(apr_18,0)) as apr2018,
sum(ISNULL(may_18,0)) as may2018,
sum(ISNULL(jun_18,0)) as jun2018,
sum(ISNULL(jul_18,0)) as jul2018,
sum(ISNULL(aug_18,0)) as aug2018,
sum(ISNULL(sep_18,0)) as sep2018,
sum(ISNULL(oct_18,0)) as oct2018,
sum(ISNULL(nov_18,0)) as nov2018,
sum(ISNULL(dec_18,0)) as dec2018,
'' as Total_2018,

sum(ISNULL(dec_19,0)) as total_2019,
sum(ISNULL(dec_19,0)) as total_2020
from  eeiuser.acctg_csm_material_cost_tabular where 
base_part = @base_part and release_id = @release_id and row_id=1
group by base_part, partusedforcost







GO
