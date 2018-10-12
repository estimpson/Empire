SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[eeisp_rpt_materials_standardPack_exceeds_demand]
as
Begin


--Get date at end of 12 Week Horizon
Declare	@Endof12WeekHorizon datetime,
		@RawPart varchar(25),
		@BasePartList varchar(1000)


Select	@Endof12WeekHorizon =  ft.fn_Truncdate('wk',dateadd(wk,13,getdate()))



-- Begin - Base Part Demand from CSM data in Troy's Database
Create table		#BasePartDemand
				 (	BasePart		varchar(25),
					DemandY1	numeric(20,6),
					DemandY2	numeric(20,6), 
					AvgDemandY1Y2	numeric(20,6), Primary Key (BasePart))
					
Insert	#BasePartDemand

select 	Base_Part,
		isNull(sum(total_2009),0),
		isNull(sum(total_2010),0),
		(sum(total_2009)+sum(total_2010))/2
from		[EEISQL1].[Monitor].[EEIUser].[acctg_csm_vw_select_total_demand]
group by	Base_Part
having	(sum(total_2009)+sum(total_2010))>50
-- End - Base Part Demand from CSM data in Troy's Database

-- Begin - Get Active Distinct BaseParts
Create table #ActiveBasepart (	ActiveBasePart varchar(25),Primary Key (ActiveBasePart))


Insert	#ActiveBasepart
select	left(part_original,7) 
from		shipper_detail 
where	date_shipped >= dateadd(wk, -52, getdate())
union
select left(part_number,7) from order_detail


-- End -  Get Active Distinct BaseParts

-- Begin - Get Distinct BasePart, Raw Part from BOM fro EEH Bill of Material for Where Used Purposes
Create table #BOM (	TopBasePart varchar(25),
					RawPart	varchar(25), Primary Key (TopBasePart, RawPart))


Insert	#BOM
Select	distinct substring(TopPart,1, 7),
		ChildPart
from		[dbo].[vw_RawQtyPerFinPart] BOM
join		#ActiveBasepart ABP on substring(TopPart,1, 7) = ActiveBAsePart
-- End - Get Distinct BasePart, Raw Part from BOM fro EEH Bill of Material for Where Used Purposes



declare @FlatWhereUsed table (
		
	RawPart		varchar(25),
	BaseParts	varchar(1000))

declare	Rawpartlist cursor local for
select	distinct Rawpart 
from		#BOM BOM
where	RawPart in (Select Part from ft.wkNMPS)

open	Rawpartlist 
fetch	Rawpartlist into @Rawpart

While	@@fetch_status = 0
Begin	
Select	@BasePartList  = ''


Select	@BasePartList = @BasePartList + ' '+ isNull( [BasePart], [TopBasePart]) +' '+isNULL(( '('+Substring(convert(varchar(1000),DemandY1 ),1, patindex( '%[.]%',convert(varchar(1000),DemandY1 ))-1 )+')' + '('+Substring(convert(varchar(1000),DemandY2 ),1, patindex( '%[.]%',convert(varchar(1000),DemandY2 ))-1 )+')'),'') +', '
from		#BOM BOM
left join	#BasePartDemand BPD on BOM.TopBasePart = BPD.BasePart
where	Rawpart = @RawPart 
group by	isNull( [BasePart], [TopBasePart]),
		[BasePart],
		[TopBasePart],
		isNULL(( '('+Substring(convert(varchar(1000),DemandY1 ),1, patindex( '%[.]%',convert(varchar(1000),DemandY1 ))-1 )+')' + '('+Substring(convert(varchar(1000),DemandY2 ),1, patindex( '%[.]%',convert(varchar(1000),DemandY2 ))-1 )+')'),'') ,
		BPD.DemandY1,
		BPD.DemandY2
		


insert	@FlatWhereUsed
Select	@RawPart,
		@BasePartList		

fetch	Rawpartlist into @Rawpart

end








