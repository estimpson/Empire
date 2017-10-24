SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE procedure [EEIUser].[OBS_acctg_csm_sp_select_adjusted_csm_demand]
	@base_part varchar(30),
	@release_id varchar(30)
as

select	@base_part,
		'Adj CSM Demand' as version, 
		AA.jan_08*BB.jan_08 as jan_08,
		AA.feb_08*BB.feb_08 as feb_08,
		AA.mar_08*BB.mar_08 as mar_08,
		AA.apr_08*BB.apr_08 as apr_08,
		AA.may_08*BB.may_08 as may_08,
		AA.jun_08*BB.jun_08 as jun_08,
		AA.jul_08*BB.jul_08 as jul_08,
		AA.aug_08*BB.aug_08 as aug_08,
		AA.sep_08*BB.sep_08 as sep_08,
		AA.oct_08*BB.oct_08 as oct_08,
		AA.nov_08*BB.nov_08 as nov_08,
		AA.dec_08*BB.dec_08 as dec_08,
		(AA.jan_08*BB.JAN_08)+(AA.feb_08*BB.feb_08)+(AA.mar_08*BB.mar_08)+(AA.apr_08*BB.apr_08)+(AA.may_08*BB.may_08)+(AA.jun_08*BB.jun_08)+(AA.jul_08*BB.jul_08)+(AA.aug_08*BB.aug_08)+(AA.sep_08*BB.sep_08)+(AA.oct_08*BB.oct_08)+(AA.nov_08*BB.nov_08)+(AA.dec_08*BB.dec_08) as total_2008,
		AA.jan_09*BB.jan_09 as jan_09,
		AA.feb_09*BB.feb_09 as feb_09,
		AA.mar_09*BB.mar_09 as mar_09,
		AA.apr_09*BB.apr_09 as apr_09,
		AA.may_09*BB.may_09 as may_09,
		AA.jun_09*BB.jun_09 as jun_09,
		AA.jul_09*BB.jul_09 as jul_09,
		AA.aug_09*BB.aug_09 as aug_09,
		AA.sep_09*BB.sep_09 as sep_09,
		AA.oct_09*BB.oct_09 as oct_09,
		AA.nov_09*BB.nov_09 as nov_09,
		AA.dec_09*BB.dec_09 as dec_09,
		(AA.jan_09*BB.JAN_09)+(AA.feb_09*BB.feb_09)+(AA.mar_09*BB.mar_09)+(AA.apr_09*BB.apr_09)+(AA.may_09*BB.may_09)+(AA.jun_09*BB.jun_09)+(AA.jul_09*BB.jul_09)+(AA.aug_09*BB.aug_09)+(AA.sep_09*BB.sep_09)+(AA.oct_09*BB.oct_09)+(AA.nov_09*BB.nov_09)+(AA.dec_09*BB.dec_09) as total_2009,
		AA.jan_10*BB.jan_10 as jan_10,
		AA.feb_10*BB.feb_10 as feb_10,
		AA.mar_10*BB.mar_10 as mar_10,
		AA.apr_10*BB.apr_10 as apr_10,
		AA.may_10*BB.may_10 as may_10,
		AA.jun_10*BB.jun_10 as jun_10,
		AA.jul_10*BB.jul_10 as jul_10,
		AA.aug_10*BB.aug_10 as aug_10,
		AA.sep_10*BB.sep_10 as sep_10,
		AA.oct_10*BB.oct_10 as oct_10,
		AA.nov_10*BB.nov_10 as nov_10,
		AA.dec_10*BB.dec_10 as dec_10,
		(AA.jan_10*BB.JAN_10)+(AA.feb_10*BB.feb_10)+(AA.mar_10*BB.mar_10)+(AA.apr_10*BB.apr_10)+(AA.may_10*BB.may_10)+(AA.jun_10*BB.jun_10)+(AA.jul_10*BB.jul_10)+(AA.aug_10*BB.aug_10)+(AA.sep_10*BB.sep_10)+(AA.oct_10*BB.oct_10)+(AA.nov_10*BB.nov_10)+(AA.dec_10*BB.dec_10) as total_2010,		
		AA.jan_11*BB.jan_11 as jan_11,
		AA.feb_11*BB.feb_11 as feb_11,
		AA.mar_11*BB.mar_11 as mar_11,
		AA.apr_11*BB.apr_11 as apr_11,
		AA.may_11*BB.may_11 as may_11,
		AA.jun_11*BB.jun_11 as jun_11,
		AA.jul_11*BB.jul_11 as jul_11,
		AA.aug_11*BB.aug_11 as aug_11,
		AA.sep_11*BB.sep_11 as sep_11,
		AA.oct_11*BB.oct_11 as oct_11,
		AA.nov_11*BB.nov_11 as nov_11,
		AA.dec_11*BB.dec_11 as dec_11,
		(AA.jan_11*BB.JAN_11)+(AA.feb_11*BB.feb_11)+(AA.mar_11*BB.mar_11)+(AA.apr_11*BB.apr_11)+(AA.may_11*BB.may_11)+(AA.jun_11*BB.jun_11)+(AA.jul_11*BB.jul_11)+(AA.aug_11*BB.aug_11)+(AA.sep_11*BB.sep_11)+(AA.oct_11*BB.oct_11)+(AA.nov_11*BB.nov_11)+(AA.dec_11*BB.dec_11) as total_2011,
		AA.jan_12*BB.jan_12 as jan_12,
		AA.feb_12*BB.feb_12 as feb_12,
		AA.mar_12*BB.mar_12 as mar_12,
		AA.apr_12*BB.apr_12 as apr_12,
		AA.may_12*BB.may_12 as may_12,
		AA.jun_12*BB.jun_12 as jun_12,
		AA.jul_12*BB.jul_12 as jul_12,
		AA.aug_12*BB.aug_12 as aug_12,
		AA.sep_12*BB.sep_12 as sep_12,
		AA.oct_12*BB.oct_12 as oct_12,
		AA.nov_12*BB.nov_12 as nov_12,
		AA.dec_12*BB.dec_12 as dec_12,
		(AA.jan_12*BB.JAN_12)+(AA.feb_12*BB.feb_12)+(AA.mar_12*BB.mar_12)+(AA.apr_12*BB.apr_12)+(AA.may_12*BB.may_12)+(AA.jun_12*BB.jun_12)+(AA.jul_12*BB.jul_12)+(AA.aug_12*BB.aug_12)+(AA.sep_12*BB.sep_12)+(AA.oct_12*BB.oct_12)+(AA.nov_12*BB.nov_12)+(AA.dec_12*BB.dec_12) as total_2012,
		AA.cal13*BB.cal13 as total_2013,
		AA.cal14*BB.cal14 as total_2014,
		AA.cal15*BB.cal15 as total_2015,
		AA.cal16*BB.cal16 as total_2016
