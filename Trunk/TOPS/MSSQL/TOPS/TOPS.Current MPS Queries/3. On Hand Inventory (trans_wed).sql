--trans_wed - $A$1:$D$83637

select
	object.serial
,	object.part
,	object.quantity
,	object.location
from
	{ oj MONITOR.dbo.object object
	left outer join MONITOR.dbo.location location
		on object.location = location.code }
where
	(isnull(field2, 'XXX') <> 'ASB')
	and (isnull(secured_location, 'N') <> 'Y')
	and (object.location not like '%LOST%')
order by
	object.part;