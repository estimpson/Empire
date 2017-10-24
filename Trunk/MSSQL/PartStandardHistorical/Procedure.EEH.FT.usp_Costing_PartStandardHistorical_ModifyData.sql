
/*
Create Procedure.EEH.FT.usp_Costing_PartStandardHistorical_ModifyData.sql
*/

use EEH
go

if	objectproperty(object_id('FT.usp_Costing_PartStandardHistorical_ModifyData'), 'IsProcedure') = 1 begin
	drop procedure FT.usp_Costing_PartStandardHistorical_ModifyData
end
go

create procedure FT.usp_Costing_PartStandardHistorical_ModifyData
	@PartCode varchar(25)
,	@BeginDT datetime
,	@EndDT datetime
,	@NewPrice numeric(20,6) = null
,	@NewMaterial numeric(20,6) = null
,	@UseFirstSnapshotOnOrBefore int = -1
		--0 use specified @BeginDT / @EndDT.
		--(-1) use the first snapshot after specified @BeginDT / @EndDT.
		--(1) use the first snapshot after specified @BeginDT / @EndDT.
,	@TranDT datetime = null out
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
/*	Determine which snapshots to use as bookends for modification. */
declare
	@actualBeginDT datetime
,	@actualEndDT datetime
,	@beginSnapshotRowID int
,	@endSnapshotRowID int

set	@actualBeginDT = coalesce
	(	(	select
				case
					when @UseFirstSnapshotOnOrBefore < 0 then max(csp.SnapshotDT)
					when @UseFirstSnapshotOnOrBefore > 0 then min(csp.SnapshotDT)
				end
			from
				FT.Costing_Snapshots_PS csp
			where
				(	@UseFirstSnapshotOnOrBefore < 0
					and csp.SnapshotDT <= @BeginDT
				)
				or
				(	@UseFirstSnapshotOnOrBefore > 0
					and csp.SnapshotDT >= @BeginDT
				)
		)
	,	@BeginDT
	)

set	@beginSnapshotRowID =
	(	select
			csp.RowID
		from
			FT.Costing_Snapshots_PS csp
		where
			csp.SnapshotDT = @actualBeginDT
	)

set	@actualEndDT = coalesce
	(	(	select
				case
					when @UseFirstSnapshotOnOrBefore < 0 then max(csp.SnapshotDT)
					when @UseFirstSnapshotOnOrBefore > 0 then min(csp.SnapshotDT)
				end
			from
				FT.Costing_Snapshots_PS csp
			where
				(	@UseFirstSnapshotOnOrBefore < 0
					and csp.SnapshotDT <= @EndDT
				)
				or
				(	@UseFirstSnapshotOnOrBefore > 0
					and csp.SnapshotDT >= @EndDT
				)
		)
	,	(	select
				max(csp.SnapshotDT)
			from
				FT.Costing_Snapshots_PS csp
			where
				@UseFirstSnapshotOnOrBefore != 0
				and @EndDT is not null
		)
	,	@EndDT
	,	(	select
	 			min(csp.SnapshotDT)
			from
				FT.Costing_Snapshots_PS csp
			where
	 			csp.SnapshotDT > @actualBeginDT
	 	)
	)

set	@endSnapshotRowID =
	(	select
			csp.RowID
		from
			FT.Costing_Snapshots_PS csp
		where
			csp.SnapshotDT = @actualEndDT
	)

/*	Build replacement data. */
declare
	@replacementCPS table
(	Part varchar(25)
,	BeginDT datetime
,	EndDT datetime
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
,	LastSnapshotRowID int
)

/*		Create two rows from first bookend if it is bisected by new start date.*/
insert
	@replacementCPS
select
	cpsh.Part
,   cpsh.BeginDT
,   EndDT = @actualBeginDT
,   cpsh.Price
,   cpsh.Cost
,   cpsh.Material
,   cpsh.Labor
,   cpsh.Burden
,   cpsh.CostAccum
,   cpsh.MaterialAccum
,   cpsh.LaborAccum
,   cpsh.BurdenAccum
,   cpsh.PlannedCost
,   cpsh.PlannedMaterial
,   cpsh.PlannedLabor
,   cpsh.PlannedBurden
,   cpsh.PlannedCostAccum
,   cpsh.PlannedMaterialAccum
,   cpsh.PlannedLaborAccum
,   cpsh.PlannedBurdenAccum
,   cpsh.BinCheckSum
,   LastSnapshotRowID = @beginSnapshotRowID
from
	FT.Costing_PartStandardHistorical cpsh
where
	cpsh.Part = @PartCode
	and	cpsh.BeginDT < @actualBeginDT
	and cpsh.EndDT > @actualBeginDT
