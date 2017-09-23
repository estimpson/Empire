begin transaction
go
truncate table
	FT.Costing_PartStandardSnapshots

truncate table
	FT.Costing_PartStandardHistoricalSnapshotDelta

truncate table
	FT.COSTING_Snapshots_PS


declare
	@timeStamp datetime = '2005-01-01'
,	@source sysname
,	@lastTimeStamp datetime
,	@lastSource sysname

select
	@timeStamp =
		case when coalesce(psh.NextTimeStamp, pshd.NextTimeStamp) < coalesce(pshd.NextTimeStamp, psh.NextTimeStamp) then coalesce(psh.NextTimeStamp, pshd.NextTimeStamp) else coalesce(pshd.NextTimeStamp, psh.NextTimeStamp) end
,	@source =
		case when coalesce(psh.NextTimeStamp, pshd.NextTimeStamp) < coalesce(pshd.NextTimeStamp, psh.NextTimeStamp) then N'dbo.part_standard_historical' else N'dbo.part_standard_historical_daily' end
from
	(	select
			NextTimeStamp = min(psh.time_stamp)
		from
			dbo.part_standard_historical psh
		where
			psh.time_stamp > @timeStamp
	) psh
	full join
    (	select
			NextTimeStamp = min(pshd.time_stamp)
		from
			dbo.part_standard_historical_daily pshd
		where
			pshd.time_stamp > @timeStamp
	) pshd on 1 = 1

select
	@timeStamp
,	@source
,	@lastTimeStamp
,	@lastSource

declare
	@nextSnapshot table
(	Part varchar(25) primary key
,	Price numeric(20,6)
,	Cost numeric(20,6)
,	Material numeric(20,6)
,	Labor numeric(20,6)
,	Burden numeric(20,6)
,	CostAccum numeric(20,6)
,	MaterialAccum numeric(20,6)
,	LaborAccum numeric(20,6)
,	BurdenAccum numeric(20,6)
)

insert
	@nextSnapshot
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
)
select
	Part = psh.part
,	Price = psh.price
,	Cost = psh.cost
,	Material = psh.material
,	Labor = psh.labor
,	Burden = psh.burden
,	CostAccum = psh.cost_cum
,	MaterialAccum = psh.material_cum
,	LaborAccum = psh.labor_cum
,	BurdenAccum = psh.burden_cum
from
	dbo.part_standard_historical psh
where
	psh.time_stamp = @timeStamp
	and @source = 'dbo.part_standard_historical'
union all
select
	Part = pshd.part
,	Price = pshd.price
,	Cost = pshd.cost
,	Material = pshd.material
,	Labor = pshd.labor
,	Burden = pshd.burden
,	CostAccum = pshd.cost_cum
,	MaterialAccum = pshd.material_cum
,	LaborAccum = pshd.labor_cum
,	BurdenAccum = pshd.burden_cum
from
	dbo.part_standard_historical_daily pshd
where
	pshd.time_stamp = @timeStamp
	and @source = 'dbo.part_standard_historical_daily'

declare
	@lastSnapshot table
(	Part varchar(25) primary key
,	Price numeric(20,6)
,	Cost numeric(20,6)
,	Material numeric(20,6)
,	Labor numeric(20,6)
,	Burden numeric(20,6)
,	CostAccum numeric(20,6)
,	MaterialAccum numeric(20,6)
,	LaborAccum numeric(20,6)
,	BurdenAccum numeric(20,6)
)

declare
	@maxIterations int = 30

