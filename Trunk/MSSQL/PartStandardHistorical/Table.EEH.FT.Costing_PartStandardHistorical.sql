
/*
truncate table
	FT.Costing_Snapshots_PS

insert
	FT.Costing_Snapshots_PS
(	SnapshotDT
,	Reason
)
select
	SnapshotDT = psh.time_stamp
,	Reason = psh.reason
from
	dbo.part_standard_historical psh
group by
	psh.time_stamp
,	psh.reason
union all
select
	SnapshotDT = pshd.time_stamp
,	Reason = pshd.reason
from
	dbo.part_standard_historical_daily pshd
group by
	pshd.time_stamp
,	pshd.reason
order by
	1

select
	*
from
	FT.Costing_Snapshots_PS csp

truncate table
	FT.Costing_PartStandardHistorical

drop table
	FT.Costing_PartStandardHistorical

create table
	FT.Costing_PartStandardHistorical
(	Part varchar(25) not null
,	BeginDT datetime not null
,	EndDT datetime null
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
,	primary key
		(	Part
		,	BeginDT
		)
)

create index ix_Costing_PartStandardHistorical_1 on FT.Costing_PartStandardHistorical (Part, EndDT, BinCheckSum)
create index ix_Costing_PartStandardHistorical_2 on FT.Costing_PartStandardHistorical (BeginDT, EndDT, Part) include (Price, CostAccum, MaterialAccum, LaborAccum, BurdenAccum)
*/
