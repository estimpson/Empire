SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FT].[csp_CreatePOSched]
--	<Debug>
(	@Debug integer = 0 )
--	</Debug>
as
/*
Arguments:
None

Result set:
None

Description:
Create new PO Schedule.

Example:
--	Cannot be tested directly.  Call csp_AutoPOGen.
execute	FT.csp_AutoPOGen
--<Debug>
	@Debug = 1
--</Debug>

Author:
Eric Stimpson
Copyright © 2004 Fore-Thought, LLC

Process:
--	I.	Delete Soft PO Schedule.
--	II.	Loop by Week No.
--		A.	Get current week frozen PO balance.
--		B.	Set Prior PO Accum.
--		C.	Calculate required PO Balance.
--		D.	Increase frozen POs.
--		E.	Create new POs.
--	III.	Finished
*/

--<Debug>
declare	@ProcStartDT datetime
declare	@StartDT datetime
if @Debug & 1 = 1 begin
	select	@StartDT = GetDate ( )
	select	@ProcStartDT = GetDate ( )
	print	'CreatePOSched START.   ' + Convert ( varchar (50), @ProcStartDT )
end
--</Debug>

--	<Debug>
if @Debug & 1 = 1
begin
	print	'Delete soft PO releases..'
	select	@StartDT = GetDate ( )
end
--	</Debug>
--	I.	Delete Soft PO Schedule.
create table #SoftPOD
(	PONumber integer,
	Part varchar (25),
	DueDT datetime,
	LineID integer )

insert	#SoftPOD
select	PONumber,
	Part,
	DueDT,
	LineID
from	vwPODSoft

delete	dbo.po_detail
from	dbo.po_detail
	join #SoftPOD on po_detail.po_number = #SoftPOD.PONumber and
		po_detail.part_number = #SoftPOD.Part and
		po_detail.date_due = #SoftPOD.DueDT and
		po_detail.row_id = #SoftPOD.LineID

--		A.	Delete PO Schedule when set to Non-Order-Status.
delete	dbo.po_detail
from	dbo.po_detail
	join FT.vwPOD vwPOD on po_detail.po_number = vwPOD.PONumber and
		po_detail.part_number = vwPOD.Part and
		po_detail.date_due = vwPOD.DueDT and
		po_detail.row_id = vwPOD.LineID
where	vwPOD.NonOrderStatus = 'Y'

update	dbo.part_vendor
set	qty_over_received = 0

--	<Debug>
if @Debug & 1 = 1
	print	'Soft PO releases deleted.   ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate ( ) ) ) + ' ms'
--	</Debug>

declare	@WeekNo integer
select	@WeekNo = 0

--	II.	Loop by Week No.
while @WeekNo <=
(	select	Max ( WeekNo )
	from	FT.WkNMPS )
begin
--		A.	Get current week frozen PO balance.
--	<Debug>
	if @Debug & 1 = 1
	begin
		print	'Calculate new release quantities..'
		select	@StartDT = GetDate ( )
	end
--	</Debug>
	update	FT.WkNMPS
	set	FrozenPOBalance = IsNull (
		(	select	sum ( POD.StdQty )
			from	vwPOD POD
			where	POD.Part = WkNMPS.Part and
				POD.DeliveryWeek <= @WeekNo ), 0 )
	where	WeekNo = @WeekNo and
		@WeekNo = 0

	update	FT.WkNMPS
	set	FrozenPOBalance = IsNull (
		(	select	sum ( POD.StdQty )
			from	vwPOD POD
			where	POD.Part = WkNMPS.Part and
				POD.DeliveryWeek = @WeekNo ), 0 )
	where	WeekNo = @WeekNo and
		@WeekNo != 0

--		B.	Set Prior PO Accum.
	update	FT.WkNMPS
	set	PriorPOAccum = IsNull (
		(	select	Max ( PriorWeek.PriorPOAccum + PriorWeek.POBalance + PriorWeek.FrozenPOBalance )
			from	WkNMPS PriorWeek
			where	WkNMPS.Part = PriorWeek.Part and
				PriorWeek.WeekNo < @WeekNo ), 0 )
	from	FT.WkNMPS WkNMPS
	where	WeekNo = @WeekNo

--		C.	Calculate required PO Balance.
	update	FT.WkNMPS
	set	POBalance =
		(	case WkNMPS.RoundingMethod
				when -1 then Floor ( ( WkNMPS.PostDemandAccum - ( WkNMPS.PriorPOAccum + WkNMPS.FrozenPOBalance ) ) / WkNMPS.StandardPack )
				when 0 then Round ( ( WkNMPS.PostDemandAccum - ( WkNMPS.PriorPOAccum + WkNMPS.FrozenPOBalance ) ) / WkNMPS.StandardPack, 0 )
				when 1 then Ceiling ( ( WkNMPS.PostDemandAccum - ( WkNMPS.PriorPOAccum + WkNMPS.FrozenPOBalance ) ) / WkNMPS.StandardPack )
			end ) * WkNMPS.StandardPack
	from	FT.WkNMPS WkNMPS
	where	WeekNo = @WeekNo and
		(	case WkNMPS.RoundingMethod
				when -1 then Floor ( ( WkNMPS.PostDemandAccum - ( WkNMPS.PriorPOAccum + WkNMPS.FrozenPOBalance ) ) / WkNMPS.StandardPack )
				when 0 then Round ( ( WkNMPS.PostDemandAccum - ( WkNMPS.PriorPOAccum + WkNMPS.FrozenPOBalance ) ) / WkNMPS.StandardPack, 0 )
				when 1 then Ceiling ( ( WkNMPS.PostDemandAccum - ( WkNMPS.PriorPOAccum + WkNMPS.FrozenPOBalance ) ) / WkNMPS.StandardPack )
			end ) * WkNMPS.StandardPack > 0
