
drop function FT.[Costing_PartStandardHistorical;bak]
(	@PartCode varchar(25) = null
,	@TimeStamp datetime
)
returns @Costing_PartStandardHistorical table
(	SnapShopDT datetime
,	Reason varchar(100)
,	Part varchar(25) primary key
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
)
as
begin
--- <Body>
	declare
		@CPSSnapshotDT datetime
	,	@CPSDSnapshotDT datetime
    
	/*	Find the closest snapshot. */
	set	@CPSSnapshotDT =
			(	select
					max(cpss.SnapshotDT)
				from
					FT.Costing_PartStandardSnapshots cpss
				where
					cpss.SnapshotDT <= @TimeStamp
			)

	declare
		@partList table
	(	PartCode varchar(25) primary key
	,	TranDT datetime
	)

	insert
		@partList
	select
		PartCode = cpss.Part
	,	TranDT = cpshsd.SnapshotDT
	from
		FT.Costing_PartStandardSnapshots cpss
		left join FT.Costing_PartStandardHistoricalSnapshotDelta cpshsd
			on cpshsd.PartCode = cpss.Part
			and cpshsd.SnapshotDT =
				(	select
						max(cpshsd.SnapshotDT)
					from
						FT.Costing_PartStandardHistoricalSnapshotDelta cpshsd
					where
						cpshsd.PartCode = cpss.Part
						and cpshsd.SnapshotDT between @CPSSnapshotDT and @TimeStamp
				)
	where
		cpss.SnapshotDT = @CPSSnapshotDT
		and coalesce(cpshsd.TranType, 'X') != 'D'
	union all
	select
		PartCode = cpshsdInserts.PartCode
	,	TranDT = cpshsd.SnapshotDT
	from
		FT.Costing_PartStandardHistoricalSnapshotDelta cpshsdInserts
		left join FT.Costing_PartStandardHistoricalSnapshotDelta cpshsd
			on cpshsd.PartCode = cpshsdInserts.PartCode
			and cpshsd.SnapshotDT =
				(	select
						max(cpshsd.SnapshotDT)
					from
						FT.Costing_PartStandardHistoricalSnapshotDelta cpshsd
					where
						cpshsd.PartCode = cpshsdInserts.PartCode
						and cpshsd.SnapshotDT between @CPSSnapshotDT and @TimeStamp
				)
	where
		cpshsdInserts.SnapshotDT between @CPSSnapshotDT and @TimeStamp
		and cpshsdInserts.TranType = 'I'
		and coalesce(cpshsd.TranType, 'X') != 'D'

	insert
		@Costing_PartStandardHistorical
	(	SnapShopDT 
	,	Reason 
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
		SnapShopDT = csp.SnapshotDT
	,	Reason = csp.Reason
	,	Part = pl.PartCode
	,	Price = coalesce(cpshsd.NewPrice, cpss.Price)
	,	Cost = coalesce(cpshsd.NewCost, cpss.Cost)
	,	Material = coalesce(cpshsd.NewMaterial, cpss.Material)
	,	Labor = coalesce(cpshsd.NewLabor, cpss.Labor)
	,	Burden = coalesce(cpshsd.NewBurden, cpss.Burden)
	,	CostAccum = coalesce(cpshsd.NewCostAccum, cpss.CostAccum)
	,	MaterialAccum = coalesce(cpshsd.NewMaterialAccum, cpss.MaterialAccum)
	,	LaborAccum = coalesce(cpshsd.NewLaborAccum, cpss.LaborAccum)
	,	BurdenAccum = coalesce(cpshsd.NewBurdenAccum, cpss.BurdenAccum)
	,	PlannedCost = coalesce(cpshsd.NewPlannedCost, cpss.PlannedCost)
	,	PlannedMaterial = coalesce(cpshsd.NewPlannedMaterial, cpss.PlannedMaterial)
	,	PlannedLabor = coalesce(cpshsd.NewPlannedLabor, cpss.PlannedLabor)
	,	PlannedBurden = coalesce(cpshsd.NewPlannedBurden, cpss.PlannedBurden)
	,	PlannedCostAccum = coalesce(cpshsd.NewPlannedCostAccum, cpss.PlannedCostAccum)
	,	PlannedMaterialAccum = coalesce(cpshsd.NewPlannedMaterialAccum, cpss.PlannedMaterialAccum)
	,	PlannedLaborAccum = coalesce(cpshsd.NewPlannedLaborAccum, cpss.PlannedLaborAccum)
	,	PlannedBurdenAccum = coalesce(cpshsd.NewPlannedBurdenAccum, cpss.PlannedBurdenAccum)
	from
		@partList pl
		left join FT.Costing_PartStandardHistoricalSnapshotDelta cpshsd
			on cpshsd.PartCode = pl.PartCode
			and cpshsd.SnapshotDT = pl.TranDT
		left join FT.Costing_PartStandardSnapshots cpss
			on cpss.Part = pl.PartCode
			and cpss.SnapshotDT = @CPSSnapshotDT
			and cpshsd.PartCode is null
		join FT.COSTING_Snapshots_PS csp
			on csp.SnapshotDT =
				(	select
						max(csp.SnapshotDT)
					from
						FT.COSTING_Snapshots_PS csp
					where
						csp.SnapshotDT <= @TimeStamp
				)
	where
		coalesce(cpshsd.TranType, 'X') != 'D'
--- </Body>

---	<Return>
	return
end
GO

select
	*
from
	FT.Costing_PartStandardHistorical (null, '2007-10-05 00:00:01.590') cpsh
where
	cpsh.Part = '1019906-WB00-STAN'