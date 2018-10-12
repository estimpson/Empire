SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[eeisp_rpt_materials_remaining_inventory]
as
Begin
Select	po_header.vendor_code,
		ft.wkNMPS.PONumber,
		ft.wkNMPS.Part,
		part.name,
		(Select	ceiling(FABAuthDays/7)
		from		part_vendor
		where	part_vendor.part = ft.wkNMPS.part and
				part_vendor.vendor = po_header.vendor_code) as LeadTimeinWeeks,
		ft.fn_truncdate('wk',dateadd(wk,WeekNo-1,getdate())) as LastDemandWeek,
		PostDemandAccum as TotalNetDemand,
		POBalance+PriorPOAccum as ARSPOQty,
		StandardPack,			
		isNULL((Select	sum(balance)
		from		po_detail
		where	po_detail.po_number = ft.wkNMPS.PONumber and
				po_detail.part_number = ft.wkNMPS.part and
				balance >0),0) as CurrentPOQty,
		( CASE WHEN (POBalance+PriorPOAccum)-PostDemandAccum<0 THEN 0 ELSE  (POBalance+PriorPOAccum)-PostDemandAccum END ) as ExceedsDemand,
		( CASE WHEN (POBalance+PriorPOAccum)-PostDemandAccum<0 THEN 0 ELSE  (POBalance+PriorPOAccum)-PostDemandAccum END )*cost_cum as ExceedsDemandExtended,
		( CASE WHEN (isNULL((Select	sum(balance)
		from		po_detail
		where	po_detail.po_number = ft.wkNMPS.PONumber and
				po_detail.part_number = ft.wkNMPS.part and
				balance >0),0))-PostDemandAccum<0 THEN 0 ELSE  (isNULL((Select	sum(balance)
		from		po_detail
		where	po_detail.po_number = ft.wkNMPS.PONumber and
				po_detail.part_number = ft.wkNMPS.part and
				balance >0),0))-PostDemandAccum END )*cost_cum as POExceedsDemandExtended,
		isNULL((Select	max(min_on_order)
		from		part_vendor
		where	part_vendor.part = ft.wkNMPS.part and
				part_vendor.vendor = po_header.vendor_code),0) as Minimumbuy,
	(Select           ( CASE WHEN (wkNMPs4.POBalance+wkNMPs4.PriorPOAccum)-wkNMPs4.PostDemandAccum<0 THEN 0 ELSE  (wkNMPs4.POBalance+wkNMPs4.PriorPOAccum)-wkNMPs4.PostDemandAccum END )*cost_cum from ft.wknmps wkNMPs4 where wkNMPS4.PONumber = ft.wknmps.PONumber and  wkNMPs4.weekNo =  (	Select		max(weekNo) 
			from		ft.wkNMPS NMPS2 
			where	NMPS2.PONumber = ft.WkNMPS.PONumber and 
					NMPS2.WeekNo <= (isNull((Select max(WeekNo) from ft.wkNMPS NMPS1 where NMPS1.PONumber = ft.WkNMPS.PONumber and ft.WKNMPS.WeekNo<=13),13)))) as Week12Remaining,
	(Select           ( CASE WHEN (isNULL((Select	sum(balance)
		from		po_detail
		where	po_detail.po_number = ft.wkNMPS.PONumber and
				po_detail.part_number = ft.wkNMPS.part and
				balance >0),0))-wkNMPs4.PostDemandAccum<0 THEN 0 ELSE  (isNULL((Select	sum(balance)
		from		po_detail
		where	po_detail.po_number = ft.wkNMPS.PONumber and
				po_detail.part_number = ft.wkNMPS.part and
				balance >0),0))-wkNMPs4.PostDemandAccum END )*cost_cum from ft.wknmps wkNMPs4 where wkNMPS4.PONumber = ft.wknmps.PONumber and  wkNMPs4.weekNo =  (	Select		max(weekNo) 
			from		ft.wkNMPS NMPS2 
			where	NMPS2.PONumber = ft.WkNMPS.PONumber and 
					NMPS2.WeekNo <= (isNull((Select max(WeekNo) from ft.wkNMPS NMPS1 where NMPS1.PONumber = ft.WkNMPS.PONumber and ft.WKNMPS.WeekNo<=13),13)))) as POWeek12Remaining,
			isNull(BaseParts, 'Check active revision switch in EEI Monitor') as BasePartWhereUsed
		
from		ft.wkNMPS

join		(	Select	max(WeekNo) LastWeekNo,
		PONumber
		from		ft.wkNMPS
		group by	PONumber	) LastWeek  on ft.wkNMPS.POnumber = LastWeek.PONumber and ft.wkNMPS.WeekNo = LastWeekNo
join		part_standard on ft.wkNMPS.Part = part_standard.part
join		po_header on ft.wkNMPS.PONumber = po_header.po_number
join		part on part_standard.part = part.part
left join	[EEISQL1].[monitor].[dbo].FlatWhereUsedBasePart FlatWhereUsedBasePart on ft.wkNMPS.Part = FlatWhereUsedBasePart.RawPart


where	POstdemandAccum>0 and
		( CASE WHEN (POBalance+PriorPOAccum)-PostDemandAccum<0 THEN 0 ELSE  (POBalance+PriorPOAccum)-PostDemandAccum END )>0
order by	LastWeek.PONumber
end
GO
