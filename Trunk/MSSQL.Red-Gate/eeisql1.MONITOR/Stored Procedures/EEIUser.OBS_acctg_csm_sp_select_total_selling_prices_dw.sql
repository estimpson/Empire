SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[OBS_acctg_csm_sp_select_total_selling_prices_dw]
  @base_part varchar(30),
  @release_id varchar(30)
as

 --exec [EEIUser].[acctg_csm_sp_select_total_selling_prices_dw]  'NAL0264' , '2012-03'

select 'Selling Price ' as description, 
sum(ISNULL(jan_12,0)) as jan_12,
sum(ISNULL(feb_12,0)) as feb_12,
sum(ISNULL(mar_12,0)) as mar_12,
sum(ISNULL(apr_12,0)) as apr_12,
sum(ISNULL(may_12,0)) as may_12,
sum(ISNULL(jun_12,0)) as jun_12,
sum(ISNULL(jul_12,0)) as jul_12,
sum(ISNULL(aug_12,0)) as aug_12,
sum(ISNULL(sep_12,0)) as sep_12,
sum(ISNULL(oct_12,0)) as oct_12,
sum(ISNULL(nov_12,0)) as nov_12,
sum(ISNULL(dec_12,0)) as dec_12,
'' as Total_2012,
sum(ISNULL(jan_13,0)) as jan_13,
sum(ISNULL(feb_13,0)) as feb_13,
sum(ISNULL(mar_13,0)) as mar_13,
sum(ISNULL(apr_13,0)) as apr_13,
sum(ISNULL(may_13,0)) as may_13,
sum(ISNULL(jun_13,0)) as jun_13,
sum(ISNULL(jul_13,0)) as jul_13,
sum(ISNULL(aug_13,0)) as aug_13,
sum(ISNULL(sep_13,0)) as sep_13,
sum(ISNULL(oct_13,0)) as oct_13,
sum(ISNULL(nov_13,0)) as nov_13,
sum(ISNULL(dec_13,0)) as dec_13,
'' as Total_2013,
sum(ISNULL(jan_14,0)) as jan_14,
sum(ISNULL(feb_14,0)) as feb_14,
sum(ISNULL(mar_14,0)) as mar_14,
sum(ISNULL(apr_14,0)) as apr_14,
sum(ISNULL(may_14,0)) as may_14,
sum(ISNULL(jun_14,0)) as jun_14,
sum(ISNULL(jul_14,0)) as jul_14,
sum(ISNULL(aug_14,0)) as aug_14,
sum(ISNULL(sep_14,0)) as sep_14,
sum(ISNULL(oct_14,0)) as oct_14,
sum(ISNULL(nov_14,0)) as nov_14,
sum(ISNULL(dec_14,0)) as dec_14,
'' as Total_2014 
from  eeiuser.acctg_csm_selling_prices_tabular where 
base_part = @base_part 
group by base_part

GO
