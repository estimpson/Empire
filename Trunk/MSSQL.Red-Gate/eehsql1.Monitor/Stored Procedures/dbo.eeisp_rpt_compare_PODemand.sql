SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	procedure [dbo].[eeisp_rpt_compare_PODemand] (@WeekDate datetime)

as 

Begin

-- eeisp_rpt_compare_PODemand '2009-04-26'

--Get Weeks to Compare
declare	@ReleasePlanID integer

execute	[EEH].FT.csp_RecordVendorReleasePlan
	@ReleasePlanID = @ReleasePlanID output

Declare	@TruncatedWeekDate datetime,
		@TruncatedWeekDateEndHorizon datetime,
		@TruncatedWeekDatePrior datetime,
		@CurrentReleasePlanID Int,
		@PriorWeekReleasePlanID Int,
		@LastWeekReceiptPeriod Int,
		@CurrentWeekReceiptPeriod int

Select	@TruncatedWeekDate = ft.fn_truncdate('wk', @WeekDate)
Select	@TruncatedWeekDatePrior = dateadd(wk,-1, @TruncatedWeekDate)
Select	@TruncatedWeekDateEndHorizon = dateadd(wk,26, @TruncatedWeekDate)


--Get Release Plan IDs to Compare

Select	@CurrentReleasePlanID = min(id)
from		FT.ReleasePlans
where	ft.fn_truncdate ('wk', GeneratedDT) = @TruncatedWeekDate

Select	@PriorWeekReleasePlanID = min(id)
from		FT.ReleasePlans
where	ft.fn_truncdate ('wk', GeneratedDT) = @TruncatedWeekDatePrior

--Select * from ft.releasePlanRaw where ReleasePlanId in ( @CurrentReleasePlanID, @PriorWeekReleasePlanID) and part = 'HW8621-4-A'

--Get AccumReceived for Prior and Current Week Schedule

Create	table #QtyReceivedPriorWeek
			(	POnumber int,
				Part varchar(25),
				QtyReceived int , Primary key (PONumber, Part))
Insert	#QtyReceivedPriorWeek
Select	PO_Number,
		Part,
		sum(std_quantity)
from		audit_trail
where	type = 'R' and date_stamp>= @TruncatedWeekDatePrior   and date_stamp< @TruncatedWeekDate and po_number in (Select PONumber from ft.ReleasePlanRaw where ReleasePlanID >= @PriorWeekReleasePlanID)
group by PO_Number,
		Part



--Get  Week and Prior Weeks POS
Create	table	#WeeksPOs
				 (	PONumber Int,
					Part varchar(25),
					DueWeek Datetime,
					QtyDue	Int, Primary Key ( PONumber, Part, DueWeek))

Insert	#WeeksPOs
Select	ReleasePlanRaw.PONumber,
		ReleasePlanRaw.Part,
		ft.fn_truncDate('wk',(CASE WHEN DueDT<= @TruncatedWeekDate THEN @TruncatedWeekDate ELSE DueDT END)),
		sum(StdQty)
from		ft.releasePlanRaw  ReleasePlanRAw
where	ReleasePlanRaw.ReleasePlanID = @CurrentReleasePlanID

Group by ReleasePlanRaw.PONumber,
		ReleasePlanRaw.Part,
		ft.fn_truncDate('wk',(CASE WHEN DueDT<= @TruncatedWeekDate THEN @TruncatedWeekDate ELSE DueDT END))

Create	table	#PriorWeeksPOs
				 (	PONumber Int,
					Part varchar(25),
					DueWeek Datetime,
					QtyDue int, Primary Key ( PONumber, Part, DueWeek))

Insert	#PriorWeeksPOs
Select	ReleasePlanRaw.PONumber,
		ReleasePlanRaw.Part,
		ft.fn_truncDate('wk',(CASE WHEN DueDT<= @TruncatedWeekDate THEN @TruncatedWeekDate ELSE DueDT END)),
		sum(StdQty)
from		ft.releasePlanRaw ReleasePlanRAw
where	ReleasePlanRaw.ReleasePlanID = @PriorWeekReleasePlanID

