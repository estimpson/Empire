drop procedure FT.usp_Costing_RemovePartStandardHistoricalRedundancy
/*
insert
	FT.Costing_PartStandardSnapshots
(	SnapshotDT
,	Part
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
	SnapShotDT = psh.time_stamp
,   Part = psh.part
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
	psh.reason = 'MONTH END'
order by
	psh.time_stamp
,	psh.part

insert
	FT.COSTING_Snapshots_PS
(	SnapshotDT
,	Reason
)
select distinct
	SnapshotDT = psh.time_stamp
,	Reason = 'MONTH END'
from
	dbo.part_standard_historical psh
where
	psh.reason = 'MONTH END'
	--and psh.time_stamp > '2008-02-07 10:00:22.303'
order by
	psh.time_stamp

alter procedure FT.usp_Costing_RemovePartStandardHistoricalRedundancy
as
declare
	@NextSnapshotDT datetime
,	@NextDailySnapshotDT datetime

set	@NextSnapshotDT =
	(	select
			min(psh.time_stamp)
		from
			dbo.part_standard_historical psh
		where
			psh.time_stamp not in
				(	select
						SnapshotDT
					from
						FT.COSTING_Snapshots_PS
				)
	)

set	@NextDailySnapshotDT =
	(	select
			min(pshd.time_stamp)
		from
			dbo.part_standard_historical_daily pshd
		where
			pshd.time_stamp not in
				(	select
						SnapshotDT
					from
						FT.COSTING_Snapshots_PS
				)
	)

declare
	@SnapshotDT datetime
,	@Reason varchar(100)

--declare
--	#PSHNew table
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

if	@NextSnapshotDT is null
	and @NextDailySnapshotDT is null begin

	return
end

if	@NextSnapshotDT < @NextDailySnapshotDT or @NextDailySnapshotDT is null begin
	set @SnapshotDT = @NextSnapshotDT

	print 'Next psh snapshot: ' + convert(varchar, @SnapshotDT)

	set	@Reason =
		(	select
				min(psh.reason)
			from
				dbo.part_standard_historical psh
			where
				psh.time_stamp = @SnapshotDT
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
		psh.time_stamp = @SnapshotDT
	order by
		psh.time_stamp
	,	psh.part
end
else begin
	set @SnapshotDT = @NextDailySnapshotDT
	
	print 'Next pshd snapshot: ' + convert(varchar, @SnapshotDT)

	set	@Reason =
		(	select
				min(pshd.reason)
			from
				dbo.part_standard_historical_daily pshd
			where
				pshd.time_stamp = @SnapshotDT
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
		Part = pshd.part
	,   Price = pshd.price
	,   Cost = pshd.cost
	,   Material = pshd.material
	,   Labor = pshd.labor
	,   Burden = pshd.burden
	,   CostAccum = pshd.cost_cum
	,   MaterialAccum = pshd.material_cum
	,   LaborAccum = pshd.labor_cum
	,   BurdenAccum = pshd.burden_cum
	,   PlannedCost = pshd.planned_cost
	,   PlannedMaterial = pshd.planned_material
	,   PlannedLabor = pshd.planned_labor
	,   PlannedBurden = pshd.planned_burden
	,   PlannedCostAccum = pshd.planned_cost_cum
	,   PlannedMaterialAccum = pshd.planned_material_cum
	,   PlannedLaborAccum = pshd.planned_labor_cum
	,   PlannedBurdenAccum = pshd.planned_burden_cum
	from
		dbo.part_standard_historical_daily pshd
	where
		pshd.time_stamp = @SnapshotDT
	order by
		pshd.time_stamp
	,	pshd.part
end

--declare
--	#PSHOld table
create table
	#PSHOld
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
	#PSHOld
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
	FT.Costing_PartStandardHistorical.Part
,   FT.Costing_PartStandardHistorical.Price
,   FT.Costing_PartStandardHistorical.Cost
,   FT.Costing_PartStandardHistorical.Material
,   FT.Costing_PartStandardHistorical.Labor
,   FT.Costing_PartStandardHistorical.Burden
,   FT.Costing_PartStandardHistorical.CostAccum
,   FT.Costing_PartStandardHistorical.MaterialAccum
,   FT.Costing_PartStandardHistorical.LaborAccum
,   FT.Costing_PartStandardHistorical.BurdenAccum
,   FT.Costing_PartStandardHistorical.PlannedCost
,   FT.Costing_PartStandardHistorical.PlannedMaterial
,   FT.Costing_PartStandardHistorical.PlannedLabor
,   FT.Costing_PartStandardHistorical.PlannedBurden
,   FT.Costing_PartStandardHistorical.PlannedCostAccum
,   FT.Costing_PartStandardHistorical.PlannedMaterialAccum
,   FT.Costing_PartStandardHistorical.PlannedLaborAccum
,   FT.Costing_PartStandardHistorical.PlannedBurdenAccum
from
	FT.Costing_PartStandardHistorical (null, @NextSnapshotDT)

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
	*
from
	#PSHNew pn
where
	Part = 'POT-AUT0037-HB01'

select
	*
from
	#PSHOld po
where
	Part = 'POT-AUT0037-HB01'

create index ix_pshn_1 on #PSHNew (Part, BinCheckSum)
create index ix_psho_1 on #PSHOld (Part, BinCheckSum)

insert
	FT.Costing_PartStandardHistoricalSnapshotDelta
(	SnapshotDT
,	TranType
,	PartCode
,	OldPrice
,	OldCost
,	OldMaterial
,	OldLabor
,	OldBurden
,	OldCostAccum
,	OldMaterialAccum
,	OldLaborAccum
,	OldBurdenAccum
,	NewPrice
,	NewCost
,	NewMaterial
,	NewLabor
,	NewBurden
,	NewCostAccum
,	NewMaterialAccum
,	NewLaborAccum
,	NewBurdenAccum
,	OldPlannedCost
,	OldPlannedMaterial
,	OldPlannedLabor
,	OldPlannedBurden
,	OldPlannedCostAccum
,	OldPlannedMaterialAccum
,	OldPlannedLaborAccum
,	OldPlannedBurdenAccum
,	NewPlannedCost
,	NewPlannedMaterial
,	NewPlannedLabor
,	NewPlannedBurden
,	NewPlannedCostAccum
,	NewPlannedMaterialAccum
,	NewPlannedLaborAccum
,	NewPlannedBurdenAccum
)
select
	SnapshotDT = @SnapshotDT
,	TranType = case when po.part is null then 'I' when pn.part is null then 'D' else 'U' end
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

insert
	FT.COSTING_Snapshots_PS
(	SnapshotDT
,	Reason
)
select
	SnapshotDT = @SnapshotDT
,	Reason = @Reason

drop table
	#PSHNew

drop table
	#PSHOld
go
*/

declare
	@startDT datetime = getdate()

while
	getdate() < dateadd(minute, 10, @startDT) begin

	execute FT.usp_Costing_RemovePartStandardHistoricalRedundancy

	print @@ROWCOUNT
end


select
	csp.SnapshotDT
,   csp.Reason
,	Rows =
		(	select
				count(*)
			from
				FT.Costing_PartStandardHistoricalSnapshotDelta cpshsd
			where
				cpshsd.SnapshotDT = csp.SnapshotDT
		)
from
	FT.COSTING_Snapshots_PS csp
