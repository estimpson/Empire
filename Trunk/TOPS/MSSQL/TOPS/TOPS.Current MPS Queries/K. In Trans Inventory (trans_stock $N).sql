--trans_stock $N$1:$P$42

declare
	@DT varchar(50) = '12/11' -- 'trans_stock!$M$2 = TEXT('Master Sheet'!F9, "mm/dd")

select
	object.part
,	quantity = sum(object.quantity)
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
	and left(convert(varchar(10), dateadd(day, 10, object.last_date), 101), 5) < @DT
group by
	object.part
,	part.type;