Group by ReleasePlanRaw.PONumber,
		ReleasePlanRaw.Part,
		ft.fn_truncDate('wk',(CASE WHEN DueDT<= @TruncatedWeekDate THEN @TruncatedWeekDate ELSE DueDT END))


--Get PO part List to Compare

Create table		#POPartList (
				PONumber Int,
				Part varchar(25), Primary Key (PONumber, Part))

Insert			#POPartList
Select			PONumber,
				Part
from				#WeeksPOs

UNION
Select			PONumber,
				Part
from				#PriorWeeksPOs




--Create	PO , Part Calendar

Create table	#Weeks
			 ( DueWeek datetime, Primary Key (DueWeek))

Insert		#Weeks			

select		ft.fn_truncdate('wk',EntryDT) DueDT
from			[FT].[fn_Calendar] (@TruncatedWeekDate,@TruncatedWeekDateEndHorizon,'wk', 1,16)
where		EntryDT >=@TruncatedWeekDate



Create table	#POPartWeeks
			(	PONumber Int,
				Part varchar(25),
				DueWeek datetime, Primary Key (PONumber, Part, DueWeek))

Insert	#POPartWeeks
Select	*
From	#POPartList
cross join	 #Weeks


Create table	#POPartWeekAccumDue
			(	PONumber Int,
				Part varchar(25),
				DueWeek datetime, 
				WeeksQtyDue Int, 
				PriorWeeksQtyDue Int,
				WeeksAccumDue Int, 
				PriorWeeksAccumDue Int, Primary Key (PONumber, Part, DueWeek))
insert	#POPartWeekAccumDue  
Select	PONumber,
		Part,
		DueWeek,
		isNull((Select sum(QtyDue) from #WeeksPOs WeeksPOS where WeeksPOs.PONumber = POPartWeeks.POnumber and WeeksPOs.Part = POPartWeeks.Part and   WeeksPOs.DueWeek = POPartWeeks.DueWeek  ),0) as WeekQtyDue,
		isNull((Select sum(QtyDue) from #PriorWeeksPOs PriorWeeksPOS where PriorWeeksPOs.PONumber = POPartWeeks.POnumber and PriorWeeksPOs.Part = POPartWeeks.Part and   PriorWeeksPOs.DueWeek = POPartWeeks.DueWeek  ),0) as PriorWeekQtyDue,
		isNull((Select sum(QtyDue) from #WeeksPOs WeeksPOS where WeeksPOs.PONumber = POPartWeeks.POnumber and WeeksPOs.Part = POPartWeeks.Part and   WeeksPOs.DueWeek <= POPartWeeks.DueWeek  ),0) as WeekAccumDue,
		isNull((Select sum(QtyDue) from #PriorWeeksPOs PriorWeeksPOS where PriorWeeksPOs.PONumber = POPartWeeks.POnumber and PriorWeeksPOs.Part = POPartWeeks.Part and   PriorWeeksPOs.DueWeek <= POPartWeeks.DueWeek  ),0) as PriorWeekAccumDue
		
from		#POPartWeeks POPArtWeeks

Select	po_header.vendor_code,
		POPartWeekAccumDue.PONumber,
		POPartWeekAccumDue.Part,
		POPartWeekAccumDue.DueWeek,
		PriorWeeksQtyDue,
		PriorWeeksAccumDue,
		WeeksQtyDue, 
		WeeksAccumDue,
		(WeeksQtyDue-PriorWeeksQtyDue) as NetDifference,
		(WeeksQtyDue-PriorWeeksQtyDue)*material_cum as ExtendedNetDifference,
		(WeeksAccumDue-PriorWeeksAccumDue) as AccumulativeDifference,
		(WeeksAccumDue-PriorWeeksAccumDue)*material_cum as ExtendedAccumulativeDifference,
		isNull(QtyReceived,0) as QtyReceived
			
from		#POPartWeekAccumDue POPartWeekAccumDue
join		part_standard  on POPartWeekAccumDue.Part =  part_standard.Part
join		po_header on POPartWeekAccumDue.PONumber = po_header.po_number
left join	#QtyReceivedPriorWeek PWSA on  POPartWeekAccumDue.PONumber = PWSA.PONumber and  POPartWeekAccumDue.Part = PWSA.Part

order by 1,2,3


End

GO
