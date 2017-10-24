
if	objectproperty(object_id('EEA.Programs'), 'IsView') = 1 begin
	drop view EEA.Programs
end
go

create view EEA.Programs
as
select
	ProgramCode = left(oh.blanket_part, 7)
,	BillTo = oh.customer
,	ShipTo = oh.destination
,	OrderNo = oh.order_no
,	AccumShipped = oh.our_cum
,	PartCode = oh.blanket_part
,	StandardPack = coalesce(nullif(pp.quantity, 0), pi.standard_pack)
,	Active = coalesce((select max(1) from dbo.order_detail where order_no = oh.order_no), 0)
from
	dbo.order_header oh
	left join dbo.part_packaging pp on
		pp.part = oh.blanket_part
		and
			pp.code = oh.package_type
	join dbo.part_inventory pi on
		pi.part = oh.blanket_part
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
					and
						pm.sequence = 1
				join dbo.location l on -- The primary machine used to produce this part is in plant EEA.
					l.code = pm.machine
					and
						l.plant = 'EEA'
			where
				xr.TopPart = oh.blanket_part
		)
go

select
	*
from
	EEA.Programs
