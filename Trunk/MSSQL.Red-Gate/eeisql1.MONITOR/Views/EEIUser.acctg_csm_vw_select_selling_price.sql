SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE view [EEIUser].[acctg_csm_vw_select_selling_price]
as
select		base_part, 
			sum(jan_10) as sp_jan_10,
			sum(feb_10) as sp_feb_10,
			sum(mar_10) as sp_mar_10,
			sum(apr_10) as sp_apr_10,
			sum(may_10) as sp_may_10,
			sum(jun_10) as sp_jun_10,
			sum(jul_10) as sp_jul_10,
			sum(aug_10) as sp_aug_10,
			sum(sep_10) as sp_sep_10,
			sum(oct_10) as sp_oct_10,
			sum(nov_10) as sp_nov_10,
			sum(dec_10) as sp_dec_10,
						
			sum(jan_11) as sp_jan_11,
			sum(feb_11) as sp_feb_11,
			sum(mar_11) as sp_mar_11,
			sum(apr_11) as sp_apr_11,
			sum(may_11) as sp_may_11,
			sum(jun_11) as sp_jun_11,
			sum(jul_11) as sp_jul_11,
			sum(aug_11) as sp_aug_11,
			sum(sep_11) as sp_sep_11,
			sum(oct_11) as sp_oct_11,
			sum(nov_11) as sp_nov_11,
			sum(dec_11) as sp_dec_11,

			sum(jan_12) as sp_jan_12,
			sum(feb_12) as sp_feb_12,
			sum(mar_12) as sp_mar_12,
			sum(apr_12) as sp_apr_12,
			sum(may_12) as sp_may_12,
			sum(jun_12) as sp_jun_12,
			sum(jul_12) as sp_jul_12,
			sum(aug_12) as sp_aug_12,
			sum(sep_12) as sp_sep_12,
			sum(oct_12) as sp_oct_12,
			sum(nov_12) as sp_nov_12,
			sum(dec_12) as sp_dec_12,

			sum(jan_13) as sp_jan_13,
			sum(feb_13) as sp_feb_13,
			sum(mar_13) as sp_mar_13,
			sum(apr_13) as sp_apr_13,
			sum(may_13) as sp_may_13,
			sum(jun_13) as sp_jun_13,
			sum(jul_13) as sp_jul_13,
			sum(aug_13) as sp_aug_13,
			sum(sep_13) as sp_sep_13,
			sum(oct_13) as sp_oct_13,
			sum(nov_13) as sp_nov_13,
			sum(dec_13) as sp_dec_13,

			sum(jan_14) as sp_jan_14,
			sum(feb_14) as sp_feb_14,
			sum(mar_14) as sp_mar_14,
			sum(apr_14) as sp_apr_14,
			sum(may_14) as sp_may_14,
			sum(jun_14) as sp_jun_14,
			sum(jul_14) as sp_jul_14,
			sum(aug_14) as sp_aug_14,
			sum(sep_14) as sp_sep_14,
			sum(oct_14) as sp_oct_14,
			sum(nov_14) as sp_nov_14,
			sum(dec_14) as sp_dec_14,

			sum(jan_15) as sp_jan_15,
			sum(feb_15) as sp_feb_15,
			sum(mar_15) as sp_mar_15,
			sum(apr_15) as sp_apr_15,
			sum(may_15) as sp_may_15,
			sum(jun_15) as sp_jun_15,
			sum(jul_15) as sp_jul_15,
			sum(aug_15) as sp_aug_15,
			sum(sep_15) as sp_sep_15,
			sum(oct_15) as sp_oct_15,
			sum(nov_15) as sp_nov_15,
			sum(dec_15) as sp_dec_15,

			sum(jan_16) as sp_jan_16,
			sum(feb_16) as sp_feb_16,
			sum(mar_16) as sp_mar_16,
			sum(apr_16) as sp_apr_16,
			sum(may_16) as sp_may_16,
			sum(jun_16) as sp_jun_16,
			sum(jul_16) as sp_jul_16,
			sum(aug_16) as sp_aug_16,
			sum(sep_16) as sp_sep_16,
			sum(oct_16) as sp_oct_16,
			sum(nov_16) as sp_nov_16,
			sum(dec_16) as sp_dec_16,
			
			sum(jan_17) as sp_jan_17,
			sum(feb_17) as sp_feb_17,
			sum(mar_17) as sp_mar_17,
			sum(apr_17) as sp_apr_17,
			sum(may_17) as sp_may_17,
			sum(jun_17) as sp_jun_17,
			sum(jul_17) as sp_jul_17,
			sum(aug_17) as sp_aug_17,
			sum(sep_17) as sp_sep_17,
			sum(oct_17) as sp_oct_17,
			sum(nov_17) as sp_nov_17,
			sum(dec_17) as sp_dec_17,
			
			sum(jan_18) as sp_jan_18,
			sum(feb_18) as sp_feb_18,
			sum(mar_18) as sp_mar_18,
			sum(apr_18) as sp_apr_18,
			sum(may_18) as sp_may_18,
			sum(jun_18) as sp_jun_18,
			sum(jul_18) as sp_jul_18,
			sum(aug_18) as sp_aug_18,
			sum(sep_18) as sp_sep_18,
			sum(oct_18) as sp_oct_18,
			sum(nov_18) as sp_nov_18,
			sum(dec_18) as sp_dec_18,

			sum(jan_19) as sp_jan_19,
			sum(feb_19) as sp_feb_19,
			sum(mar_19) as sp_mar_19,
			sum(apr_19) as sp_apr_19,
			sum(may_19) as sp_may_19,
			sum(jun_19) as sp_jun_19,
			sum(jul_19) as sp_jul_19,
			sum(aug_19) as sp_aug_19,
			sum(sep_19) as sp_sep_19,
			sum(oct_19) as sp_oct_19,
			sum(nov_19) as sp_nov_19,
			sum(dec_19) as sp_dec_19,

			sum(jan_20) as sp_jan_20,
			sum(feb_20) as sp_feb_20,
			sum(mar_20) as sp_mar_20,
			sum(apr_20) as sp_apr_20,
			sum(may_20) as sp_may_20,
			sum(jun_20) as sp_jun_20,
			sum(jul_20) as sp_jul_20,
			sum(aug_20) as sp_aug_20,
			sum(sep_20) as sp_sep_20,
			sum(oct_20) as sp_oct_20,
			sum(nov_20) as sp_nov_20,
			sum(dec_20) as sp_dec_20,

			sum(dec_21) as sp_dec_21,
			sum(dec_22) as sp_dec_22,
			sum(dec_23) as sp_dec_23,
			sum(dec_24) as sp_dec_24,
			sum(dec_25) as sp_dec_25

from		eeiuser.acctg_csm_selling_prices_tabular 

where		release_id = (Select	[dbo].[fn_ReturnLatestCSMRelease] ('CSM') ) 

group by	base_part












GO
