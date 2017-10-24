declare
	@oldDT datetime = '2008-02-07 10:00:22.303'
,	@newDT datetime = '2008-02-07 10:00:22.303'

create table
	#PSHold
(	Part varchar(25) null
,	Price numeric(20, 6) null
,	Cost numeric(20, 6) null
,	Material numeric(20, 6) null
,	Labor numeric(20, 6) null
,	Burden numeric(20, 6) null
,	CostAccum numeric(20, 6) null
,	MaterialAccum numeric(20, 6) null
,	LaborAccum numeric(20, 6) null
,	BurdenAccum numeric(20, 6) null
,	PlannedCost numeric(20, 6) null
,	PlannedMaterial numeric(20, 6) null
,	PlannedLabor numeric(20, 6) null
,	PlannedBurden numeric(20, 6) null
,	PlannedCostAccum numeric(20, 6) null
,	PlannedMaterialAccum numeric(20, 6) null
,	PlannedLaborAccum numeric(20, 6) null
,	PlannedBurdenAccum numeric(20, 6) null
,	BinCheckSum int
)

insert
	#PSHold
(	Part
,	Price
,	Cost
,	Material
,	Labor
,	Burden
,	CostAccum
,	MaterialAccum
,	LaborAccum
,	BurdenAccum
,	PlannedCost
,	PlannedMaterial
,	PlannedLabor
,	PlannedBurden
,	PlannedCostAccum
,	PlannedMaterialAccum
,	PlannedLaborAccum
,	PlannedBurdenAccum
)
select
	fcpss.Part
,   fcpss.Price
,   fcpss.Cost
,   fcpss.Material
,   fcpss.Labor
,   fcpss.Burden
,   fcpss.CostAccum
,   fcpss.MaterialAccum
,   fcpss.LaborAccum
,   fcpss.BurdenAccum
,   fcpss.PlannedCost
,   fcpss.PlannedMaterial
,   fcpss.PlannedLabor
,   fcpss.PlannedBurden
,   fcpss.PlannedCostAccum
,   fcpss.PlannedMaterialAccum
,   fcpss.PlannedLaborAccum
,   fcpss.PlannedBurdenAccum
from
	FT.Costing_PartStandardHistorical(null, @oldDT) fcpss

create table
	#PSHNew
(	Part varchar(25) null
,	Price numeric(20, 6) null
,	Cost numeric(20, 6) null
,	Material numeric(20, 6) null
,	Labor numeric(20, 6) null
,	Burden numeric(20, 6) null
,	CostAccum numeric(20, 6) null
,	MaterialAccum numeric(20, 6) null
,	LaborAccum numeric(20, 6) null
,	BurdenAccum numeric(20, 6) null
,	PlannedCost numeric(20, 6) null
,	PlannedMaterial numeric(20, 6) null
,	PlannedLabor numeric(20, 6) null
,	PlannedBurden numeric(20, 6) null
,	PlannedCostAccum numeric(20, 6) null
,	PlannedMaterialAccum numeric(20, 6) null
,	PlannedLaborAccum numeric(20, 6) null
,	PlannedBurdenAccum numeric(20, 6) null
,	BinCheckSum int
)

insert
	#PSHNew
(	Part
,	Price
,	Cost
,	Material
,	Labor
,	Burden
,	CostAccum
,	MaterialAccum
,	LaborAccum
,	BurdenAccum
,	PlannedCost
,	PlannedMaterial
,	PlannedLabor
,	PlannedBurden
,	PlannedCostAccum
,	PlannedMaterialAccum
,	PlannedLaborAccum
,	PlannedBurdenAccum
)
select
	Part = psh.part
,   Price = psh.price
,   Cost = psh.cost
,   Material = psh.material
,   Labor = psh.labor
,   Burden = psh.burden
,   CostAccum = psh.cost_cum
,   MaterialAccum = psh.material_cum
,   LaborAccum = psh.labor_cum
,   BurdenAccum = psh.burden_cum
,   PlannedCost = psh.planned_cost
,   PlannedMaterial = psh.planned_material
,   PlannedLabor = psh.planned_labor
,   PlannedBurden = psh.planned_burden
,   PlannedCostAccum = psh.planned_cost_cum
,   PlannedMaterialAccum = psh.planned_material_cum
,   PlannedLaborAccum = psh.planned_labor_cum
,   PlannedBurdenAccum = psh.planned_burden_cum
from
	dbo.part_standard_historical psh
where
	psh.time_stamp = @newDT
order by
	psh.time_stamp
,	psh.part

update
	pn
set	BinCheckSum = binary_checksum(*)
from
	#PSHNew pn

update
	po
set	BinCheckSum = binary_checksum(*)
from
	#PSHOld po

select
	TranType = case when po.part is null then 'I' when pn.part is null then 'D' else 'U' end
,	PartCode = coalesce(pn.Part, po.Part)
,   po.Price
,   po.Cost
,   po.Material
,   po.Labor
,   po.Burden
,   po.CostAccum
,   po.MaterialAccum
,   po.LaborAccum
,   po.BurdenAccum
,   pn.Price
,   pn.Cost
,   pn.Material
,   pn.Labor
,   pn.Burden
,   pn.CostAccum
,   pn.MaterialAccum
,   pn.LaborAccum
,   pn.BurdenAccum
,   po.PlannedCost
,   po.PlannedMaterial
,   po.PlannedLabor
,   po.PlannedBurden
,   po.PlannedCostAccum
,   po.PlannedMaterialAccum
,   po.PlannedLaborAccum
,   po.PlannedBurdenAccum
,   pn.PlannedCost
,   pn.PlannedMaterial
,   pn.PlannedLabor
,   pn.PlannedBurden
,   pn.PlannedCostAccum
,   pn.PlannedMaterialAccum
,   pn.PlannedLaborAccum
,   pn.PlannedBurdenAccum
from
	#PSHNew pn
	full join #PSHOld po
		on pn.Part = po.Part
where
	coalesce(pn.BinCheckSum, -1) != coalesce(po.BinCheckSum, -1)

drop table
	#PSHNew

drop table
	#PSHOld