union all
select
	cpsh.Part
,   BeginDT = @actualBeginDT
,   cpsh.EndDT
,   Price = coalesce(@NewPrice, cpsh.Price)
,   cpsh.Cost
,   cpsh.Material
,   cpsh.Labor
,   cpsh.Burden
,   cpsh.CostAccum
,   MaterialAccum = coalesce(@NewMaterial, cpsh.MaterialAccum)
,   cpsh.LaborAccum
,   cpsh.BurdenAccum
,   cpsh.PlannedCost
,   cpsh.PlannedMaterial
,   cpsh.PlannedLabor
,   cpsh.PlannedBurden
,   cpsh.PlannedCostAccum
,   cpsh.PlannedMaterialAccum
,   cpsh.PlannedLaborAccum
,   cpsh.PlannedBurdenAccum
,   BinCheckSum = binary_checksum
		(	cpsh.Part
		,   coalesce(@NewPrice, cpsh.Price)
		,   cpsh.Cost
		,   cpsh.Material
		,   cpsh.Labor
		,   cpsh.Burden
		,   cpsh.CostAccum
		,   coalesce(@NewMaterial, cpsh.MaterialAccum)
		,   cpsh.LaborAccum
		,   cpsh.BurdenAccum
		,   cpsh.PlannedCost
		,   cpsh.PlannedMaterial
		,   cpsh.PlannedLabor
		,   cpsh.PlannedBurden
		,   cpsh.PlannedCostAccum
		,   cpsh.PlannedMaterialAccum
		,   cpsh.PlannedLaborAccum
		,   cpsh.PlannedBurdenAccum
		)
,   cpsh.LastSnapshotRowID
from
	FT.Costing_PartStandardHistorical cpsh
where
	cpsh.Part = @PartCode
	and	cpsh.BeginDT < @actualBeginDT
	and cpsh.EndDT > @actualBeginDT

/*		Create rows from all rows between the bookends.*/
insert
	@replacementCPS
select
	cpsh.Part
,   cpsh.BeginDT
,   cpsh.EndDT
,   Price = coalesce(@NewPrice, cpsh.Price)
,   cpsh.Cost
,   cpsh.Material
,   cpsh.Labor
,   cpsh.Burden
,   cpsh.CostAccum
,   MaterialAccum = coalesce(@NewMaterial, cpsh.MaterialAccum)
,   cpsh.LaborAccum
,   cpsh.BurdenAccum
,   cpsh.PlannedCost
,   cpsh.PlannedMaterial
,   cpsh.PlannedLabor
,   cpsh.PlannedBurden
,   cpsh.PlannedCostAccum
,   cpsh.PlannedMaterialAccum
,   cpsh.PlannedLaborAccum
,   cpsh.PlannedBurdenAccum
,   BinCheckSum = binary_checksum
		(	cpsh.Part
		,   coalesce(@NewPrice, cpsh.Price)
		,   cpsh.Cost
		,   cpsh.Material
		,   cpsh.Labor
		,   cpsh.Burden
		,   cpsh.CostAccum
		,   coalesce(@NewMaterial, cpsh.MaterialAccum)
		,   cpsh.LaborAccum
		,   cpsh.BurdenAccum
		,   cpsh.PlannedCost
		,   cpsh.PlannedMaterial
		,   cpsh.PlannedLabor
		,   cpsh.PlannedBurden
		,   cpsh.PlannedCostAccum
		,   cpsh.PlannedMaterialAccum
		,   cpsh.PlannedLaborAccum
		,   cpsh.PlannedBurdenAccum
		)
,   cpsh.LastSnapshotRowID
from
	FT.Costing_PartStandardHistorical cpsh
where
	cpsh.Part = @PartCode
	and cpsh.BeginDT >= @actualBeginDT
	and	cpsh.EndDT <= @actualEndDT

/*		Create two rows from last bookend if it is bisected by new end date.*/
insert
	@replacementCPS
select
	cpsh.Part
