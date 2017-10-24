SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure  [EEIUser].[OBS_acctg_cogs]
as

CREATE TABLE A# (part varchar(25), material_cum decimal(18,6))
insert into A#
select part, material_cum from [EEHSQL1].[monitor].[dbo].part_standard_historical where fiscal_year = '2009' and period = 1 and reason = 'MONTH END' and part in 
(select distinct(part_original) from shipper_detail join shipper on shipper_detail.shipper = shipper.id where shipper.date_shipped >= '2009-01-01' and shipper.date_shipped < '2009-02-01')

CREATE TABLE B# (part varchar(25), material_cum decimal(18,6))
insert into B#
select part, material_cum from [EEHSQL1].[monitor].[dbo].part_standard_historical where fiscal_year = '2008' and period = 1 and reason = 'MONTH END' and part in 
(select distinct(part_original) from shipper_detail join shipper on shipper_detail.shipper = shipper.id where shipper.date_shipped >= '2008-01-01' and shipper.date_shipped < '2008-02-01')

select ISNULL(AA.base_part, BB.base_part) as basepart, sum(AA.qty_packed) as qty_packed ,sum(AA.ext_sales) as ext_sales, sum(AA.ext_material) as ext_material, sum(BB.qty_packed) as qty_packed_yrago, sum(BB.ext_sales) as ext_sales_yrago, sum(BB.ext_material) as ext_material_yrago from
(
select left(part_original,7) as base_part, part_original, shipper.date_shipped, qty_packed, alternate_price, qty_packed*alternate_price as ext_sales, A#.material_cum, qty_packed*A#.material_cum as ext_material
from shipper_detail 
join shipper on shipper_detail.shipper = shipper.id
left join A# on shipper_detail.part_original = A#.part
where shipper.date_shipped >= '2009-02-01' and shipper.date_shipped < '2009-03-01') AA

full outer join
(
select left(part_original,7) as base_part, part_original, shipper.date_shipped, qty_packed, alternate_price, qty_packed*alternate_price as ext_sales, B#.material_cum, qty_packed*B#.material_cum as ext_material 
from shipper_detail 
join shipper on shipper_detail.shipper = shipper.id
left join B# on shipper_detail.part_original = B#.part
where shipper.date_shipped >= '2008-02-01' and shipper.date_shipped < '2008-03-01') BB

on AA.part_original = BB.part_original

group by ISNULL(AA.base_part, BB.base_part)

drop table A#
drop table B#


GO
