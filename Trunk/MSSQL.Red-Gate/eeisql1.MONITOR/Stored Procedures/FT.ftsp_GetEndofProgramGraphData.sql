SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[ftsp_GetEndofProgramGraphData] (
	@Operator varchar (5),
	@ProgramID int,
	@VariablePart varchar (25),
	@MaxValue numeric (20,6)
--<Debug>
	, @Debug integer = 0
--</Debug>
)
as
/*
Arguments:
Operator
ProgramID
VariablePart
MaxValue

Result set:
None

Description:
Modifys an Ending Orders.

Example:
execute	FT.ftsp_GetEndofProgramGraphData
	@PartCode = 'Test',
	@CustomerCode = 'Test',
	@EndingQty = 0
--<Debug>
	, @Debug = 1
--</Debug>

Author:
Eric Stimpson
Copyright © 2004 Fore-Thought, LLC

Process:
--	I.	Validate parameters.
--		A.	PartCode must be valid.
--		B.	CustomerCode must be valid.
--		C.	PartCode-CustomerCode must exist.
--		D.	Quantity must be zero or more.
--	II.	Modify ending order.
*/

create table #VariableDemand
(	EndingPartCode varchar (25),
	EndingQty numeric (20,6) default (0) primary key )

declare	@Packs integer
select	@Packs = 0

insert	#VariableDemand
(	EndingPartCode )
select	@VariablePart

while
(	select	max ( EndingQty )
	from	#VariableDemand ) < @MaxValue and
(	select	standard_pack
	from	dbo.part_inventory part_inventory
	where	part = @VariablePart ) > 0 begin
	select	@Packs = @Packs + 1

	insert	#VariableDemand
	select	part,
		standard_pack * @Packs
	from	part_inventory
	where	part = @VariablePart
end

select	VariablePart,
	VariableEndingQty,
	RawPart,
	RawDescription,
	RawXRef,
	GrossDemand,
	BOMOnhand,
	OnOrderFirm,
	OnOrderTotal,
	NetDemand,
	StandardPack,
	NetRemaining =
	(	case when NetDemand < 0 then -NetDemand else
			(	case when NetDemand % StandardPack = 0 then 0
					else StandardPack - NetDemand % StandardPack
				end )
		end ),
	Cost,
	LeadTime,
	RunDT,
	default_vendor
into	#VariableBuildOut
from	(
select	VariablePart = #VariableDemand.EndingPartCode,
	VariableEndingQty = #VariableDemand.EndingQty,
	RawPart = XRt.ChildPart,
	RawDescription = min (raw.name),
	RawXRef = min (raw.cross_ref),
	GrossDemand = sum (case when #VariableDemand.EndingPartCode = EndingOrders.PartCode then #VariableDemand.EndingQty else EndingOrders.EndingQty end * XQty) + IsNull (min (OrderDemand), 0),
	BOMOnhand = isnull (min (BOMOnhand), 0),
	OnOrderFirm = isnull (min (OnOrderFirm.POBalance), 0),
	OnOrderTotal = isnull (min (OnOrderTotal.POBalance), 0),
	NetDemand = convert (integer, sum (case when #VariableDemand.EndingPartCode = EndingOrders.PartCode then #VariableDemand.EndingQty else EndingOrders.EndingQty end * XQty) + IsNull (min (OrderDemand), 0) - isnull (min (BOMOnhand), 0) - isnull (min (OnOrderFirm.POBalance), 0)),
	StandardPack = convert (integer, min (part_inventory.standard_pack)),
	Cost = min (part_standard.cost_cum),
	LeadTime = part_vendor.lead_time,
	RunDT = GetDate (),
	default_vendor = min(part_online.default_vendor)
from	#VariableDemand
	cross join FT.EndingOrders EndingOrders
	join FT.XRt XRT on EndingOrders.PartCode = XRt.TopPart
	join FT.EndofProgramRawParts EndofProgramRawParts on XRt.ChildPart = EndofProgramRawParts.PartCode and
		EndofProgramRawParts.Operator = @Operator and
		EndofProgramRawParts.ProgramID = @ProgramID
	join dbo.part raw on XRt.ChildPart = raw.part and
		raw.type = 'R'
	join dbo.part_inventory part_inventory on XRt.ChildPart = part_inventory.part
	join dbo.part_standard part_standard on XRt.ChildPart = part_standard.part
	join dbo.part_online part_online on XRt.ChildPart = part_online.part
	left outer join dbo.part_vendor part_vendor on part_online.default_vendor = part_vendor.vendor and
		XRt.ChildPart = part_vendor.part
	left outer join
	(	select	XRt1.ChildPart,
			BOMOnhand = sum (object.std_quantity * XRt1.XQty)
		from	dbo.object object
			join dbo.location location on object.location = location.code and
				isnull (location.secured_location, 'N') = 'N'
			join FT.XRt XRt1 on object.part = XRt1.TopPart
		group by
			XRt1.ChildPart ) BOMOnhand on XRt.ChildPart = BOMOnhand.ChildPart
	left outer join
	(	select	po_detail.part_number,
			POBalance = sum (po_detail.balance)
		from	dbo.po_detail po_detail
			join dbo.part_online part_online on po_detail.part_number = part_online.part
			left outer join dbo.part_vendor part_vendor on part_online.default_vendor = part_vendor.vendor and
				po_detail.part_number = part_vendor.part
		where	po_detail.po_number = part_online.default_po_number and
			po_detail.date_due <= GetDate () + part_vendor.lead_time
		group by
			po_detail.part_number) OnOrderFirm on OnOrderFirm.part_number = XRt.ChildPart
	left outer join
	(	select	po_detail.part_number,
			POBalance = sum (po_detail.balance)
		from	dbo.po_detail po_detail
			join dbo.part_online part_online on po_detail.part_number = part_online.part
			left outer join dbo.part_vendor part_vendor on part_online.default_vendor = part_vendor.vendor and
				po_detail.part_number = part_vendor.part
		where	po_detail.po_number = part_online.default_po_number and
			po_detail.date_due <= GetDate () + part_vendor.lead_time
		group by
			po_detail.part_number) OnOrderTotal on OnOrderTotal.part_number = XRt.ChildPart
	left outer join
	(	select	XRt1.ChildPart,
			OrderDemand = sum (order_detail.std_qty * XRt1.XQty)
		from	dbo.order_detail order_detail
			join FT.XRt XRt1 on order_detail.part_number = XRt1.TopPart
		where	order_detail.part_number not in
			(	select	PartCode
				from	FT.EndingOrders
				where	Operator = @Operator and
					ProgramID = @ProgramID)
		group by
			XRt1.ChildPart) OrderDemand on XRt.ChildPart = OrderDemand.ChildPart
where	EndingOrders.Operator = @Operator and
	EndingOrders.ProgramID = @ProgramID
group by
	XRt.ChildPart,
	part_online.default_po_number,
	part_vendor.lead_time,
	#VariableDemand.EndingQty,
	#VariableDemand.EndingPartCode ) NetDemand
order by
	1

select	VariablePart,
	VariableEndingQty,
	Sum ( NetRemaining * Cost )
from	#VariableBuildOut
group by
	VariablePart,
	VariableEndingQty
order by
	2
GO