--	<Debug>
	if @Debug & 1 = 1
		print	'Releases calculated.   ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate ( ) ) ) + ' ms'
--	</Debug>

--	<Debug>
	if @Debug & 1 = 1
	begin
		print	'Update POs w/in frozen..'
		select	@StartDT = GetDate ( )
	end
--	</Debug>
--		D.	Increase frozen POs.
	update	dbo.po_detail
	set	quantity = po_detail.quantity + WkNMPS.POBalance,
		balance = po_detail.balance + WkNMPS.POBalance
	from	dbo.po_detail
		join FT.WkNMPS WkNMPS on po_detail.po_number = WkNMPS.PONumber and
			WkNMPS.WeekNo = @WeekNo
	where	po_detail.date_due = dateadd ( wk, WkNMPS.WeekNo + DateDiff ( wk, '1995/01/01', GetDate ( ) ), '1995/01/01' ) + WkNMPS.DeliveryDW - 1
--	<Debug>
	if @Debug & 1 = 1
		print	'POs updated.   ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate ( ) ) ) + ' ms'
--	</Debug>

--	<Debug>
	if @Debug & 1 = 1
	begin
		print	'Create new POs..'
		select	@StartDT = GetDate ( )
	end
--	</Debug>
--		E.	Create new POs.
	insert	dbo.po_detail
	(	po_number,
		vendor_code,
		part_number,
		description,
		unit_of_measure,
		date_due,
		status,
		type,
		quantity,
		balance,
		price,
		row_id,
		ship_to_destination,
		terms,
		week_no,
		standard_qty,
		ship_type,
		ship_via,
		received,
		alternate_price )
	select	WkNMPS.PONumber,
		po_header.vendor_code,
		WkNMPS.Part,
		part.name,
		part_inventory.standard_unit,
		date_due = dateadd ( wk, WkNMPS.WeekNo + DateDiff ( wk, '1995/01/01', GetDate ( ) ), '1995/01/01' ) + WkNMPS.DeliveryDW - 1,
		po_header.status,
		po_header.type,
		quantity = WkNMPS.POBalance,
		balance = WkNMPS.POBalance,
		Price =
		(	select	price
			from	dbo.part_vendor_price_matrix
			where	part = WkNMPS.Part and
				vendor = po_header.vendor_code and
				break_qty =
				(	select	max ( break_qty )
					from	dbo.part_vendor_price_matrix
					where	part = WkNMPS.Part and
						vendor = po_header.vendor_code and
						break_qty <= WkNMPS.POBalance ) ),
		RowID = DatePart ( dy, dateadd ( wk, WkNMPS.WeekNo + DateDiff ( wk, '1995/01/01', GetDate ( ) ), '1995/01/01' ) + WkNMPS.DeliveryDW - 1 ),
		po_header.ship_to_destination,
		po_header.terms,
		week_no = DatePart ( wk, dateadd ( wk, WkNMPS.WeekNo + DateDiff ( wk, '1995/01/01', GetDate ( ) ), '1995/01/01' ) + WkNMPS.DeliveryDW - 1 ),
		standard_qty = WkNMPS.POBalance,
		ship_type = 'N',
		po_header.ship_via,
		received = 0,
		alternate_price =
		(	select	price
			from	dbo.part_vendor_price_matrix
			where	part = WkNMPS.Part and
				vendor = po_header.vendor_code and
				break_qty =
				(	select	max ( break_qty )
					from	dbo.part_vendor_price_matrix
					where	part = WkNMPS.Part and
						vendor = po_header.vendor_code and
						break_qty <= WkNMPS.POBalance ) )
	from	FT.WkNMPS WkNMPS
		join dbo.po_header on WkNMPS.PONumber = po_header.po_number
		join dbo.part on WkNMPS.Part = part.part
		join dbo.part_inventory on WkNMPS.Part = part_inventory.part
	where	WkNMPS.POBalance > 0 and
		WkNMPS.WeekNo = @WeekNo and
		not exists
		(	select	1
			from	dbo.po_detail
			where	po_detail.po_number = WkNMPS.PONumber and
				po_detail.date_due = dateadd ( wk, WkNMPS.WeekNo + DateDiff ( wk, '1995/01/01', GetDate ( ) ), '1995/01/01' ) + WkNMPS.DeliveryDW - 1 ) and
		not exists
		(	select	1
			from	dbo.po_detail
			where	po_detail.po_number = WkNMPS.PONumber and
				po_detail.row_id = DatePart ( dy, dateadd ( wk, WkNMPS.WeekNo + DateDiff ( wk, '1995/01/01', GetDate ( ) ), '1995/01/01' ) + WkNMPS.DeliveryDW - 1 ) )
--	<Debug>
	if @Debug & 1 = 1
		print	'New POs created.   ' + Convert ( varchar, DateDiff ( ms, @StartDT, GetDate ( ) ) ) + ' ms'
--	</Debug>

select	@WeekNo = @WeekNo + 1
end

--	III.	Finished
--<Debug>
if @Debug & 1 = 1 begin
	print	'FINISHED.   ' + Convert ( varchar, DateDiff ( ms, @ProcStartDT, GetDate ( ) ) ) + ' ms'
end
--</Debug>
GO
