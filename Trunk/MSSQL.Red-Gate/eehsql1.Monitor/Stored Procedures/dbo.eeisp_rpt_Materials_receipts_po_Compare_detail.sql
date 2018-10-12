SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE	procedure [dbo].[eeisp_rpt_Materials_receipts_po_Compare_detail] (@Date datetime, @DayofWeek int, @PriorWeekSchedule int)
as
begin

--eeisp_rpt_Materials_receipts_po_Compare_detail '2008-12-15', 2, 1






Select	@PriorWeekSchedule = isNULL(@PriorWeekSchedule,0)



Select	vendor_code,
		(CASE WHEN	PODQty+Qty> isNULL(RunningTotal,0) THEN 1 ELSE 0 END) as LineItemTouched,
		(CASE WHEN	isNULL(PODetailDue, dateadd(wk,2, ft.fn_TruncDate('wk',@Date))) >dateadd(wk,1, ft.fn_TruncDate('wk',@Date)) THEN 0 ELSE 1 END) as DueCurrentWeek,
		ATPO,
		ATShipper,
		Part,
		PODetailDue,
		PODqty*cost as ExtendedPO,
		Standard_pack,
		cost*RunningTotal as ExtendedRunningTotal,
		cost*Qty as ExtendedReceipts,
		cost,
		EOW

into		#POReceipts		
from	



(Select	Receipts.EOW,
		sum(isNull(Receipts.Qty,0)-isNULL(DeleteReceipts.qty,0)) as qty,
		Receipts.Part,
		Receipts.ATPO,
		ATShipper,
		Receipts.Cost,
		sum(isNull(Receipts.ExtCost,0)-isNULL(DeleteReceipts.ExtCost,0))  as ExtCost,
		Receipts.Vendor_code,
		Receipts.standard_pack
from		(Select	serial,
		dateadd(wk,1, ft.fn_TruncDate('wk',@Date)) as EOW,
		std_quantity qty,
		audit_trail.part,
		convert(int,audit_trail.po_number) ATPO,
		part_standard.cost,
		part_standard.cost*std_quantity Extcost,
		vendor_code,
		standard_pack,
		audit_trail.shipper ATShipper
from		audit_trail 
join		part_standard on audit_trail.part = part_standard.part
join		po_header on audit_trail.po_number = po_header.po_number
join		part_inventory on part_standard.part = part_inventory.part
where	audit_trail.type  = 'R'  and		
		date_stamp >=dateadd(wk,0, ft.fn_TruncDate('wk',@Date)) and
		date_stamp <	dateadd(wk,1, ft.fn_TruncDate('wk',@Date))
) Receipts left Join	

(Select	serial,
		dateadd(wk,1, ft.fn_TruncDate('wk',@date)) as EOW,
		std_quantity qty,
		audit_trail.part,
		convert(int,audit_trail.po_number) ATPO,
		part_standard.cost,
		part_standard.cost*std_quantity Extcost,
		vendor_code,
		standard_pack
from		audit_trail 
join		part_standard on audit_trail.part = part_standard.part
join		po_header on audit_trail.po_number = po_header.po_number
join		part_inventory on part_standard.part = part_inventory.part
where	audit_trail.type  = 'D'  and		
		date_stamp >=dateadd(wk,0, ft.fn_TruncDate('wk',@Date)) and
		date_stamp <	dateadd(wk,1, ft.fn_TruncDate('wk',@Date)) and
		std_quantity>0
) DeleteReceipts on Receipts.serial = DeleteReceipts.serial
group by 
Receipts.EOW,
		Receipts.Part,
		Receipts.ATPO,
		Receipts.Cost,
		Receipts.Vendor_code,
		Receipts.standard_pack,
		ATShipper) Receipts left Join

(Select	PONumber PODPOnumber,
		Part PODPart,
		DueDT PODetailDue,
		StdQty PODQty,
		GeneratedDT,
		isNULL(( Select	sum(isNULL(STDQty,0))
		 from	FT.ReleasePlanRaw RP2
		where	RP2.ReleaseplanID = FT.ReleasePlanRaw.ReleaseplanID and
				Rp2.PONumber = FT.ReleasePlanRaw.PONumber and
				Rp2.Part = FT.ReleasePlanRaw.Part and
				rp2.DueDT<=  FT.ReleasePlanRaw.DueDT),0) as RunningTotal
from		FT.ReleasePlanRaw
join		FT.releasePlans on Ft.ReleasePlanRaw.releasePlanId = FT.ReleasePlans.id
where	DueDT < dateadd(wk,8, ft.fn_TruncDate('wk',@Date)) and
		GeneratedDT  = (Select		max(GeneratedDT)
						 from	FT.releasePlans 
						where	GeneratedDT >=	dateadd(wk,0-@PriorWeekSchedule, ft.fn_TruncDate('wk',@Date)) and
								GeneratedDT <	dateadd(wk,1-@PriorWeekSchedule, ft.fn_TruncDate('wk',@Date)) and
								GeneratedWeekDay <= @DayOfWeek) 
) PODetail on Receipts.ATPO = PODPONumber and Receipts.Part = PODPArt
order by ATPO, Part, PODetailDue





