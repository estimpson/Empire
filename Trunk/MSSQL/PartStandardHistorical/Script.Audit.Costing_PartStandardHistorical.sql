/*
select
	csp.SnapshotDT
,   csp.Reason
,	Rows =
		(	select
				count(*)
			from
				FT.Costing_PartStandardHistorical cpsh
			where
				cpsh.LastSnapshotRowID = csp.RowID
		)
from
	FT.COSTING_Snapshots_PS csp
--where
--	csp.SnapshotDT > '2008-01-01'
order by
	csp.SnapshotDT

*/

select
	count(*)
,	max(EndDT)
,	max(LastSnapshotRowID)
from
	FT.Costing_PartStandardHistorical cpsh

declare
	@auditDT datetime = '2013-09-25 23:55:00.530'

select
	*
from
	FT.Costing_PartStandardHistorical cpsh
where
	convert(datetime, @auditDT) between cpsh.BeginDT and cpsh.EndDT

select
	*
from
	--dbo.part_standard_historical phd
	dbo.part_standard_historical_daily phd
where
	phd.time_stamp = @auditDT
--	and phd.Part like '1B%'
--group by
--	left(phd.part, 25)

select
	count(*)
--,	left(cpsh.Part, 25)
,	sum(cpsh.MaterialAccum)
from
	FT.Costing_PartStandardHistorical cpsh
where
	convert(datetime, @auditDT) between cpsh.BeginDT and cpsh.EndDT
--	and cpsh.Part like '1B%'
--group by
--	left(cpsh.Part, 25)
order by
	2

select
	count(*)
--,	left(phd.part, 25)
,	sum(phd.material_cum)
from
	--dbo.part_standard_historical phd
	dbo.part_standard_historical_daily phd
where
	phd.time_stamp = @auditDT
--	and phd.Part like '1B%'
--group by
--	left(phd.part, 25)
order by
	2
