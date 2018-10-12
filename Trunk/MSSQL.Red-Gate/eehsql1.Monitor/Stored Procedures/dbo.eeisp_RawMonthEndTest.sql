SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[eeisp_RawMonthEndTest]
as
/*	Excess raw inventory with no demand.*/
declare	@ExcessNoDemand table
(	Part varchar (25) primary key,
	Excess numeric (20,6),
	Cost numeric (20,6),
	ExcessCost numeric (20,6))
insert	@ExcessNoDemand
select	Part = Excess.Part,
	Excess = Excess.Excess,
	Cost = ps.material_cum,
	ExcessCost = Excess.Excess * ps.material_cum
from	(	select	Part = part,
			Excess = sum (std_quantity)
		from	object
		where	part in (select part from part where type = 'R') and
			part not in (select Part from FT.NetMPS where RequiredDT < '2009-03-01')
		group by
			part) Excess
	join part_standard ps on Excess.Part = ps.part

/*	Excess inventory (more than half a standard pack + min on hand).*/
declare	@ExcessDemand table
(	Part varchar (25) primary key,
	Excess numeric (20,6),
	Cost numeric (20,6),
	ExcessCost numeric (20,6))
insert	@ExcessDemand
select	NetMPS.Part,
	Excess = sum (OnHandQty) - (.5 * min (pi.standard_pack) + coalesce (min (po.min_onhand), 0)),
	Cost = min (ps.material_cum),
	ExcessCost = (sum (OnHandQty) - (.5 * min (pi.standard_pack) + coalesce (min (po.min_onhand), 0))) * min (ps.material_cum)
from	FT.NetMPS NetMPS
	join part_standard ps on NetMPS.Part = ps.part
	join part_inventory pi on NetMPS.Part = pi.part
	join part_online po on NetMPS.Part = po.part
where	NetMPS.Part in (select part from part where type = 'R') and
	NetMPS.RequiredDT >= '2009-03-01'
group by
	NetMPS.Part
having
	sum (OnHandQty) > .5 * min (pi.standard_pack) + coalesce (min (po.min_onhand), 0)

/*	Half a standard pack of all active raw parts.*/
declare	@HalfPack table
(	Part varchar (25) primary key,
	HalfPack numeric (20,6),
	Cost numeric (20,6),
	HalfPackCost numeric (20,6))
insert	@HalfPack
select	Part = pi.part,
	HalfPack = .5 * pi.standard_pack,
	Cost = ps.material_cum,
	HalfPackCost = .5 * pi.standard_pack * ps.material_cum
from	part_inventory pi
	join part_standard ps on pi.part = ps.part
where	pi.part in (select part from part where type = 'R') and
	pi.part in (select Part from FT.NetMPS where RequiredDT < '2009-03-01' and Balance > 0 and OrderNo > 0)

/*	Two weeks demand of raw part.*/
declare	@FourWeeksDemand table
(	Part varchar (25) primary key,
	FourWeeksDemand numeric (20,6),
	Cost numeric (20,6),
	FourWeeksDemandCost numeric (20,6))
insert	@FourWeeksDemand
select	Part = NetMPS.Part,
	FourWeeksDemand = sum (NetMPS.OnHandQty + NetMPS.WIPQty + NetMPS.Balance),
	Cost = min (ps.material_cum),
	FourWeeksDemandCost = sum (NetMPS.OnHandQty + NetMPS.WIPQty + NetMPS.Balance) * min (ps.material_cum)
from	FT.NetMPS NetMPS
	join part_standard ps on NetMPS.Part = ps.part
	join part_inventory pi on NetMPS.Part = pi.part
where	NetMPS.Part in (select part from part where type = 'R') and
	NetMPS.RequiredDT >= '2009-02-01' and
	NetMPS.RequiredDT < '2009-03-01'
group by
	NetMPS.Part
having	sum (NetMPS.OnHandQty + NetMPS.WIPQty + NetMPS.Balance) > 0

/*	Min On Hand.*/
declare	@MinOnHand table
(	Part varchar (25) primary key,
	MinOnHand numeric (20,6),
	Cost numeric (20,6),
	MinOnHandost numeric (20,6))
insert	@MinOnHand
select	Part = po.part,
	MinOnHand = po.min_onhand,
	Cost = ps.material_cum,
	MinOnHandCost = po.min_onhand * ps.material_cum
from	part_online po
	join part_standard ps on po.part = ps.part
where	po.part in (select part from part where type = 'R') and
	po.part in (select Part from FT.NetMPS where RequiredDT < '2009-03-01' and Balance > 0 and OrderNo > 0) and
	po.min_onhand > 0

select	PartList.Part,
	StandardPack = pi.standard_pack,
	UnitCost = ps.material_cum,
	FourWeeksDemand = coalesce (FourWeeksDemand.FourWeeksDemand, 0),
	ExcessDemand = coalesce (ExcessDemand.Excess, 0),
	HalfPack = coalesce (HalfPack.HalfPack, 0),
	MinOnHand = coalesce (MinOnHand.MinOnHand, 0),
	ExcessNoDemand = coalesce (ExcessNoDemand.Excess, 0),
	Total = coalesce (ExcessNoDemand.Excess, 0) + coalesce (ExcessDemand.Excess, 0) + coalesce (HalfPack.HalfPack, 0) + coalesce (FourWeeksDemand.FourWeeksDemand, 0) + coalesce (MinOnHand.MinOnHand, 0),
	FourWeeksDemandCost = ps.material_cum * coalesce (FourWeeksDemand.FourWeeksDemand, 0),
	ExcessDemandCost = ps.material_cum * coalesce (ExcessDemand.Excess, 0),
	HalfPackCost = ps.material_cum * coalesce (HalfPack.HalfPack, 0),
	MinOnHandCost = ps.material_cum * coalesce (MinOnHand.MinOnHand, 0),
	ExcessNoDemandCost = ps.material_cum * coalesce (ExcessNoDemand.Excess, 0),
	PartCostTotal = ps.material_cum * (coalesce (ExcessNoDemand.Excess, 0) + coalesce (ExcessDemand.Excess, 0) + coalesce (HalfPack.HalfPack, 0) + coalesce (FourWeeksDemand.FourWeeksDemand, 0) + coalesce (MinOnHand.MinOnHand, 0))
from	(	select	Part = part
		from	object
		where	part in (select part from part where type = 'R')
		union
		select	Part
		from	FT.NetMPS
		where	Part in (select part from part where type = 'R')) PartList
	join part_inventory pi on PartList.Part = pi.part
	join part_standard ps on PartList.Part = ps.part
	left join @ExcessNoDemand ExcessNoDemand on PartList.Part = ExcessNoDemand.Part
	left join @ExcessDemand ExcessDemand on PartList.Part = ExcessDemand.Part
	left join @HalfPack HalfPack on PartList.Part = HalfPack.Part
	left join @FourWeeksDemand FourWeeksDemand on PartList.Part = FourWeeksDemand.Part
	left join @MinOnHand MinOnHand on PartList.Part = MinOnHand.Part
order by
	PartList.Part
GO
