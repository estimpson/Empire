
/*
Create Procedure.EEH.FT.usp_Costing_CalculatePartStandardHistorical.sql
*/

use EEH
go

if	objectproperty(object_id('FT.usp_Costing_CalculatePartStandardHistorical'), 'IsProcedure') = 1 begin
	drop procedure FT.usp_Costing_CalculatePartStandardHistorical
end
go

create procedure FT.usp_Costing_CalculatePartStandardHistorical
	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings off
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. FT.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>

declare
	@snapshotDT datetime
,	@reason varchar(50)
,	@snapshotRowID int

select top 1
	@snapshotDT = csp.SnapshotDT
,	@reason = csp.Reason
,	@snapshotRowID = csp.RowID
from
	FT.Costing_Snapshots_PS csp
where
	SnapshotDT >
		(	select
				coalesce(max(csp.SnapshotDT), '2000-01-01')
			from
				FT.Costing_PartStandardHistorical cpsh
				join FT.Costing_Snapshots_PS csp
					on cpsh.LastSnapshotRowID = csp.RowID
		)
order by
	1
,	2

if	@snapshotDT is null return

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

if	@reason = 'DAILY' begin

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
		pshd.time_stamp = @snapshotDT
		and pshd.reason = @reason
	order by
		pshd.part
end
if	not exists
	(	select
			*
		from
			#PSHNew pn
	) begin

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
		dbo.part_standard_historical pshd
	where
		pshd.time_stamp = @snapshotDT
		and pshd.reason = @reason
	order by
		pshd.part
end

if	not exists
	(	select
			*
		from
			#PSHNew pn
	) begin

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
		pshd.time_stamp = @snapshotDT
		and pshd.reason = @reason
	order by
		pshd.part
end

update
	pn
set	BinCheckSum = binary_checksum(*)
--		(	pn.Part
--		,   pn.Price
--		,   pn.Cost
--		,   pn.Material
--		,   pn.Labor
--		,   pn.Burden
--		,   pn.CostAccum
--		,   pn.MaterialAccum
--		,   pn.LaborAccum
--		,   pn.BurdenAccum
--		,   pn.PlannedCost
--		,   pn.PlannedMaterial
--		,   pn.PlannedLabor
--		,   pn.PlannedBurden
--		,   pn.PlannedCostAccum
--		,   pn.PlannedMaterialAccum
--		,   pn.PlannedLaborAccum
--		,   pn.PlannedBurdenAccum
--		)
from
	#PSHNew pn

create index ix_#PSHNew_1 on #PSHNew (Part, BinCheckSum)

insert
	FT.Costing_PartStandardHistorical
select
	pn.Part
,	BeginDT = @snapshotDT
,	EndDT = @snapshotDT
,   pn.Price
,   pn.Cost
,   pn.Material
,   pn.Labor
,   pn.Burden
,   pn.CostAccum
,   pn.MaterialAccum
,   pn.LaborAccum
,   pn.BurdenAccum
,   pn.PlannedCost
,   pn.PlannedMaterial
,   pn.PlannedLabor
,   pn.PlannedBurden
,   pn.PlannedCostAccum
,   pn.PlannedMaterialAccum
,   pn.PlannedLaborAccum
,   pn.PlannedBurdenAccum
,   pn.BinCheckSum
,	LastSnapshotRowID = @snapshotRowID
from
	#PSHNew pn
	left join FT.Costing_PartStandardHistorical cpsh
		on cpsh.LastSnapshotRowID = @snapshotRowID - 1
		and cpsh.Part = pn.Part
