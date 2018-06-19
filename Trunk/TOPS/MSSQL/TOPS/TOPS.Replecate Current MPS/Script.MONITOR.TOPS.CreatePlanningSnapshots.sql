create table
	#HNLeadTime
(	TopPart varchar(25) primary key
,	Part varchar(25)
,	RealLeadTime int
,	LongestLeadTime int
,	BackDays int
)

insert
	#HNLeadTime
select
	*
from
	openquery(EEHSQL1, 'select * from MONITOR.TOPS.fn_Leg_GetHNLeadTime(null) flghlt')

create table
	#EEHCapacityData
(	BasePart varchar(50)
,	BottleNeck numeric(18,2)
)

insert
	#EEHCapacityData
(	BasePart
,	BottleNeck
)
select
	ec.BasePart
,	ec.BottleNeck
from
	EEHSQL1.Monitor.TOPS.EEH_Capacity ec

create table
	#EOPData
(	BasePart char(7)
,	SOP datetime
,	EOP datetime
,	CSM_SOP datetime
,	CSM_EOP datetime
)

insert
	#EOPData
(	BasePart
,	SOP
,	EOP
,	CSM_SOP
,	CSM_EOP
)
select
	le.BasePart
,	le.SOP
,	le.EOP
,	le.CSM_SOP
,	le.CSM_EOP
from
	TOPS.Leg_EOP le

declare
	parts
cursor local read_only for
select distinct
	--top(100)
	p.part
from
	dbo.part p
	join dbo.order_detail od
		on od.part_number = p.part
	join dbo.part_eecustom pe
		on pe.part = p.part
	join dbo.po_header ph
		on ph.blanket_part = p.part
	join dbo.employee e
		on e.operator_code = ph.buyer
where
	p.type = 'F'
	and not exists
		(	select
				*
			from
				TOPS.PlanningSnapshotHeaders psh
			where
				psh.FinishedPart = p.part
				and psh.Revision =
					(	select
							max(psh2.Revision)
						from
							TOPS.PlanningSnapshotHeaders psh2
					)
		)
order by
	p.part

open parts

while
	1 = 1 begin

	declare
		@FinishedPart varchar(25)

	fetch
		parts
	into
		@FinishedPart

	if	@@fetch_status != 0 begin
		break
	end

	exec TOPS.usp_PlanningSnapshot_NewPlanningForFinishedPart
		@FinishedPart = @FinishedPart
	,	@ParentHeirarchID = null -- hierarchyid
	,	@Debug = 1
end

close
	parts

deallocate
	parts

drop table
	#EOPData

drop table
	#EEHCapacityData

drop table
	#HNLeadTime

go

select
	*
from
	TOPS.PlanningSnapshotHeaders psh
order by
	psh.PlanningSnapshotID

select
	*
from
	FXSYS.USP_Calls uc
