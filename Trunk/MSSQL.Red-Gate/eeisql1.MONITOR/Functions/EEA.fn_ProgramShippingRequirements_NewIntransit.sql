SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EEA].[fn_ProgramShippingRequirements_NewIntransit]
()
returns @ProgramShippingRequirements table
(	ProgramCode char(7)
,	CustomerPart varchar(35)
,	BillTo varchar(10)
,	ShipTo varchar(20)
,	InHouseFG numeric(20,6)
,	InHouseRaw numeric(20,6)
,	InTransit1 numeric(20,6)
,	InTransit2 numeric(20,6)
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
,	QtyTrans1 numeric(20,6)
,	QtyTrans2 numeric(20,6)
,	QtyCurrent numeric(20,6)
,	QtyNext numeric(20,6)
,	QtyShip numeric(20,6)
,	AccumRequired numeric(20,6)
)
as
begin
-- <Body>
	declare
		@NetMPS table
	(	ID int primary key nonclustered
	,	OrderNo int default (-1) not null
	,	LineID int not null
	,	Part varchar(25) not null
	,	RequiredDT datetime not null --default (getdate()) 
	,	GrossDemand numeric(30,12) not null
	,	Balance numeric(30,12) not null
	,	OnHandQty numeric(30,12) default (0) not null
	,	InTransitQty1 numeric(30,12) default (0) not null
	,	InTransitQty2 numeric(30,12) default (0) not null
	,	WIPQty numeric(30,12) default (0) not null
	,	LowLevel int not null
	,	Sequence int not null
	,	unique
		(	OrderNo
		,	LowLevel
		,	OnHandQty
		,	InTransitQty1
		,	InTransitQty2
		,	ID
		)
	,	unique
		(	Part
		,	Sequence
		,	OrderNo
		,	ID
		)
	,	unique
		(	OrderNo
		,	LineID
		,	LowLevel
		,	OnHandQty
		,	InTransitQty1
		,	InTransitQty2
		,	ID
		)
	)
	
	insert
		@NetMPS
	(	ID
	,	OrderNo
	,	LineID
	,	Part
	,	RequiredDT
	,	GrossDemand
	,	Balance
	,	OnHandQty
	,	InTransitQty1
	,	InTransitQty2
	,	WIPQty
	,	LowLevel
	,	Sequence)
	select
		fgn.ID
	,	fgn.OrderNo
	,	fgn.LineID
	,	fgn.Part
	,	fgn.RequiredDT
	,	fgn.GrossDemand
	,	fgn.Balance
	,	fgn.OnHandQty
	,	fgn.InTransitQty1
	,	fgn.InTransitQty2
	,	fgn.WIPQty
	,	fgn.LowLevel
	,	fgn.Sequence
	from
		EEA.fn_GetNetout_NewIntransit() fgn
	where
		fgn.Part like '[A-Z][A-Z][A-Z][0-9,A-Z][0-9][0-9][0-9]%'
	
	declare
		@Releases table
	(	ProgramCode char(7)
	,	CustomerPart varchar(35)
	,	BlanketPart varchar(25)
	,	BillTo varchar(10)
	,	ShipTo varchar(20)
	,	InHouseFG numeric(20,6)
	,	InHouseRaw numeric(20,6)
	,	InTransit1 numeric(20,6)
	,	InTransit2 numeric(20,6)
	,	CurrentBuild numeric(20,6)
	,	NextBuild numeric(20,6)
	,	ShipSched numeric(20,6)			
	,	OrderNo numeric(8,0)
	,	DueDT datetime
	,	LineID int
	,	PartCode varchar(25)
	,	QtyDue numeric(20,6)
	,	Firm char(1)
	,	StandardPack numeric(20,6)
	,	Totes int
	,	AccumRequired numeric(20,6)
	)
	
	insert
		@Releases
	select
		ProgramCode = left(oh.blanket_part, 7)
	,	CustomerPart = oh.customer_part
	,	BlanketPart = oh.blanket_part
	,	BillTo = oh.customer
	,	ShipTo = oh.destination
	,	InHouseFG = coalesce(availableMaterial.InHouseFG, 0)
	,	InHouseRaw = coalesce(availableMaterial.InHouseRaw, 0)
	,	InTransit1 = coalesce(availableMaterial.InTransit1, 0)
	,	InTransit2 = coalesce(availableMaterial.InTransit2, 0)
	,	CurrentBuild = coalesce
		(	(	select
					case when sum(QtyRequired - QtyCompleted) > 0 then sum(QtyRequired - QtyCompleted) else 0 end
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
					case when sum(QtyRequired - QtyCompleted) > 0 then sum(QtyRequired - QtyCompleted) else 0 end
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
	,	LineID = od.id
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
		left join
		(	select
				nmps2.Part
			,	InHouseFG = coalesce(sum(case when nmps1.LowLevel = 0 then nmps1.OnHandQty end), 0)
			,	InHouseRaw = coalesce(sum(case when nmps1.LowLevel >= 1 then nmps1.OnHandQty end), 0)
			,	InTransit1 = coalesce(sum(case when nmps1.LowLevel >= 1 then nmps1.InTransitQty1 end), 0)
			,	InTransit2 = coalesce(sum(case when nmps1.LowLevel >= 1 then nmps1.InTransitQty2 end), 0)
			from
				@NetMPS nmps1
				join @NetMPS nmps2
					on nmps2.Sequence = 0
					and nmps2.OrderNo = nmps1.OrderNo
					and nmps2.LineID = nmps1.LineID
			group by
				nmps2.Part
		) availableMaterial
			on availableMaterial.Part = oh.blanket_part
	where
		1 = 1
		and	-- Has a part like XXX9999-AXXX* or XXX9999-RAXXX*  The "A" or "RA" indicates the part is built in Alabama.
			(	blanket_part like '[A-Z][A-Z][A-Z][0-9,A-Z][0-9][0-9][0-9]-A%'
				or blanket_part like '[A-Z][A-Z][A-Z][0-9,A-Z][0-9][0-9][0-9]-RA%'
				or blanket_part like '[A-Z][A-Z][A-Z][0-9,A-Z][0-9][0-9][0-9]-RWA%'
			)
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
		r.ProgramCode
	,	r.CustomerPart
	,	r.BillTo
	,	r.ShipTo
	,	r.InHouseFG
	,	r.InHouseRaw
	,	r.InTransit1
	,	r.InTransit2
	,	r.CurrentBuild
	,	r.NextBuild
	,	r.ShipSched
	,	r.OrderNo
	,	r.DueDT
	,	r.PartCode
	,	r.QtyDue
	,	r.Firm
	,	r.StandardPack
	,	r.Totes
	,	QtyFG = coalesce(allocMaterial.QtyFG, 0)
	,	QtyRaw = coalesce(allocMaterial.QtyRaw, 0)
	,	QtyTrans1 = coalesce(allocMaterial.QtyTrans1, 0)
	,	QtyTrans2 = coalesce(allocMaterial.QtyTrans2, 0)
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
		@Releases r
		left join
		(	select
				nmps1.OrderNo
			,	nmps1.LineID
			,	QtyFG = coalesce(sum(case when nmps1.LowLevel = 0 then nmps1.OnHandQty end), 0)
			,	QtyRaw = coalesce(sum(case when nmps1.LowLevel >= 1 then nmps1.OnHandQty end), 0)
			,	QtyTrans1 = coalesce(sum(case when nmps1.LowLevel >= 1 then nmps1.InTransitQty1 end), 0)
			,	QtyTrans2 = coalesce(sum(case when nmps1.LowLevel >= 1 then nmps1.InTransitQty2 end), 0)
			from
				@NetMPS nmps1
			group by
				nmps1.OrderNo
			,	nmps1.LineID
		) allocMaterial
			on allocMaterial.OrderNo = r.OrderNo
			and allocMaterial.LineID = r.LineID
				
	-- </Body>

--	<Return>
	return
end
GO
