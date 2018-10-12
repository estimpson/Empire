SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE	procedure [dbo].[eeisp_rpt_Materials_poreceipts_to_PriorWeeksRelease_all] (@EvaluateWeek datetime, @LookOutWeeks int)
as
begin

--eeisp_rpt_Materials_poreceipts_to_PriorWeeksRelease_all '2009/02/16', 1

Declare	@Date datetime,
		@DayofWeek int,
		@PriorWeekSchedule int


Select	@date = @EvaluateWeek
Select	@DayofWeek = 1
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


create	table #deletes (	PONumber varchar(25),
						Part varchar(25),
						Quantity numeric(20,6),
						Cost numeric(20,6),
						Extended numeric(20,6), Primary Key ( POnumber, PArt))

Insert	#deletes
Select	po_number,
		audit_trail.part,
		sum(quantity),
		material_cum,
		sum(quantity*material_cum)
from		audit_trail
join		part_standard on audit_trail.part = part_standard.part
where	type = 'D' and
		date_stamp>= ft.fn_TruncDate('wk',@date) and date_stamp< dateadd(wk,2, ft.fn_TruncDate('wk',@date)) and
		remarks = 'Delete' and
		serial in (Select serial
				from		audit_trail
join		part_standard on audit_trail.part = part_standard.part
where	type = 'R' and
		date_stamp>= ft.fn_TruncDate('wk',@date) and date_stamp< dateadd(wk,1, ft.fn_TruncDate('wk',@date))) and
		quantity>0 and
		po_number is not null
group by	po_number,
		audit_trail.part,		
		material_cum


create	table #POs (		Vendor varchar(25), 
						PONumber varchar(25),
						Part varchar(25),
						Quantity numeric(20,6), Primary Key (POnumber, PArt))					
		

Insert	#POs
Select	COALESCE(TWVendorCode, LWVendorCode),
		COALESCE(TWPONumber, LWPONumber),
		COALESCE(TWpart, LWPart),
		isnull(dbo.fn_GreaterOf(isNull((ThisWeekStdQty),0),isNull((LastWeekStdQty),0)),0)
from
(Select	po_header.vendor_code as LWVendorCode,
		PONumber as LWPONumber,
		Part as LWpart,
		Sum(StdQty) as LastWeekStdQty
from		FT.ReleasePlanRaw
join		FT.releasePlans on Ft.ReleasePlanRaw.releasePlanId = FT.ReleasePlans.id
join		po_header on FT.ReleasePlanRaw.PONumber = po_header.po_number
where	DueDT < dateadd(wk,2, ft.fn_TruncDate('wk',@Date)) and
		DueDT>= dateadd(d, -30, @Date) and
		GeneratedDT  = (Select		min(GeneratedDT)
						 from	FT.releasePlans 
						where	GeneratedDT >=	dateadd(wk,-1, ft.fn_TruncDate('wk',@Date)) and
								GeneratedDT <	dateadd(wk,0, ft.fn_TruncDate('wk',@Date)) and
								GeneratedWeekDay > 1)
group by	po_header.vendor_code ,
		PONumber,
		Part) LW
full join	(Select	po_header.vendor_code as TWVendorCode,
		PONumber as TWPONumber,
		Part as TWpart,
		Sum(StdQty) as ThisWeekStdQty		
from		FT.ReleasePlanRaw
join		FT.releasePlans on Ft.ReleasePlanRaw.releasePlanId = FT.ReleasePlans.id
join		po_header on FT.ReleasePlanRaw.PONumber = po_header.po_number
where	DueDT < dateadd(wk,2, ft.fn_TruncDate('wk',@Date)) and
		DueDT>= dateadd(d, -30, @Date) and
		GeneratedDT  = (Select		max(GeneratedDT)
						 from	FT.releasePlans 
						where	GeneratedDT >=	dateadd(wk,0, ft.fn_TruncDate('wk',@Date)) and
								GeneratedDT <	dateadd(wk,1, ft.fn_TruncDate('wk',@Date)) and
								GeneratedWeekDay >= 1)
group by	po_header.vendor_code,
		PONumber,
		Part) TW on LW.LWPONumber = TW.TWPONumber  and LW.LWPart = TW.TWPart


select	POs.PONumber PO_PONumber,
		POs.Part PO_Part,
		isNULL(POs.Quantity,0) POQty,
		isNULL(POs.Quantity,0)*isNULL(PS.material_cum,0) POExtended,
		COALESCE(receipts.Vendor, POs.Vendor) Vendor,
		COALESCE(receipts.PONumber, POs.PONumber)  ReceiptPO,
		COALESCE(receipts.Part, POs.Part) ReceiptPart,
		isNULL(receipts.Quantity,0) - isNULL(Deletes.Quantity,0) ReceiptQty,
		isNULL(receipts.Cost,0) as ReceiptCost,
		isNULL(receipts.Extended,0) -isNULL(Deletes.Extended,0) as Receiptext,
		(CASE WHEN isNULL(POs.Quantity,0)*isNULL(PS.material_cum,0)<(isNULL(receipts.Extended,0)-isNULL(Deletes.Extended,0)) THEN ((isNULL(receipts.Extended,0)-isNULL(Deletes.Extended,0)) - (isNULL(POs.Quantity,0)*isNULL(PS.material_cum,0))) ELSE 0 END) OverreceiptsExtended,
		isNULL(Deletes.Extended,0) as DeletesExtended,
		isNULL(Deletes.Quantity,0) as Deletes
from		#receipts Receipts 
full	join	#POs POs on Convert(int,receipts.PoNumber) = POs.PONumber	and	rtrim(receipts.Part) = rtrim(POs.Part)
left	join	#Deletes Deletes on Convert(int,deletes.PoNumber) = Convert(int,receipts.PoNumber) and rtrim(deletes.Part) = rtrim(receipts.Part)
left join	part_standard PS on POs.part = PS.part
--where	(CASE WHEN isNULL(#POs.Quantity,0)*isNULL(PS.material_cum,0)<isNULL(#receipts.Extended,0) THEN isNULL(#receipts.Extended,0) - isNULL(#POs.Quantity,0)*isNULL(PS.material_cum,0) ELSE 0 END)  > 0 

order by 5,1,2





End
GO
