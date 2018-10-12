SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE	procedure	[dbo].[eeisp_rpt_materials_projected_receipts] as
Begin

Create	table	#PriorPOs (	PONumber int,
							Part varchar(25),
							DueWeek	datetime,
							Balance  numeric(20,6), Primary Key( PONumber, Part, DueWeek))

Create	table	#PriorReleasePlans (	ReleasePlanID int, Primary Key( ReleasePlanID))
		


Declare	@Datebk5wk datetime,
		@Datebk4wk datetime,
		@Datebk3wk datetime,
		@Datebk2wk datetime,
		@Datebk1wk datetime,
		@Datebk0wk datetime,
		@RPDatebk5wk datetime,
		@RPDatebk4wk datetime,
		@RPDatebk3wk datetime,
		@RPDatebk2wk datetime,
		@RPDatebk1wk datetime,
		@RPDatebk0wk datetime



Select	@Datebk5wk = dateadd(wk,-5, ft.fn_TruncDate('wk',getdate()))

Select	@Datebk4wk = dateadd(wk,-4, ft.fn_TruncDate('wk',getdate()))

Select	@Datebk3wk = dateadd(wk,-3, ft.fn_TruncDate('wk',getdate()))

Select	@Datebk2wk = dateadd(wk,-2, ft.fn_TruncDate('wk',getdate()))

Select	@Datebk1wk = dateadd(wk,-1, ft.fn_TruncDate('wk',getdate()))

Select	@Datebk0wk = dateadd(wk,0, ft.fn_TruncDate('wk',getdate()))
/*
Select	@Datebk5wk
union
Select	@Datebk4wk
union
Select	@Datebk3wk
union
Select	@Datebk2wk
union
Select	@Datebk1wk
union
Select	@Datebk0wk
*/

Select	@RPDatebk5wk = min(GeneratedDT)
		from	FT.releasePlans 
where	GeneratedDT >=	@Datebk5wk and
		GeneratedDT <	@Datebk4wk and
						GeneratedWeekDay > 1

Select	@RPDatebk4wk = min(GeneratedDT)
		from	FT.releasePlans 
where	GeneratedDT >=	@Datebk4wk and
		GeneratedDT <	@Datebk3wk and
						GeneratedWeekDay > 1

Select	@RPDatebk3wk = min(GeneratedDT)
		from	FT.releasePlans 
where	GeneratedDT >=	@Datebk3wk and
		GeneratedDT <	@Datebk2wk and
						GeneratedWeekDay > 1

Select	@RPDatebk2wk = min(GeneratedDT)
		from	FT.releasePlans 
where	GeneratedDT >=	@Datebk2wk and
		GeneratedDT <	@Datebk1wk and
						GeneratedWeekDay > 1

Select	@RPDatebk1wk = min(GeneratedDT)
		from	FT.releasePlans 
where	GeneratedDT >=	@Datebk1wk and
		GeneratedDT <	@Datebk0wk and
						GeneratedWeekDay > 1


Select	@RPDatebk0wk = min(GeneratedDT)
		from	FT.releasePlans 
where	GeneratedDT >=	@Datebk0wk and
						GeneratedWeekDay >= 1
insert	#PriorReleasePlans 
Select	ID
from		FT.releasePlans
where	GeneratedDT in ( 
Select	@RPDatebk5wk
union
Select	@RPDatebk4wk
union
Select	@RPDatebk3wk
union
Select	@RPDatebk2wk
union
Select	@RpDatebk1wk
union
Select	@RpDatebk0wk)


Select	ReleasePlanID,
		po_header.vendor_code as VendorCode,
		PONumber as PONumber,
		FT.ReleasePlanRaw.Part as Part,
		Sum(StdQty) as StdQty,
		ft.fn_TruncDate('wk',DueDT) as DueDate,
		max(material_cum) as Cost,
		Sum(StdQty*isNull(material_cum,0)) as Extended

Into		#PriorPOReleases
		
from		FT.ReleasePlanRaw
join		part_standard on FT.ReleasePlanRaw.Part = part_standard.part
join		FT.releasePlans on Ft.ReleasePlanRaw.releasePlanId = FT.ReleasePlans.id
join		po_header on FT.ReleasePlanRaw.PONumber = po_header.po_number
where	DueDT < dateadd(wk,0, @Datebk0wk) and
		DueDT >= dateadd(wk, -2, @Datebk5wk) and
		ID in (	Select	ReleasePlanID
				from		#PriorReleasePlans 
				)
