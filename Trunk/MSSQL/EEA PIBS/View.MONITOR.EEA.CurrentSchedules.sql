
/*
Create View.MONITOR.EEA.CurrentSchedules.sql
*/

use MONITOR
go

--drop table EEA.CurrentSchedules
if	objectproperty(object_id('EEA.CurrentSchedules'), 'IsView') = 1 begin
	drop view EEA.CurrentSchedules
end
go

create view EEA.CurrentSchedules
as
select
	fgh.ProgramCode
,	fgh.CustomerPart
,	fgh.BillTo
,	fgh.ShipTo
,	woh.Machine
,	fgh.CurrentBuild
,	fgh.NextBuild
,	fgh.StandardPack
,	Totes = ceiling(case when woh.Status = 0 then fgh.NextBuild when woh.Status = 1 then fgh.CurrentBuild end / fgh.StandardPack)
,	LabelledTotes = ceiling(wod.QtyLabelled / fgh.StandardPack)
,	CompletedTotes = ceiling(wod.QtyCompleted / fgh.StandardPack)
,	WODID = wod.id
,	JobStatus = case when woh.Status = 0 then 'NextBuild' when woh.Status = 1 then 'CurrentBuild' end
,	wod.TopPart
,	wod.Part
,	wod.QtyRequired
,	wod.QtyLabelled
,	wod.QtyCompleted
,	wod.QtyDefect
,	LabelFormat = (select max(box_label) from dbo.order_header where blanket_part = fgh.PartCode and destination = fgh.ShipTo)
from
	EEA.FinishedGoodHeaders fgh
	join dbo.WOHeaders woh
		join dbo.WODetails wod
			on wod.WOID = woh.ID
		on wod.Part = fgh.PartCode
	join dbo.WOShift wos on
		wos.WOID = wod.WOID
where
	woh.Status in (0, 1)
go

select
	cs.ProgramCode
,	cs.CustomerPart
,	cs.BillTo
,	cs.ShipTo
,	cs.Machine
,	cs.CurrentBuild
,	cs.NextBuild
,	cs.StandardPack
,	cs.Totes
,	cs.LabelledTotes
,	cs.CompletedTotes
,	cs.WODID
,	cs.JobStatus
,	cs.TopPart
,	cs.Part
,	cs.QtyRequired
,	cs.QtyLabelled
,	cs.QtyCompleted
,	cs.QtyDefect
,	cs.LabelFormat
from
	EEA.CurrentSchedules cs
order by
	cs.JobStatus
,	cs.BillTo
,	cs.ProgramCode
go
