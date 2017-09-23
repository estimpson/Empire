
declare
	@PartCode varchar(max) = null

set	@PartCode = 'NAL0480-APT04,NAL0150-AA00, NAL0091-AA00'

begin transaction Test

select
	ps.part
,	ps.cost
,	ps.material
,	ps.labor
,	ps.burden
,	ps.other
,	ps.cost_cum
,	ps.material_cum
,	ps.burden_cum
,	ps.other_cum
,	ps.labor_cum
from
	dbo.part_standard ps
where
	ps.part in
		(	select
				ltrim(usstr.Value)
			from
				dbo.fn_SplitStringToRows(@PartCode, ',') usstr
		)

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FT.usp_Costing_PartRollup
	@PartCode = @PartCode
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult

select
	ps.part
,	ps.cost
,	ps.material
,	ps.labor
,	ps.burden
,	ps.other
,	ps.cost_cum
,	ps.material_cum
,	ps.burden_cum
,	ps.other_cum
,	ps.labor_cum
from
	dbo.part_standard ps
where
	ps.part in
		(	select
				ltrim(usstr.Value)
			from
				dbo.fn_SplitStringToRows(@PartCode, ',') usstr
		)
go

if	@@trancount > 0 begin
	rollback
--	commit
end
go
