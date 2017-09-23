
/*
Create View.EEH.FT.Costing_PartStandardHistorical_All.sql
*/

use EEH
go

--drop table FT.Costing_PartStandardHistorical_All
if	objectproperty(object_id('FT.Costing_PartStandardHistorical_All'), 'IsView') = 1 begin
	drop view FT.Costing_PartStandardHistorical_All
end
go

create view FT.Costing_PartStandardHistorical_All
as
select
	csp.SnapshotDT
,   csp.Reason
,   cpsh.Part
,   cpsh.BeginDT
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
,   csp.RowID
,   csp.RowCreateDT
,   csp.RowCreateUser
,   csp.RowModifiedDT
,   csp.RowModifiedUser
from
	FT.Costing_Snapshots_PS csp
	join FT.Costing_PartStandardHistorical cpsh
		on csp.SnapshotDT between cpsh.BeginDT and cpsh.EndDT
go

select
	cpsha.SnapshotDT
,	count(*)
from
	FT.Costing_PartStandardHistorical_All cpsha
where
	cpsha.Reason = 'MONTH END'
group by
	cpsha.SnapshotDT
order by
	1
go
