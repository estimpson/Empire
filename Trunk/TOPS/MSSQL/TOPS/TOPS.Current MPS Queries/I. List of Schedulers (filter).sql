--Filter - $C$1:$C$12

select
	Buyer = 'All'
union all
select
	Buyer = isnull(Employee.name, '')
from
	MONITOR.dbo.order_detail order_detail
	inner join MONITOR.dbo.part_eecustom part_eecustom
		on order_detail.part_number = part_eecustom.part
	left join MONITOR.dbo.po_header po_header
		on po_header.blanket_part = order_detail.part_number
	left join MONITOR.dbo.employee Employee
		on po_header.buyer = Employee.operator_code
where
	(order_detail.quantity > $0)
	and (isnull(custom01, 'XXX') <> 'ASB')
group by
	Employee.name
order by
	1 asc;