from 
		(	select	a.BASE_PART, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.jan_08) as jan_08, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.feb_08) as feb_08, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.mar_08) as mar_08, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.apr_08) as apr_08, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.may_08) as may_08, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.jun_08) as jun_08, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.jul_08) as jul_08, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.aug_08) as aug_08, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.sep_08) as sep_08, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.oct_08) as oct_08, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.nov_08) as nov_08, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.dec_08) as dec_08, 
					sum(a.qty_per*a.take_rate*a.family_allocation*(b.jan_08+b.feb_08+b.mar_08+b.apr_08+b.may_08+b.jun_08+b.jul_08+b.aug_08+b.sep_08+b.oct_08+b.nov_08+b.dec_08)) as total_2008,
					sum(a.qty_per*a.take_rate*a.family_allocation*b.jan_09) as jan_09, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.feb_09) as feb_09, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.mar_09) as mar_09, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.apr_09) as apr_09, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.may_09) as may_09, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.jun_09) as jun_09, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.jul_09) as jul_09, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.aug_09) as aug_09, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.sep_09) as sep_09, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.oct_09) as oct_09, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.nov_09) as nov_09, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.dec_09) as dec_09, 
					sum(a.qty_per*a.take_rate*a.family_allocation*(b.jan_09+b.feb_09+b.mar_09+b.apr_09+b.may_09+b.jun_09+b.jul_09+b.aug_09+b.sep_09+b.oct_09+b.nov_09+b.dec_09)) as total_2009,
					sum(a.qty_per*a.take_rate*a.family_allocation*b.jan_10) as jan_10, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.feb_10) as feb_10, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.mar_10) as mar_10, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.apr_10) as apr_10, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.may_10) as may_10, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.jun_10) as jun_10, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.jul_10) as jul_10, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.aug_10) as aug_10, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.sep_10) as sep_10, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.oct_10) as oct_10, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.nov_10) as nov_10, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.dec_10) as dec_10, 
					sum(a.qty_per*a.take_rate*a.family_allocation*(b.jan_10+b.feb_10+b.mar_10+b.apr_10+b.may_10+b.jun_10+b.jul_10+b.aug_10+b.sep_10+b.oct_10+b.nov_10+b.dec_10)) as total_2010,
					sum(a.qty_per*a.take_rate*a.family_allocation*b.jan_11) as jan_11, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.feb_11) as feb_11, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.mar_11) as mar_11, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.apr_11) as apr_11, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.may_11) as may_11, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.jun_11) as jun_11, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.jul_11) as jul_11, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.aug_11) as aug_11, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.sep_11) as sep_11, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.oct_11) as oct_11, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.nov_11) as nov_11, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.dec_11) as dec_11, 
					sum(a.qty_per*a.take_rate*a.family_allocation*(b.jan_11+b.feb_11+b.mar_11+b.apr_11+b.may_11+b.jun_11+b.jul_11+b.aug_11+b.sep_11+b.oct_11+b.nov_11+b.dec_11)) as total_2011,
					sum(a.qty_per*a.take_rate*a.family_allocation*b.jan_12) as jan_12, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.feb_12) as feb_12, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.mar_12) as mar_12, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.apr_12) as apr_12, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.may_12) as may_12, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.jun_12) as jun_12, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.jul_12) as jul_12, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.aug_12) as aug_12, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.sep_12) as sep_12, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.oct_12) as oct_12, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.nov_12) as nov_12, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.dec_12) as dec_12, 
					sum(a.qty_per*a.take_rate*a.family_allocation*(b.jan_12+b.feb_12+b.mar_12+b.apr_12+b.may_12+b.jun_12+b.jul_12+b.aug_12+b.sep_12+b.oct_12+b.nov_12+b.dec_12)) as total_2012,
					sum(a.qty_per*a.take_rate*a.family_allocation*b.cal13) as cal13, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.cal14) as cal14, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.cal15) as cal15, 
					sum(a.qty_per*a.take_rate*a.family_allocation*b.cal16) as cal16
			from 
					(	select	* 
						from	eeiuser.acctg_csm_base_part_mnemonic
					) a 
					left outer join 
					(	select	* 
						from	eeiuser.acctg_csm_NACSM 
						where	release_id = @release_id
							and VERSION = 'CSM'
					) b
					on a.mnemonic = b.mnemonic 
					where	a.base_part = @base_part 
					group by base_part
						

		) AA
		join
		(	select	a.base_part, 
					b.jan_08, 
					b.feb_08, 
					b.mar_08, 
					b.apr_08, 
					b.may_08, 
					b.jun_08, 
					b.jul_08, 
					b.aug_08, 
					b.sep_08, 
					b.oct_08, 
					b.nov_08, 
					b.dec_08, 
					b.jan_09, 
					b.feb_09, 
					b.mar_09, 
					b.apr_09, 
					b.may_09, 
					b.jun_09, 
					b.jul_09, 
					b.aug_09, 
					b.sep_09, 
					b.oct_09, 
					b.nov_09, 
					b.dec_09, 
					b.jan_10, 
					b.feb_10, 
					b.mar_10, 
					b.apr_10, 
					b.may_10, 
					b.jun_10, 
					b.jul_10, 
					b.aug_10, 
					b.sep_10, 
					b.oct_10, 
					b.nov_10, 
					b.dec_10, 
					b.jan_11, 
					b.feb_11, 
					b.mar_11, 
					b.apr_11, 
					b.may_11, 
					b.jun_11, 
					b.jul_11, 
					b.aug_11, 
					b.sep_11, 
					b.oct_11, 
					b.nov_11, 
					b.dec_11, 
					b.jan_12, 
					b.feb_12, 
					b.mar_12, 
					b.apr_12, 
					b.may_12, 
					b.jun_12, 
					b.jul_12, 
					b.aug_12, 
					b.sep_12, 
					b.oct_12, 
					b.nov_12, 
					b.dec_12, 
					b.cal13, 
					b.cal14, 
					b.cal15, 
					b.cal16	
			from 
					(	select	* 
						from	eeiuser.acctg_csm_base_part_mnemonic
					) a 
					join 
					(	select	* 
						from	eeiuser.acctg_csm_NACSM 
						where	release_id = @release_id
							and VERSION = 'Empire Factor'
					) b
					on a.mnemonic = b.mnemonic 
					where	a.base_part = @base_part
		) BB
on AA.base_part = BB.base_part


GO