--(Select	dateadd(wk,1, ft.fn_TruncDate('wk',@Date)) as EOW,
--		sum(std_quantity) qty,
--		audit_trail.part,
--		convert(int,audit_trail.po_number) ATPO,
--		part_standard.cost,
--		sum(part_standard.cost*std_quantity) Extcost,
--		vendor_code,
--		standard_pack,
--		(select	min(date_Stamp) 
--		from		audit_trail at2 
--		where	at2.type = 'R' and at2.part = audit_trail.part and 
--				at2.po_number = audit_trail.po_number and
--				at2.date_stamp >=dateadd(wk,0, ft.fn_TruncDate('wk',@Date)) and
--				at2.date_stamp <	dateadd(wk,1, ft.fn_TruncDate('wk',@Date))) as FirstReceiptDT
--from		audit_trail
--join		part_standard on audit_trail.part = part_standard.part
--join		po_header on audit_trail.po_number = po_header.po_number
--join		part_inventory on part_standard.part = part_inventory.part
--where	audit_trail.type = 'R' and		
--		date_stamp >=dateadd(wk,0, ft.fn_TruncDate('wk',@Date)) and
--		date_stamp <	dateadd(wk,1, ft.fn_TruncDate('wk',@Date))
--
--group	by
--		audit_trail.part,
--		audit_trail.po_number,
--		part_standard.cost,
--		vendor_code,
--		standard_pack) Receipts left Join
--
--(Select	PONumber PODPOnumber,
--		Part PODPart,
--		DueDT PODetailDue,
--		StdQty PODQty,
--		GeneratedDT,
--		isNULL(( Select	sum(isNULL(STDQty,0))
--		 from	FT.ReleasePlanRaw RP2
--		where	RP2.ReleaseplanID = FT.ReleasePlanRaw.ReleaseplanID and
--				Rp2.PONumber = FT.ReleasePlanRaw.PONumber and
--				Rp2.Part = FT.ReleasePlanRaw.Part and
--				rp2.DueDT<=  FT.ReleasePlanRaw.DueDT),0) as RunningTotal
--from		FT.ReleasePlanRaw
--join		FT.releasePlans on Ft.ReleasePlanRaw.releasePlanId = FT.ReleasePlans.id
--where	DueDT < dateadd(wk,8, ft.fn_TruncDate('wk',@Date)) and
--		GeneratedDT  = (Select		max(GeneratedDT)
--						 from	FT.releasePlans 
--						where	GeneratedDT >=	dateadd(wk,0-@PriorWeekSchedule, ft.fn_TruncDate('wk',@Date)) and
--								GeneratedDT <	dateadd(wk,1-@PriorWeekSchedule, ft.fn_TruncDate('wk',@Date)) and
--								GeneratedWeekDay <= @DayOfWeek) 
--) PODetail on Receipts.ATPO = PODPONumber and Receipts.Part = PODPArt
--order by ATPO, Part, PODetailDue


select *,
	isNULL(( Select min(PODetailDue) from #POReceipts POR2 where POR2.ATPO = #POReceipts.ATPO and POR2.Part = #POReceipts.part and POR2.LineItemTouched = 1 ),'2999-01-01') as FirstDue,
	isNULL(( Select max(PODetailDue) from #POReceipts POR2 where POR2.ATPO = #POReceipts.ATPO and POR2.Part = #POReceipts.part and POR2.LineItemTouched = 1 ),'2999-01-01') as LastDue,
	(CASE WHEN isNULL(( Select min(PODetailDue) from #POReceipts POR2 where POR2.ATPO = #POReceipts.ATPO and POR2.Part = #POReceipts.part and POR2.LineItemTouched = 1 ),'2999-01-01')  > EOW THEN ExtendedReceipts ELSE  ExtendedReceipts - ExtendedRunningTotal END) as EVAL
into	#POReceiptsEval
from	 #POReceipts

--Select * from #POReceipts
--
--order by 1,4,5,6
Select * from #POReceiptsEval

order by 1,4,5,6

--Select	Vendor_code,
--		ATPO,
--		Part,
--		Standard_pack,
--		Cost,
--		max(EOW),
--		LastDue,
--		net_days,
--		[dbo].[fn_GreaterOf] (isNULL((Select min(EVAL) 
--			from		#POReceiptsEval POR2
--		where	POR2.ATPO = #POReceiptsEval.ATPO and
--				 POR2.Part = #POReceiptsEval.part and
--				 POR2.LineItemTouched = 1 and
--				POR2.Eval> 0 and
--				POR2.POdetailDue<= EOW ),0),
--		isNULL((Select max(EVAL) 
--			from		#POReceiptsEval POR2
--		where	POR2.ATPO = #POReceiptsEval.ATPO and
--				 POR2.Part = #POReceiptsEval.part and
--				 POR2.LineItemTouched = 1 and
--				POR2.Eval> 0 and
--				POR2.POdetailDue> EOW ),0) +
--		isNULL((Select max(EVAL) 
--			from		#POReceiptsEval POR2
--		where	POR2.ATPO = #POReceiptsEval.ATPO and
--				 POR2.Part = #POReceiptsEval.part and
--				POR2.Eval> 0 and
--				POR2.POdetailDue is NULL ),0) )   OverReceipt,
--		
--		(CASE WHEN EOW>LastDue Then dateadd(dd, isNull(net_days,30),EOW) ELSE  dateadd(dd, isNull(net_days,30),LastDue) END ) as DUEDT
		
		
		
--from		#POReceiptsEval
--join		vendors on #POReceiptsEval.Vendor_code = vendors.vendor
--left		join	terms on vendors.hdr_terms = terms.terms
--where	EVAL>0
--group by	Vendor_code,
--		ATPO,
--		Part,
--		LastDue,
--		net_days,
--		#POReceiptsEval.EOW,
--		standard_pack,
--		cost




End
GO
