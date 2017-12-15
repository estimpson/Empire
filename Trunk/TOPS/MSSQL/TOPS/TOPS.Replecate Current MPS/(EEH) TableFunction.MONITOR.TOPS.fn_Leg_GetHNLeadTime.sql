
/*
Create function (EEH) TableFunction.MONITOR.TOPS.fn_Leg_GetHNLeadTime.sql
*/

use Monitor
go

if	objectproperty(object_id('TOPS.fn_Leg_GetHNLeadTime'), 'IsTableFunction') = 1 begin
	drop function TOPS.fn_Leg_GetHNLeadTime
end
go

create function TOPS.fn_Leg_GetHNLeadTime
(	@ProductionPart varchar(25)
)
returns @HNLeadTime table
(	TopPart varchar(25)
,	Part varchar(25)
,	RealLeadTime int
,	LongestLeadTime int
,	BackDays int
)
as
begin
--- <Body>
	insert
		@HNLeadTime
	select
		*
	from
	(
		select
			bom.toppart
		,	bom.part
		,	bom.real_lead_time
		,	longest_leadtime =
			(
				select
					max(bom1.real_lead_time)
				from
					Monitor.HN.bom_query bom1 with (nolock)
				where
					bom1.parttype = 'r'
					and bom1.toppart = bom.toppart
			)
		,	pe.backdays
		from
			Monitor.HN.bom_query bom with (nolock)
			join
			(
				select distinct
					mps.part
				from
					Monitor.dbo.master_prod_sched mps with (nolock)
					join Monitor.dbo.part p with (nolock)
						on p.part = mps.part
				where
					p.type = 'f'
			) FG
				on FG.part = bom.toppart
			left join part_eecustom pe
				on pe.part = bom.part
		where
			bom.parttype = 'r'
	) as t1
	where
		t1.real_lead_time >= t1.longest_leadtime
		and t1.TopPart = @ProductionPart
--- </Body>

---	<Return>
	return
end
go

