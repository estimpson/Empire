--trans_stock - $F$1:$J$958

select
	Filtro = object.part + left(convert(varchar(10), dateadd(day, 10, object.last_date), 101), 5)
,	object.part
,	quantity = sum(object.quantity)
,	part.type
,	Fecha = left(convert(varchar(10), dateadd(day, 10, object.last_date), 101), 5)
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
--and Object.part = 'LER0060-DSA02'
group by
	object.part
,	part.type
,	left(convert(varchar(10), dateadd(day, 10, object.last_date), 101), 5);