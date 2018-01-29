SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [EEIUser].[acctg_csm_sp_select_selling_prices2018]
  @base_part varchar(30),
  @release_id varchar(30)
as
select	@base_part as [base_part],
		'Selling Price ' as description, 
		version as version,
		inclusion as inclusion,
		row_id as row_id,

		ISNULL(jan_15,0) as [Jan2015],
		ISNULL(feb_15,0) as [Feb2015],
		ISNULL(mar_15,0) as [Mar2015],
		ISNULL(apr_15,0) as [Apr2015],
		ISNULL(may_15,0) as [May2015],
		ISNULL(jun_15,0) as [Jun2015],
		ISNULL(jul_15,0) as [Jul2015],
		ISNULL(aug_15,0) as [Aug2015],
		ISNULL(sep_15,0) as [Sep2015],
		ISNULL(oct_15,0) as [Oct2015],
		ISNULL(nov_15,0) as [Nov2015],
		ISNULL(dec_15,0) as [Dec2015],
		'' as Total_2015,

		ISNULL(jan_16,0) as [Jan2016],
		ISNULL(feb_16,0) as [Feb2016],
		ISNULL(mar_16,0) as [Mar2016],
		ISNULL(apr_16,0) as [Apr2016],
		ISNULL(may_16,0) as [May2016],
		ISNULL(jun_16,0) as [Jun2016],
		ISNULL(jul_16,0) as [Jul2016],
		ISNULL(aug_16,0) as [Aug2016],
		ISNULL(sep_16,0) as [Sep2016],
		ISNULL(oct_16,0) as [Oct2016],
		ISNULL(nov_16,0) as [Nov2016],
		ISNULL(dec_16,0) as [Dec2016],
		'' as Total_2016,

		ISNULL(jan_17,0) as [Jan2017],
		ISNULL(feb_17,0) as [Feb2017],
		ISNULL(mar_17,0) as [Mar2017],
		ISNULL(apr_17,0) as [Apr2017],
		ISNULL(may_17,0) as [May2017],
		ISNULL(jun_17,0) as [Jun2017],
		ISNULL(jul_17,0) as [Jul2017],
		ISNULL(aug_17,0) as [Aug2017],
		ISNULL(sep_17,0) as [Sep2017],
		ISNULL(oct_17,0) as [Oct2017],
		ISNULL(nov_17,0) as [Nov2017],
		ISNULL(dec_17,0) as [Dec2017],
		'' as Total_2017,

		ISNULL(jan_18,0) as [Jan2018],
		ISNULL(feb_18,0) as [Feb2018],
		ISNULL(mar_18,0) as [Mar2018],
		ISNULL(apr_18,0) as [Apr2018],
		ISNULL(may_18,0) as [May2018],
		ISNULL(jun_18,0) as [Jun2018],
		ISNULL(jul_18,0) as [Jul2018],
		ISNULL(aug_18,0) as [Aug2018],
		ISNULL(sep_18,0) as [Sep2018],
		ISNULL(oct_18,0) as [Oct2018],
		ISNULL(nov_18,0) as [Nov2018],
		ISNULL(dec_18,0) as [Dec2018],
		'' as Total_2018,
		
		ISNULL(jan_19,0) as [Jan2019],
		ISNULL(feb_19,0) as [Feb2019],
		ISNULL(mar_19,0) as [Mar2019],
		ISNULL(apr_19,0) as [Apr2019],
		ISNULL(may_19,0) as [May2019],
		ISNULL(jun_19,0) as [Jun2019],
		ISNULL(jul_19,0) as [Jul2019],
		ISNULL(aug_19,0) as [Aug2019],
		ISNULL(sep_19,0) as [Sep2019],
		ISNULL(oct_19,0) as [Oct2019],
		ISNULL(nov_19,0) as [Nov2019],
		ISNULL(dec_19,0) as [Dec2019],
		'' as Total_2019,
		
		ISNULL(jan_20,0) as [Jan2020],
		ISNULL(feb_20,0) as [Feb2020],
		ISNULL(mar_20,0) as [Mar2020],
		ISNULL(apr_20,0) as [Apr2020],
		ISNULL(may_20,0) as [May2020],
		ISNULL(jun_20,0) as [Jun2020],
		ISNULL(jul_20,0) as [Jul2020],
		ISNULL(aug_20,0) as [Aug2020],
		ISNULL(sep_20,0) as [Sep2020],
		ISNULL(oct_20,0) as [Oct2020],
		ISNULL(nov_20,0) as [Nov2020],
		ISNULL(dec_20,0) as [Dec2020],
		'' as Total_2020,
	
		/*
		ISNULL(jan_21,0) as [Jan2021],
		ISNULL(feb_21,0) as [Feb2021],
		ISNULL(mar_21,0) as [Mar2021],
		ISNULL(apr_21,0) as [Apr2021],
		ISNULL(may_21,0) as [May2021],
		ISNULL(jun_21,0) as [Jun2021],
		ISNULL(jul_21,0) as [Jul2021],
		ISNULL(aug_21,0) as [Aug2021],
		ISNULL(sep_21,0) as [Sep2021],
		ISNULL(oct_21,0) as [Oct2021],
		ISNULL(nov_21,0) as [Nov2021],
		ISNULL(dec_21,0) as [Dec2021],
		'' as Total_2021,
		*/
		
		ISNULL(dec_21,0) as [Total_2021],
		ISNULL(dec_22,0) as [Total_2022],
		ISNULL(dec_23,0) as [Total_2023]
		

from	eeiuser.acctg_csm_selling_prices_tabular 

where	base_part = @base_part
		and release_id = @release_id
		and ROW_ID=1







GO