Select	po_header.vendor_code,
		ft.wkNMPS.PONumber,
		ft.wkNMPS.Part,
		part.name,
		(Select	ceiling(FABAuthDays/7)
		from		part_vendor
		where	part_vendor.part = ft.wkNMPS.part and
				part_vendor.vendor = po_header.vendor_code) as LeadTimeinWeeks,
		ft.fn_truncdate('wk',dateadd(wk,(Select	ceiling(FABAuthDays/7)
		from		part_vendor
		where	part_vendor.part = ft.wkNMPS.part and
				part_vendor.vendor = po_header.vendor_code), getdate())) as LeadTimeWeek,		
		(CASE WHEN datediff(wk,ft.fn_truncdate('wk',dateadd(wk,(Select	ceiling(FABAuthDays/7)
		from		part_vendor
		where	part_vendor.part = ft.wkNMPS.part and
				part_vendor.vendor = po_header.vendor_code), getdate())),ft.fn_truncdate('wk',(Select min(date_due)
						 from	po_detail
						where	po_detail.po_number = ft.wkNMPS.PONumber and
								po_detail.part_number = ft.wkNMPS.part and
								balance >0)))<=0 THEN 'Inside Lead Time' ELSE 'Outside Lead Time' END) as LeadTimeIndicator,
		
		ft.fn_truncdate('wk',dateadd(wk,WeekNo-1,getdate())) as LastDemandWeek,
		PostDemandAccum as TotalNetDemand,
		POBalance+PriorPOAccum as ARSPOQty,			
		ft.fn_truncdate('wk',dateadd(wk,(	Select	min(WeekNo-1)
			from		ft.WkNMPS NMPS2
			where	NMPS2.PONumber = ft.wkNMPS.PONumber and
					POBalance+PriorPOAccum>0),getdate())) as ARSPOWeek,
		ft.fn_truncdate('wk',(Select min(date_due)
						 from	po_detail
						where	po_detail.po_number = ft.wkNMPS.PONumber and
								po_detail.part_number = ft.wkNMPS.part and
								balance >0))as CurrentFirstPOWeek,
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
		datediff(wk,ft.fn_truncdate('wk',dateadd(wk,(Select	ceiling(FABAuthDays/7)
		from		part_vendor
		where	part_vendor.part = ft.wkNMPS.part and
				part_vendor.vendor = po_header.vendor_code), getdate())),ft.fn_truncdate('wk',(Select min(date_due)
						 from	po_detail
						where	po_detail.po_number = ft.wkNMPS.PONumber and
								po_detail.part_number = ft.wkNMPS.part and
								balance >0))) as PODateRelativeToLeadTime,
		(Select           ( CASE WHEN (wkNMPs4.POBalance+wkNMPs4.PriorPOAccum)-wkNMPs4.PostDemandAccum<0 THEN 0 ELSE  (wkNMPs4.POBalance+wkNMPs4.PriorPOAccum)-wkNMPs4.PostDemandAccum END )*cost_cum from ft.wknmps wkNMPs4 where wkNMPS4.PONumber = ft.wknmps.PONumber and  wkNMPs4.weekNo =  (	Select		max(weekNo) 
			from		ft.wkNMPS NMPS2 
			where	NMPS2.PONumber = ft.WkNMPS.PONumber and 
					NMPS2.WeekNo <= (isNull((Select max(WeekNo) from ft.wkNMPS NMPS1 where NMPS1.PONumber = ft.WkNMPS.PONumber and ft.WKNMPS.WeekNo<=13),13)))) as Week12Remaining,
		(Select           ( CASE WHEN (isNULL((Select	sum(balance)
		from		po_detail
		where	po_detail.po_number = ft.wkNMPS.PONumber and
				po_detail.part_number = ft.wkNMPS.part and
				po_detail.date_due< @Endof12WeekHorizon and
				balance >0),0))-wkNMPs4.PostDemandAccum<0 THEN 0 ELSE  (isNULL((Select	sum(balance)
		from		po_detail
		where	po_detail.po_number = ft.wkNMPS.PONumber and
				po_detail.part_number = ft.wkNMPS.part and
				po_detail.date_due< @Endof12WeekHorizon and
				balance >0),0))-wkNMPs4.PostDemandAccum END )*cost_cum from ft.wknmps wkNMPs4 where wkNMPS4.PONumber = ft.wknmps.PONumber and  wkNMPs4.weekNo =  (	Select		max(weekNo) 
			from		ft.wkNMPS NMPS2 
			where	NMPS2.PONumber = ft.WkNMPS.PONumber and 
					NMPS2.WeekNo <= (isNull((Select max(WeekNo) from ft.wkNMPS NMPS1 where NMPS1.PONumber = ft.WkNMPS.PONumber and ft.WKNMPS.WeekNo<=13),13)))) as POWeek12Remaining,
		Weekno,
		isNull(BaseParts, 'No CSM Association') as BasePartWhereUsed
from		ft.wkNMPS

join		(	Select	max(WeekNo) LastWeekNo,
		PONumber
		from		ft.wkNMPS
		group by	PONumber	) LastWeek  on ft.wkNMPS.POnumber = LastWeek.PONumber and ft.wkNMPS.WeekNo = LastWeekNo
join		part_standard on ft.wkNMPS.Part = part_standard.part
join		po_header on ft.wkNMPS.PONumber = po_header.po_number
join		part on part_standard.part = part.part
left join	@FlatWhereUsed FlatWhereUsedBasePart on ft.wkNMPS.Part = FlatWhereUsedBasePart.RawPart


where	POstdemandAccum>0 and
		StandardPack>PostDemandAccum
order by	LastWeek.PONumber
end
GO
