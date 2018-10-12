SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure	[dbo].[eeisp_rpt_materials_projected_receipts_with_ReceiptHistory] as
Begin


Declare	@Datebk5wk datetime,
		@Datebk4wk datetime,
		@Datebk3wk datetime,
		@Datebk2wk datetime,
		@Datebk1wk datetime,
		@Datebk0wk datetime



Select	@Datebk5wk = dateadd(wk,-5, ft.fn_TruncDate('wk',getdate()))
Select	@Datebk4wk = dateadd(wk,-4, ft.fn_TruncDate('wk',getdate()))
Select	@Datebk3wk = dateadd(wk,-3, ft.fn_TruncDate('wk',getdate()))
Select	@Datebk2wk = dateadd(wk,-2, ft.fn_TruncDate('wk',getdate()))
Select	@Datebk1wk = dateadd(wk,-1, ft.fn_TruncDate('wk',getdate()))
Select	@Datebk0wk = dateadd(wk,0, ft.fn_TruncDate('wk',getdate()))



/*Create	Table	#POsDue (
				Vendor varchar(15), 
				PONumber int,
				part varchar(25),
				DueDT datetime,
				Qty numeric(20,6),
				Cost numeric(20,6),
				Extended numeric(20,6), Primary Key (POnumber, Part, DueDT))

Insert		 #POsDue (
				Vendor,
				PONumber, 
				part,
				DueDT,
				Qty ,
				Cost,
				Extended )

Select		vendor_code,
			po_number,
			part_number,
			ft.fn_truncdate('wk', (CASE WHEN date_due< getdate() then getdate() else date_due END)),
			sum(balance),
			material,
			sum(material*balance)
from			po_detail
join			part_standard on po_detail.part_number = part_standard.part
group by		
			vendor_code,
			po_number,
			part_number,
			ft.fn_truncdate('wk', (CASE WHEN date_due< getdate() then getdate() else date_due END)),
			material
having		sum(balance) >0 */

/*Create	Table	#PriorPOsDue (
				Vendor varchar(15), 
				PONumber int,
				part varchar(25),
				DueDT datetime,
				Qty numeric(20,6),
				Cost numeric(20,6),
				Extended numeric(20,6), Primary Key (POnumber, Part, DueDT))

Insert		 #PriorPOsDue (
				Vendor,
				PONumber, 
				part,
				DueDT,
				Qty ,
				Cost,
				Extended )*/

Select	COALESCE(TWVendorCode, LWVendorCode),
		COALESCE(TWPONumber, LWPONumber),
		COALESCE(TWpart, LWPart),
		(CASE WHEN isNull((ThisWeekStdQty),0)>isNull((LastWeekStdQty),0) THEN TWDueDate ELSE LWDueDate  END ),
		isnull(dbo.fn_GreaterOf(isNull((ThisWeekStdQty),0),isNull((LastWeekStdQty),0)),0)
from
(Select	po_header.vendor_code as LWVendorCode,
		PONumber as LWPONumber,
		FT.ReleasePlanRaw.Part as LWpart,
		Sum(StdQty) as LastWeekStdQty,
		ft.fn_TruncDate('wk',DueDT) as LWDueDate,
		max(material_cum) as LWCost,
		Sum(StdQty*isNull(material_cum,0)) as LWExtended
		
from		FT.ReleasePlanRaw
join		part_standard on FT.ReleasePlanRaw.Part = part_standard.part
join		FT.releasePlans on Ft.ReleasePlanRaw.releasePlanId = FT.ReleasePlans.id
join		po_header on FT.ReleasePlanRaw.PONumber = po_header.po_number
where	DueDT <= @Datebk4wk and
		DueDT >= dateadd(wk, -2, @Datebk5wk) and
		GeneratedDT  = (	Select	min(GeneratedDT)
						from		FT.releasePlans 
						where	GeneratedDT >=	@Datebk5wk and
								GeneratedDT <	@Datebk4wk and
								GeneratedWeekDay > 1)
group by	po_header.vendor_code ,
		PONumber,
		FT.ReleasePlanRaw.Part,
		ft.fn_TruncDate('wk',DueDT)) LW
