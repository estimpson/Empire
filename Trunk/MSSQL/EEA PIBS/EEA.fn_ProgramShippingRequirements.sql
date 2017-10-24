
if	objectproperty(object_id('EEA.fn_ProgramShippingRequirements'), 'IsTableFunction') = 1 begin
	drop function EEA.fn_ProgramShippingRequirements
end
go

create function EEA.fn_ProgramShippingRequirements
()
returns @ProgramShippingRequirements table
(	ProgramCode char(7)
,	BillTo varchar(10)
,	ShipTo varchar(20)
,	InHouseFG numeric(20,6)
,	InHouseRaw numeric(20,6)
,	InTransit numeric(20,6)
,	CurrentBuild numeric(20,6)
,	NextBuild numeric(20,6)
,	ShipSched numeric(20,6)			
,	OrderNo numeric(8,0)
,	DueDT datetime
,	PartCode varchar(25)
,	QtyDue numeric(20,6)
,	Firm char(1)
,	StandardPack numeric(20,6)
,	Totes int
,	QtyFG numeric(20,6)
,	QtyRaw numeric(20,6)
,	QtyTrans numeric(20,6)
,	QtyCurrent numeric(20,6)
,	QtyNext numeric(20,6)
,	QtyShip numeric(20,6)
,	AccumRequired numeric(20,6)
)
as
begin
--- <Body>
	declare
		@Releases table
	(	ProgramCode char(7)
	,	BillTo varchar(10)
	,	ShipTo varchar(20)
	,	InHouseFG numeric(20,6)
	,	InHouseRaw numeric(20,6)
	,	InTransit numeric(20,6)
	,	CurrentBuild numeric(20,6)
	,	NextBuild numeric(20,6)
	,	ShipSched numeric(20,6)			
	,	OrderNo numeric(8,0)
	,	DueDT datetime
	,	PartCode varchar(25)
	,	QtyDue numeric(20,6)
	,	Firm char(1)
	,	StandardPack numeric(20,6)
	,	Totes int
	,	AccumRequired numeric(20,6)
	)
	
	declare
		@Inventory table
	(	Part varchar(25) primary key
	,	Inventory numeric(20,6)
	)
	
	insert
		@Inventory
	(	Part
	,	Inventory
	)
	select
		Part = part
	,	Inventory = sum(std_quantity)
	from
		dbo.object
	where
		location != 'INTRANSAL'
		and location in
			(	select
					code
				from
					dbo.location
				where
					plant = 'EEA'
					and coalesce(secured_location, 'N') != 'Y'
			)
	group by
		part

	declare
		@TransInventory table
	(	Part varchar(25) primary key
	,	Inventory numeric(20,6)
	)
	
	insert
		@TransInventory
	(	Part
	,	Inventory
	)
	select
		Part = part
	,	Inventory = sum(std_quantity)
	from
		dbo.object
	where
		location = 'INTRANSAL'
	group by
		part

	insert
		@Releases
	select
		ProgramCode = left(oh.blanket_part, 7)
	,	BillTo = oh.customer
	,	ShipTo = oh.destination
	,	InHouseFG = coalesce
		(	(	select
					sum(Inventory)
				from
					@Inventory
				where
					Part like left(oh.blanket_part, 7) + '-A%' -- Part matches the program code and is the EEA part number.
			)
		,	0
		)
	,	InHouseRaw = coalesce
		(	(	select
					sum(Inventory)
				from
					@Inventory
				where
					Part like left(oh.blanket_part, 7) + '-H%' -- Part matches the program code and is the EEA part number.
			)
		,	0
		)
	,	InTransit = coalesce
		(	(	select
					sum(Inventory)
				from
					@TransInventory
				where
					Part like left(oh.blanket_part, 7) + '%' -- Part matches the program code and is the EEA part number.
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
					sum(qty_required)
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
			blanket_part like '[A-Z][A-Z][A-Z][0-9,A-Z][0-9][0-9][0-9]-A%'
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

	insert
		@ProgramShippingRequirements
	select
		ProgramCode
	,	BillTo
	,	ShipTo
	,	InHouseFG
	,	InHouseRaw
	,	InTransit
	,	CurrentBuild
	,	NextBuild
	,	ShipSched
	,	OrderNo
	,	DueDT
	,	PartCode
	,	QtyDue
	,	Firm
	,	StandardPack
	,	Totes
	,	QtyFG =
		case
			when InHouseFG >= AccumRequired then QtyDue
			when InHouseFG <= AccumRequired - QtyDue then 0
			else InHouseFG - (AccumRequired - QtyDue)
		end
	,	QtyRaw =
		case
			when InHouseFG >= AccumRequired then 0  -- Misses right
			when InHouseFG + InHouseRaw <= AccumRequired - QtyDue then 0  -- Misses left
			when InHouseFG >= AccumRequired - QtyDue and InHouseFG + InHouseRaw <= AccumRequired then InHouseRaw  -- Falls within
			when InHouseFG >= AccumRequired - QtyDue and InHouseFG + InHouseRaw >= AccumRequired then AccumRequired - InHouseFG  -- Overlaps right
			when InHouseFG <= AccumRequired - QtyDue and InHouseFG + InHouseRaw <= AccumRequired then InHouseFG + InHouseRaw - (AccumRequired - QtyDue)  -- Overlaps left
			when InHouseFG <= AccumRequired - QtyDue and InHouseFG + InHouseRaw >= AccumRequired then QtyDue  -- Overlaps right and left
		end
	,	QtyTrans =
		case
			when (InHouseFG + InHouseRaw) >= AccumRequired then 0  -- Misses right
			when (InHouseFG + InHouseRaw) + InTransit <= AccumRequired - QtyDue then 0  -- Misses left
			when (InHouseFG + InHouseRaw) >= AccumRequired - QtyDue and (InHouseFG + InHouseRaw) + InTransit <= AccumRequired then InHouseRaw  -- Falls within
			when (InHouseFG + InHouseRaw) >= AccumRequired - QtyDue and (InHouseFG + InHouseRaw) + InTransit >= AccumRequired then AccumRequired - (InHouseFG + InHouseRaw)  -- Overlaps right
			when (InHouseFG + InHouseRaw) <= AccumRequired - QtyDue and (InHouseFG + InHouseRaw) + InTransit <= AccumRequired then (InHouseFG + InHouseRaw) + InTransit - (AccumRequired - QtyDue)  -- Overlaps left
			when (InHouseFG + InHouseRaw) <= AccumRequired - QtyDue and (InHouseFG + InHouseRaw) + InTransit >= AccumRequired then QtyDue  -- Overlaps right and left
		end
	,	QtyCurrent =
		case
			when InHouseFG >= AccumRequired then 0  -- Misses right
			when InHouseFG + CurrentBuild <= AccumRequired - QtyDue then 0  -- Misses left
			when InHouseFG >= AccumRequired - QtyDue and InHouseFG + CurrentBuild <= AccumRequired then CurrentBuild  -- Falls within
			when InHouseFG >= AccumRequired - QtyDue and InHouseFG + CurrentBuild >= AccumRequired then AccumRequired - InHouseFG  -- Overlaps right
			when InHouseFG <= AccumRequired - QtyDue and InHouseFG + CurrentBuild <= AccumRequired then InHouseFG + CurrentBuild - (AccumRequired - QtyDue)  -- Overlaps left
			when InHouseFG <= AccumRequired - QtyDue and InHouseFG + CurrentBuild >= AccumRequired then QtyDue  -- Overlaps right and left
		end
	,	QtyNext =
		case
			when (InHouseFG + CurrentBuild) >= AccumRequired then 0  -- Misses right
			when (InHouseFG + CurrentBuild) + NextBuild <= AccumRequired - QtyDue then 0  -- Misses left
			when (InHouseFG + CurrentBuild) >= AccumRequired - QtyDue and (InHouseFG + CurrentBuild) + NextBuild <= AccumRequired then NextBuild  -- Falls within
			when (InHouseFG + CurrentBuild) >= AccumRequired - QtyDue and (InHouseFG + CurrentBuild) + NextBuild >= AccumRequired then AccumRequired - (InHouseFG + CurrentBuild)  -- Overlaps right
			when (InHouseFG + CurrentBuild) <= AccumRequired - QtyDue and (InHouseFG + CurrentBuild) + NextBuild <= AccumRequired then (InHouseFG + CurrentBuild) + NextBuild - (AccumRequired - QtyDue)  -- Overlaps left
			when (InHouseFG + CurrentBuild) <= AccumRequired - QtyDue and (InHouseFG + CurrentBuild) + NextBuild >= AccumRequired then QtyDue  -- Overlaps right and left
		end
	,	QtyShip =
		case
			when ShipSched >= AccumRequired then QtyDue
			when ShipSched <= AccumRequired - QtyDue then 0
			else ShipSched - (AccumRequired - QtyDue)
		end
	,	AccumRequired
	from
		@Releases
	--- </Body>

---	<Return>
	return
end
go

select
	*
from
	EEA.fn_ProgramShippingRequirements() fpsr
