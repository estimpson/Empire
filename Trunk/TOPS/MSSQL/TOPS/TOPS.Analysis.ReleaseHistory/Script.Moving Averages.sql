declare
	@BasePart varchar(7) = 'ALC0514'

declare
	@beginDT datetime = FT.fn_TruncDate('week', convert(datetime, '2014-01-01'))
,	@endDT datetime = FT.fn_TruncDate('week', convert(datetime, '2018-05-01') + 6)

declare
	@shipHistWeeks int = 24
,	@demandWeeks int = 24

declare
	@calendar table
(	WeekNo int not null primary key
,	CalendarDT datetime not null
)

insert
	@calendar
(	WeekNo
,	CalendarDT
)
select
	ur.RowNumber - 1
,	@beginDT + (ur.RowNumber - 1) * 7
from
	dbo.udf_Rows(datediff(week, @beginDT, @endDT) + 1) ur

select
	c.WeekNo
,	c.CalendarDT
from
	@calendar c

select
	BasePart = left(sd.part_original, 7)
,	WeekNo = datediff(week, @beginDT, sd.date_shipped)
,	ShipQuantity = sum(sd.qty_packed)
from
	dbo.shipper_detail sd
where
	sd.date_shipped between @beginDT - 7*@shipHistWeeks and @endDT
	and left(sd.part_original, 7) like @BasePart
group by
	left(sd.part_original, 7)
,	datediff(week, @beginDT, sd.date_shipped)

;
with
	WeeklyShipHistory
	(	BasePart, WeekNo, ShipQuantity)
	as
	(	select
			BasePart = left(sd.part_original, 7)
		,	WeekNo = datediff(week, @beginDT, sd.date_shipped)
		,	ShipQuantity = sum(sd.qty_packed)
		from
			dbo.shipper_detail sd
		where
			sd.date_shipped between @beginDT - 7*@shipHistWeeks and @endDT
			and left(sd.part_original, 7) like @BasePart
		group by
			left(sd.part_original, 7)
		,	datediff(week, @beginDT, sd.date_shipped)
	)
,	WeeklyOrderDemand
	(	BasePart, WeekNo, OrderQuantity)
	as
	(	select
			crpr.BasePart
		,	WeekNo = c.WeekNo
		,	OrderQuantity = sum(crpr.StdQty) / @demandWeeks
		from
			@calendar c
			join dbo.CustomerReleasePlans crp
				on crp.ID =
					(	select
							min(crp2.ID)
						from
							dbo.CustomerReleasePlans crp2
						where
							crp2.GeneratedDT > c.CalendarDT
					)
			join dbo.CustomerReleasePlanRaw crpr
				on crpr.ReleasePlanID = crp.ID
				and crpr.DueDT between crp.GeneratedDT and crp.GeneratedDT + 7*@demandWeeks
		where
			left(crpr.Part, 7) like @BasePart
		group by
			crpr.BasePart
		,	c.WeekNo
	)
select
	BasePart = @BasePart
,	c.WeekNo
,	c.CalendarDT
,	[12 Wk Moving Avg SHIP HIST] = sh.ShipAvg
,	[12 Wk Moving Avg CUST ORD] = od.DemandAvg
from
	@calendar c
	outer apply
		(	select
				ShipAvg = sum(wsh.ShipQuantity) / @shipHistWeeks
			from
				WeeklyShipHistory wsh
			where
				wsh.WeekNo between c.WeekNo - @shipHistWeeks and c.WeekNo - 1			
		) sh
	outer apply
		(	select
				DemandAvg = sum(wod.OrderQuantity) / @demandWeeks
			from
				WeeklyOrderDemand wod
			where
				wod.WeekNo between c.WeekNo - @demandWeeks and c.WeekNo - 1
		) od
order by
	1
,	2