full join	(Select po_header.vendor_code as TWVendorCode,
		PONumber as TWPONumber,
		FT.ReleasePlanRaw.Part as TWpart,
		Sum(StdQty) as ThisWeekStdQty,
		ft.fn_TruncDate('wk',DueDT) as TWDueDate,
		max(material_cum) as TWCost,
		Sum(StdQty*isNull(material_cum,0)) as TWExtended	
from		FT.ReleasePlanRaw
join		part_standard on FT.ReleasePlanRaw.Part = part_standard.part
join		FT.releasePlans on Ft.ReleasePlanRaw.releasePlanId = FT.ReleasePlans.id
join		po_header on FT.ReleasePlanRaw.PONumber = po_header.po_number
where	DueDT <= @Datebk4wk  and
		DueDT >	dateadd(wk, -2, @Datebk5wk) and
		GeneratedDT  = (	Select	min(GeneratedDT)
						from		FT.releasePlans 
						where	GeneratedDT >=	@Datebk4wk and
								GeneratedDT <	@Datebk3wk and
								GeneratedWeekDay > 1)
group by	po_header.vendor_code,
		PONumber,
		FT.ReleasePlanRaw.Part,
		ft.fn_TruncDate('wk',DueDT)) TW on LW.LWPONumber = TW.TWPONumber  and LW.LWPart = TW.TWPart

/*Create	Table	#POsReceived ( 
				Vendor varchar(15),
				PONumber int,
				part varchar(25),
				ReceivedDT datetime,
				Qty numeric(20,6),
				Cost numeric(20,6),
				Extended numeric(20,6), Primary Key (POnumber, Part, ReceivedDT))

Insert		 #POsReceived (
				Vendor,
				PONumber, 
				part,
				ReceivedDT,
				Qty ,
				Cost,
				Extended )

Select		vendor,
			po_number,
			audit_trail.part,
			ft.fn_truncdate('wk', (CASE WHEN date_stamp< getdate() then getdate() else date_stamp END)),
			sum(quantity),
			material,
			sum(quantity*material)
from			audit_trail
join			part_standard on audit_trail.part = part_standard.part
where		type = 'R' and
			date_stamp >= ft.fn_truncdate('wk', getdate())
group by		
			vendor,
			po_number,
			audit_trail.part,
			ft.fn_truncdate('wk', (CASE WHEN date_stamp< getdate() then getdate() else date_stamp END)),
			material

Create table	#Buckets (
			BucketDT datetime, Primary Key (BucketDT))

Declare		@Date1 datetime,
			@Date2 datetime
Select		@date1 = FT.fn_TruncDate('wk', getdate())	
Select		@date2 = dateadd(wk, 26, @date1)

Insert		#Buckets
select		EntryDT
from			[FT].[fn_Calendar] (@date1,@date2,'wk', 1,26)
where		EntryDT >= FT.fn_TruncDate('wk', getdate())
order by		1

Create table	#POPartList (
			PONumber Int,
			Part varchar(25),  Primary Key (PONumber, Part))

Insert		#POPartList (
			PONumber,
			Part)
Select		distinct PONumber,
			Part
From		#POsDue
UNION
Select		distinct PONumber,
			Part
From		#POsReceived




Select		POPartList.PONumber,
			POPartList.Part,
			BucketDT,
			COALESCE(POSDue.Vendor, POSReceived.Vendor) as Vendor,
			isNUll(POSDue.Qty,0) as POQty,
			COALESCE(POSDue.cost, POSReceived.Cost) as UnitCost,
			isNUll(POsDue.Extended,0) as ExtendedPODue,
			isNUll(POSReceived.Qty,0) as ReceivedQty,
			isNUll(POsReceived.Extended,0) as ExtendedPOReceived		
			
			
from			#POPartList POPartList
cross join		#Buckets Buckets
left join		#POsDue POsDue on Buckets.BucketDT = POSDue.DueDT and POPArtList.Part = POSDue.Part and POPartList.PONumber= POSDue.PONumber
left join		#POsReceived POsReceived on Buckets.BucketDT = POSReceived.ReceivedDT and POPArtList.Part = POSReceived.Part and POPartList.PONumber= POSReceived.PONumber
where		POsDue.Qty > 0 or POSReceived.Qty >0 
order by 1,2,4
*/
End
GO
