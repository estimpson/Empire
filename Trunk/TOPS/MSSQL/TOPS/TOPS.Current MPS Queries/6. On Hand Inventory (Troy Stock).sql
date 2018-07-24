--Troy Stock - $A$1$B$575

select
	serial
,	object.part
,	object.location
,	object.quantity
,	part.type
,	location.code
from
	MONITOR.dbo.object object
	join MONITOR.dbo.part part
		on object.part = part.part
	left outer join MONITOR.dbo.location location
		on object.location = location.code
where
	(
		object.location not like '%EEH%'
		and object.location not like '%lost%'
		and object.location not like '%tran%'
		and object.location not like '%Lost%'
		and part.type = 'f'
		and isnull(object.field2, 'XXX') <> 'ASB'
		and isnull(location.code, 'Lost') <> 'Lost'
		and isnull(location.secured_location, 'N') <> 'Y'
	)
	or
	(
		object.location = 'TEEH-WAREH'
		and object.part != 'PALLET'
	)
---AND object.location ='TEEH-WAREH'
order by
	object.part;