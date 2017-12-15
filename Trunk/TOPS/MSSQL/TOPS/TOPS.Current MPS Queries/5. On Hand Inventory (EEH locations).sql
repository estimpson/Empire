--Honduras stock - $A$1:$B$12

select
	object.part
,	object.location
,	object.quantity
,	part.type
from
	dbo.object object
	left join dbo.location location
		on location.code = object.location
	join dbo.part part
		on part.part = object.part
where
	(
		(
			object.location like '%eeh%'
			and object.location not like '%qual%'
			and object.location not like '%Lost%'
		)
		and (part.type = 'F')
		and (isnull(secured_location, 'N') <> 'Y')
	);