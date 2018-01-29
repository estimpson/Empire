SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE procedure [EEIUser].[acctg_csm_sp_insert_selling_prices] 
@release_id varchar(25),
@base_part varchar(25),
@sp decimal(8,4)

--select @release_id = '2012-04';
--select @base_part = 'ADC0023';
--select @sp = 2.32

as 

insert into eeiuser.acctg_csm_selling_prices_tabular (release_id, row_id, base_part, version, 
jan_08, feb_08, mar_08, apr_08, may_08, jun_08, jul_08, aug_08, sep_08, oct_08, nov_08, dec_08, 
jan_09, feb_09, mar_09, apr_09, may_09, jun_09, jul_09, aug_09, sep_09, oct_09, nov_09, dec_09,
jan_10, feb_10, mar_10, apr_10, may_10, jun_10, jul_10, aug_10, sep_10, oct_10, nov_10, dec_10,
jan_11, feb_11, mar_11, apr_11, may_11, jun_11, jul_11, aug_11, sep_11, oct_11, nov_11, dec_11,
jan_12, feb_12, mar_12, apr_12, may_12, jun_12, jul_12, aug_12, sep_12, oct_12, nov_12, dec_12, 
jan_13, feb_13, mar_13, apr_13, may_13, jun_13, jul_13, aug_13, sep_13, oct_13, nov_13, dec_13, 
jan_14, feb_14, mar_14, apr_14, may_14, jun_14, jul_14, aug_14, sep_14, oct_14, nov_14, Dec_14,
jan_15, feb_15, mar_15, apr_15, may_15, jun_15, jul_15, aug_15, sep_15, oct_15, nov_15, dec_15, 
jan_16, feb_16, mar_16, apr_16, may_16, jun_16, jul_16, aug_16, sep_16, oct_16, nov_16, dec_16, 
jan_17, feb_17, mar_17, apr_17, may_17, jun_17, jul_17, aug_17, sep_17, oct_17, nov_17, Dec_17, 
jan_18, feb_18, mar_18, apr_18, may_18, jun_18, jul_18, aug_18, sep_18, oct_18, nov_18, Dec_18,
jan_19, feb_19, mar_19, apr_19, may_19, jun_19, jul_19, aug_19, sep_19, oct_19, nov_19, Dec_19,
jan_20, feb_20, mar_20, apr_20, may_20, jun_20, jul_20, aug_20, sep_20, oct_20, nov_20, Dec_20,
Dec_21, 
Dec_22,
Dec_23,
Dec_24,
Dec_25)

select @release_id,'1',@base_part,'Current Selling Price', 
@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp, --2008
@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp, --2009
@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp, --2010
@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp, --2011
@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp, --2012
@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp, --2013
@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp, --2014
@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp, --2015
@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp, --2016
@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp, --2017
@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp, --2018
@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp, --2019
@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp,@sp, --2020
@sp, --2021
@sp, --2022
@sp, --2023
@sp, --2024
@sp  --2025

  


GO