group by	ReleasePlanID,
		po_header.vendor_code ,
		PONumber,
		FT.ReleasePlanRaw.Part,
		ft.fn_TruncDate('wk',DueDT)
order by	PONumber,
		ft.fn_TruncDate('wk',DueDT),
		ReleasePlanID


Select	VendorCode,
		PONumber,
		Part,
		DueDate,
		Max(StdQty) StdQty,
		max(cost) Cost,
		max(extended) Extended
into		#POReleases		
from		#PriorPOReleases
group by	VendorCode,
		PONumber,
		Part,
		DueDate

Create	Table	#POsDue (
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

Select		COALESCE(vendor_code, vendorCode),
			COALESCE(po_number,PONumber),
			COALESCE(part_number,POReleases.Part),
			COALESCE(ft.fn_truncdate('wk', date_due),DueDate),
			dbo.fn_GreaterOf(isNull(sum(balance),0),isNUll(Sum(stdQty),0)),
			COALESCE(material,POReleases.Cost),
			dbo.fn_GreaterOf(isNull(sum(balance*material_cum),0),isNull(Sum(Extended),0))
from			po_detail
full join		#POReleases POReleases on ft.fn_truncdate('wk', po_detail.date_due) = DueDate and po_number = PONumber and part_number = part
join			part_standard on po_detail.part_number = part_standard.part
where		date_due>= dateadd(wk,0, @Datebk0wk) 
group by		
			COALESCE(vendor_code, vendorCode),
			COALESCE(po_number,PONumber),
			COALESCE(part_number,POReleases.Part),
			COALESCE(ft.fn_truncdate('wk', date_due),DueDate),
			COALESCE(material,POReleases.Cost)
having		dbo.fn_GreaterOf(isNull(sum(balance),0),isNUll(Sum(stdQty),0)) >0 

union

Select		*
from			#POReleases



Create	Table	#POsReceived ( 
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
			ft.fn_truncdate('wk', (CASE WHEN date_stamp< @RPDatebk4wk then @RPDatebk4wk else date_stamp END)),
			sum(quantity),
			material,
			sum(quantity*material)
from			audit_trail
join			part_standard on audit_trail.part = part_standard.part
where		type = 'R' and
			date_stamp >=@RPDatebk4wk
group by		
			vendor,
			po_number,
			audit_trail.part,
			ft.fn_truncdate('wk', (CASE WHEN date_stamp<@RPDatebk4wk then @RPDatebk4wk else date_stamp END)),
			material

Create table	#Buckets (
			BucketDT datetime, Primary Key (BucketDT))

Declare		@Date1 datetime,
			@Date2 datetime
Select		@date1 = @RPDatebk4wk
Select		@date2 = dateadd(wk, 26, @date1)

Insert		#Buckets
select		ft.fn_truncdate('wk',EntryDT)
from			[FT].[fn_Calendar] (@date1,@date2,'wk', 1,26)
where		EntryDT >=@RPDatebk4wk
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
			isNUll(POsReceived.Extended,0) as ExtendedPOReceived,
			part_inventory.standard_pack as StdPack	
			
into			#POandReceipts			
from			#POPartList POPartList
join			part_inventory on POPartList.Part = part_inventory.part
cross join		#Buckets Buckets
left join		#POsDue POsDue on Buckets.BucketDT = POSDue.DueDT and POPArtList.Part = POSDue.Part and POPartList.PONumber= POSDue.PONumber
left join		#POsReceived POsReceived on Buckets.BucketDT = POSReceived.ReceivedDT and POPArtList.Part = POSReceived.Part and POPartList.PONumber= POSReceived.PONumber
where		POsDue.Qty > 0 or POSReceived.Qty >0 
order by 1,2,4

Select	*,
		(CASE WHEN ReceivedQty<= POQty THEN 0 ELSE ReceivedQty-POQty END) as OverReceiptQty,
		(CASE WHEN ReceivedQty<= POQty THEN 0 ELSE ReceivedQty-POQty END)*UnitCost as OverReceiptExtended

from		#POandReceipts


End
GO
