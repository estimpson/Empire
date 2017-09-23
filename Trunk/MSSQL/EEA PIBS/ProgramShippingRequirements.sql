select
	ProgramCode = left(oh.blanket_part, 7)
,	BillTo = oh.customer
,	ShipTo = oh.destination
,	InHouseFG = coalesce
	(	(	select
				sum(std_quantity)
			from
				dbo.object
			where
				1 = 1
				and part like left(oh.blanket_part, 7) + '-A%' -- Part matches the program code and is the EEA part number.
				and location != 'INTRANSAL'
				and location in
					(	select
							code
						from
							dbo.location
						where
							plant = 'EEA'
							and coalesce(secured_location, 'N') != 'Y'
					)
		)
	,	0
	)
,	InHouseRaw = coalesce
	(	(	select
				sum(std_quantity)
			from
				dbo.object
			where
				1 = 1
				and part like left(oh.blanket_part, 7) + '%' -- Part matches the program code...
				and part not like left(oh.blanket_part, 7) + '-A%' -- ...but isn't the finished good.
				and location != 'INTRANSAL'
				and location in
					(	select
							code
						from
							dbo.location
						where
							plant = 'EEA'
							and coalesce(secured_location, 'N') != 'Y'
					)
		)
	,	0
	)
,	InTransit = coalesce
	(	(	select
				sum(std_quantity)
			from
				dbo.object
			where
				part like left(oh.blanket_part, 7) + '%' -- Part matches the program code.
				and location = 'INTRANSAL' -- In the future this could become a date of transport, truck number, etc.
		)
	,	0
	)
,	CurrentBuild = coalesce
	(	(	select
				sum(QtyRequired - QtyCompleted)
			from
				dbo.WODetails wod
				join dbo.WOHeaders woh on
					woh.ID = wod.WOID
				join dbo.WOShift wos on
					wos.WOID = wod.WOID
			where
				wod.Part = od.part_number
				and woh.Status = 1
		)
	,	0
	)
,	NextBuild = coalesce
	(	(	select
				sum(QtyRequired - QtyCompleted)
			from
				dbo.WODetails wod
				join dbo.WOHeaders woh on
					woh.ID = wod.WOID
				join dbo.WOShift wos on
					wos.WOID = wod.WOID
			where
				wod.Part = od.part_number
				and woh.Status = 0
		)
	,	0
	)
,	ShipSched = coalesce
	(	(	select
				qty_required
			from
				dbo.shipper_detail sd
				join dbo.shipper s on
					s.id = sd.shipper
					and s.status in ('O', 'S')
					and coalesce(s.type, 'N') = 'N'
			where
				sd.part_original = od.part_number
				and sd.order_no = od.order_no
		)
	,	0
	)				
,	OrderNo = oh.order_no
,	DueDT = od.due_date
,	PartCode = od.part_number
,	QtyDue = od.quantity
,	Firm = case when od.type = 'F' then 'Y' else 'N' end
,	StandardPack = coalesce(nullif(pp.quantity, 0), pi.standard_pack)
,	Totes = od.quantity / coalesce(nullif(pp.quantity, 0), pi.standard_pack)
,	AccumRequired =
	(	select
			sum(std_qty)
		from
			dbo.order_detail
		where
			part_number = oh.blanket_part
			and	convert(char(23), due_date, 126) + destination + convert(varchar, id) <= convert(char(23), od.due_date, 126) + od.destination + convert(varchar, od.id)
	) -- od.the_cum - coalesce(oh.our_cum, 0)
from
	dbo.order_header oh
	join dbo.order_detail od on
		od.order_no = oh.order_no
	left join dbo.part_packaging pp on
		pp.part = od.part_number
		and pp.code = od.packaging_type
	join dbo.part_inventory pi on
		pi.part = od.part_number
where
	1 = 1
	and	-- Has a part like XXX9999-AXXX*  The "A" indicates the part is built in Alabama.
		blanket_part like '[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9]-A%'
	and -- Has a valid router for EEA.
		exists
		(	select
				*
			from
				FT.XRt xr
				join dbo.part_machine pm on
					pm.part = xr.ChildPart
					and pm.sequence = 1
				join dbo.location l on -- The primary machine used to produce this part is in plant EEA.
					l.code = pm.machine
					and l.plant = 'EEA'
			where
				xr.TopPart = oh.blanket_part
		)