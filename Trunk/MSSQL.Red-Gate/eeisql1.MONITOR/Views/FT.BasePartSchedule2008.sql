SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[BasePartSchedule2008]
as
select	BasePart = coalesce (ProductionSchedule.BasePart, ShipSchedule.BasePart),
	Month = DateDiff (month, '2008-01-01', coalesce (ProductionSchedule.FirstReleaseDT, ShipSchedule.FirstReleaseDT)) + 1,
	ProdFirstReleaseDT = ProductionSchedule.FirstReleaseDT,
	ProdReleases = ProductionSchedule.Releases,
	ProdQuantity = ProductionSchedule.Quantity,
	ShipFirstReleaseDT = ShipSchedule.FirstReleaseDT,
	ShipReleases = ShipSchedule.Releases,
	ShipQuantity = ShipSchedule.Quantity
from	(	select	*
		from	OpenQuery ([EEHDATA1.EMPIRE.HN], '
					select	BasePart = left (part_number, 7),
						FirstReleaseDT = min (due_date),
						LastReleaseDT = max (due_date),
						Releases = count (1),
						Quantity = sum (quantity)
					from	monitor.dbo.order_detail
					where	due_date >= ''2008-01-01''
					group by
						left (part_number, 7),
						datediff (month, ''2008-01-01'', due_date)
					order by
						1, 2
				')) ProductionSchedule
	full join
	(	select	BasePart = left (part_number, 7),
			FirstReleaseDT = min (due_date),
			LastReleaseDT = max (due_date),
			Releases = count (1),
			Quantity = sum (quantity)
		from	order_detail
		where	due_date >= '2008-01-01'
		group by
			left (part_number, 7),
			datediff (month, '2008-01-01', due_date)) ShipSchedule on ProductionSchedule.BasePart = ShipSchedule.BasePart and
		DateDiff (month, ProductionSchedule.FirstReleaseDT, ShipSchedule.FirstReleaseDT) = 0

GO
