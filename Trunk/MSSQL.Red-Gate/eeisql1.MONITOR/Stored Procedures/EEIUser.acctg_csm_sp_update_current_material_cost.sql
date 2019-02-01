SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[acctg_csm_sp_update_current_material_cost] (@release_id varchar(10))

as


-- exec eeiuser.acctg_csm_sp_update_current_material_cost '2018-08'

-- for testing:  DECLARE @release_id varchar(10) = '2018-04'

IF OBJECT_ID('tempdb...#a') IS NOT NULL
DROP TABLE #a


create table #a 
( base_part1 varchar(25),
  base_part2 varchar(25), 
  part varchar(25), 
  currentrevlevel varchar(1), 
  eeh_part varchar(25), 
  eeh_material_cum decimal(18,6),
  eei_part varchar(25),
  eei_product_line varchar(25),
  eei_frozen_material_cum decimal(18,6),
  material_cum decimal(18,6)
)


-- 1. Get current costs from EEH or from EEI (in the case of bulbed parts)

insert into #a

select	base_part1, 
		base_part2, 
		part, 
		currentrevlevel, 
		eeh_part, 
		eeh_material_cum, 
		eei_part, 
		eei_product_line, 
		eei_frozen_material_cum,
		(case when eei_product_line in ('Bulbed Wire Harn - EEH','Bulbed ES3 Components') then eei_frozen_material_cum else eeh_material_cum end)

from 

	(select distinct(BASE_PART) as base_part1 from eeiuser.acctg_csm_base_part_mnemonic) a
 
	left join  (select left(part,7) as base_part2, part, CurrentRevLevel from part_eecustom where CurrentRevLevel = 'Y') b
	on a.base_part1 = b.base_part2

	left join (select part as eeh_part, material_cum as eeh_material_cum from eehsql1.eeh.dbo.part_standard) c
	on b.part = c.eeh_part

	left join (select part_standard.part as eei_part, product_line as eei_product_line, frozen_material_cum as eei_frozen_material_cum  from part_standard join part on part_standard.part = part.part) d
	on b.part = d.eei_part


-- 2. Only delete rows from the MSF where eeh costs exist.  For parts where an EEH costs does not exist, we will maintain the previously input quoted material cost.

delete from eeiuser.acctg_csm_material_cost_tabular where release_id = @release_id and base_part in (select base_part1 from #a where isnull(eeh_part,'') <> '')


-- 3. Insert the new costs into the MSF tables

Insert into eeiuser.acctg_csm_material_cost_tabular (release_id, row_id, base_part, version, inclusion, partusedforcost, 
jan_12, feb_12, mar_12, apr_12, may_12, jun_12, jul_12, aug_12, sep_12, oct_12, nov_12, dec_12, 
jan_13, feb_13, mar_13, apr_13, may_13, jun_13, jul_13, aug_13, sep_13, oct_13, nov_13, dec_13, 
jan_14, feb_14, mar_14, apr_14, may_14, jun_14, jul_14, aug_14, sep_14, oct_14, nov_14, dec_14, 
jan_15, feb_15, mar_15, apr_15, may_15, jun_15, jul_15, aug_15, sep_15, oct_15, nov_15, dec_15, 
jan_16, feb_16, mar_16, apr_16, may_16, jun_16, jul_16, aug_16, sep_16, oct_16, nov_16, dec_16, 
jan_17, feb_17, mar_17, apr_17, may_17, jun_17, jul_17, aug_17, sep_17, oct_17, nov_17, dec_17,
jan_18, feb_18, mar_18, apr_18, may_18, jun_18, jul_18, aug_18, sep_18, oct_18, nov_18, dec_18,
jan_19, feb_19, mar_19, apr_19, may_19, jun_19, jul_19, aug_19, sep_19, oct_19, nov_19, dec_19,
jan_20, feb_20, mar_20, apr_20, may_20, jun_20, jul_20, aug_20, sep_20, oct_20, nov_20, dec_20,
dec_21,
dec_22,
dec_23,
dec_24,
dec_25)

select @release_id, 1, base_part1, 'Current Cost 2018-10-08', 'Y', eeh_part, 
material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, --2012
material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, --2013
material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, --2014
material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, --2015
material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, --2016
material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, --2017
material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, --2018
material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, --2019
material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, material_cum, --2020
material_cum, --2021
material_cum, --2022
material_cum, --2023
material_cum, --2024
material_cum  --2025
from #a
where isnull(eeh_part,'') <> ''



GO
