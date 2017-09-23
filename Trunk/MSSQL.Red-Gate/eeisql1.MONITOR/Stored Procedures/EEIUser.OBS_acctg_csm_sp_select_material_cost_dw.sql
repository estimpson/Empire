SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EEIUser].[OBS_acctg_csm_sp_select_material_cost_dw]
  @base_part varchar(30),
  @release_id varchar(30)
as
select	@base_part as [base_part],
		'Material Cost' as description, 
		[VERSION] as version,
		inclusion as inclusion,
		row_id as row_id, 
		PartUsedForCost,
		Effective_Date,
		ISNULL(jan_12,0) as [Jan 2012],
		ISNULL(feb_12,0) as [Feb 2012],
		ISNULL(mar_12,0) as [Mar 2012],
		ISNULL(apr_12,0) as [Apr 2012],
		ISNULL(may_12,0) as [May 2012],
		ISNULL(jun_12,0) as [Jun 2012],
		ISNULL(jul_12,0) as [Jul 2012],
		ISNULL(aug_12,0) as [Aug 2012],
		ISNULL(sep_12,0) as [Sep 2012],
		ISNULL(oct_12,0) as [Oct 2012],
		ISNULL(nov_12,0) as [Nov 2012],
		ISNULL(dec_12,0) as [Dec 2012],
		'' as Total_2012 ,
		ISNULL(jan_13,0) as [Jan 2013],
		ISNULL(feb_13,0) as [Feb 2013],
		ISNULL(mar_13,0) as [Mar 2013],
		ISNULL(apr_13,0) as [Apr 2013],
		ISNULL(may_13,0) as [May 2013],
		ISNULL(jun_13,0) as [Jun 2013],
		ISNULL(jul_13,0) as [Jul 2013],
		ISNULL(aug_13,0) as [Aug 2013],
		ISNULL(sep_13,0) as [Sep 2013],
		ISNULL(oct_13,0) as [Oct 2013],
		ISNULL(nov_13,0) as [Nov 2013],
		ISNULL(dec_13,0) as [Dec 2013],
		'' as Total_2013,
		ISNULL(jan_14,0) as [Jan 2014],
		ISNULL(feb_14,0) as [Feb 2014],
		ISNULL(mar_14,0) as [Mar 2014],
		ISNULL(apr_14,0) as [Apr 2014],
		ISNULL(may_14,0) as [May 2014],
		ISNULL(jun_14,0) as [Jun 2014],
		ISNULL(jul_14,0) as [Jul 2014],
		ISNULL(aug_14,0) as [Aug 2014],
		ISNULL(sep_14,0) as [Sep 2014],
		ISNULL(oct_14,0) as [Oct 2014],
		ISNULL(nov_14,0) as [Nov 2014],
		ISNULL(dec_14,0) as [Dec 2014],
		'' as Total_2014,
		
		ISNULL(jan_15,0) as [Jan 2015],
		ISNULL(feb_15,0) as [Feb 2015],
		ISNULL(mar_15,0) as [Mar 2015],
		ISNULL(apr_15,0) as [Apr 2015],
		ISNULL(may_15,0) as [May 2015],
		ISNULL(jun_15,0) as [Jun 2015],
		ISNULL(jul_15,0) as [Jul 2015],
		ISNULL(aug_15,0) as [Aug 2015],
		ISNULL(sep_15,0) as [Sep 2015],
		ISNULL(oct_15,0) as [Oct 2015],
		ISNULL(nov_15,0) as [Nov 2015],
		ISNULL(dec_15,0) as [Dec 2015],
		'' as Total_2015,
		
		ISNULL(jan_16,0) as [Jan 2016],
		ISNULL(feb_16,0) as [Feb 2016],
		ISNULL(mar_16,0) as [Mar 2016],
		ISNULL(apr_16,0) as [Apr 2016],
		ISNULL(may_16,0) as [May 2016],
		ISNULL(jun_16,0) as [Jun 2016],
		ISNULL(jul_16,0) as [Jul 2016],
		ISNULL(aug_16,0) as [Aug 2016],
		ISNULL(sep_16,0) as [Sep 2016],
		ISNULL(oct_16,0) as [Oct 2016],
		ISNULL(nov_16,0) as [Nov 2016],
		ISNULL(dec_16,0) as [Dec 2016],
		'' as Total_2016,
		
		ISNULL(jan_17,0) as [Jan 2017],
		ISNULL(feb_17,0) as [Feb 2017],
		ISNULL(mar_17,0) as [Mar 2017],
		ISNULL(apr_17,0) as [Apr 2017],
		ISNULL(may_17,0) as [May 2017],
		ISNULL(jun_17,0) as [Jun 2017],
		ISNULL(jul_17,0) as [Jul 2017],
		ISNULL(aug_17,0) as [Aug 2017],
		ISNULL(sep_17,0) as [Sep 2017],
		ISNULL(oct_17,0) as [Oct 2017],
		ISNULL(nov_17,0) as [Nov 2017],
		ISNULL(dec_17,0) as [Dec 2017],
		'' as Total_2017,

		ISNULL(dec_18,0) as [Total_2018],
		ISNULL(dec_19,0) as [Total_2019]
		
from	eeiuser.acctg_csm_material_cost_tabular 

where	base_part = @base_part 
	and RELEASE_ID = @release_id 


GO
