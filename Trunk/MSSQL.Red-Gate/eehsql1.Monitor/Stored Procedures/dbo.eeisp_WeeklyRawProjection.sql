SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[eeisp_WeeklyRawProjection]
as
declare	@StartDT datetime; set @StartDT = eeh.FT.fn_TruncDate ('week', getdate ())

declare	@NetMPSWeekly table
(	Part varchar (25),
	MinOnHand bit,
	RequiredWeekNo smallint,
	ReleaseWeekNo smallint,
	Balance numeric (20,6),
	OnHandQty numeric (20,6),
	WIPQty numeric (20,6),
	primary key (Part, MinOnHand, RequiredWeekNo, ReleaseWeekNo))

insert	@NetMPSWeekly
select	NetMPS.Part,
	MinOnHand = case when min (od.due_date) is null then 1 else 0 end,
	RequiredWeekNo = DateDiff (week, @StartDT, NetMPS.RequiredDT),
	ReleaseWeekNo = min (coalesce (DateDiff (week, @StartDT, od.due_date), DateDiff (week, @StartDT, NetMPS.RequiredDT))),
	Balance = sum (Balance),
	OnHandQty = sum (OnHandQty),
	WIPQty = sum (WIPQty)
from	FT.NetMPS NetMPS
	left join order_detail od on NetMPS.OrderNo = od.order_no and LineID = od.sequence
where	Part in (select part from part where type = 'R')
group by
	Part,
	DateDiff (week, @StartDT, NetMPS.RequiredDT),
	DateDiff (week, @StartDT, od.due_date)
order by
	1, 2, 3

declare	@RawInventoryWeekly table
(	Part varchar (25),
	BucketWeekNo smallint,
	BucketWeekDate datetime,
	StandardPack numeric (20,6),
	UnitCost  numeric (20,6),
	CurrentInventory numeric (20,6),
	HalfPack numeric (20,6),
	ManufacturingLeadTimeInventory numeric (20,6),
	RemainingInventory numeric (20,6),
	primary key
	(	Part,
		BucketWeekNo))

insert	@RawInventoryWeekly
select	PartList.Part,
	BucketWeekNo = datediff (week, @StartDT, Calendar.EntryDT),
	BucketWeekDate = Calendar.EntryDT,
	StandardPack = pi.standard_pack,
	UnitCost = ps.material_cum,
	CurrentInventory = (select sum (std_quantity) from object where PartList.Part = object.part),
	HalfPack =
	case	when not exists
		(	select	1
			from	@NetMPSWeekly NetMPSWeekly
			where	PartList.Part = NetMPSWeekly.Part and
				NetMPSWeekly.MinOnHand = 0 and
				NetMPSWeekly.Balance > 0 and
				datediff (week, @StartDT, Calendar.EntryDT) >= NetMPSWeekly.RequiredWeekNo) then 0
		when pee.generate_mr = 'U' then pi.standard_pack / 2
		when pee.generate_mr = 'D' then -pi.standard_pack / 2
		else 0
	end,
	ManufacturingLeadTimeInventory = coalesce (
	(	select	sum (NetMPSWeekly.Balance + NetMPSWeekly.OnHandQty)
		from	@NetMPSWeekly NetMPSWeekly
		where	PartList.Part = NetMPSWeekly.Part and
			NetMPSWeekly.MinOnHand = 0 and
			datediff (week, @StartDT, Calendar.EntryDT) between NetMPSWeekly.RequiredWeekNo and NetMPSWeekly.ReleaseWeekNo), 0),
	RemainingInventory = coalesce (
	(	select	sum (OnHand)
		from	FT.Inventory Inventory
		where	PartList.Part = Inventory.Part), 0) - coalesce (
	(	select	sum (NetMPSWeekly.OnHandQty)
		from	@NetMPSWeekly NetMPSWeekly
		where	PartList.Part = NetMPSWeekly.Part and
			NetMPSWeekly.MinOnHand = 0 and
			datediff (week, @StartDT, Calendar.EntryDT) >= NetMPSWeekly.RequiredWeekNo), 0)
from	(	select	Part = part
		from	object
		where	part in (select part from part where type = 'R')
		union
		select	Part
		from	FT.NetMPS
		where	Part in (select part from part where type = 'R')) PartList
	cross join eeh.FT.fn_Calendar (@StartDT, null, 'week', 1, 16) Calendar
	join part_inventory pi on PartList.Part = pi.part
	join part_standard ps on PartList.Part = ps.part
	join part_eecustom pee on PartList.Part = pee.part
	left join part_online po on PartList.Part = po.part
