begin transaction
go
set xact_abort on
set ansi_warnings on

declare
	@FinishedPart varchar(25) = 'ALC0464-HA02'

exec TOPS.usp_PlanningSnapshot_NewPlanningForFinishedPart
	@FinishedPart = @FinishedPart
,	@ParentHeirarchID = null -- hierarchyid
,	@Debug = 1

select
	*
from
	TOPS.PlanningSnapshotHeaders psh
where
	psh.FinishedPart = 'ALC0464-HA02'

select
	*
from
	FXSYS.ErrorLog el
go

rollback
go

--select
--	le.BasePart
--from
--	TOPS.Leg_EOP le
--group by
--	le.BasePart
--having
--	min(le.SOP) != max(le.SOP)
--	or min(le.EOP) != max(le.EOP)
--order by
--	le.BasePart