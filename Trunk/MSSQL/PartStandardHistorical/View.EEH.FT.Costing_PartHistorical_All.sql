
/*
Create View.EEH.FT.Costing_PartHistorical_All.sql
*/

use EEH
go

--drop table FT.Costing_PartHistorical_All
if	objectproperty(object_id('FT.Costing_PartHistorical_All'), 'IsView') = 1 begin
	drop view FT.Costing_PartHistorical_All
end
go

create view FT.Costing_PartHistorical_All
as
select
	csp.SnapshotDT
,   csp.Reason
,	cph.Part
,   cph.BeginDT
,   cph.EndDT
,   cph.Name
,   cph.CrossRef
,   cph.PartClass
,   cph.PartType
,   cph.Commodity
,   cph.GroupTechnology
,   cph.ProductLine
,   cph.BinCheckSum
,   cph.LastSnapshotRowID
,   csp.RowID
,   csp.RowCreateDT
,   csp.RowCreateUser
,   csp.RowModifiedDT
,   csp.RowModifiedUser
from
	FT.Costing_Snapshots_P csp
	join FT.Costing_PartHistorical cph
		on csp.SnapshotDT between cph.BeginDT and cph.EndDT
go

select
	cpha.SnapshotDT
,	count(*)
from
	FT.Costing_PartHistorical_All cpha
where
	cpha.Reason = 'MONTH END'
group by
	cpha.SnapshotDT
order by
	1
go

