
/*
select
	*
from
	FT.PreObjectHistory poh
where
	status = 0
*/
begin transaction
go

declare
    @ProcResult int
,   @ProcReturn int
,   @Operator varchar(10)
,   @PreObjectSerial int
,	@TranDT datetime

set	@Operator = 'ES'
set	@PreObjectSerial = 786266

select
	CreateDT
,	Serial
,	WODID
,	Operator
,	Part
,	Quantity
,	Status
from
	FT.PreObjectHistory poh
where
	Serial = @PreObjectSerial
order by
	CreateDT

execute @ProcReturn = FT.ftsp_ProdControl_JCPreObject 
    @Operator = @Operator
,   @PreObjectSerial = @PreObjectSerial
,	@TranDT = @TranDT out
,   @Result = @ProcResult out

select
    @ProcResult
,   @PreObjectSerial
,   @ProcReturn
,	@TranDT

rollback
go

select
	CurrentScheduleWODID = min (cs.WODID)
from
	EEA.ProgramHeaders ph
	left join EEA.CurrentSchedules cs on
		ph.PartCode = cs.Part
where
	ph.PartCode = 'NAL0096-AD01'

select
	CreateDT
,	Serial
,	WODID
,	Operator
,	Part
,	Quantity
,	Status
from
	FT.PreObjectHistory poh
where
	WODID = 14
order by
	CreateDT

select
	ProgramCode
,	BillTo
,	ShipTo
,	CurrentBuild
,	NextBuild
,	StandardPack
,	Totes
,	LabelledTotes
,	CompletedTotes
,	WODID
,	JobStatus
,	TopPart
,	Part
,	QtyRequired
,	QtyLabelled
,	QtyCompleted
,	QtyDefect
,	LabelFormat
from
	EEA.CurrentSchedules cs
where
	WODID = 14