,   cpsh.BeginDT
,   EndDT = @actualEndDT
,   Price = coalesce(@NewPrice, cpsh.Price)
,   cpsh.Cost
,   cpsh.Material
,   cpsh.Labor
,   cpsh.Burden
,   cpsh.CostAccum
,   MaterialAccum = coalesce(@NewMaterial, cpsh.MaterialAccum)
,   cpsh.LaborAccum
,   cpsh.BurdenAccum
,   cpsh.PlannedCost
,   cpsh.PlannedMaterial
,   cpsh.PlannedLabor
,   cpsh.PlannedBurden
,   cpsh.PlannedCostAccum
,   cpsh.PlannedMaterialAccum
,   cpsh.PlannedLaborAccum
,   cpsh.PlannedBurdenAccum
,   BinCheckSum = binary_checksum
		(	cpsh.Part
		,   coalesce(@NewPrice, cpsh.Price)
		,   cpsh.Cost
		,   cpsh.Material
		,   cpsh.Labor
		,   cpsh.Burden
		,   cpsh.CostAccum
		,   coalesce(@NewMaterial, cpsh.MaterialAccum)
		,   cpsh.LaborAccum
		,   cpsh.BurdenAccum
		,   cpsh.PlannedCost
		,   cpsh.PlannedMaterial
		,   cpsh.PlannedLabor
		,   cpsh.PlannedBurden
		,   cpsh.PlannedCostAccum
		,   cpsh.PlannedMaterialAccum
		,   cpsh.PlannedLaborAccum
		,   cpsh.PlannedBurdenAccum
		)		
,   LastSnapshotRowID = @endSnapshotRowID
from
	FT.Costing_PartStandardHistorical cpsh
where
	cpsh.Part = @PartCode
	and	cpsh.BeginDT < @actualEndDT
	and cpsh.EndDT > @actualEndDT
union all
select
	cpsh.Part
,   BeginDT = @actualEndDT
,   cpsh.EndDT
,   cpsh.Price
,   cpsh.Cost
,   cpsh.Material
,   cpsh.Labor
,   cpsh.Burden
,   cpsh.CostAccum
,   cpsh.MaterialAccum
,   cpsh.LaborAccum
,   cpsh.BurdenAccum
,   cpsh.PlannedCost
,   cpsh.PlannedMaterial
,   cpsh.PlannedLabor
,   cpsh.PlannedBurden
,   cpsh.PlannedCostAccum
,   cpsh.PlannedMaterialAccum
,   cpsh.PlannedLaborAccum
,   cpsh.PlannedBurdenAccum
,   cpsh.BinCheckSum
,   cpsh.LastSnapshotRowID
from
	FT.Costing_PartStandardHistorical cpsh
where
	cpsh.Part = @PartCode
	and	cpsh.BeginDT < @actualEndDT
	and cpsh.EndDT > @actualEndDT

/*	Replace the modified rows. */
--- <Delete rows="*">
set	@TableName = 'FT.Costing_PartStandardHistorical'

delete
	cpsh
from
	FT.Costing_PartStandardHistorical cpsh
where
	cpsh.Part like @PartCode
	and cpsh.BeginDT < @actualEndDT
	and cpsh.EndDT > @actualBeginDT

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Delete>

--- <Insert rows="*">
set	@TableName = 'FT.Costing_PartStandardHistorical'

insert
	FT.Costing_PartStandardHistorical
(	Part
,	BeginDT
,	EndDT
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
,	BinCheckSum
,	LastSnapshotRowID
)
select
	Part
,	BeginDT
,	EndDT
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
,	BinCheckSum
,	LastSnapshotRowID
from
	@replacementCPS rc

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Insert>
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
	@PartCode varchar(25) = 'AUT0108-HA00'
,	@BeginDT datetime = '2012-11-18'
,	@EndDT datetime = '2013-02-15'
,	@NewPrice numeric(20,6) = 4.15
,	@NewMaterial numeric(20,6) = 2.37
,	@UseFirstSnapshotOnOrBefore int = 1
		--0 use specified @BeginDT / @EndDT.
		--(-1) use the first snapshot after specified @BeginDT / @EndDT.
		--(1) use the first snapshot after specified @BeginDT / @EndDT.

select
	cpsh.Part
,   cpsh.BeginDT
,   cpsh.EndDT
,   cpsh.Price
,   cpsh.MaterialAccum
,   cpsh.BinCheckSum
,   cpsh.LastSnapshotRowID
from
	FT.Costing_PartStandardHistorical cpsh
where
	cpsh.Part like @PartCode
	and cpsh.BeginDT <= @EndDT
	and cpsh.EndDT >= @BeginDT

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FT.usp_Costing_PartStandardHistorical_ModifyData
	@PartCode = @PartCode
,	@BeginDT = @BeginDT
,	@EndDT = @EndDT
,	@NewPrice = @NewPrice
,	@NewMaterial = @NewMaterial
,	@UseFirstSnapshotOnOrBefore = @UseFirstSnapshotOnOrBefore
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult

select
	cpsh.Part
,   cpsh.BeginDT
,   cpsh.EndDT
,   cpsh.Price
,   cpsh.MaterialAccum
,   cpsh.BinCheckSum
,   cpsh.LastSnapshotRowID
from
	FT.Costing_PartStandardHistorical cpsh
where
	cpsh.Part like @PartCode
	and cpsh.BeginDT <= @EndDT
	and cpsh.EndDT >= @BeginDT
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

