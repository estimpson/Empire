SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	procedure	[dbo].[eeisp_rtpt_materials_ReceiptHistoryandProjection]

as

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
Select	@RpDatebk1wk)


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
where	DueDT < @Datebk0wk and
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


Select	*
from		#POReleases
End

GO