where
	coalesce (cpsh.BinCheckSum, -1) != pn.BinCheckSum
	or coalesce (cpsh.Price, -1) != coalesce(pn.Price, -1)
	or coalesce (cpsh.Cost, -1) != coalesce(pn.Cost, -1)
	or coalesce (cpsh.Material, -1) != coalesce(pn.Material, -1)
	or coalesce (cpsh.Labor, -1) != coalesce(pn.Labor, -1)
	or coalesce (cpsh.Burden, -1) != coalesce(pn.Burden, -1)
	or coalesce (cpsh.CostAccum, -1) != coalesce(pn.CostAccum, -1)
	or coalesce (cpsh.MaterialAccum, -1) != coalesce(pn.MaterialAccum, -1)
	or coalesce (cpsh.LaborAccum, -1) != coalesce(pn.LaborAccum, -1)
	or coalesce (cpsh.BurdenAccum, -1) != coalesce(pn.BurdenAccum, -1)
	or coalesce (cpsh.PlannedCost, -1) != coalesce(pn.PlannedCost, -1)
	or coalesce (cpsh.PlannedMaterial, -1) != coalesce(pn.PlannedMaterial, -1)
	or coalesce (cpsh.PlannedLabor, -1) != coalesce(pn.PlannedLabor, -1)
	or coalesce (cpsh.PlannedBurden, -1) != coalesce(pn.PlannedBurden, -1)
	or coalesce (cpsh.PlannedCostAccum, -1) != coalesce(pn.PlannedCostAccum, -1)
	or coalesce (cpsh.PlannedMaterialAccum, -1) != coalesce(pn.PlannedMaterialAccum, -1)
	or coalesce (cpsh.PlannedLaborAccum, -1) != coalesce(pn.PlannedLaborAccum, -1)
	or coalesce (cpsh.PlannedBurdenAccum, -1) != coalesce(pn.PlannedBurdenAccum, -1)
order by
	1
,	2

update
	cpsh
set	EndDT = @snapshotDT
,	LastSnapshotRowID = @snapshotRowID
from
	#PSHNew pn
	left join FT.Costing_PartStandardHistorical cpsh
		on cpsh.LastSnapshotRowID = @snapshotRowID - 1
		and cpsh.Part = pn.Part
where
	coalesce (cpsh.BinCheckSum, -1) = pn.BinCheckSum
	and coalesce (cpsh.Price, -1) = coalesce(pn.Price, -1)
	and coalesce (cpsh.Cost, -1) = coalesce(pn.Cost, -1)
	and coalesce (cpsh.Material, -1) = coalesce(pn.Material, -1)
	and coalesce (cpsh.Labor, -1) = coalesce(pn.Labor, -1)
	and coalesce (cpsh.Burden, -1) = coalesce(pn.Burden, -1)
	and coalesce (cpsh.CostAccum, -1) = coalesce(pn.CostAccum, -1)
	and coalesce (cpsh.MaterialAccum, -1) = coalesce(pn.MaterialAccum, -1)
	and coalesce (cpsh.LaborAccum, -1) = coalesce(pn.LaborAccum, -1)
	and coalesce (cpsh.BurdenAccum, -1) = coalesce(pn.BurdenAccum, -1)
	and coalesce (cpsh.PlannedCost, -1) = coalesce(pn.PlannedCost, -1)
	and coalesce (cpsh.PlannedMaterial, -1) = coalesce(pn.PlannedMaterial, -1)
	and coalesce (cpsh.PlannedLabor, -1) = coalesce(pn.PlannedLabor, -1)
	and coalesce (cpsh.PlannedBurden, -1) = coalesce(pn.PlannedBurden, -1)
	and coalesce (cpsh.PlannedCostAccum, -1) = coalesce(pn.PlannedCostAccum, -1)
	and coalesce (cpsh.PlannedMaterialAccum, -1) = coalesce(pn.PlannedMaterialAccum, -1)
	and coalesce (cpsh.PlannedLaborAccum, -1) = coalesce(pn.PlannedLaborAccum, -1)
	and coalesce (cpsh.PlannedBurdenAccum, -1) = coalesce(pn.PlannedBurdenAccum, -1)

drop table
	#PSHNew
--- </Body>

---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>

/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go

declare
	@Param1 [scalar_data_type]

set	@Param1 = [test_value]

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FT.usp_Costing_CalculatePartStandardHistorical
	@Param1 = @Param1
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

if	@@trancount > 0 begin
	rollback
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/
go

declare
	@startDT datetime = getdate()

while
	exists
	(	select top 1
			*
		from
			FT.Costing_Snapshots_PS csp
		where
			SnapshotDT >
				(	select
						coalesce(max(csp.SnapshotDT), '2000-01-01')
					from
						FT.Costing_PartStandardHistorical cpsh
						join FT.Costing_Snapshots_PS csp
							on cpsh.LastSnapshotRowID = csp.RowID
				)
	) begin

	begin transaction

	execute
		FT.usp_Costing_CalculatePartStandardHistorical

	commit

	print 'loop'
end
go

select top 1000
	*
from
	FT.Costing_PartStandardHistorical cpsh
order by
	1, 2

select
	count(*)
,	max(EndDT)
,	max(LastSnapshotRowID)
from
	FT.Costing_PartStandardHistorical cpsh
