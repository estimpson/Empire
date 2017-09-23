SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE procedure [EEIUser].[acctg_csm_sp_update_current_material_cost] (@release_id varchar(10))

-- exec eeiuser.acctg_csm_sp_update_current_material_cost '2017-08'


as

create table #a 
( base_part1 varchar(25),
  base_part2 varchar(25), 
  part1 varchar(25), 
  currentrevlevel varchar(1), 
  part2 varchar(25), 
  material_cum decimal(18,6)
)


insert into #a
select * from 

(select distinct(BASE_PART) base_part from eeiuser.acctg_csm_base_part_mnemonic) a
 left join

(select left(part,7)as base_part, part, CurrentRevLevel from part_eecustom where CurrentRevLevel = 'Y') b

on a.base_part = b.base_part

left join

(select part, material_cum from eehsql1.eeh.dbo.part_standard ) c

on b.part = c.part

delete from eeiuser.acctg_csm_material_cost_tabular where release_id = @release_id and base_part in (select base_part1 from #a)

Insert into eeiuser.acctg_csm_material_cost_tabular (release_id, row_id, base_part, version, inclusion, partusedforcost, 
jan_12, feb_12, mar_12, apr_12, may_12, jun_12, jul_12, aug_12, sep_12, oct_12, nov_12, dec_12, 
jan_13, feb_13, mar_13, apr_13, may_13, jun_13, jul_13, aug_13, sep_13, oct_13, nov_13, dec_13, 
jan_14, feb_14, mar_14, apr_14, may_14, jun_14, jul_14, aug_14, sep_14, oct_14, nov_14, dec_14, 
jan_15, feb_15, mar_15, apr_15, may_15, jun_15, jul_15, aug_15, sep_15, oct_15, nov_15, dec_15, 
jan_16, feb_16, mar_16, apr_16, may_16, jun_16, jul_16, aug_16, sep_16, oct_16, nov_16, dec_16, 
jan_17, feb_17, mar_17, apr_17, may_17, jun_17, jul_17, aug_17, sep_17, oct_17, nov_17, dec_17,
jan_18, feb_18, mar_18, apr_18, may_18, jun_18, jul_18, aug_18, sep_18, oct_18, nov_18, dec_18,
jan_19, feb_19, mar_19, apr_19, may_19, jun_19, jul_19, aug_19, sep_19, oct_19, nov_19, dec_19,
dec_20,
dec_21,
dec_22,
dec_23,
dec_24)

select @release_id,1, base_part1, 'Current Cost 2017-08-21', 'Y', part2, 
material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, --2012
material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, --2013
material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, --2014
material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, --2015
material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, --2016
material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, --2017
material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, --2018
material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, --2019
material_cum, --2020
material_cum, --2021
material_cum, --2022
material_cum, --2023
material_cum  --2024
from #a



GO
