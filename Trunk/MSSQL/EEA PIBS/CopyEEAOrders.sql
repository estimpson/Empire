
select
	ohEEA.order_no
,	DateAdd (wk, DateDiff(wk, '2001-01-01', fgn.RequiredDT), '2001-01-01') -- - coalesce(BackDays, 0)),'2001-01-01')
,	min(fgn.Part)
,	sum(fgn.Balance)
from
	EEA.fn_GetNetout() fgn
	join dbo.order_header ohEEA
		on ohEEA.customer = 'EEA'
		and ohEEA.blanket_part = fgn.Part
		and ohEEA.order_no =
			(	select
					max(order_no)
				from
					dbo.order_header oh
				where
					oh.customer = 'EEA'
					and oh.blanket_part = fgn.Part
			)
where
	fgn.Balance > 0
group by
	ohEEA.order_no
,	DateAdd (wk, DateDiff(wk, '2001-01-01', fgn.RequiredDT), '2001-01-01') -- - coalesce(BackDays, 0)),'2001-01-01')
