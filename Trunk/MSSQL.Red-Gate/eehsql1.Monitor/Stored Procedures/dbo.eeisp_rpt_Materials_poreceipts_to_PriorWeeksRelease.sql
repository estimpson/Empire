SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE	procedure [dbo].[eeisp_rpt_Materials_poreceipts_to_PriorWeeksRelease] (@EvaluateWeek datetime, @LookOutWeeks int)
as
begin

--eeisp_rpt_Materials_poreceipts_to_PriorWeeksRelease '2009/01/12', 1

Declare	@Date datetime,
		@DayofWeek int,
		@PriorWeekSchedule int


Select	@date = @EvaluateWeek
Select	@DayofWeek = 7
Select	@PriorWeekSchedule = 1
Select	@LookOutWeeks = @LookOutWeeks+1

create	table #receipts (	Vendor varchar(25),
						PONumber varchar(25),
						Part varchar(25),
						Quantity numeric(20,6),
						Cost numeric(20,6),
						Extended numeric(20,6), Primary Key (Vendor, POnumber, PArt))

Insert	#receipts
Select	from_loc,
		po_number,
		audit_trail.part,
		sum(quantity),
		material_cum,
		sum(quantity*material_cum)
from		audit_trail
join		part_standard on audit_trail.part = part_standard.part
where	type = 'R' and
		date_stamp>= ft.fn_TruncDate('wk',@Date) and date_stamp< dateadd(wk,1, ft.fn_TruncDate('wk',@Date))
group by	from_loc,
		po_number,
		audit_trail.part,		
		material_cum


create	table #POs (		PONumber varchar(25),
						Part varchar(25),
						Quantity numeric(20,6), Primary Key (POnumber, PArt))					
		

Insert	#POs
Select	PONumber,
		Part,
		Sum(StdQty)
from		FT.ReleasePlanRaw
join		FT.releasePlans on Ft.ReleasePlanRaw.releasePlanId = FT.ReleasePlans.id
where	DueDT < dateadd(wk,@LookOutWeeks, ft.fn_TruncDate('wk',@Date)) and
		DueDT>= dateadd(d, -30, getdate()) and
		GeneratedDT  = (Select		max(GeneratedDT)
						 from	FT.releasePlans 
						where	GeneratedDT >=	dateadd(wk,0-@PriorWeekSchedule, ft.fn_TruncDate('wk',@Date)) and
								GeneratedDT <	dateadd(wk,1-@PriorWeekSchedule, ft.fn_TruncDate('wk',@Date)) and
								GeneratedWeekDay <= @DayOfWeek)
group by PONumber,
		Part
UNION ALL
Select	PONumber,
		Part,
		Sum(StdQty)
from		FT.ReleasePlanRaw
join		FT.releasePlans on Ft.ReleasePlanRaw.releasePlanId = FT.ReleasePlans.id
where	DueDT < dateadd(wk,@LookOutWeeks, ft.fn_TruncDate('wk',@Date)) and
		DueDT>= dateadd(d, -30, getdate()) and
		GeneratedDT  = (Select		max(GeneratedDT)
						 from	FT.releasePlans 
						where	GeneratedDT >=	dateadd(wk,0, ft.fn_TruncDate('wk',@Date)) and
								GeneratedDT <	dateadd(wk,1, ft.fn_TruncDate('wk',@Date)) and
								GeneratedWeekDay <= @DayOfWeek) and PONumber not in(Select	PONumber
from		FT.ReleasePlanRaw
join		FT.releasePlans on Ft.ReleasePlanRaw.releasePlanId = FT.ReleasePlans.id
where	DueDT < dateadd(wk,@LookOutWeeks, ft.fn_TruncDate('wk',@Date)) and
		DueDT>= dateadd(d, -30, getdate()) and
		GeneratedDT  = (Select		max(GeneratedDT)
						 from	FT.releasePlans 
						where	GeneratedDT >=	dateadd(wk,0-@PriorWeekSchedule, ft.fn_TruncDate('wk',@Date)) and
								GeneratedDT <	dateadd(wk,1-@PriorWeekSchedule, ft.fn_TruncDate('wk',@Date)) and
								GeneratedWeekDay <= @DayOfWeek))
group by PONumber,
		Part






select	#POs.PONumber PO_PONumber,
		#POs.Part PO_Part,
		isNULL(#POs.Quantity,0) POQty,
		isNULL(#POs.Quantity,0)*isNULL(PS.material_cum,0) POExtended,
		#receipts.Vendor Vendor,
		#receipts.PONumber ReceiptPO,
		#receipts.Part ReceiptPart,
		isNULL(#receipts.Quantity,0) ReceiptQty,
		isNULL(#receipts.Cost,0) as ReceiptCost,
		isNULL(#receipts.Extended,0) as Receiptext,
		(CASE WHEN isNULL(#POs.Quantity,0)*isNULL(PS.material_cum,0)<isNULL(#receipts.Extended,0) THEN isNULL(#receipts.Extended,0) - isNULL(#POs.Quantity,0)*isNULL(PS.material_cum,0) ELSE 0 END) OverreceiptsExtended
from		#receipts
full	join	#POs on #receipts.PoNumber = #POs.PONumber and #receipts.Part = #POs.Part
left join		part_standard PS on #POs.part = PS.part
where	(CASE WHEN isNULL(#POs.Quantity,0)*isNULL(PS.material_cum,0)<isNULL(#receipts.Extended,0) THEN isNULL(#receipts.Extended,0) - isNULL(#POs.Quantity,0)*isNULL(PS.material_cum,0) ELSE 0 END)  > 0 

order by 1,2





End
GO
