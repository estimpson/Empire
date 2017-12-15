--trans_stock $A$1:$B$305

select
	object.part
,	object.location
,	object.quantity
,	part.type
from
	object
	join part
		on object.part = part.part
where
	upper(object.location) like '%TRAN%'
	and part.type = 'F'
	and isnull(object.field2, 'XXX') <> 'ASB'
	and object.location not in
		(
			select
				code
			from
				location
			where
				(isnull(secured_location, 'N') = 'Y')
		)
order by
	object.part;