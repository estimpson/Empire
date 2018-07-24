--Trans_Sun - $A$1:D$83637

select
	object.serial
,	object.part
,	object.location
,	object.quantity
from
	{ oj MONITOR.dbo.object object
	left outer join MONITOR.dbo.location location
		on object.location = location.code }
where
	(object.location not like '%Lost%')
	and (isnull(secured_location, 'N') <> 'Y')
order by
	object.part;