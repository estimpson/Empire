SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

CREATE	procedure [dbo].[eeisp_rpt_materials_earlyReceipts_onHand]
as
Begin
Select	
		(Select max(shipper) from audit_trail where serial = object.serial and type = 'R') as Shipper,
		Serial,
		vendor_code,
		object.po_number,
		object.part,
		quantity,
		material_cum,
		material_cum*quantity as Extended,
		(select sum(quantity) from audit_trail at where type = 'R'  and at.date_stamp>= ft.fn_TruncDate('wk',getdate()) and at.date_stamp< dateadd(wk,1, ft.fn_TruncDate('wk',getdate())) and at.part = object.part and at.po_number = object.po_number)-isnull((select sum(quantity) from audit_trail at2 where type = 'D'  and at2.date_stamp>= ft.fn_TruncDate('wk',getdate()) and at2.date_stamp< dateadd(wk,1, ft.fn_TruncDate('wk',getdate())) and at2.part = object.part and at2.po_number = object.po_number and
		serial in ( Select Serial from audit_trail at3
join		part_standard on at3.part = part_standard.part
where	at3.type = 'R' and
		at3.date_stamp>= ft.fn_TruncDate('wk',getdate()) and at3.date_stamp< dateadd(wk,1, ft.fn_TruncDate('wk',getdate())) and
		at3.po_number =  object.po_number and
		at3.part =object.part)),0) as QtyReceieved,
		(select min(date_due) from po_detail where part_number = object.part and po_number = object.po_number and balance>0 ) as firstDue,
		(select max(date_due) from po_detail where part_number = object.part and po_number = object.po_number and balance>0 ) as lastDue,
		isNull((select sum(balance) from po_detail where part_number = object.part and po_number = object.po_number and date_due <= (select min(date_due) from po_detail where part_number = object.part and po_number = object.po_number and balance>0)),0) as firstQtyDue,
		isNull((select sum(balance) from po_detail where part_number = object.part and po_number = object.po_number and date_due <= (select max(date_due) from po_detail where part_number = object.part and po_number = object.po_number and balance>0)),0) as TotalQtyDue,
		isnull((Select	sum(stdQty)
from		FT.ReleasePlanRaw
join		FT.releasePlans on Ft.ReleasePlanRaw.releasePlanId = FT.ReleasePlans.id
join		po_header on FT.ReleasePlanRaw.PONumber = po_header.po_number
where	PONumber = object.po_number and
		Part = object.part and
		DueDT < dateadd(wk,2, ft.fn_TruncDate('wk',getdate())) and
		DueDT>= dateadd(d, -30, getdate()) and
		GeneratedDT  = (Select		min(GeneratedDT)
						 from	FT.releasePlans 
						where	GeneratedDT >=	dateadd(wk,0, ft.fn_TruncDate('wk',getdate())) and
								GeneratedDT <	dateadd(wk,1, ft.fn_TruncDate('wk',getdate())) and
								GeneratedWeekDay >= 1)),0)ThisweekDueQty,
	isNull((Select	sum(stdQty)
from		FT.ReleasePlanRaw
join		FT.releasePlans on Ft.ReleasePlanRaw.releasePlanId = FT.ReleasePlans.id
join		po_header on FT.ReleasePlanRaw.PONumber = po_header.po_number
where	PONumber = object.po_number and
		Part = object.part and
		DueDT < dateadd(wk,2, ft.fn_TruncDate('wk',getdate())) and
		DueDT>= dateadd(d, -30, getdate()) and
		GeneratedDT  = (Select		min(GeneratedDT)
						 from	FT.releasePlans 
						where	GeneratedDT >=	dateadd(wk,-1, ft.fn_TruncDate('wk',getdate())) and
								GeneratedDT <	dateadd(wk,0, ft.fn_TruncDate('wk',getdate())) and
								GeneratedWeekDay >= 1)),0) LastweekDueQty
		
		
 
from		object 
join		po_header on object.po_number = po_header.po_number
join		part_standard on object.part = part_standard.part
where	user_defined_status = 'Early Receipt' and not exists (Select 1 from audit_trail where type = 'T' and (to_loc like 'CONT%' or to_loc like 'TRAN%') and audit_trail.serial = object.serial)
End
GO
