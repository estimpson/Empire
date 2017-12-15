--LeadTime - $A$1:$E$1817
--EEH

use Monitor
go

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
				HN.bom_query bom1
			where
				bom1.parttype = 'r'
				and bom1.toppart = bom.toppart
		)
	,	pe.backdays
	from
		HN.bom_query bom
		inner join
		(
			select distinct
				mps.part
			from
				master_prod_sched mps
				inner join part p
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
order by
	1 asc
,	3 desc;