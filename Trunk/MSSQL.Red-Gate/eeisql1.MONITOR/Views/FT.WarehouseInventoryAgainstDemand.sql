SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [FT].[WarehouseInventoryAgainstDemand]
as
select
	Part = o.part
,	Plant = l.plant
,	Location = o.location
,	Status = o.status
,	Quantity = sum(o.std_quantity)
,	StandardPack = max(pinv.standard_pack)
,	OnOrder30 =
	(	select
			sum(od.std_qty)
		from
			dbo.order_detail od
		where
			od.part_number = o.part
			and od.due_date < getdate() + 30
	)
,	OnOrder60 =
	(	select
			sum(od.std_qty)
		from
			dbo.order_detail od
		where
			od.part_number = o.part
			and od.due_date between getdate() + 30 and getdate() + 60
	)
,	OnOrderBeyond =
	(	select
			sum(od.std_qty)
		from
			dbo.order_detail od
		where
			od.part_number = o.part
			and od.due_date > getdate() + 60
	)
from
	dbo.object o
	join dbo.location l
		on l.code = o.location
	join dbo.part_inventory pinv
		on pinv.part = o.part
where
	std_quantity > 0
group by
	o.part
,	l.plant
,	o.location
,	o.status


GO