while
	@maxIterations > 0 begin
    
	set @maxIterations -= 1

	delete
		@lastSnapShot
	  
	insert
		@lastSnapshot
	select
		*
	from
		@nextSnapshot

	set	@lastSource = @source
	set @lastTimeStamp = @timeStamp

	select
		@timeStamp =
			case when coalesce(psh.NextTimeStamp, pshd.NextTimeStamp) < coalesce(pshd.NextTimeStamp, psh.NextTimeStamp) then coalesce(psh.NextTimeStamp, pshd.NextTimeStamp) else coalesce(pshd.NextTimeStamp, psh.NextTimeStamp) end
	,	@source =
			case when coalesce(psh.NextTimeStamp, pshd.NextTimeStamp) < coalesce(pshd.NextTimeStamp, psh.NextTimeStamp) then N'dbo.part_standard_historical' else N'dbo.part_standard_historical_daily' end
	from
		(	select
				NextTimeStamp = min(psh.time_stamp)
			from
				dbo.part_standard_historical psh
			where
				psh.time_stamp > @timeStamp
		) psh
		full join
		(	select
				NextTimeStamp = min(pshd.time_stamp)
			from
				dbo.part_standard_historical_daily pshd
			where
				pshd.time_stamp > @timeStamp
		) pshd on 1 = 1

	select
		@timeStamp
	,	@source
	,	@lastTimeStamp
	,	@lastSource

	delete
		@nextSnapshot

	insert
		@nextSnapshot
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
	)
	select
		Part = psh.part
	,	Price = psh.price
	,	Cost = psh.cost
	,	Material = psh.material
	,	Labor = psh.labor
	,	Burden = psh.burden
	,	CostAccum = psh.cost_cum
	,	MaterialAccum = psh.material_cum
	,	LaborAccum = psh.labor_cum
	,	BurdenAccum = psh.burden_cum
	from
		dbo.part_standard_historical psh
	where
		psh.time_stamp = @timeStamp
		and @source = 'dbo.part_standard_historical'
	union all
	select
		Part = pshd.part
	,	Price = pshd.price
	,	Cost = pshd.cost
	,	Material = pshd.material
	,	Labor = pshd.labor
	,	Burden = pshd.burden
	,	CostAccum = pshd.cost_cum
	,	MaterialAccum = pshd.material_cum
	,	LaborAccum = pshd.labor_cum
	,	BurdenAccum = pshd.burden_cum
	from
		dbo.part_standard_historical_daily pshd
	where
		pshd.time_stamp = @timeStamp
		and @source = 'dbo.part_standard_historical_daily'
    
	/*	Capture delta. */
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
	)
	select
		SnapshotDT = @timeStamp
	,	TranType = case when ns.Part is null then 'D' when ls.Part is null then 'I' else 'U' end
	,	PartCode = coalesce(ns.Part, ls.Part)
	,	OldPrice = ls.Price
	,	OldCost = ls.Cost
	,	OldMaterial = ls.Material
	,	OldLabor = ls.Labor
	,	OldBurden = ls.Burden
	,	OldCostAccum = ls.CostAccum
	,	OldMaterialAccum = ls.MaterialAccum
	,	OldLaborAccum = ls.LaborAccum
	,	OldBurdenAccum = ls.BurdenAccum
	,	NewPrice = ns.Price
	,	NewCost = ns.Cost
	,	NewMaterial = ns.Material
	,	NewLabor = ns.Labor
	,	NewBurden = ns.Burden
	,	NewCostAccum = ns.CostAccum
	,	NewMaterialAccum = ns.MaterialAccum
	,	NewLaborAccum = ns.LaborAccum
	,	NewBurdenAccum = ns.BurdenAccum
	from
		@lastSnapshot ls
		full join @nextSnapshot ns
			on ns.Part = ls.Part
	where
		coalesce
		(	binary_checksum
			(	ls.Part
			,	ls.Price
			,	ls.Cost
			,	ls.Material
			,	ls.Labor
			,	ls.Burden
			,	ls.CostAccum
			,	ls.MaterialAccum
			,	ls.LaborAccum
			,	ls.BurdenAccum
			)
		,	-1
		) != coalesce
		(	binary_checksum
			(	ns.Part
			,	ns.Price
			,	ns.Cost
			,	ns.Material
			,	ns.Labor
			,	ns.Burden
			,	ns.CostAccum
			,	ns.MaterialAccum
			,	ns.LaborAccum
			,	ns.BurdenAccum
			)
		,	-1
		)

	/*	Keep year end, 3 most recent month ends, 7 most recent days. */
	if	datepart(year, @timeStamp) != datepart(year, @lastTimeStamp)
		or
		(	datepart(month, @timeStamp) != datepart(month, @lastTimeStamp)
			and @lastTimeStamp >= '2013-05-01'
		)
		or
		(	datepart(day, @timeStamp) != datepart(day, @lastTimeStamp)
			and @lastTimeStamp >= '2013-07-25'
		) begin
		
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
		)
		select
			SnapshotDT = @lastTimeStamp
		,	ns.Part
		,	ns.Price
		,	ns.Cost
		,	ns.Material
		,	ns.Labor
		,	ns.Burden
		,	ns.CostAccum
		,	ns.MaterialAccum
		,	ns.LaborAccum
		,	ns.BurdenAccum
		from
			@lastSnapshot ns
	end
  
end
go

select
	cpss.SnapshotDT
,	count(*)
from
	FT.Costing_PartStandardSnapshots cpss
group by
	cpss.SnapshotDT

select
	*
from
	FT.Costing_PartStandardHistoricalSnapshotDelta cpshsd
go

rollback
go
