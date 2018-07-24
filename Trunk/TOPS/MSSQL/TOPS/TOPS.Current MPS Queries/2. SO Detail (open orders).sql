--open orders - $A$a:$C$13994

select
	order_detail.part_number
,	order_detail.quantity
,	FT.fn_TruncDate('dd', order_detail.due_date) as 'due_date'
from
	MONITOR.dbo.order_detail order_detail
where
	(isnull(order_detail.custom01, 'XXX') <> 'ASB')
order by
	order_detail.part_number
,	order_detail.due_date;