order by
	PartList.Part,
	Calendar.EntryDT

select	Part,
	StandardPack = min (StandardPack),
	UnitCost = min (UnitCost),
	CurrentInventory = min (CurrentInventory),
	Bucket00Date = min (case when BucketWeekNo = 00 then BucketWeekDate end),
	Bucket01Date = min (case when BucketWeekNo = 01 then BucketWeekDate end),
	Bucket02Date = min (case when BucketWeekNo = 02 then BucketWeekDate end),
	Bucket03Date = min (case when BucketWeekNo = 03 then BucketWeekDate end),
	Bucket04Date = min (case when BucketWeekNo = 04 then BucketWeekDate end),
	Bucket05Date = min (case when BucketWeekNo = 05 then BucketWeekDate end),
	Bucket06Date = min (case when BucketWeekNo = 06 then BucketWeekDate end),
	Bucket07Date = min (case when BucketWeekNo = 07 then BucketWeekDate end),
	Bucket08Date = min (case when BucketWeekNo = 08 then BucketWeekDate end),
	Bucket09Date = min (case when BucketWeekNo = 09 then BucketWeekDate end),
	Bucket10Date = min (case when BucketWeekNo = 10 then BucketWeekDate end),
	Bucket11Date = min (case when BucketWeekNo = 11 then BucketWeekDate end),
	Bucket12Date = min (case when BucketWeekNo = 12 then BucketWeekDate end),
	Bucket13Date = min (case when BucketWeekNo = 13 then BucketWeekDate end),
	Bucket14Date = min (case when BucketWeekNo = 14 then BucketWeekDate end),
	Bucket15Date = min (case when BucketWeekNo = 15 then BucketWeekDate end),
	Bucket00InventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 00 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket01InventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 01 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket02InventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 02 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket03InventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 03 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket04InventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 04 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket05InventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 05 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket06InventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 06 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket07InventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 07 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket08InventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 08 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket09InventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 09 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket10InventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 10 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket11InventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 11 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket12InventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 12 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket13InventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 13 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket14InventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 14 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket15InventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 15 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket00HalfPackCost = min (UnitCost) * sum (case when BucketWeekNo = 00 then HalfPack end),
	Bucket01HalfPackCost = min (UnitCost) * sum (case when BucketWeekNo = 01 then HalfPack end),
	Bucket02HalfPackCost = min (UnitCost) * sum (case when BucketWeekNo = 02 then HalfPack end),
	Bucket03HalfPackCost = min (UnitCost) * sum (case when BucketWeekNo = 03 then HalfPack end),
	Bucket04HalfPackCost = min (UnitCost) * sum (case when BucketWeekNo = 04 then HalfPack end),
	Bucket05HalfPackCost = min (UnitCost) * sum (case when BucketWeekNo = 05 then HalfPack end),
	Bucket06HalfPackCost = min (UnitCost) * sum (case when BucketWeekNo = 06 then HalfPack end),
	Bucket07HalfPackCost = min (UnitCost) * sum (case when BucketWeekNo = 07 then HalfPack end),
	Bucket08HalfPackCost = min (UnitCost) * sum (case when BucketWeekNo = 08 then HalfPack end),
	Bucket09HalfPackCost = min (UnitCost) * sum (case when BucketWeekNo = 09 then HalfPack end),
	Bucket10HalfPackCost = min (UnitCost) * sum (case when BucketWeekNo = 10 then HalfPack end),
	Bucket11HalfPackCost = min (UnitCost) * sum (case when BucketWeekNo = 11 then HalfPack end),
	Bucket12HalfPackCost = min (UnitCost) * sum (case when BucketWeekNo = 12 then HalfPack end),
	Bucket13HalfPackCost = min (UnitCost) * sum (case when BucketWeekNo = 13 then HalfPack end),
	Bucket14HalfPackCost = min (UnitCost) * sum (case when BucketWeekNo = 14 then HalfPack end),
	Bucket15HalfPackCost = min (UnitCost) * sum (case when BucketWeekNo = 15 then HalfPack end),
	Bucket00ManufacturingLeadTimeInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 00 then ManufacturingLeadTimeInventory end),
	Bucket01ManufacturingLeadTimeInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 01 then ManufacturingLeadTimeInventory end),
	Bucket02ManufacturingLeadTimeInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 02 then ManufacturingLeadTimeInventory end),
	Bucket03ManufacturingLeadTimeInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 03 then ManufacturingLeadTimeInventory end),
	Bucket04ManufacturingLeadTimeInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 04 then ManufacturingLeadTimeInventory end),
	Bucket05ManufacturingLeadTimeInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 05 then ManufacturingLeadTimeInventory end),
	Bucket06ManufacturingLeadTimeInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 06 then ManufacturingLeadTimeInventory end),
	Bucket07ManufacturingLeadTimeInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 07 then ManufacturingLeadTimeInventory end),
	Bucket08ManufacturingLeadTimeInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 08 then ManufacturingLeadTimeInventory end),
	Bucket09ManufacturingLeadTimeInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 09 then ManufacturingLeadTimeInventory end),
	Bucket10ManufacturingLeadTimeInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 10 then ManufacturingLeadTimeInventory end),
	Bucket11ManufacturingLeadTimeInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 11 then ManufacturingLeadTimeInventory end),
	Bucket12ManufacturingLeadTimeInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 12 then ManufacturingLeadTimeInventory end),
	Bucket13ManufacturingLeadTimeInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 13 then ManufacturingLeadTimeInventory end),
	Bucket14ManufacturingLeadTimeInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 14 then ManufacturingLeadTimeInventory end),
	Bucket15ManufacturingLeadTimeInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 15 then ManufacturingLeadTimeInventory end),
	Bucket00RemainingInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 00 then RemainingInventory end),
	Bucket01RemainingInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 01 then RemainingInventory end),
	Bucket02RemainingInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 02 then RemainingInventory end),
	Bucket03RemainingInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 03 then RemainingInventory end),
	Bucket04RemainingInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 04 then RemainingInventory end),
	Bucket05RemainingInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 05 then RemainingInventory end),
	Bucket06RemainingInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 06 then RemainingInventory end),
	Bucket07RemainingInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 07 then RemainingInventory end),
	Bucket08RemainingInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 08 then RemainingInventory end),
	Bucket09RemainingInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 09 then RemainingInventory end),
	Bucket10RemainingInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 10 then RemainingInventory end),
	Bucket11RemainingInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 11 then RemainingInventory end),
	Bucket12RemainingInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 12 then RemainingInventory end),
	Bucket13RemainingInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 13 then RemainingInventory end),
	Bucket14RemainingInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 14 then RemainingInventory end),
	Bucket15RemainingInventoryCost = min (UnitCost) * sum (case when BucketWeekNo = 15 then RemainingInventory end),
	Bucket00Inventory = sum (case when BucketWeekNo = 00 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket01Inventory = sum (case when BucketWeekNo = 01 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket02Inventory = sum (case when BucketWeekNo = 02 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket03Inventory = sum (case when BucketWeekNo = 03 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket04Inventory = sum (case when BucketWeekNo = 04 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket05Inventory = sum (case when BucketWeekNo = 05 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket06Inventory = sum (case when BucketWeekNo = 06 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket07Inventory = sum (case when BucketWeekNo = 07 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket08Inventory = sum (case when BucketWeekNo = 08 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket09Inventory = sum (case when BucketWeekNo = 09 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket10Inventory = sum (case when BucketWeekNo = 10 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket11Inventory = sum (case when BucketWeekNo = 11 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket12Inventory = sum (case when BucketWeekNo = 12 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket13Inventory = sum (case when BucketWeekNo = 13 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket14Inventory = sum (case when BucketWeekNo = 14 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket15Inventory = sum (case when BucketWeekNo = 15 then HalfPack + ManufacturingLeadTimeInventory + RemainingInventory end),
	Bucket00HalfPack = sum (case when BucketWeekNo = 00 then HalfPack end),
	Bucket01HalfPack = sum (case when BucketWeekNo = 01 then HalfPack end),
	Bucket02HalfPack = sum (case when BucketWeekNo = 02 then HalfPack end),
	Bucket03HalfPack = sum (case when BucketWeekNo = 03 then HalfPack end),
	Bucket04HalfPack = sum (case when BucketWeekNo = 04 then HalfPack end),
	Bucket05HalfPack = sum (case when BucketWeekNo = 05 then HalfPack end),
	Bucket06HalfPack = sum (case when BucketWeekNo = 06 then HalfPack end),
	Bucket07HalfPack = sum (case when BucketWeekNo = 07 then HalfPack end),
	Bucket08HalfPack = sum (case when BucketWeekNo = 08 then HalfPack end),
	Bucket09HalfPack = sum (case when BucketWeekNo = 09 then HalfPack end),
	Bucket10HalfPack = sum (case when BucketWeekNo = 10 then HalfPack end),
	Bucket11HalfPack = sum (case when BucketWeekNo = 11 then HalfPack end),
	Bucket12HalfPack = sum (case when BucketWeekNo = 12 then HalfPack end),
	Bucket13HalfPack = sum (case when BucketWeekNo = 13 then HalfPack end),
	Bucket14HalfPack = sum (case when BucketWeekNo = 14 then HalfPack end),
	Bucket15HalfPack = sum (case when BucketWeekNo = 15 then HalfPack end),
	Bucket00ManufacturingLeadTimeInventory = sum (case when BucketWeekNo = 00 then ManufacturingLeadTimeInventory end),
	Bucket01ManufacturingLeadTimeInventory = sum (case when BucketWeekNo = 01 then ManufacturingLeadTimeInventory end),
	Bucket02ManufacturingLeadTimeInventory = sum (case when BucketWeekNo = 02 then ManufacturingLeadTimeInventory end),
	Bucket03ManufacturingLeadTimeInventory = sum (case when BucketWeekNo = 03 then ManufacturingLeadTimeInventory end),
	Bucket04ManufacturingLeadTimeInventory = sum (case when BucketWeekNo = 04 then ManufacturingLeadTimeInventory end),
	Bucket05ManufacturingLeadTimeInventory = sum (case when BucketWeekNo = 05 then ManufacturingLeadTimeInventory end),
	Bucket06ManufacturingLeadTimeInventory = sum (case when BucketWeekNo = 06 then ManufacturingLeadTimeInventory end),
	Bucket07ManufacturingLeadTimeInventory = sum (case when BucketWeekNo = 07 then ManufacturingLeadTimeInventory end),
	Bucket08ManufacturingLeadTimeInventory = sum (case when BucketWeekNo = 08 then ManufacturingLeadTimeInventory end),
	Bucket09ManufacturingLeadTimeInventory = sum (case when BucketWeekNo = 09 then ManufacturingLeadTimeInventory end),
	Bucket10ManufacturingLeadTimeInventory = sum (case when BucketWeekNo = 10 then ManufacturingLeadTimeInventory end),
	Bucket11ManufacturingLeadTimeInventory = sum (case when BucketWeekNo = 11 then ManufacturingLeadTimeInventory end),
	Bucket12ManufacturingLeadTimeInventory = sum (case when BucketWeekNo = 12 then ManufacturingLeadTimeInventory end),
	Bucket13ManufacturingLeadTimeInventory = sum (case when BucketWeekNo = 13 then ManufacturingLeadTimeInventory end),
	Bucket14ManufacturingLeadTimeInventory = sum (case when BucketWeekNo = 14 then ManufacturingLeadTimeInventory end),
	Bucket15ManufacturingLeadTimeInventory = sum (case when BucketWeekNo = 15 then ManufacturingLeadTimeInventory end),
	Bucket00RemainingInventory = sum (case when BucketWeekNo = 00 then RemainingInventory end),
	Bucket01RemainingInventory = sum (case when BucketWeekNo = 01 then RemainingInventory end),
	Bucket02RemainingInventory = sum (case when BucketWeekNo = 02 then RemainingInventory end),
	Bucket03RemainingInventory = sum (case when BucketWeekNo = 03 then RemainingInventory end),
	Bucket04RemainingInventory = sum (case when BucketWeekNo = 04 then RemainingInventory end),
	Bucket05RemainingInventory = sum (case when BucketWeekNo = 05 then RemainingInventory end),
	Bucket06RemainingInventory = sum (case when BucketWeekNo = 06 then RemainingInventory end),
	Bucket07RemainingInventory = sum (case when BucketWeekNo = 07 then RemainingInventory end),
	Bucket08RemainingInventory = sum (case when BucketWeekNo = 08 then RemainingInventory end),
	Bucket09RemainingInventory = sum (case when BucketWeekNo = 09 then RemainingInventory end),
	Bucket10RemainingInventory = sum (case when BucketWeekNo = 10 then RemainingInventory end),
	Bucket11RemainingInventory = sum (case when BucketWeekNo = 11 then RemainingInventory end),
	Bucket12RemainingInventory = sum (case when BucketWeekNo = 12 then RemainingInventory end),
	Bucket13RemainingInventory = sum (case when BucketWeekNo = 13 then RemainingInventory end),
	Bucket14RemainingInventory = sum (case when BucketWeekNo = 14 then RemainingInventory end),
	Bucket15RemainingInventory = sum (case when BucketWeekNo = 15 then RemainingInventory end)
from	@RawInventoryWeekly
group by
	Part
GO
